"""Build the audio setup, MIDI mappings, and MIDI port patchers."""


def label(panel, name, caption, rect, **attributes):
    panel.add(name, "comment", rect, view=rect, outs=0, text=caption, **attributes)


def menu(panel, name, items, rect, **attributes):
    panel.add(name, "umenu", rect, view=rect, outs=3, types=["int", "", ""],
              items=[atom for item in items for atom in (item, ",")][:-1],
              allowdrag=0, parameter_enable=0, **attributes)


def button(panel, name, caption, rect, *, toggle=False, active=True):
    panel.add(name, "live.text", rect, view=rect, outs=2, types=["int" if toggle else "bang", ""],
              text=caption, texton=caption, mode=int(toggle), active=int(active), parameter_enable=0)


def route(panel, source, selector, x, y, *, send_value=False, target="events"):
    node = source + "_event"
    if send_value:
        panel.obj(node, f"prepend {selector}", x, y, ins=2)
    else:
        panel.add(node, "message", [x, y, 130, 22], ins=2, text=selector)
    panel.connect(source, 0, node)
    panel.connect(node, 0, target)


def add_window(p, panel, name, title, rect, version, patching_rect):
    window = name + "_window"
    content = name + "_panel"
    p.obj(window, "pcontrol", patching_rect[0], patching_rect[1] - 33)
    patcher = dict(fileversion=1, appversion=version, classnamespace="box", title=title,
                   rect=rect, openinpresentation=1, toolbarvisible=0,
                   boxes=panel.boxes, lines=panel.lines)
    p.add(content, "newobj", patching_rect, outs=1, types=[""], text=f"p {title}", patcher=patcher)
    p.connect(window, 0, content)
    p.connect(content, 0, "io_control")


def add_audio_panel(p, panel, version):
    label(panel, "io_title", "Audio & MIDI Setup", [16, 12, 240, 26], fontsize=16, fontface=1)
    button(panel, "io_refresh", "Refresh", [326, 14, 76, 23])
    button(panel, "io_close", "Close", [410, 14, 70, 23])
    label(panel, "io_input_label", "Input device", [16, 54, 114, 23])
    label(panel, "io_output_label", "Output device", [16, 89, 114, 23])
    menu(panel, "io_audio_input", ("No device",), [134, 54, 346, 24])
    menu(panel, "io_audio_output", ("No device",), [134, 89, 346, 24])
    label(panel, "io_audio_status", "Choose recording channels in the main Input section.", [16, 123, 464, 21])
    button(panel, "io_advanced", "Advanced audio…", [16, 164, 146, 25])
    button(panel, "io_open_mappings", "MIDI Mappings…", [326, 164, 154, 25])

    panel.add("window_messages", "inlet", [16, 218, 26, 26], ins=0, index=1)
    panel.add("events", "outlet", [16, 462, 26, 26], outs=0, index=1)
    panel.connect("io_refresh", 0, "events")
    route(panel, "io_open_mappings", "open_mappings", 16, 416)
    route(panel, "io_audio_input", "input_device", 16, 361, send_value=True)
    route(panel, "io_audio_output", "output_device", 186, 361, send_value=True)
    panel.obj("io_thispatcher", "thispatcher", 298, 459, outs=2, types=["", ""])
    route(panel, "io_close", "wclose", 298, 416, target="io_thispatcher")
    panel.add("io_advanced_event", "message", [440, 416, 100, 22], ins=2, text="; dsp open")
    panel.connect("io_advanced", 0, "io_advanced_event")
    for key, option in (("input", 0), ("output", 1)):
        panel.obj(f"io_{key}_setting", f"adstatus option {option}", 16 + 170 * option, 315, ins=2, outs=2)
        panel.connect(f"io_{key}_setting", 0, f"io_audio_{key}")

    add_window(p, panel, "io_setup", "Audio & MIDI Setup", [260, 160, 496, 207], version, [1420, 870, 160, 22])
    p.add("open_audio_setup", "message", [1420, 804, 118, 22], ins=2, text="open_io_setup")
    p.connect("audio_setup", 0, "open_audio_setup")
    p.connect("open_audio_setup", 0, "theme_control")


