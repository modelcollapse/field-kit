"""Build the working folder settings window in the Files drawer."""


def add_working_folders(p, panel, version):
    def label(name, caption, rect, **attrs):
        panel.add(name, "comment", rect, view=rect, outs=0, text=caption, **attrs)

    def button(name, caption, rect):
        panel.add(name, "live.text", rect, view=rect, outs=2, types=["bang", ""],
                  text=caption, texton=caption, mode=0, parameter_enable=0)

    label("folders_title", "Working folders", [16, 12, 255, 26], fontsize=16, fontface=1)
    button("folders_close", "Close", [444, 14, 72, 23])
    panel.add("folders_open", "inlet", [16, 236, 26, 26], ins=0, index=1)
    panel.add("folders_events", "outlet", [16, 398, 26, 26], outs=0, index=1)
    for index, (key, caption) in enumerate((("import", "Import folder"), ("recording", "Recording folder"))):
        y = 54 + index * 58
        x = 16 + index * 206
        label(key + "_label", caption, [16, y, 345, 20], fontface=1)
        label(key + "_path", "System default", [16, y + 22, 368, 20])
        button(key + "_choose", "Choose…", [400, y + 9, 116, 24])
        panel.obj(key + "_folder_dialog", "opendialog fold", x, 279, outs=2, types=["", "bang"])
        panel.obj(key + "_folder_choice", f"prepend folder_choose {key}", x, 316, ins=2)
        panel.connect(key + "_choose", 0, key + "_folder_dialog")
        panel.connect(key + "_folder_dialog", 0, key + "_folder_choice")
        panel.connect(key + "_folder_choice", 0, "folders_events")
    label("folders_status", "These folders are the starting locations for audio dialogs.",
          [16, 175, 500, 25], fontsize=11)
    panel.add("folders_close_message", "message", [426, 279, 80, 22], ins=2, text="wclose")
    panel.obj("folders_thispatcher", "thispatcher", 426, 316, outs=2)
    panel.connect("folders_close", 0, "folders_close_message")
    panel.connect("folders_close_message", 0, "folders_thispatcher")

    patcher = dict(fileversion=1, appversion=version, classnamespace="box", title="Working folders",
                   rect=[278, 174, 532, 211], openinpresentation=1, toolbarvisible=0,
                   boxes=panel.boxes, lines=panel.lines)
    rect = [918, 127, 146, 24]
    p.add("working_folders", "live.text", rect, view=rect, outs=2, types=["bang", ""],
          text="Working folders…", texton="Working folders…", mode=0, parameter_enable=0,
          annotation="source_drawer", hidden=1)
    p.add("open_working_folders", "message", [2580, 2085, 144, 22], ins=2, text="open_working_folders")
    p.obj("working_folders_window", "pcontrol", 2580, 2120)
    p.add("working_folders_panel", "newobj", [2580, 2155, 154, 22], outs=1, types=[""],
          text="p Working folders", patcher=patcher)
    p.connect("working_folders", 0, "open_working_folders")
    p.connect("open_working_folders", 0, "theme_control")
    p.connect("working_folders_window", 0, "working_folders_panel")
    p.connect("working_folders_panel", 0, "set_writer")
