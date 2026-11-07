"""Build the stock Max presentation and the four copies of its signal graph."""

import json
import math
import random
import runpy
import struct
import wave
from pathlib import Path

from build_fx import DIALS as FX_DIALS

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
DEFAULT_PANS = (-45, -15, 15, 45)
PITCH_SCALES = ("Off", "Chromatic", "Major", "Natural Minor", "Dorian",
                "Major Pentatonic", "Minor Pentatonic")
DIALS = ("rate", "fade", "drive", "filter", "level", "pan")
DIAL_LABELS = ("Speed ×", "Fade ms", "Drive %", "Filter", "Level %", "Pan %")
WINDOW_MOD_CHANNELS = 4 * len(CELLS)
FX_MOD_CHANNELS = len(FX_DIALS)
MOD_CHANNELS = WINDOW_MOD_CHANNELS + 2 + FX_MOD_CHANNELS

MARGIN = 16
TRACK = 48
ROW = 24
GUTTER = 4
SECTION_GAP = 16
TRACKS = 22
SPLIT = 14
MIXER_TRACKS = 5
RIGHT_TRACKS = TRACKS - SPLIT
INPUT_TOP = 80
INPUT_HEIGHT = 74
PATTERNS_TOP = INPUT_TOP + INPUT_HEIGHT + SECTION_GAP
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


def modulated_gain(p, control, output, initial, low, high, depth, x, y):
    ramp = f"{control}_ramp"
    base = f"{control}_base"
    mod = f"{control}_mod"
    total = f"{control}_sum"
    effective = f"{control}_effective"
    p.obj(ramp, f"pack {initial}. 20", x, y, ins=2)
    p.obj(base, f"line~ {initial}.", x, y + 32, ins=2, outs=2, types=["signal", "bang"])
    p.obj(mod, f"*~ {depth}.", x + 105, y + 32, ins=2, types=["signal"])
    p.obj(total, "+~", x, y + 64, ins=2, types=["signal"])
    p.obj(effective, f"clip~ {low}. {high}.", x, y + 96, ins=3, types=["signal"])
    p.obj(output, "dbtoa~", x, y + 128, types=["signal"])
    p.connect(control, 0, ramp)
    p.connect(ramp, 0, base)
    p.connect(base, 0, total)
    p.connect(mod, 0, total, 1)
    p.connect(total, 0, effective)
    p.connect(effective, 0, output)


def action(patch, name, label, column, selector, width=2, target="source_control", hint=None,
           *, row=1, y_offset=0, routing_y=728):
    rect = grid_rect(column, row, width, y_offset=y_offset)
    rect[3] = 32
    control = patch.add(name, "live.text", rect, view=rect, outs=2, types=["", ""],
                        mode=0, text=label, texton=label, parameter_enable=0,
                        **({"hint": hint} if hint else {}))
    patch.obj(name + "_click", "sel bang", 24 + column * 110, routing_y, outs=2,
              types=["bang", ""])
    patch.add(name + "_message", "message", [24 + column * 110, routing_y + 38, 140, 22],
              ins=2, text=selector)
    patch.connect(name, 0, name + "_click")
    patch.connect(name + "_click", 0, name + "_message")
    patch.connect(name + "_message", 0, target)
    return control


