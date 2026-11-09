"""Build the scene transport beside the workspace tabs."""


def append_mix_scene_strip(patch, x, y, width):
    backplate = [x - 5, y - 2, width + 10, 24]
    patch.add("surface_mix_scene_strip", "panel", backplate, view=backplate, outs=0,
              background=1, ignoreclick=1, border=0, rounded=6,
              bgcolor=[39 / 255, 52 / 255, 68 / 255, 1.0])

    bar_left = width - 228
    for key, text, left, field_width in (
        ("label", "Scenes", 0, 58),
        ("current", "Now —", 60, 52),
        ("next", "Next —", 116, bar_left - 120),
        ("bar", "Bar —", bar_left, 74),
    ):
        rect = [x + left, y + 1, field_width, 19]
        patch.add("mix_scene_" + key, "comment", rect, view=rect, outs=0, text=text,
                  fontsize=12 if key == "label" else 11, fontface=int(key == "label"),
                  textcolor=[243 / 255, 247 / 255, 252 / 255, 1.0])

    for index, (key, label, command, left, button_width, hint) in enumerate((
        ("toggle", "Start", "toggle", width - 150, 62,
         "Start the scene sequence or stop scene changes while the loops keep playing."),
        ("advance", "Next bar", "next", width - 80, 80,
         "Queue the next stored scene for the next bar boundary."),
    )):
        name = "mix_scene_" + key
        rect = [x + left, y, button_width, 20]
        patch.add(name, "live.text", rect, view=rect, outs=2, types=["bang", ""],
                  mode=0, text=label, texton=label, parameter_enable=0, active=0, hint=hint)
        message = name + "_command"
        patch.add(message, "message", [2615, 2370 + index * 32, 68, 22],
                  ins=2, text=command)
        patch.connect(name, 0, message)
        patch.connect(message, 0, "sequence_control")
