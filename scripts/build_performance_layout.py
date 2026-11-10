"""Arrange the existing performance controls in the main presentation."""

from build_docked_loop import layout_loop_editor
from build_performance_top import layout_performance_top


PERFORMANCE_WINDOW_HEIGHT = 900


def layout_performance(p, parameter):
    boxes = {entry["box"]["varname"]: entry["box"] for entry in p.boxes}

    def place(name, rect, **attrs):
        boxes[name].update(presentation_rect=rect, **attrs)

    def move_to_y(name, y):
        rect = boxes[name]["presentation_rect"].copy()
        rect[1] = y
        place(name, rect)

    def backdrop(name, rect, **attrs):
        p.add(name, "panel", rect, view=rect, outs=0, background=1,
              ignoreclick=1, border=0, rounded=8, bgcolor=[0.14, 0.19, 0.25, 1], **attrs)

    place("surface_header", [8, 8, 637, 40])
    place("surface_audio", [651, 8, 425, 40])
    place("title", [18, 13, 125, 27])
    place("source_label", [150, 17, 220, 22])
    place("status", [379, 17, 256, 22], fontsize=11)
    boxes["output_heading"]["presentation"] = 0
    place("audio_switch", [661, 16, 103, 24])
    place("theme_choice", [771, 16, 124, 24])
    toggle = [903, 16, 164, 24]
    p.add("source_drawer_toggle", "live.text", toggle, view=toggle, outs=2,
          types=["int", ""], text="Source, Input & Files", texton="Hide Source, Input & Files",
          mode=1, fontsize=11, parameter_mappable=0,
          hint="Show or hide source loading, input routing, source recording and Set files.",
          **parameter("Source drawer view", 0, 0, 1, options=["Closed", "Open"]))
    p.obj("source_drawer_command", "prepend source_drawer", 3240, 1856, ins=2)
    p.connect("source_drawer_toggle", 0, "source_drawer_command")
    p.connect("source_drawer_command", 0, "theme_control")
    layout_performance_top(p, parameter)

    # This hidden panel supplies the insertion point and expansion height.
    backdrop("source_drawer_anchor", [8, 120, 1068, 108], hidden=1)
    drawer = dict(annotation="source_drawer", hidden=1)
    for name, rect in (
        ("surface_source", [8, 120, 284, 102]),
        ("surface_input", [298, 120, 358, 102]),
        ("surface_input_capture", [662, 120, 238, 102]),
        ("input_heading", [20, 128, 83, 22]),
        ("loop_destination", [154, 127, 126, 24]),
        ("load", [20, 163, 125, 28]),
        ("demo", [154, 163, 126, 28]),
        ("audio_setup", [500, 127, 144, 24]),
        ("input_left_label", [310, 154, 65, 19]),
        ("input_right_label", [381, 154, 65, 19]),
        ("input_gain_label", [452, 154, 74, 19]),
        ("input_level_label", [538, 154, 108, 19]),
        ("input_left", [310, 178, 61, 24]),
        ("input_right", [381, 178, 61, 24]),
        ("input_gain", [452, 178, 74, 24]),
        ("input_meter_label_L", [539, 174, 15, 15]),
        ("input_meter_L", [557, 177, 87, 10]),
        ("input_meter_label_R", [539, 191, 15, 15]),
        ("input_meter_R", [557, 194, 87, 10]),
        ("input_record_state", [674, 153, 157, 20]),
        ("input_record_time", [832, 153, 55, 20]),
        ("input_record_button", [674, 184, 111, 26]),
        ("input_save_button", [790, 184, 98, 26]),
        ("set_menu", [918, 155, 146, 24]),
        ("set_status", [918, 182, 146, 36]),
    ):
        place(name, rect, **drawer)
    rect = [105, 130, 46, 19]
    p.add("loop_destination_label", "comment", rect, view=rect, outs=0, text="Send to", fontsize=11, **drawer)
    boxes["input_level_label"].update(text="Input level", fontsize=11)
    boxes["input_record_state"]["fontsize"] = 11
    boxes["input_save_button"]["fontsize"] = 10
    boxes["set_status"]["fontsize"] = 10
    backdrop("surface_source_files", [906, 120, 170, 102], **drawer)
    for name, title, x, width in (
        ("drawer_input_title", "Input", 310, 110),
        ("drawer_capture_title", "Source recording", 674, 211),
    ):
        rect = [x, 128, width, 22]
        p.add(name, "comment", rect, view=rect, outs=0, text=title,
              fontsize=15, fontface=1, **drawer)

    pattern_shift = 128 - boxes["pattern_1"]["presentation_rect"][1]
    for name in ("surface_patterns", "pattern_heading", "pattern_store", "pattern_status",
                 "pattern_banks", "sequence_open", *(f"pattern_{i}" for i in range(1, 9))):
        move_to_y(name, boxes[name]["presentation_rect"][1] + pattern_shift)

    scene_rect = boxes["sequence_panel"]["presentation_rect"]
    move_to_y("sequence_panel", 182)
    backdrop("surface_scenes", [8, 176, 1068, scene_rect[3] + 12], hidden=1)
    place("surface_mixer", [8, 176, 318, 310])
    place("surface_playback", [332, 176, 328, 310])
    place("mixer_heading", [18, 184, 110, 22])
    place("mixer_clear_solo", [160, 183, 64, 22])
    for key, caption, x in (("echo", "Echo %", 230), ("room", "Room %", 278)):
        rect = [x, 186, 42, 19]
        p.add(f"mixer_{key}_sends_label", "comment", rect, view=rect, outs=0,
              text=caption, fontsize=10, fontface=1, textjustification=1)
    place("row_heading", [341, 184, 157, 22])
    place("wave_heading", [499, 186, 151, 20], text="Drag to set loop range", fontsize=11)
    for voice in range(1, 5):
        y = 213 + 67 * (voice - 1)
        for name, x, offset, width, height in (
            ("loop_row", 12, 0, 644, 62),
            ("loop_edit", 18, 6, 24, 22),
            ("play", 47, 6, 58, 22),
            ("mixer_mute", 110, 6, 47, 22),
            ("mixer_solo", 162, 6, 62, 22),
            ("mixer_level", 18, 34, 78, 19),
            ("mixer_level_value", 101, 35, 43, 19),
            ("mixer_pan", 149, 35, 37, 19),
            ("meter", 191, 36, 33, 16),
            ("echo_send", 230, 23, 42, 22),
            ("room_send", 278, 23, 42, 22),
            ("wave", 334, 2, 318, 58),
        ):
            place(f"{name}_{voice}", [x, y + offset, width, height])
    layout_loop_editor(p)

    place("surface_effects", [8, 496, 676, 128])
    move_to_y("mix_fx", 502)
    place("surface_capture", [686, 496, 390, 128])
    move_to_y("recorder", 520)
    place("surface_workspace", [8, 636, 1068, 28])
    for name in ("workspace_label", "workspace_view", "fullscreen_toggle"):
        move_to_y(name, 641)
    place("surface_modulation", [8, 670, 1068, 224])
    backdrop("surface_visuals", [8, 670, 1068, 224], hidden=1)
    for name in ("patchbay", "visuals_panel", "performance_mix", "performance_sends", "drifting_memory", "tuner_panel"):
        move_to_y(name, 676)
