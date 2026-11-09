"""Build FIELD KIT's stock Max stereo capture panel."""

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "max"
WIDTH = 380
HEIGHT = 78


def build(output_dir=ROOT):
    boxes = []
    lines = []

    def box(name, maxclass, rect, ins=1, outputs=(), visible=False, **attributes):
        ident = f"obj-{len(boxes) + 1}"
        data = dict(id=ident, varname=name, maxclass=maxclass, patching_rect=rect,
                    numinlets=ins, numoutlets=len(outputs), **attributes)
        if outputs:
            data["outlettype"] = list(outputs)
        if visible:
            data.update(presentation=1, presentation_rect=rect)
        boxes.append({"box": data})
        return ident

    def obj(name, text, x, y, width, ins=1, outputs=("",)):
        return box(name, "newobj", [x, y, width, 22], ins, outputs, text=text)

    def label(name, text, rect, **attributes):
        return box(name, "comment", rect, visible=True, text=text, **attributes)

    def connect(source, target, outlet=0, inlet=0):
        lines.append({"patchline": {"source": [source, outlet], "destination": [target, inlet]}})

    def action(name, label_text, x, width, selector, router, hint):
        button = box(name, "live.text", [x, 21, width, 21], outputs=("", ""),
                     visible=True, mode=0, active=0, parameter_enable=0,
                     text=label_text, texton=label_text, hint=hint)
        message = box(name + "_message", "message", [x, 150, 90, 22], 2, ("",), text=selector)
        connect(button, message)
        connect(message, router)

    label("capture_title", "Mix recording", [10, 0, 131, 20], fontsize=15, fontface=1)
    label("record_format", "Stereo WAV · 24-bit", [153, 2, 131, 17], fontsize=11)
    label("record_time", "00:00.0", [287, 0, 84, 20], fontsize=16, fontface=1, textjustification=2)
    label("record_status", "Enable audio to record", [10, 44, 361, 17], fontsize=12, fontface=1)
    label("record_file", "", [10, 61, 361, 16], fontsize=11)

    router = obj("rec_controller", "js fk_recorder.js", 240, 216, 120, outputs=())
    action("record_button", "Record mix…", 10, 135, "choose", router, "Choose where to save a WAV of the final mix.")
    action("stop_button", "Stop mix", 153, 91, "stop_record", router, "Finish and save the mix recording.")

    dialog = obj("save_dialog", "savedialog WAVE", 400, 150, 110, outputs=("", "", "bang"))
    chosen = obj("chosen_path", "prepend start_path", 400, 182, 110, 2)
    cancel = box("cancel_dialog", "message", [520, 182, 100, 22], 2, ("",), text="cancel")
    connect(dialog, chosen)
    connect(dialog, cancel, 2)
    connect(chosen, router)
    connect(cancel, router)

    writer = obj("writer", "sfrecord~ 2", 0, 280, 116, 2, ("signal",))
    for index, (x, channel) in enumerate(((0, "Left"), (90, "Right")), 1):
        source = box("audio_" + channel.lower(), "inlet", [x, 216, 30, 30],
                     0, ("signal",), index=index, comment=channel + " final mix")
        connect(source, writer, inlet=index - 1)
    snapshot = obj("elapsed_sample", "snapshot~ 100", 0, 314, 116, 2, ("float",))
    elapsed = obj("elapsed_message", "prepend elapsed", 0, 346, 116, 2)
    connect(writer, snapshot)
    connect(snapshot, elapsed)
    connect(elapsed, router)

    dsp = obj("rec_dsp", "dspstate~", 398, 266, 90, outputs=("int", "float", "int", "int"))
    enabled = obj("enabled_message", "prepend dsp_enabled", 398, 298, 140, 2)
    connect(dsp, enabled)
    connect(enabled, router)
    boot = obj("rec_load", "loadbang", 560, 266, 64, outputs=("bang",))
    defer = obj("rec_defer", "deferlow", 560, 298, 64)
    connect(boot, defer)
    connect(defer, dsp)

    unload = obj("rec_unload", "freebang", 128, 280, 64, outputs=("bang",))
    close = box("close_writer", "message", [128, 314, 40, 22], 2, ("int",), text="0")
    connect(unload, close)
    connect(close, writer)

    patch = {"patcher": {
        "fileversion": 1,
        "appversion": dict(major=9, minor=2, revision=0, architecture="arm64", modernui=1),
        "classnamespace": "box",
        "rect": [80, 80, WIDTH, HEIGHT],
        "openinpresentation": 1,
        "description": "FIELD KIT capture. Feed the final stereo mix into inlets 1 and 2.",
        "boxes": boxes,
        "lines": lines,
    }}
    (Path(output_dir) / "fk_record.maxpat").write_text(json.dumps(patch, ensure_ascii=False, indent=2) + "\n")


if __name__ == "__main__":
    build()