def source_input(p):
    band = [MARGIN, INPUT_TOP, TRACKS * TRACK - GUTTER, INPUT_HEIGHT]
    p.add("input_panel", "panel", band, outs=0, view=band, background=1, ignoreclick=1,
          border=0, rounded=6, bgcolor=[0.175, 0.175, 0.18, 1.0])
    for name, text, x, width in (
        ("input_heading", "Input recording", 28, 248),
        ("input_gain_label", "Input gain", 312, 104),
        ("input_level_label", "Input level · after gain", 456, 230),
    ):
        heading = name == "input_heading"
        rect = [x, INPUT_TOP + (8 if heading else 11), width, 22]
        p.add(name, "comment", rect, outs=0, view=rect, text=text,
              **({"fontsize": 16, "fontface": 1} if heading else {}))
    state_rect = [736, INPUT_TOP + 10, 145, 20]
    p.add("input_record_state", "comment", state_rect, outs=0, view=state_rect,
          text="Enable audio to record", fontface=1, textcolor=[0.96, 0.96, 0.97, 1.0])
    time_rect = [946, INPUT_TOP + 10, 74, 20]
    p.add("input_record_time", "comment", time_rect, outs=0, view=time_rect,
          text="00:00.0", fontface=1, textjustification=2,
          hint="Elapsed audio captured in the current or last input take.")
    for index, x in enumerate((292, 716)):
        rect = [x, INPUT_TOP + 10, 1, INPUT_HEIGHT - 20]
        p.add(f"input_divider_{index}", "panel", rect, outs=0, view=rect, background=1,
              ignoreclick=1, border=0, rounded=0, bgcolor=[0.29, 0.29, 0.30, 1.0])

    button_row = 2
    button_offset = INPUT_TOP + 33 - (MARGIN + ROW * button_row)
    for name, text, column, command, hint in (
        ("input_record_button", "Record input", 15, "toggle_input_record",
         "Record the selected inputs as a new source for all four loops."),
        ("input_save_button", "Save input WAV…", 18, "choose_input_save",
         "Save the current input take so a Set can reopen it."),
    ):
        control = action(p, name, text, column, command, 3, hint=hint,
                         row=button_row, y_offset=button_offset, routing_y=2230)
        control["active"] = 0

    for outlet, side, short, x in ((1, "left", "L", 28), (2, "right", "R", 158)):
        name = "input_" + side
        label_rect = [x, INPUT_TOP + 38, 48, 20]
        p.add(name + "_label", "comment", label_rect, outs=0, view=label_rect,
              text="Input " + short)
        menu_rect = [x + 52, INPUT_TOP + 37, 64, 22]
        p.add(name, "umenu", menu_rect, view=menu_rect, outs=3, types=["int", "", ""],
              items=["—"], allowdrag=0, parameter_enable=0,
              hint=f"Select the {side} channel from your Audio Setup device. Choose the same input on both sides for mono.")
        p.obj(name + "_message", f"prepend set_input_channel {outlet}",
              530 + (outlet - 1) * 280, 2230, ins=2)
        p.connect(name, 0, name + "_message")
        p.connect(name + "_message", 0, "source_control")

    gain_rect = [312, INPUT_TOP + 36, 104, 24]
    p.add("input_gain", "live.numbox", gain_rect, view=gain_rect, outs=2, types=["float", "float"],
          hint="Adjust both inputs before metering and recording. 0 dB leaves their level unchanged.",
          **parameter("Input gain", 0, -60, 18, unit_style=4))
    modulated_gain(p, "input_gain", "input_gain_signal", 0, -60, 18, 24, 2750, 691)

    p.obj("input_adc", "adc~ 1 2", 2260, 736, outs=2, types=["signal", "signal"])
    p.obj("input_recorder", "record~ fk-unbound-set 2", 2260, 832, ins=4, types=["signal"])
    p.obj("input_progress", "peakamp~ 0", 2260, 864, ins=2, types=["float"])
    p.obj("input_progress_message", "prepend input_record_progress", 2260, 896, ins=2)
    for channel, side in enumerate(("L", "R")):
        y = INPUT_TOP + 34 + 17 * channel
        label_rect = [456, y - 2, 20, 18]
        meter_rect = [478, y, 216, 12]
        p.add(f"input_meter_label_{side}", "comment", label_rect, outs=0, view=label_rect,
              text=side, fontsize=11)
        meter = f"input_meter_{side}"
        p.add(meter, "live.meter~", meter_rect, view=meter_rect, outs=2,
              types=["float", "int"], orientation=1, clip_size=1,
              hint=f"{side} input peak after gain. Red indicates overload.")
        trimmed = f"input_trim_{side}"
        p.obj(trimmed, "*~", 2260 + 88 * channel, 784, ins=2, types=["signal"])
        p.connect("input_adc", channel, trimmed)
        p.connect("input_gain_signal", 0, trimmed, 1)
        p.connect(trimmed, 0, meter)
        p.connect(trimmed, 0, "input_recorder", channel)
    p.connect("input_recorder", 0, "input_progress")
    p.connect("input_progress", 0, "input_progress_message")
    p.connect("input_progress_message", 0, "source_control")
    p.obj("input_clock", "snapshot~ 100 @active 0", 2470, 864, ins=2, types=["float"])
    p.obj("input_clock_message", "prepend input_elapsed_phase", 2470, 896, ins=2)
    p.connect("input_recorder", 0, "input_clock")
    p.connect("input_clock", 0, "input_clock_message")
    p.connect("input_clock_message", 0, "source_control")

    p.obj("input_rate_message", "prepend input_sample_rate", 1130, 884, ins=2)
    p.connect("dsp_state", 1, "input_rate_message")
    p.connect("input_rate_message", 0, "source_control")
    p.obj("input_device_channels", "adstatus numinputs", 1150, 2230, ins=2, outs=2,
          types=["int", "int"])
    p.obj("input_count_message", "prepend input_channel_count", 1325, 2230, ins=2)
    p.connect("input_device_channels", 1, "input_count_message")
    p.connect("input_count_message", 0, "source_control")

    p.obj("input_save_dialog", "savedialog WAVE", 2540, 812, outs=3, types=["", "", "bang"])
    p.obj("input_save_path", "prepend save_input_path", 2540, 850, ins=2)
    p.connect("input_save_dialog", 0, "input_save_path")
    p.connect("input_save_path", 0, "source_control")


