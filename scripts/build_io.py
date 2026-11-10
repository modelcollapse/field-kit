"""Build the audio device and MIDI input setup window."""


def add_io_setup(p, panel, version):
    def label(name, caption, rect, **attributes):
        panel.add(name, "comment", rect, view=rect, outs=0, text=caption, **attributes)

    def menu(name, caption, rect):
        panel.add(name, "umenu", rect, view=rect, outs=3, types=["int", "", ""],
                  items=[caption], allowdrag=0, parameter_enable=0)

    def button(name, caption, rect):
        panel.add(name, "live.text", rect, view=rect, outs=2, types=["bang", ""],
                  text=caption, texton=caption, mode=0, parameter_enable=0)

    label("io_title", "Audio & MIDI Setup", [16, 12, 240, 26], fontsize=16, fontface=1)
    button("io_refresh", "Refresh", [326, 14, 76, 23])
    button("io_close", "Close", [410, 14, 70, 23])
    label("io_input_label", "Input device", [16, 54, 114, 23])
    label("io_output_label", "Output device", [16, 89, 114, 23])
    menu("io_audio_input", "No device", [134, 54, 346, 24])
    menu("io_audio_output", "No device", [134, 89, 346, 24])
    label("io_audio_status", "Choose recording channels in the main Input section.", [16, 123, 464, 21])
    label("io_midi_label", "MIDI In", [16, 163, 114, 23], fontface=1)
    menu("io_midi_input", "Off", [134, 163, 346, 24])
    label("io_target_label", "Control", [16, 199, 114, 23])
    menu("io_target", "Global speed", [134, 199, 174, 24])
    button("io_learn", "Learn", [318, 199, 76, 24])
    button("io_forget", "Clear", [404, 199, 76, 24])
    label("io_midi_status", "Choose a MIDI input to begin.", [16, 233, 464, 21])
    label("io_midi_help", "Use CC knobs for values and a note or momentary CC for buttons.", [16, 260, 464, 21])
    button("io_advanced", "Advanced audio…", [16, 298, 146, 23])

    panel.add("io_open", "inlet", [16, 290, 26, 26], ins=0, index=1)
    panel.add("io_events", "outlet", [16, 500, 26, 26], outs=0, index=1)
    panel.connect("io_refresh", 0, "io_events")
    for index, (name, selector) in enumerate((("io_learn", "learn"), ("io_forget", "forget"))):
        panel.add(name + "_event", "message", [16 + index * 100, 456, 90, 22], ins=2, text=selector)
        panel.connect(name, 0, name + "_event")
        panel.connect(name + "_event", 0, "io_events")
    for index, (name, selector) in enumerate((
        ("io_audio_input", "input_device"),
        ("io_audio_output", "output_device"),
        ("io_midi_input", "midi_device"),
        ("io_target", "target"),
    )):
        panel.obj(name + "_event", f"prepend {selector}", 16 + index * 160, 398, ins=2)
        panel.connect(name, 0, name + "_event")
        panel.connect(name + "_event", 0, "io_events")

    panel.obj("io_thispatcher", "thispatcher", 290, 457, outs=2, types=["", ""])
    for name, command, x in (("io_close", "wclose", 290), ("io_advanced", "; dsp open", 407)):
        panel.add(name + "_message", "message", [x, 421, 100, 22], ins=2, text=command)
        panel.connect(name, 0, name + "_message")
    panel.connect("io_close_message", 0, "io_thispatcher")
    for key, option in (("input", 0), ("output", 1)):
        panel.obj("io_" + key + "_setting", f"adstatus option {option}", 16 + 170 * option, 318, ins=2, outs=2)
        panel.connect("io_" + key + "_setting", 0, "io_audio_" + key)

    patcher = dict(fileversion=1, appversion=version, classnamespace="box", title="Audio & MIDI Setup",
                   rect=[260, 160, 496, 337], openinpresentation=1, toolbarvisible=0,
                   boxes=panel.boxes, lines=panel.lines)
    p.obj("io_setup_window", "pcontrol", 1420, 837)
    p.add("io_setup_panel", "newobj", [1420, 870, 160, 22], outs=1, types=[""],
          text="p Audio & MIDI Setup", patcher=patcher)
    p.connect("io_setup_window", 0, "io_setup_panel")
    p.add("open_audio_setup", "message", [1420, 804, 118, 22], ins=2, text="open_io_setup")
    p.connect("audio_setup", 0, "open_audio_setup")
    p.connect("open_audio_setup", 0, "theme_control")

    p.obj("io_control", "js fk_io.js", 1530, 938, ins=2, outs=0)
    p.connect("io_setup_panel", 0, "io_control")
    p.obj("io_midi_ports", "midiinfo @autopollinput 1", 1530, 905, ins=2)
    p.add("io_midi_query", "message", [1420, 905, 40, 22], ins=2, text="0")
    p.connect("io_midi_query", 0, "io_midi_ports", 1)
    p.connect("io_midi_ports", 0, "io_control", 1)
    for i, (kind, obj) in enumerate((("note", "notein"), ("cc", "ctlin"))):
        x = 1700 + i * 172
        port, packed, message = (f"io_midi_{kind}{suffix}" for suffix in ("_in", "_pack", "_event"))
        p.obj(port, f"{obj} none @matchport 1", x, 840, outs=3, types=["int", "int", "int"])
        p.obj(packed, "pack 0 0 0", x, 873, ins=3, types=["list"])
        for outlet in range(3):
            p.connect(port, outlet, packed, outlet)
        p.obj(message, f"prepend {kind}", x, 906, ins=2)
        p.connect(packed, 0, message)
        p.connect(message, 0, "io_control")
