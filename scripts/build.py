"""Build the stock Max presentation and the four copies of its signal graph."""

import json
import math
import random
import runpy
import struct
import wave
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
ROOT = SCRIPT_DIR.parent / "max"
VERSION = dict(major=9, minor=2, revision=0, architecture="arm64", modernui=1)
CELLS = (
    # name, min, max, initial, offset at full LFO depth, conversion
    ("start", 0, 100, 0, 25, 0.01),
    ("end", 0, 100, 25, 25, 0.01),
    ("rate", 0.125, 4, 1, 1, 1),
    ("direction", 0, 2, 0, 2, 1),
    ("fade", 0, 500, 30, 100, 1),
    ("drive", 0, 100, 0, 100, 0.01),
    ("filter", -100, 100, 0, 100, 0.01),
    ("level", 0, 100, 70, 100, 0.01),
    ("pan", -100, 100, 0, 100, 0.01),
)
DIRECTIONS = ["Forward", "Reverse", "Ping-pong"]
DIALS = ("rate", "fade", "drive", "filter", "level", "pan")
DIAL_LABELS = ("Speed ×", "Fade ms", "Drive %", "LP / HP", "Level %", "Pan %")

MARGIN = 16
TRACK = 48
ROW = 24
GUTTER = 4
SECTION_GAP = 16
TRACKS = 22
SPLIT = 14
RIGHT_TRACKS = TRACKS - SPLIT
PATTERNS_TOP = 88
PLAYBACK_TOP = PATTERNS_TOP + 2 * ROW - GUTTER + SECTION_GAP
PLAYBACK_OFFSET = PLAYBACK_TOP - (MARGIN + 2 * ROW)
MODULATION_TOP = PLAYBACK_TOP + 9 * ROW - GUTTER + SECTION_GAP
MODULATION_ROWS = 9
FOOTER_TOP = MODULATION_TOP + MODULATION_ROWS * ROW - GUTTER + SECTION_GAP
FOOTER_OFFSET = FOOTER_TOP - (MARGIN + 22 * ROW)
FRAME_HEIGHT = FOOTER_TOP + 5 * ROW - GUTTER + MARGIN


def grid_rect(col, row, width, height=1, y_offset=0):
    return [MARGIN + TRACK * col, MARGIN + ROW * row + y_offset,
            TRACK * width - GUTTER, ROW * height - GUTTER]


class Patch:
    def __init__(self):
        self.boxes = []
        self.lines = []
        self.names = {}

    def add(self, name, cls, rect, ins=1, outs=1, types=None, view=None, **attributes):
        if name in self.names:
            raise ValueError(name)
        ident = f"obj-{len(self.boxes) + 1}"
        box = dict(id=ident, varname=name, maxclass=cls, numinlets=ins,
                   numoutlets=outs, patching_rect=rect, **attributes)
        if types is not None:
            box["outlettype"] = types
        if view is not None:
            box.update(presentation=1, presentation_rect=view)
        self.boxes.append({"box": box})
        self.names[name] = ident
        return box

    def obj(self, name, text, x, y, ins=1, outs=1, types=None, width=None):
        return self.add(name, "newobj", [x, y, width or max(42, len(text) * 7 + 12), 22],
                        ins, outs, types, text=text)

    def ui(self, name, cls, col, row, width=1, height=1, y_offset=0, **attrs):
        rect = grid_rect(col, row, width, height, y_offset)
        return self.add(name, cls, rect, view=rect, **attrs)

    def label(self, name, text, col, row, width, heading=False, y_offset=0):
        self.ui(name, "comment", col, row, width, y_offset=y_offset, outs=0, text=text,
                **({"fontsize": 16, "fontface": 1} if heading else {}))

    def connect(self, source, outlet, destination, inlet=0):
        self.lines.append({"patchline": {
            "source": [self.names[source], outlet],
            "destination": [self.names[destination], inlet],
        }})

    def save(self):
        patch = dict(fileversion=1, appversion=VERSION, classnamespace="box",
                     rect=[60, 70, 2 * MARGIN + TRACKS * TRACK - GUTTER, FRAME_HEIGHT], openinpresentation=1,
                     gridsize=[8, 8], isolateaudio=1, description="Four-window sample instrument with modulation, mix effects and stereo capture",
                     boxes=self.boxes, lines=self.lines)
        (ROOT / "Field Kit.maxpat").write_text(
            json.dumps({"patcher": patch}, ensure_ascii=False, indent=2) + "\n"
        )