def pattern_controls(p):
    row = 3
    y_offset = PATTERNS_TOP - (MARGIN + row * ROW)
    p.label("pattern_heading", "Patterns", 0, row, 2, heading=True, y_offset=y_offset + 4)
    p.label("set_heading", "Set files", SPLIT, row, 2, heading=True, y_offset=y_offset + 4)
    divider = [MARGIN + TRACK * SPLIT - 7, PATTERNS_TOP, 1, 48]
    p.add("set_divider", "panel", divider, outs=0, view=divider, background=1,
          border=0, rounded=0, bgcolor=[0.37, 0.37, 0.37, 1.0])

    def control_rect(col, width):
        rect = grid_rect(col, row, width, y_offset=y_offset)
        rect[3] = 30
        return rect

    p.obj("pattern_control", "js fk_patterns.js", 1550, 2010, outs=0)
    p.obj("pattern_gain", "line~ 1.", 1550, 2120, ins=2, outs=2, types=["signal", "bang"])
    p.obj("pattern_gain_sample", "snapshot~ 5 @active 0", 1550, 2155, ins=2, types=["float"])
    p.obj("pattern_gain_zero", "sel 0.", 1550, 2190, outs=2, types=["bang", "float"])
    p.obj("pattern_gain_defer", "deferlow", 1550, 2225, types=["bang"])
    p.add("pattern_gain_ready", "message", [1550, 2260, 95, 22], ins=2, text="recall_silent")
    p.connect("pattern_gain", 0, "pattern_gain_sample")
    p.connect("pattern_gain_sample", 0, "pattern_gain_zero")
    p.connect("pattern_gain_zero", 0, "pattern_gain_defer")
    p.connect("pattern_gain_defer", 0, "pattern_gain_ready")
    p.connect("pattern_gain_ready", 0, "pattern_control")
    p.obj("pattern_dsp", "prepend recall_dsp", 1550, 2295, ins=2)
    p.connect("dsp_state", 0, "pattern_dsp")
    p.connect("pattern_dsp", 0, "pattern_control")
    p.obj("pattern_slot_trigger", "t i b", 2460, 2000, outs=2, types=["int", "bang"])
    p.obj("pattern_modifiers", "modifiers", 2580, 2000, outs=5, types=["int"] * 5)
    p.obj("pattern_slot_and_shift", "pack 0 0", 2460, 2035, ins=2)
    p.obj("pattern_slot_command", "prepend slot", 2460, 2070)
    p.connect("pattern_slot_trigger", 1, "pattern_modifiers")
    p.connect("pattern_modifiers", 0, "pattern_slot_and_shift", 1)
    p.connect("pattern_slot_trigger", 0, "pattern_slot_and_shift")
    p.connect("pattern_slot_and_shift", 0, "pattern_slot_command")
    p.connect("pattern_slot_command", 0, "pattern_control")
    for slot in range(1, 9):
        name = f"pattern_{slot}"
        rect = control_rect(slot + 1, 1)
        p.add(name, "live.text", rect, view=rect, outs=2,
             types=["", ""], mode=1, outputmode=1, text=str(slot), texton=str(slot), parameter_enable=0,
             hint=f"Click to recall pattern {slot}. Shift-click to store or replace it.")
        x = 1540 + (slot - 1) * 112
        p.obj(f"pattern_click_{slot}", "t b", x, 1920, types=["bang"])
        p.add(f"pattern_slot_{slot}", "message", [x, 1960, 70, 22], ins=2, text=str(slot))
        p.connect(name, 0, f"pattern_click_{slot}")
        p.connect(f"pattern_click_{slot}", 0, f"pattern_slot_{slot}")
        p.connect(f"pattern_slot_{slot}", 0, "pattern_slot_trigger")
    rect = control_rect(10, 2)
    p.add("pattern_store", "live.text", rect, view=rect, outs=2, types=["", ""],
         mode=0, text="Store pattern", texton="Store pattern", parameter_enable=0)
    p.obj("pattern_store_click", "sel bang", 1675, 2000, outs=2, types=["bang", ""])
    p.add("pattern_toggle_store", "message", [1675, 2035, 100, 22], ins=2, text="toggle_store")
    p.connect("pattern_store", 0, "pattern_store_click")
    p.connect("pattern_store_click", 0, "pattern_toggle_store")
    p.connect("pattern_toggle_store", 0, "pattern_control")
    p.label("pattern_status", "Click to recall. Shift-click to store.",
            0, row + 1, SPLIT, y_offset=y_offset + 8)
    p.label("set_status", "Saves the sample location, patterns, and current mix.",
            SPLIT, row + 1, RIGHT_TRACKS, y_offset=y_offset + 8)

    rect = control_rect(12, 2)
    rect[1] += 4
    rect[2] -= 6
    rect[3] = 22
    p.add("pattern_banks", "umenu", rect, view=rect, outs=3, types=["int", "", ""],
          items=["Banks…", ",", "Load Bank…", ",", "Save Bank…"], align=1, allowdrag=0,
          parameter_enable=0, hint="Load or save a bank of pattern slots.")
    p.obj("pattern_bank_action", "t i b", 1955, 2010, outs=2, types=["int", "bang"])
    p.add("pattern_bank_label", "message", [2050, 2040, 58, 22], ins=2, text="set 0")
    p.obj("pattern_bank_choice", "sel 1 2", 1955, 2040, outs=3, types=["bang", "bang", ""])
    p.connect("pattern_banks", 0, "pattern_bank_action")
    p.connect("pattern_bank_action", 1, "pattern_bank_label")
    p.connect("pattern_bank_label", 0, "pattern_banks")
    p.connect("pattern_bank_action", 0, "pattern_bank_choice")

    for offset, (name, label, command, result, dialog, outputs) in enumerate((
        ("set_open", "Open Set…", "open_set", "read_set", "opendialog JSON", ["", "bang"]),
        ("set_save", "Save Set…", "save_set", "write_set", "savedialog JSON", ["", "", "bang"]),
        ("pattern_load", "Load Bank…", "load_bank", "read_bank", "opendialog JSON", ["", "bang"]),
        ("pattern_save", "Save Bank…", "save_bank", "write_bank", "savedialog JSON", ["", "", "bang"]),
    )):
        if offset < 2:
            rect = control_rect(SPLIT + 2 + offset * 3, 3)
            p.add(name, "live.text", rect, view=rect, outs=2, types=["", ""],
                  mode=0, text=label, texton=label, parameter_enable=0)
        x = 1520 + 145 * offset
        p.add(name + "_message", "message", [x, 2090, 80, 22], ins=2, text=command)
        p.obj(name + "_dialog", dialog, x, 2125, outs=len(outputs), types=outputs)
        p.obj(name + "_result", "prepend " + result, x, 2160, ins=2)
        if offset < 2:
            p.connect(name, 0, name + "_message")
        else:
            p.connect("pattern_bank_choice", offset - 2, name + "_message")
        p.connect(name + "_message", 0, "pattern_control")
        p.connect(name + "_dialog", 0, name + "_result")
        p.connect(name + "_result", 0, "pattern_control")

    p.obj("set_relink_dialog", "opendialog", 2125, 2125, outs=2, types=["", "bang"])
    p.obj("set_relink_result", "prepend relink_set", 2125, 2160, ins=2)
    p.add("set_relink_cancel", "message", [2280, 2160, 100, 22], ins=2, text="cancel_relink")
    p.connect("set_relink_dialog", 0, "set_relink_result")
    p.connect("set_relink_dialog", 1, "set_relink_cancel")
    p.connect("set_relink_result", 0, "pattern_control")
    p.connect("set_relink_cancel", 0, "pattern_control")
    p.obj("set_writer", "node.script fk_set_writer.js @autostart 1", 2425, 2125, outs=2)
    p.connect("set_writer", 0, "pattern_control")


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
    p.label("filter_help", "Filter: LP ← 0 → HP", SPLIT, 10, 3,
            y_offset=PLAYBACK_OFFSET)
    p.label("pitch_scale_label", "Pitch snap · All", SPLIT + 3, 10, 2,
            y_offset=PLAYBACK_OFFSET)
    scale_items = [atom for scale in PITCH_SCALES for atom in (scale, ",")][:-1]
    p.ui("pitch_scale", "umenu", SPLIT + 5, 10, 3, y_offset=PLAYBACK_OFFSET,
         outs=3, types=["int", "", ""], items=scale_items, pattrmode=0,
         hint="Snap the speed of all four windows to a scale. The original sample at 1× is the tonic.")
    p.obj("pitch_scale_default", "loadmess 0", 2280, 805, types=["int"])
    p.obj("pitch_scale_signal", "sig~ 0.", 2280, 845, types=["signal"])
    p.connect("pitch_scale_default", 0, "pitch_scale")
    p.connect("pitch_scale", 0, "pitch_scale_signal")


