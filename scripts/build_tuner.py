"""Build the stock Max tuner and its input taps."""


def add_tuner(p, patch_type, version):
    window = patch_type()
    for index, name in enumerate(("live_left", "live_right", "selected_loop"), 1):
        window.add(name, "inlet", [18 + index * 72, 250, 26, 26], ins=0, types=["signal"], index=index)
    heading = [18, 10, 62, 25]
    window.add("tuner_title", "comment", heading, view=heading, outs=0, text="Tuner",
               fontsize=16, fontface=1)
    menu = [85, 10, 131, 25]
    window.add("tuner_source", "umenu", menu, view=menu, outs=3, types=["int", "", ""],
               items=["Live input L", ",", "Live input R", ",", "Selected loop"], parameter_enable=0)
    reference = [223, 13, 93, 20]
    window.add("tuner_reference", "comment", reference, view=reference, outs=0,
               text="A4 = 440 Hz", fontsize=11)
    canvas = [16, 44, 296, 154]
    window.add("tuner_canvas", "jsui", canvas, view=canvas, outs=0,
               filename="fk_tuner.js", background=1, border=0, parameter_enable=0)
    window.obj("tuner_input", "selector~ 3 1", 90, 348, ins=4, types=["signal"])
    window.obj("tuner_input_index", "+ 1", 18, 320, ins=2, types=["int"])
    window.obj("tuner_reset", "t b i", 18, 350, outs=2, types=["bang", "int"])
    window.obj("tuner_pitch", "fzero~ @freqmin 40 @freqmax 1800 @size 4096 @period 2048 @threshold 0.003 @quiet 1",
               90, 380, outs=3, types=["float", "float", "bang"])
    window.obj("tuner_hz", "prepend frequency", 90, 410, ins=2)
    for index, name in enumerate(("live_left", "live_right", "selected_loop"), 1):
        window.connect(name, 0, "tuner_input", index)
    window.connect("tuner_source", 0, "tuner_input_index")
    window.connect("tuner_input_index", 0, "tuner_reset")
    window.connect("tuner_reset", 1, "tuner_input")
    window.connect("tuner_reset", 0, "tuner_canvas")
    window.connect("tuner_input", 0, "tuner_pitch")
    window.connect("tuner_pitch", 0, "tuner_hz")
    window.connect("tuner_hz", 0, "tuner_canvas")

    rect = [748, 676, 328, 212]
    p.add("tuner_panel", "bpatcher", [3600, 2080, 100, 22], view=rect, ins=3, outs=0,
          embed=1, hidden=1, border=0, enablehscroll=0, enablevscroll=0, lockeddragscroll=0,
          clickthrough=0, bgmode=0, offset=[0.0, 0.0],
          patcher=dict(fileversion=1, appversion=version, classnamespace="box",
                       rect=[0, 0, rect[2], rect[3]], openinpresentation=1, toolbarvisible=0,
                       title="Tuner", boxes=window.boxes, lines=window.lines))
    p.obj("tuner_selected_loop", "selector~ 4 1", 3600, 2000, ins=5, types=["signal"])
    for voice in range(1, 5):
        name = f"tuner_loop_mono_{voice}"
        p.obj(name, "*~ 0.5", 3600 + 90 * (voice - 1), 1970, ins=2, types=["signal"])
        p.connect(f"voice_pitch_{voice}", 0, name)
        p.connect(f"voice_pitch_{voice}", 1, name)
        p.connect(name, 0, "tuner_selected_loop", voice)
    p.connect("tuner_selected_loop", 0, "tuner_panel", 2)
    for channel, side in enumerate(("L", "R")):
        p.connect(f"input_trim_{side}", 0, "tuner_panel", channel)