def add_mapping_table(panel):
    rect = [16, 96, 772, 244]
    panel.add("midi_mapping_table", "jit.cellblock", rect, view=rect, ins=2, outs=4,
              types=["list", "list", "list", "list"], cols=5, rows=2, rowhead=1, colhead=0,
              rowheight=21, vscroll=1, hscroll=0, selmode=3, neverdirty=1, savemode=0,
              border=1, bgcolor=[0.08, 0.11, 0.15, 1], fgcolor=[0.9, 0.93, 0.98, 1],
              headercolor=[0.18, 0.24, 0.32, 1], textcolor=[0.92, 0.95, 0.99, 1],
              hcellcolor=[0.23, 0.35, 0.53, 1], gridlinecolor=[0.24, 0.28, 0.34, 1],
              fontsize=12, fontname="Arial")
    panel.obj("midi_table_init", "loadbang", 16, 605, types=["bang"])
    layout = ", ".join(f"col {i} width {width}" for i, width in enumerate((278, 216, 60, 100, 100)))
    panel.add("midi_table_layout", "message", [16, 635, 340, 22], ins=2, text=layout)
    panel.connect("midi_table_init", 0, "midi_table_layout")
    panel.connect("midi_table_layout", 0, "midi_mapping_table")
    route(panel, "midi_mapping_table", "mapping_row", 380, 635, send_value=True)


def add_mapping_search(panel):
    label(panel, "midi_filter_label", "Show", [16, 55, 42, 23])
    menu(panel, "midi_mapping_filter", ("Mapped", "All controls", "Unmapped"), [64, 55, 127, 24])
    label(panel, "midi_search_label", "Search", [204, 55, 52, 23])
    rect = [260, 55, 288, 24]
    panel.add("midi_mapping_search", "textedit", rect, view=rect, outs=3,
              types=["", "int", ""], outputmode=1, keymode=1, lines=1,
              wordwrap=0, nosymquotes=1, parameter_enable=0, fontsize=12,
              hint="Filter by control, MIDI device, channel, or message. Press Return after pasting.")
    button(panel, "midi_clear_search", "Clear search", [556, 55, 102, 24])
    button(panel, "midi_find", "Find hardware", [666, 55, 122, 24])
    panel.obj("midi_search_text", "route text", 16, 674, ins=2, outs=2, types=["", ""])
    panel.obj("midi_search_content", "route bang", 16, 704, ins=2, outs=2, types=["bang", ""])
    panel.obj("midi_search_event", "prepend mapping_search", 16, 734, ins=2)
    panel.connect("midi_mapping_search", 0, "midi_search_text")
    panel.connect("midi_search_text", 0, "midi_search_content")
    panel.connect("midi_search_content", 1, "midi_search_event")
    panel.connect("midi_search_event", 0, "events")
    route(panel, "midi_search_content", "mapping_search", 185, 734)

    panel.obj("midi_search_keystroke", "t b", 185, 674, types=["bang"])
    panel.obj("midi_search_defer", "deferlow", 185, 704, types=["bang"])
    panel.connect("midi_mapping_search", 1, "midi_search_keystroke")
    panel.connect("midi_search_keystroke", 0, "midi_search_defer")
    panel.connect("midi_search_defer", 0, "midi_mapping_search")
    panel.add("midi_search_clear_value", "message", [336, 674, 80, 22], ins=2, text="set")
    panel.connect("midi_clear_search", 0, "midi_search_clear_value")
    panel.connect("midi_search_clear_value", 0, "midi_mapping_search")
    route(panel, "midi_clear_search", "mapping_search", 336, 704)
    route(panel, "midi_mapping_filter", "mapping_filter", 426, 674, send_value=True)
    route(panel, "midi_find", "find_hardware", 615, 674)