def performance_mixer(p):
    p.label("mixer_heading", "Mixer", 0, 2, 2, heading=True,
            y_offset=PLAYBACK_OFFSET)
    p.obj("mixer_control", "js fk_mixer.js", 1560, 1880, outs=0)
    p.connect("dsp_enabled", 0, "mixer_control")
    p.ui("mixer_clear_solo", "live.text", 4, 2, y_offset=PLAYBACK_OFFSET, outs=2,
         types=["bang", ""], mode=0, active=0, text="Unsolo", texton="Unsolo",
         parameter_enable=0, hint="Clear all solo buttons and return to the current mute mix.")
    p.add("mixer_unsolo", "message", [1560, 1910, 100, 22], ins=2, text="clear_solos")
    p.connect("mixer_clear_solo", 0, "mixer_unsolo")
    p.connect("mixer_unsolo", 0, "mixer_control")


def stereo_field(p):
    field = Patch()
    field.add("input", "inlet", [20, 320, 30, 30], ins=0, index=1)
    field.add("output", "outlet", [20, 365, 30, 30], outs=0, index=1)
    canvas_rect = [12, 12, 480, 244]
    field.add("canvas", "jsui", canvas_rect, view=canvas_rect,
              filename="fk_stereo_field.js", border=0, parameter_enable=0, types=[""])
    help_rect = [12, 266, 480, 22]
    field.add("help", "comment", help_rect, outs=0, view=help_rect, fontsize=12,
              text="Drag left or right to pan, up or down to set level.")
    field.connect("input", 0, "canvas")
    field.connect("canvas", 0, "output")

    p.ui("stereo_field_open", "live.text", 2, 2, 2, y_offset=PLAYBACK_OFFSET,
         outs=2, types=["bang", ""], mode=0, text="Stereo field…", texton="Stereo field…",
         parameter_enable=0, hint="Open stereo placement and level for the four loops.")
    p.add("stereo_field_open_message", "message", [3040, 1880, 52, 22], ins=2, text="open")
    p.obj("stereo_field_window", "pcontrol", 3040, 1910)
    p.add("stereo_field_panel", "newobj", [3040, 1940, 122, 22],
          text="p Stereo field", types=[""], patcher=dict(
              fileversion=1, appversion=VERSION, classnamespace="box",
              rect=[570, 152, 506, 298], title="Stereo field", openinpresentation=1,
              boxes=field.boxes, lines=field.lines))
    p.connect("stereo_field_open", 0, "stereo_field_open_message")
    p.connect("stereo_field_open_message", 0, "stereo_field_window")
    p.connect("stereo_field_window", 0, "stereo_field_panel")

    p.obj("stereo_field_position", "route position", 3040, 1970, outs=2)
    p.obj("stereo_field_voice", "route 1 2 3 4", 3040, 2000, outs=5)
    p.connect("stereo_field_panel", 0, "stereo_field_position")
    p.connect("stereo_field_position", 0, "stereo_field_voice")
    p.obj("stereo_field_init", "loadbang", 3040, 2040, types=["bang"])
    for voice, pan in enumerate(DEFAULT_PANS, 1):
        x = 3040 + 150 * (voice - 1)
        unpack = f"stereo_field_edit_{voice}"
        state = f"stereo_field_state_{voice}"
        source = f"stereo_field_source_{voice}"
        p.obj(unpack, "unpack f f", x, 2080, outs=2, types=["float", "float"])
        p.obj(state, f"pak {voice} {float(pan)} 70.", x, 2110, ins=3, types=["list"])
        p.obj(source, "prepend source", x, 2140, ins=2)
        p.connect("stereo_field_voice", voice - 1, unpack)
        for axis, control in enumerate((f"pan_{voice}", f"level_{voice}")):
            p.connect(unpack, axis, control)
            p.connect(control, 0, state, axis + 1)
        p.connect("stereo_field_init", 0, state)
        p.connect(state, 0, source)
        p.connect(source, 0, "stereo_field_panel")


