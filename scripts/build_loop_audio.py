"""Build the loop audio controls, confirmation window, and reusable buffer pool."""


def add_loop_audio(p, panel, version):
    def button(patch, name, caption, rect):
        patch.add(name, "live.text", rect, view=rect, outs=2, types=["bang", ""],
                  mode=0, parameter_enable=0, text=caption, texton=caption)

    def command(patch, control, name, text, target, x, y):
        patch.add(name, "message", [x, y, 125, 22], ins=2, text=text)
        patch.connect(control, 0, name)
        patch.connect(name, 0, target)

    rect = [0, 0, 112, 22]
    p.add("loop_copy", "umenu", rect, view=rect, outs=3, types=["int", "", ""],
          items=["Copy to Loop…", ",", "Loop 1", ",", "Loop 2", ",", "Loop 3", ",", "Loop 4"],
          allowdrag=0, parameter_enable=0)
    p.obj("loop_copy_command", "prepend copy_loop_to", 1720, 2780, ins=2)
    p.connect("loop_copy", 0, "loop_copy_command")
    p.connect("loop_copy_command", 0, "source_control")
    button(p, "loop_replace", "Replace audio…", [0, 0, 110, 22])
    command(p, "loop_replace", "loop_choose_audio", "choose_loop_audio", "source_control", 1890, 2780)
    p.obj("loop_file", "opendialog", 1890, 2810, outs=2, types=["", "bang"])
    p.obj("loop_file_path", "prepend stage_loop_file", 1890, 2840, ins=2)
    p.add("loop_file_cancel", "message", [2070, 2840, 112, 22], ins=2, text="discard_loop_audio")
    p.connect("loop_file", 0, "loop_file_path")
    p.connect("loop_file", 1, "loop_file_cancel")
    p.connect("loop_file_path", 0, "source_control")
    p.connect("loop_file_cancel", 0, "source_control")

    rect = [16, 12, 388, 28]
    panel.add("take_title", "comment", rect, view=rect, outs=0, text="Replace loop audio", fontsize=16, fontface=1)
    rect = [16, 46, 388, 24]
    panel.add("take_detail", "comment", rect, view=rect, outs=0, text="")
    button(panel, "take_confirm", "Use on Loop", [16, 84, 156, 26])
    button(panel, "take_discard", "Discard", [182, 84, 110, 26])
    panel.add("take_in", "inlet", [16, 160, 26, 26], ins=0, index=1)
    panel.add("take_out", "outlet", [16, 243, 26, 26], outs=0, index=1)
    command(panel, "take_confirm", "take_use", "confirm_loop_audio", "take_out", 16, 203)
    command(panel, "take_discard", "take_cancel", "discard_loop_audio", "take_out", 160, 203)
    panel.obj("take_thispatcher", "thispatcher", 288, 203, outs=2)
    panel.obj("take_closebang", "closebang", 290, 160, types=["bang"])
    command(panel, "take_closebang", "take_closed", "loop_take_closed", "take_out", 290, 242)
    patcher = dict(fileversion=1, appversion=version, classnamespace="box",
                   title="Replace loop audio", rect=[290, 182, 420, 130],
                   openinpresentation=1, toolbarvisible=0, boxes=panel.boxes, lines=panel.lines)
    p.obj("loop_take_window", "pcontrol", 2290, 2780)
    p.add("loop_take_panel", "newobj", [2290, 2810, 160, 22], outs=1, types=[""],
          text="p Replace loop audio", patcher=patcher)
    p.connect("loop_take_window", 0, "loop_take_panel")
    p.connect("loop_take_panel", 0, "source_control")

    # Four current sources and four staged sources during a transactional Set open.
    for slot in range(8):
        x = 240 + 205 * slot
        p.obj(f"loop_buffer_{slot}", f"buffer~ fk-loop-unbound-{slot}", x, 2780, outs=2,
              types=["float", "bang"])
        p.obj(f"loop_info_{slot}", "info~", x, 2810, outs=10,
              types=["float", "list", "float", "float", "float", "float", "float", "", "int", ""])
        p.obj(f"loop_ready_{slot}", f"prepend loop_buffer_ready {slot}", x, 2840, ins=2)
        p.connect(f"loop_buffer_{slot}", 1, f"loop_info_{slot}")
        p.connect(f"loop_info_{slot}", 0, f"loop_ready_{slot}")
        p.connect(f"loop_ready_{slot}", 0, "source_control")