def parameter(name, initial, low, high, *, options=None, unit_style=0, short=None, units=None):
    value = dict(parameter_longname=name, parameter_shortname=short or name,
                 parameter_type=0, parameter_mmin=low, parameter_mmax=high,
                 parameter_initial=[initial], parameter_initial_enable=1,
                 parameter_unitstyle=unit_style)
    if units:
        value.update(parameter_unitstyle=9, parameter_units=units)
    if options:
        value.update(parameter_type=2, parameter_enum=options)
    return dict(parameter_enable=1, saved_attribute_attributes={"valueof": value})


def action(patch, name, label, column, selector, width=2, target="source_control", hint=None):
    rect = grid_rect(column, 1, width)
    rect[3] = 32
    patch.add(name, "live.text", rect, view=rect, outs=2, types=["", ""],
              mode=0, text=label, texton=label, parameter_enable=0, **({"hint": hint} if hint else {}))
    patch.obj(name + "_click", "sel bang", 24 + column * 110, 728, outs=2,
              types=["bang", ""])
    patch.add(name + "_message", "message", [24 + column * 110, 766, 140, 22],
              ins=2, text=selector)
    patch.connect(name, 0, name + "_click")
    patch.connect(name + "_click", 0, name + "_message")
    patch.connect(name + "_message", 0, target)


def pattern_controls(p):
    row = 3
    y_offset = PATTERNS_TOP - (MARGIN + row * ROW)
    p.label("pattern_heading", "Patterns", 0, row, 2, heading=True, y_offset=y_offset)
    p.obj("pattern_control", "js fk_patterns.js", 1550, 2010, outs=0)
    for slot in range(1, 9):
        name = f"pattern_{slot}"
        p.ui(name, "live.text", slot + 1, row, 1, 2, y_offset=y_offset, outs=2,
             types=["", ""], mode=1, text=str(slot), texton=str(slot), parameter_enable=0,
             hint=f"Recall pattern {slot}. Enable Store first to save into this square.")
        x = 1540 + (slot - 1) * 112
        p.obj(f"pattern_click_{slot}", "t b", x, 1920, types=["bang"])
        p.add(f"pattern_slot_{slot}", "message", [x, 1960, 70, 22], ins=2, text=f"slot {slot}")
        p.connect(name, 0, f"pattern_click_{slot}")
        p.connect(f"pattern_click_{slot}", 0, f"pattern_slot_{slot}")
        p.connect(f"pattern_slot_{slot}", 0, "pattern_control")
    p.ui("pattern_store", "live.text", 10, row, 4, 2, y_offset=y_offset, outs=2, types=["", ""],
         mode=1, text="Store pattern", texton="Choose a square", parameter_enable=0)
    p.obj("pattern_arm", "prepend arm", 1675, 1960, ins=2)
    p.connect("pattern_store", 0, "pattern_arm")
    p.connect("pattern_arm", 0, "pattern_control")
    p.label("pattern_status", "Store a setup, then click a filled square to recall it.",
            SPLIT, row + 1, RIGHT_TRACKS, y_offset=y_offset)
    for name, label, col, command, result, dialog, outputs in (
        ("pattern_load", "Load bank…", SPLIT, "load_bank", "read_bank", "opendialog JSON", ["", "bang"]),
        ("pattern_save", "Save bank…", SPLIT + 4, "save_bank", "write_bank", "savedialog JSON", ["", "", "bang"]),
    ):
        p.ui(name, "live.text", col, row, 4, y_offset=y_offset, outs=2, types=["", ""],
             mode=0, text=label, texton=label, parameter_enable=0)
        x = 1520 + 50 * (col - SPLIT)
        p.add(name + "_message", "message", [x, 2090, 80, 22], ins=2, text=command)
        p.obj(name + "_dialog", dialog, x, 2125, outs=len(outputs), types=outputs)
        p.obj(name + "_result", "prepend " + result, x, 2160, ins=2)
        p.connect(name, 0, name + "_message")
        p.connect(name + "_message", 0, "pattern_control")
        p.connect(name + "_dialog", 0, name + "_result")
        p.connect(name + "_result", 0, "pattern_control")