def mixer_strip(p, voice, row, y):
    for column, key in ((2, "mute"), (3, "solo")):
        name = f"mixer_{key}_{voice}"
        hint = ("Mute this window without stopping the loop." if key == "mute" else
                "Listen to soloed windows. Mute still silences a window.")
        p.ui(name, "live.text", column, row, y_offset=PLAYBACK_OFFSET, outs=2,
             types=["int", ""], mode=1, text=key.capitalize(), texton=key.capitalize(),
             parameter_enable=0, hint=hint)
        p.obj(name + "_msg", f"prepend {key} {voice}", 2680, y + (column - 2) * 30, ins=2)
        p.connect(name, 0, name + "_msg")
        p.connect(name + "_msg", 0, "mixer_control")

    p.ui(f"mixer_pan_{voice}", "live.numbox", 4, row, y_offset=PLAYBACK_OFFSET,
         outs=2, types=["float", "float"], hint=f"Window {voice} pan",
         **parameter(f"Mixer pan {voice}", DEFAULT_PANS[voice - 1], -100, 100, unit_style=6))
    p.ui(f"mixer_level_{voice}", "live.slider", 0, row + 1, 3, y_offset=PLAYBACK_OFFSET,
         outs=2, types=["float", "float"], orientation=1, showname=0, shownumber=0, relative=0,
         tricolor=[0.56, 0.71, 0.96, 1.0], trioncolor=[0.68, 0.80, 0.99, 1.0],
         hint=f"Window {voice} volume. Click or drag to set it directly.",
         **parameter(f"Mixer level {voice}", 70, 0, 100, unit_style=5))
    level_value = f"mixer_level_value_{voice}"
    p.ui(level_value, "live.numbox", 3, row + 1, y_offset=PLAYBACK_OFFSET + 2,
         outs=2, types=["float", "float"], hint=f"Window {voice} level in percent",
         parameter_mappable=0, **parameter(f"Mixer level value {voice}", 70, 0, 100, unit_style=5))
    p.connect(level_value, 0, f"level_{voice}")
    p.ui(f"meter_{voice}", "live.meter~", 4, row + 1, y_offset=PLAYBACK_OFFSET, outs=2,
         types=["float", "int"], orientation=1, hint=f"Window {voice} peak after mute and solo.")

    for index, key in enumerate(("level", "pan")):
        name = f"mixer_{key}_{voice}"
        base = f"{key}_{voice}"
        sync = f"{name}_sync"
        p.obj(sync, "prepend set", 2680 + 116 * index, y + 62, ins=2)
        p.connect(name, 0, base)
        p.connect(base, 0, sync)
        p.connect(sync, 0, name)
    p.connect(f"mixer_level_{voice}_sync", 0, level_value)