def add_mapping_options(panel):
    label(panel, "midi_mapping_selection", "Select a mapping to edit", [16, 432, 770, 24], fontface=1)
    controls = (
        ("enabled", "Enabled", [16, 464, 80, 24]),
        ("invert", "Invert", [106, 464, 72, 24]),
        ("pickup", "Pickup", [188, 464, 76, 24]),
    )
    for index, (name, caption, rect) in enumerate(controls):
        button(panel, f"midi_{name}", caption, rect, toggle=True, active=False)
        route(panel, f"midi_{name}", f"mapping_option {name}", 16 + 180 * index, 800, send_value=True)

    for index, (name, caption, x) in enumerate((("min", "Min", 278), ("max", "Max", 414))):
        label(panel, f"midi_{name}_label", caption, [x, 464, 39, 23])
        rect = [x + 41, 464, 80, 24]
        panel.add(f"midi_{name}", "flonum", rect, view=rect, outs=2, types=["float", "bang"],
                  parameter_enable=0, ignoreclick=1)
        route(panel, f"midi_{name}", f"mapping_option {name}", 556 + index * 180, 800, send_value=True)

    for index, (name, caption, items, x, width) in enumerate((
        ("encoder", "Encoder", ("Absolute", "Relative (two’s complement)", "Relative (binary offset)",
                                  "Relative (signed bit)"), 16, 220),
        ("button", "Button", ("Press", "Toggle", "Momentary"), 316, 128),
        ("feedback", "Feedback", ("Off",), 524, 192),
    )):
        label(panel, f"midi_{name}_label", caption, [x, 500, 63, 23])
        menu(panel, f"midi_{name}", items, [x + 72, 500, width, 24], ignoreclick=1)
        route(panel, f"midi_{name}", f"mapping_option {name}", 16 + 194 * index, 835, send_value=True)
    button(panel, "midi_apply_options", "Apply options", [658, 464, 130, 24], active=False)
    route(panel, "midi_apply_options", "apply_options", 616, 835)