def window_controls(p):
    p.label("inspector_title", "Window controls", SPLIT, 2, RIGHT_TRACKS,
            heading=True, y_offset=PLAYBACK_OFFSET)
    p.ui("inspector_tabs", "live.tab", SPLIT, 3, RIGHT_TRACKS, y_offset=PLAYBACK_OFFSET,
         outs=3, types=["int", "", "float"],
         **parameter("Edit window", 0, 0, 3, options=[f"Window {i}" for i in range(1, 5)]))
    p.obj("choose_window", "prepend inspect_window", 1500, 808, ins=2)
    p.connect("inspector_tabs", 0, "choose_window")
    p.connect("choose_window", 0, "source_control")

    for col, width, text in ((SPLIT, 2, "In %"), (SPLIT + 2, 2, "Out %"), (SPLIT + 4, 4, "Direction")):
        p.label(f"inspector_label_{col}", text, col, 4, width, y_offset=PLAYBACK_OFFSET)

    for index, (key, low, high, initial, _, _) in enumerate(CELLS):
        name = f"inspect_{key}"
        if key in ("start", "end"):
            p.ui(name, "live.numbox", SPLIT if key == "start" else SPLIT + 2, 5, 2,
                 y_offset=PLAYBACK_OFFSET,
                 outs=2, types=["float", "float"],
                 **parameter(f"Selected {key}", initial, low, high, units="%.2f"))
        elif key == "direction":
            p.ui(name, "umenu", SPLIT + 4, 5, 4, y_offset=PLAYBACK_OFFSET, outs=3, types=["int", "", ""],
                 items=["Forward", ",", "Reverse", ",", "Ping-pong"])
        else:
            dial_index = DIALS.index(key)
            dial_label = DIAL_LABELS[dial_index]
            dial_track = TRACK * RIGHT_TRACKS // len(DIALS)
            rect = [MARGIN + TRACK * SPLIT + dial_index * dial_track, PLAYBACK_TOP + 100,
                    dial_track - GUTTER, 4 * ROW - 8]
            p.add(name, "live.dial", rect, outs=2, types=["float", "float"], view=rect,
                  appearance=3, showname=1, shownumber=1,
                  **parameter(f"Selected {key}", initial, low, high, short=dial_label,
                              units="%.2f" if key == "rate" else None))
        message = f"edit_inspect_{key}"
        p.obj(message, f"prepend inspector_edit {key}", 1600, 510 + index * 29, ins=2)
        p.connect(name, 0, message)
        p.connect(message, 0, "source_control")
    p.label("filter_help", "Filter at 0 is flat · left LP / right HP", SPLIT, 10, RIGHT_TRACKS,
            y_offset=PLAYBACK_OFFSET)