def build():
    p = Patch()
    p.label("title", "FIELD KIT", 0, 0, 3, heading=True)
    p.label("source_label", "Loading demo…", 3, 0, SPLIT - 3, y_offset=4)
    p.label("output_heading", "Audio I/O", SPLIT, 0, 2)
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
    p.obj("set_buffer", "buffer~ fk-unbound-set", 630, 2180, outs=2, types=["float", "bang"])
    p.obj("set_source_info", "info~", 810, 2180, outs=10,
          types=["float", "list", "float", "float", "float", "float", "float", "", "int", ""])
    p.obj("set_buffer_complete", "prepend set_source_read", 935, 2180, ins=2)
    p.connect("set_buffer", 1, "set_source_info")
    p.connect("set_source_info", 0, "set_buffer_complete")
    p.connect("set_buffer_complete", 0, "source_control")
    p.obj("dsp_state", "dspstate~", 1130, 808, outs=4, types=["int", "float", "int", "int"])
    p.obj("dsp_enabled", "prepend dsp_enabled", 1130, 846, ins=2)
    p.connect("dsp_state", 0, "dsp_enabled")
    p.connect("dsp_enabled", 0, "source_control")
    p.obj("source_rate", "sig~ 0.", 880, 846, types=["signal"])

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
    modulated_gain(p, "master", "master_gain", -12, -70, 0, 36, 22, 1840)
    for name, file, col, width, inputs, outputs in (
        ("mix_fx", "fk_fx.maxpat", 0, SPLIT, 2 + FX_MOD_CHANNELS, 2 + FX_MOD_CHANNELS),
        ("recorder", "fk_record.maxpat", SPLIT, RIGHT_TRACKS, 2, 0),
    ):
        rect = grid_rect(col, 22, width, 5, FOOTER_OFFSET)
        p.add(name, "bpatcher", rect, ins=inputs, outs=outputs, types=["signal"] * outputs,
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
    p.obj("normal_blend", "line~ 0.", 1100, 1880, ins=2, outs=2, types=["signal", "bang"])
    p.add("normal_fade_done", "message", [1240, 1880, 115, 22], ins=2, text="normal_faded")
    p.connect("normal_blend", 1, "normal_fade_done")
    p.connect("normal_fade_done", 0, "source_control")
    for channel, suffix in enumerate(("left", "right")):
        mix = "normal_mix_" + suffix[0]
        difference = "normal_difference_" + suffix
        blend = "normal_blend_" + suffix
        x = 820 + 140 * channel
        # Interpolate from the loop mix to the original sample and back.
        p.obj(difference, "-~", x, 1840, ins=2, types=["signal"])
        p.obj(blend, "*~", x, 1880, ins=2, types=["signal"])
        p.obj(mix, "+~", x, 1920, ins=2, types=["signal"])
        p.connect("normal_voice" if channel == 0 else "normal_right_channel", 0, difference)
        p.connect("mix_fx", channel, difference, 1)
        p.connect(difference, 0, blend)
        p.connect("normal_blend", 0, blend, 1)
        p.connect("mix_fx", channel, mix)
        p.connect(blend, 0, mix, 1)
        p.obj("master_" + suffix, "*~", 360 + 140 * channel, 1840, ins=2, types=["signal"])
        p.obj("pattern_level_" + suffix, "*~", 360 + 140 * channel, 1862, ins=2, types=["signal"])
        p.obj("output_" + suffix, "clip~ -0.99 0.99", 360 + 140 * channel, 1880,
              ins=3, types=["signal"])
        p.connect(mix, 0, "master_" + suffix)
        p.connect("master_gain", 0, "master_" + suffix, 1)
        p.connect("master_" + suffix, 0, "pattern_level_" + suffix)
        p.connect("pattern_gain", 0, "pattern_level_" + suffix, 1)
        p.connect("pattern_level_" + suffix, 0, "output_" + suffix)
        p.connect("output_" + suffix, 0, "dac", channel)
        p.connect("output_" + suffix, 0, "recorder", channel)
        p.obj("output_peak_" + suffix, "abs~", 640 + 140 * channel, 1920, types=["signal"])
        p.connect("output_" + suffix, 0, "output_peak_" + suffix)
        p.connect("output_peak_" + suffix, 0, "mix_peak", channel)

    performance_mixer(p)
    p.label("row_heading", "Playback windows", MIXER_TRACKS, 2, 4, heading=True, y_offset=PLAYBACK_OFFSET)
    p.label("wave_heading", "Drag a range, release to set the loop", 9, 2, SPLIT - 9, y_offset=PLAYBACK_OFFSET + 4)
    window_controls(p)

    mod_rect = [MARGIN, MODULATION_TOP, TRACKS * TRACK - GUTTER, MODULATION_ROWS * ROW - GUTTER]
    p.add("patchbay", "bpatcher", mod_rect, ins=1, outs=2,
          types=["multichannelsignal", "int"], view=mod_rect)
    patchbay = p.boxes[-1]["box"]
    patchbay.update(name="fk_modulation.maxpat", args=[], offset=[0.0, 0.0],
                    border=0, clickthrough=0, enablehscroll=0, enablevscroll=0, lockeddragscroll=0)
    p.obj("mod_signals", f"mc.unpack~ {MOD_CHANNELS}", 28, 886, outs=MOD_CHANNELS,
          types=["signal"] * MOD_CHANNELS, width=1016)
    p.connect("patchbay", 0, "mod_signals")
    p.obj("watch_target", f"selector~ {MOD_CHANNELS} 1", 1560, 886, ins=MOD_CHANNELS + 1,
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
        p.ui(f"wave_{voice}", "waveform~", MIXER_TRACKS, row, SPLIT - MIXER_TRACKS, 2,
             y_offset=PLAYBACK_OFFSET, ins=5, outs=6,
             types=["float", "float", "float", "float", "list", "list"], setmode=1)
        p.connect("source_control", voice - 1, f"wave_{voice}", 2)

        y = 950 + 210 * (voice - 1)
        p.obj(f"voice_{voice}", "gen~ fk_voice", 28, y + 132, ins=13, outs=12,
              types=["signal"] * 12, width=500)
        p.obj(f"run_{voice}", "sig~ 0.", 925, y, types=["signal"])
        p.obj(f"wave_edit_revision_{voice}", "sig~ 0.", 1030, y + 108, types=["signal"])
        p.connect(f"run_{voice}", 0, f"voice_{voice}", 9)
        p.connect("source_rate", 0, f"voice_{voice}", 10)
        p.connect("pitch_scale_signal", 0, f"voice_{voice}", 11)
        p.connect(f"wave_edit_revision_{voice}", 0, f"voice_{voice}", 12)

        for i, (key, low, high, default, depth, unit) in enumerate(CELLS):
            control = f"{key}_{voice}"
            base = f"base_{control}"
            if key in ("start", "end"):
                default += 25 * (voice - 1)
            if key == "pan":
                default = DEFAULT_PANS[voice - 1]
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
            route = (voice - 1) * len(CELLS) + i
            p.connect("mod_signals", route, mod)
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
            p.connect(f"voice_{voice}", i + 3, "watch_target", route + 1)
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
        mixer_strip(p, voice, row, y)
        p.obj(f"mixer_gain_{voice}", "line~ 1.", 2680, y + 94, ins=2, outs=2, types=["signal", "bang"])
        p.obj(f"peak_{voice}", "maximum~", 920, y + 170, ins=2, types=["signal"])
        p.connect(f"peak_{voice}", 0, f"meter_{voice}")
        for suffix, outlet in (("left", 0), ("right", 1)):
            mix_channel = f"mixer_{suffix}_{voice}"
            p.obj(mix_channel, "*~", 2680 + 116 * outlet, y + 124, ins=2, types=["signal"])
            p.connect(f"voice_{voice}", outlet, mix_channel)
            p.connect(f"mixer_gain_{voice}", 0, mix_channel, 1)
            p.connect(mix_channel, 0, "mix_fx", outlet)
            rect_x = 780 + outlet * 100
            p.obj(f"abs_{suffix}_{voice}", "abs~", rect_x, y + 132, types=["signal"])
            p.connect(mix_channel, 0, f"abs_{suffix}_{voice}")
            p.connect(f"abs_{suffix}_{voice}", 0, f"peak_{voice}", outlet)

        p.obj(f"track_wave_{voice}", f"prepend track_wave {voice}", 1110, y + 34, ins=2)
        p.connect(f"wave_{voice}", 5, f"track_wave_{voice}")
        p.connect(f"track_wave_{voice}", 0, "source_control")
        p.obj(f"wave_mouse_{voice}", f"prepend wave_mouse {voice}", 1110, y + 102, ins=2)
        p.connect(f"wave_{voice}", 4, f"wave_mouse_{voice}")
        p.connect(f"wave_mouse_{voice}", 0, "source_control")
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

    stereo_field(p)
    source_input(p)
    for index, control in enumerate(("master", "input_gain"), WINDOW_MOD_CHANNELS):
        p.connect("mod_signals", index, f"{control}_mod")
        p.connect(f"{control}_effective", 0, "watch_target", index + 1)
    for channel in range(2, 2 + FX_MOD_CHANNELS):
        index = WINDOW_MOD_CHANNELS + channel
        p.connect("mod_signals", index, "mix_fx", channel)
        p.connect("mix_fx", channel, "watch_target", index + 1)
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