def add_mappings_panel(p, panel, version):
    panel.add("window_messages", "inlet", [16, 570, 26, 26], ins=0, index=1)
    panel.add("events", "outlet", [16, 980, 26, 26], outs=0, index=1)
    panel.obj("midi_thispatcher", "thispatcher", 610, 980, outs=2, types=["", ""])
    label(panel, "midi_title", "MIDI Mappings", [16, 12, 256, 26], fontsize=17, fontface=1)
    button(panel, "midi_learn", "MIDI Learn", [486, 14, 120, 25])
    button(panel, "midi_undo", "Undo", [614, 14, 80, 25], active=False)
    button(panel, "midi_close", "Close", [702, 14, 86, 25])
    route(panel, "midi_learn", "learn", 312, 571)
    route(panel, "midi_undo", "undo", 459, 571)
    route(panel, "midi_close", "wclose", 606, 571, target="midi_thispatcher")
    panel.obj("midi_closebang", "closebang", 312, 908, types=["bang"])
    route(panel, "midi_closebang", "mapping_window_closed", 312, 937)
    panel.obj("midi_window_key", "key", 616, 875, ins=0, outs=4, types=["int"] * 4)
    panel.obj("midi_window_escape", "sel 27", 616, 905, outs=2, types=["bang", ""])
    panel.connect("midi_window_key", 0, "midi_window_escape")
    route(panel, "midi_window_escape", "midi_escape", 616, 935)

    add_mapping_search(panel)
    add_mapping_table(panel)
    label(panel, "midi_mapping_status", "Connect a MIDI controller and click Learn.", [16, 348, 772, 22])
    label(panel, "midi_activity_status", "", [16, 371, 772, 20], fontsize=11)
    for index, (name, caption, selector, x, width) in enumerate((
        ("remap", "Learn selection", "remap", 16, 122),
        ("forget", "Clear mapping", "forget", 146, 112),
        ("conflict_replace", "Replace", "conflict_replace", 466, 102),
        ("conflict_share", "Share", "conflict_share", 576, 102),
        ("conflict_cancel", "Cancel", "conflict_cancel", 686, 102),
    )):
        button(panel, f"midi_{name}", caption, [x, 397, width, 24], active=False)
        route(panel, f"midi_{name}", selector, 16 + 149 * index, 754)

    add_mapping_options(panel)
    button(panel, "midi_import", "Import…", [16, 545, 86, 25])
    label(panel, "midi_import_port_label", "Import device", [112, 545, 90, 23])
    menu(panel, "midi_import_port", ("Keep devices",), [207, 545, 210, 25])
    button(panel, "midi_export", "Export…", [478, 545, 86, 25])
    menu(panel, "midi_export_scope", ("All controllers", "Selected controller"), [572, 545, 216, 25])
    route(panel, "midi_import_port", "mapping_import_port", 16, 937, send_value=True)
    route(panel, "midi_export_scope", "mapping_export_scope", 463, 937, send_value=True)
    panel.obj("midi_import_dialog", "opendialog JSON", 16, 872, outs=2, types=["", "bang"])
    panel.obj("midi_export_dialog", "savedialog JSON", 211, 872, outs=3, types=["", "", "bang"])
    for kind, x in (("import", 16), ("export", 211)):
        panel.connect(f"midi_{kind}", 0, f"midi_{kind}_dialog")
        route(panel, f"midi_{kind}_dialog", f"{kind}_mappings", x, 904, send_value=True)

    add_window(p, panel, "midi_mappings", "MIDI Mappings", [175, 130, 804, 587], version, [1584, 870, 132, 22])


def add_midi_ports(p, panel, version):
    panel.add("port_commands", "inlet", [16, 14, 26, 26], ins=0, index=1)
    panel.add("port_events", "outlet", [16, 256, 26, 26], outs=0, index=1)
    panel.obj("port_controller", "js fk_midi_ports.js", 16, 208, ins=3, outs=1)
    panel.obj("port_load", "loadbang", 171, 14, types=["bang"])
    panel.obj("port_inputs", "midiinfo @autopollinput 1", 16, 132, ins=2)
    panel.obj("port_outputs", "midiinfo @autopolloutput 1", 240, 132, ins=2)
    panel.add("query_inputs", "message", [16, 88, 37, 22], ins=2, text="0")
    panel.add("query_outputs", "message", [240, 88, 37, 22], ins=2, text="0")
    panel.connect("port_load", 0, "query_inputs")
    panel.connect("port_load", 0, "query_outputs")
    panel.connect("query_inputs", 0, "port_inputs", 1)
    panel.connect("query_outputs", 0, "port_outputs")
    panel.connect("port_inputs", 0, "port_controller", 1)
    panel.connect("port_outputs", 0, "port_controller", 2)
    panel.connect("port_commands", 0, "port_controller")
    panel.connect("port_controller", 0, "port_events")
    panel.obj("port_feedback", "midiout none @matchport 1", 240, 210, outs=0)
    patcher = dict(fileversion=1, appversion=version, classnamespace="box",
                   rect=[260, 160, 720, 400], boxes=panel.boxes, lines=panel.lines)
    p.add("io_midi_ports_control", "newobj", [1728, 870, 114, 22], outs=1, types=[""],
          text="p MIDI Ports", patcher=patcher)
    p.connect("io_midi_ports_control", 0, "io_control")


def add_io_setup(p, panel, version):
    p.obj("io_control", "js fk_io.js", 1530, 938, ins=2, outs=0)
    add_audio_panel(p, panel, version)
    add_mappings_panel(p, type(panel)(), version)
    add_midi_ports(p, type(panel)(), version)
