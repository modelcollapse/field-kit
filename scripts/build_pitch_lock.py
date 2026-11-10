"""Build the stereo phase-vocoder branch and its unprocessed Tape path."""

import json


def write_pitch_fft(patch_type, version, destination):
    fft = patch_type()
    fft.obj("ratio", "in 3", 320, 28, ins=0, types=["float"])
    fft.obj("initialize_clip", "loadmess clip 1", 320, 64, types=[""])
    for channel in (1, 2):
        x = 24 + 150 * (channel - 1)
        fft.obj(f"input_{channel}", f"fftin~ {channel}", x, 28, outs=3, types=["signal"] * 3)
        fft.obj(f"shift_{channel}", "gizmo~ 1.", x, 88, ins=3, outs=2, types=["signal"] * 2)
        fft.obj(f"output_{channel}", f"fftout~ {channel}", x, 148, ins=2, outs=0)
        fft.connect("ratio", 0, f"shift_{channel}", 2)
        fft.connect("initialize_clip", 0, f"shift_{channel}")
        for part in (0, 1):
            fft.connect(f"input_{channel}", part, f"shift_{channel}", part)
            fft.connect(f"shift_{channel}", part, f"output_{channel}", part)
    patcher = dict(fileversion=1, appversion=version, classnamespace="box",
                   rect=[60, 80, 505, 222], boxes=fft.boxes, lines=fft.lines)
    destination.write_text(json.dumps({"patcher": patcher}, indent=2) + "\n")


def pitch_lock_patch(patch_type, version):
    branch = patch_type()
    for index, (name, signal) in enumerate((("left", True), ("right", True),
                                            ("ratio", True), ("mode", False)), 1):
        branch.add(name, "inlet", [30 + 102 * (index - 1), 25, 26, 26], ins=0,
                   index=index, types=["signal" if signal else "int"])
    branch.obj("sample_ratio", "snapshot~ 10", 234, 65, ins=2, types=["float"])
    branch.obj("spectral_shift", "pfft~ fk_pitch_fft 2048 8", 30, 105, ins=3, outs=2, types=["signal"] * 2)
    branch.obj("select_mode", "+ 1", 336, 65, ins=2, types=["int"])
    branch.connect("ratio", 0, "sample_ratio")
    branch.connect("sample_ratio", 0, "spectral_shift", 2)
    branch.connect("mode", 0, "select_mode")
    for index, side in enumerate(("left", "right")):
        x = 30 + 155 * index
        selector = "output_" + side
        branch.obj(selector, "selector~ 2 1 @ramptime 35", x, 150, ins=3, types=["signal"])
        branch.add("out_" + side, "outlet", [x, 195, 26, 26], index=index + 1, outs=0)
        branch.connect(side, 0, "spectral_shift", index)
        branch.connect(side, 0, selector, 1)
        branch.connect("spectral_shift", index, selector, 2)
        branch.connect("select_mode", 0, selector)
        branch.connect(selector, 0, "out_" + side)
    return dict(fileversion=1, appversion=version, classnamespace="box",
                rect=[60, 80, 480, 245], boxes=branch.boxes, lines=branch.lines)