def build():
    p = Patch()
    p.label("title", "FIELD KIT", 0, 0, 3, heading=True)
    p.label("source_label", "Loading demo…", 3, 0, SPLIT - 3, y_offset=4)
    p.label("output_heading", "Audio output", SPLIT, 0, 2)
    p.label("status", "Loading the demo…", SPLIT, 1, RIGHT_TRACKS, y_offset=6)
    p.obj("standalone", "standalone @bundleidentifier audio.poeticstate.fieldkit @preffilename FieldKit @gensupport 1 @cefsupport 0", 30, 2080, outs=0)

    p.obj("source_control", "js fk_source.js", 24, 808, outs=4, types=["list"] * 4)
    p.obj("initialize", "loadmess initialize", 200, 808, types=[""])
    p.connect("initialize", 0, "source_control")
    p.obj("audio_file", "opendialog", 400, 808, outs=2, types=["", "bang"])
    p.obj("load_path", "prepend open_source", 400, 846, ins=2, types=[""])
    p.connect("audio_file", 0, "load_path")
    p.connect("load_path", 0, "source_control")
    p.obj("buffer", "buffer~ fk-unbound", 630, 808, outs=2, types=["float", "bang"])
    p.obj("source_info", "info~", 880, 808, outs=10,
          types=["float", "list", "float", "float", "float", "float", "float", "", "int", ""])
    p.obj("buffer_complete", "prepend source_loaded", 630, 846, ins=2, types=[""])
    p.connect("buffer", 1, "source_info")
    p.connect("source_info", 0, "buffer_complete")
    p.connect("buffer_complete", 0, "source_control")
    p.obj("dsp_state", "dspstate~", 1130, 808, outs=4, types=["int", "float", "int", "int"])
    p.obj("dsp_enabled", "prepend dsp_enabled", 1130, 846, ins=2)
    p.connect("dsp_state", 0, "dsp_enabled")
    p.connect("dsp_enabled", 0, "source_control")
    p.obj("source_rate", "sig~ 0.", 880, 846, types=["signal"])
    p.connect("source_info", 0, "source_rate")

    for name, label, col, selector, width in (
        ("load", "Load audio…", 0, "choose", 3),
        ("demo", "Load demo", 3, "load_demo", 2),
        ("play", "▶  Play all", 5, "play_all", 3),
        ("stop", "■  Stop all", 8, "stop_all", 2),
        ("normal", "Play normal", 10, "play_normal", 2),
    ):
        action(p, name, label, col, selector, width,
               hint="Play the original sample once at normal speed with effects bypassed." if name == "normal" else None)
    pattern_controls(p)
    action(p, "reset", "Reset", 12, "reset", 2, target="pattern_control",
           hint="Stop and restore the default loop, modulation and effects settings. Saved patterns stay in their squares.")

    p.ui("audio_setup", "live.text", 19, 0, 3, outs=2, types=["", ""],
         text="Audio Setup…", texton="Audio Setup…", mode=0, parameter_enable=0)
    p.add("open_audio_setup", "message", [1420, 804, 110, 22], ins=2, text="; dsp open")
    p.connect("audio_setup", 0, "open_audio_setup")

    p.ui("master_label", "comment", SPLIT + 2, 22, 2, y_offset=FOOTER_OFFSET, outs=0, text="Master")
    p.ui("master", "live.numbox", SPLIT + 4, 22, 1, y_offset=FOOTER_OFFSET, outs=2, types=["float", "float"],
         **parameter("Master", -12, -70, 0, unit_style=4))
    p.ui("audio_switch", "live.text", 16, 0, 3, outs=2, types=["", ""],
         text="Enable audio", texton="Audio on", mode=1,
         hint="Play starts audio automatically. Click here to enable audio alone or turn audio off.",
         **parameter("Audio engine", 0, 0, 1, options=["Off", "On"]))
    p.obj("set_audio", "prepend set_audio", 1270, 808, ins=2)
    p.connect("audio_switch", 0, "set_audio")
    p.connect("set_audio", 0, "source_control")
    p.obj("dac", "dac~ 1 2", 360, 1958, ins=2, outs=0)
    p.ui("mix_meter", "live.meter~", SPLIT + 5, 22, 3, y_offset=FOOTER_OFFSET, outs=2,
         types=["float", "int"], orientation=1, hint="Post-effects master peak. Capture records this signal.")
    p.obj("mix_peak", "maximum~", 640, 1958, ins=2, types=["signal"])
    p.connect("mix_peak", 0, "mix_meter")
    p.obj("master_amplitude", "dbtoa", 22, 1840, types=["float"])
    p.obj("master_ramp", "pack 0. 20", 105, 1840, ins=2)
    p.obj("master_gain", "line~ 0.2511886432", 220, 1840, ins=2, outs=2, types=["signal", "bang"])
    p.connect("master", 0, "master_amplitude")
    p.connect("master_amplitude", 0, "master_ramp")
    p.connect("master_ramp", 0, "master_gain")
    for name, file, col, width, outputs in (
        ("mix_fx", "fk_fx.maxpat", 0, SPLIT, 2),
        ("recorder", "fk_record.maxpat", SPLIT, RIGHT_TRACKS, 0),
    ):
        rect = grid_rect(col, 22, width, 5, FOOTER_OFFSET)
        p.add(name, "bpatcher", rect, ins=2, outs=outputs, types=["signal"] * outputs,
              view=rect)
        p.boxes[-1]["box"].update(name=file, args=[], offset=[0.0, 0.0], border=0, clickthrough=0,
                   enablehscroll=0, enablevscroll=0, lockeddragscroll=0)
    p.obj("normal_voice", "play~ fk-unbound 2", 1100, 1800, outs=3,
          types=["signal", "signal", "bang"])
    p.add("normal_done", "message", [1240, 1840, 115, 22], ins=2, text="normal_finished")
    p.connect("normal_voice", 2, "normal_done")
    p.connect("normal_done", 0, "source_control")
    p.obj("normal_right_channel", "selector~ 2 2", 1100, 1840, ins=3, types=["signal"])
    p.connect("normal_voice", 0, "normal_right_channel", 1)
    p.connect("normal_voice", 1, "normal_right_channel", 2)
    for channel, suffix in enumerate(("left", "right")):
        mix = "normal_mix_" + suffix[0]
        p.obj(mix, "selector~ 2 1", 820 + 140 * channel, 1880, ins=3, types=["signal"])
        p.connect("mix_fx", channel, mix, 1)
        p.connect("normal_voice" if channel == 0 else "normal_right_channel", 0, mix, 2)
        p.obj("master_" + suffix, "*~", 360 + 140 * channel, 1840, ins=2, types=["signal"])
        p.obj("output_" + suffix, "clip~ -0.99 0.99", 360 + 140 * channel, 1880,
              ins=3, types=["signal"])
        p.connect(mix, 0, "master_" + suffix)
        p.connect("master_gain", 0, "master_" + suffix, 1)
        p.connect("master_" + suffix, 0, "output_" + suffix)
        p.connect("output_" + suffix, 0, "dac", channel)
        p.connect("output_" + suffix, 0, "recorder", channel)
        p.obj("output_peak_" + suffix, "abs~", 640 + 140 * channel, 1920, types=["signal"])
        p.connect("output_" + suffix, 0, "output_peak_" + suffix)
        p.connect("output_peak_" + suffix, 0, "mix_peak", channel)

    p.label("row_heading", "Playback windows", 0, 2, 7, heading=True, y_offset=PLAYBACK_OFFSET)
    p.label("wave_heading", "Drag to set a loop", 7, 2, SPLIT - 7, y_offset=PLAYBACK_OFFSET + 4)
    window_controls(p)

    mod_rect = [MARGIN, MODULATION_TOP, TRACKS * TRACK - GUTTER, MODULATION_ROWS * ROW - GUTTER]
    p.add("patchbay", "bpatcher", mod_rect, ins=1, outs=2,
          types=["multichannelsignal", "int"], view=mod_rect)
    patchbay = p.boxes[-1]["box"]
    patchbay.update(name="fk_modulation.maxpat", args=[], offset=[0.0, 0.0],
                    border=0, clickthrough=0, enablehscroll=0, enablevscroll=0, lockeddragscroll=0)
    p.obj("mod_signals", "mc.unpack~ 36", 28, 886, outs=36,
          types=["signal"] * 36, width=1016)
    p.connect("patchbay", 0, "mod_signals")
    p.obj("watch_target", "selector~ 36 1", 1560, 886, ins=37,
          types=["signal"], width=660)
    p.obj("watch_snapshot", "snapshot~ 50", 1560, 928, ins=2, types=["float"])
    p.obj("watch_value", "prepend effective", 1560, 965, ins=2)
    p.obj("watch_running", "prepend running", 1750, 965, ins=2)
    p.connect("patchbay", 1, "watch_target")
    p.connect("watch_target", 0, "watch_snapshot")
    p.connect("watch_snapshot", 0, "watch_value")
    p.connect("watch_value", 0, "patchbay")
    p.connect("dsp_state", 0, "watch_running")
    p.connect("watch_running", 0, "patchbay")

    for voice in range(1, 5):
        row = 3 + 2 * (voice - 1)
        p.ui(f"play_{voice}", "live.text", 0, row, 2, y_offset=PLAYBACK_OFFSET, outs=2, types=["", ""],
             text=f"{voice:02} Stopped", texton=f"{voice:02} Playing", mode=1,
             **parameter(f"Window {voice} Play", 0, 0, 1, options=["Off", "On"]))
        p.ui(f"meter_{voice}", "live.meter~", 0, row + 1, 2, y_offset=PLAYBACK_OFFSET, outs=2,
             types=["float", "int"], orientation=1)
        p.ui(f"wave_{voice}", "waveform~", 2, row, SPLIT - 2, 2, y_offset=PLAYBACK_OFFSET, ins=5, outs=6,
             types=["float", "float", "float", "float", "list", "list"], setmode=1)
        p.connect("source_control", voice - 1, f"wave_{voice}", 2)

        y = 950 + 210 * (voice - 1)
        p.obj(f"voice_{voice}", "gen~ fk_voice", 28, y + 132, ins=11, outs=12,
              types=["signal"] * 12, width=500)
        p.obj(f"run_{voice}", "sig~ 0.", 925, y, types=["signal"])
        p.connect(f"run_{voice}", 0, f"voice_{voice}", 9)
        p.connect("source_rate", 0, f"voice_{voice}", 10)

        for i, (key, low, high, default, depth, unit) in enumerate(CELLS):
            control = f"{key}_{voice}"
            base = f"base_{control}"
            if key in ("start", "end"):
                default += 25 * (voice - 1)
            if key == "pan":
                default = [-45, -15, 15, 45][voice - 1]
            options = DIRECTIONS if key == "direction" else None
            p.add(control, "live.menu" if options else "live.numbox", [1690 + i * 96, y, 92, 20],
                 outs=3 if options else 2,
                 types=["", "", "float"] if options else ["float", "float"],
                 **parameter(f"W{voice} {key}", default, low, high, options=options))
            x = 28 + i * 100
            p.obj(base, f"sig~ {float(default)}", x, y, types=["signal"])
            mod = f"mod_{control}"
            result = f"sum_{control}"
            p.obj(mod, f"*~ {float(depth)}", x, y + 32, ins=2, types=["signal"])
            p.obj(result, "+~", x, y + 64, ins=2, types=["signal"])
            p.connect("mod_signals", (voice - 1) * 9 + i, mod)
            p.connect(base, 0, result)
            p.connect(mod, 0, result, 1)
            if unit != 1:
                conversion = f"unit_{control}"
                p.obj(conversion, f"*~ {float(unit)}", x, y + 96, ins=2, types=["signal"])
                p.connect(result, 0, conversion)
                result = conversion
            if key == "rate":
                limit = f"clip_{control}"
                p.obj(limit, "clip~ 0.125 4.", x, y + 96, ins=3, types=["signal"])
                p.connect(result, 0, limit)
                result = limit
            p.connect(result, 0, f"voice_{voice}", i)
            p.connect(f"voice_{voice}", i + 3, "watch_target", (voice - 1) * 9 + i + 1)
            if key in ("start", "end"):
                p.obj(f"edit_{control}", f"prepend edit_{key} {voice}", 1110 + i * 180, y,
                      ins=2)
                p.connect(control, 0, f"edit_{control}")
                p.connect(f"edit_{control}", 0, "source_control")
            else:
                p.connect(control, 0, base)
                sync = f"sync_{control}"
                p.obj(sync, f"prepend inspector_sync {voice} {key}", 1690 + i * 96, y + 40, ins=2)
                p.connect(control, 0, sync)
                p.connect(sync, 0, "source_control")
        p.obj(f"peak_{voice}", "maximum~", 920, y + 170, ins=2, types=["signal"])
        p.connect(f"peak_{voice}", 0, f"meter_{voice}")
        for suffix, outlet in (("left", 0), ("right", 1)):
            p.connect(f"voice_{voice}", outlet, "mix_fx", outlet)
            rect_x = 780 + outlet * 100
            p.obj(f"abs_{suffix}_{voice}", "abs~", rect_x, y + 132, types=["signal"])
            p.connect(f"voice_{voice}", outlet, f"abs_{suffix}_{voice}")
            p.connect(f"abs_{suffix}_{voice}", 0, f"peak_{voice}", outlet)

        p.obj(f"edit_wave_{voice}", f"prepend edit_wave {voice}", 1110, y + 34, ins=2)
        p.connect(f"wave_{voice}", 5, f"edit_wave_{voice}")
        p.connect(f"edit_wave_{voice}", 0, "source_control")
        p.obj(f"edit_play_{voice}", f"prepend edit_play {voice}", 1290, y + 34, ins=2)
        p.connect(f"play_{voice}", 0, f"edit_play_{voice}")
        p.connect(f"edit_play_{voice}", 0, "source_control")
        p.obj(f"playhead_{voice}", "snapshot~ 50", 1110, y + 68, ins=2, types=["float"])
        p.obj(f"playhead_gate_{voice}", "gate 1", 1290, y + 68, ins=2)
        p.obj(f"draw_playhead_{voice}", "prepend line", 1450, y + 68, ins=2)
        p.connect(f"voice_{voice}", 2, f"playhead_{voice}")
        p.connect(f"playhead_{voice}", 0, f"playhead_gate_{voice}", 1)
        p.connect(f"playhead_gate_{voice}", 0, f"draw_playhead_{voice}")
        p.connect(f"draw_playhead_{voice}", 0, f"wave_{voice}")

    p.save()


def demo():
    """A small original stereo soundscape for first playback."""
    rng = random.Random(741)
    sr = 44100
    seconds = 8
    frames = bytearray()
    low_noise = [0.0, 0.0]
    for n in range(sr * seconds):
        t = n / sr
        section = min(3, int(t // 2))
        frequency = (110, 146.83, 164.81, 220)[section]
        local = t % 2
        fade = min(1.0, local * 80, (2 - local) * 80)
        tone = 0.21 * math.sin(math.tau * frequency * t) * (0.42 + 0.58 * math.exp(-local * 1.6))
        tone += 0.075 * math.sin(math.tau * 1.5 * frequency * t)
        values = []
        for channel in range(2):
            low_noise[channel] += 0.028 * (rng.uniform(-1, 1) - low_noise[channel])
            texture = 0.38 * low_noise[channel] * (0.7 + 0.3 * math.sin(math.tau * 0.4 * t + channel))
            overtone = 0.045 * math.sin(math.tau * frequency * (2.002 + channel * 0.007) * t)
            values.append(round(32767 * fade * (tone + texture + overtone)))
        frames.extend(struct.pack("<hh", *values))
    with wave.open(str(ROOT / "fk_demo.wav"), "wb") as target:
        target.setparams((2, 2, sr, 0, "NONE", "not compressed"))
        target.writeframes(frames)


if __name__ == "__main__":
    runpy.run_path(str(SCRIPT_DIR / "build_modulation.py"))
    for generator in ("build_fx.py", "build_recorder.py"):
        runpy.run_path(str(SCRIPT_DIR / generator), run_name="__main__")
    build()
    demo()
