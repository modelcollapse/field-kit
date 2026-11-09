"""Place transport, scene controls and master output above the work area."""


def layout_performance_top(p):
    boxes = {entry["box"]["varname"]: entry["box"] for entry in p.boxes}

    def place(name, rect, **attrs):
        boxes[name].update(presentation_rect=rect, **attrs)

    transport = [8, 54, 298, 60]
    p.add("surface_transport", "panel", transport, view=transport, outs=0,
          background=1, ignoreclick=1, border=0, rounded=8,
          bgcolor=[38 / 255, 48 / 255, 64 / 255, 1.0])
    heading = [18, 59, 125, 19]
    p.add("transport_label", "comment", heading, view=heading, outs=0,
          text="Transport", fontsize=15, fontface=1,
          textcolor=[243 / 255, 247 / 255, 252 / 255, 1.0])
    for name, left, width in (("play", 18, 67), ("stop", 90, 65),
                              ("normal", 160, 86), ("reset", 251, 45)):
        place(name, [left, 81, width, 25])

    place("surface_mix_scene_strip", [314, 54, 392, 60], rounded=8)
    place("mix_scene_label", [324, 59, 90, 19], fontsize=15)
    for field, left, width in (("current", 324, 56), ("next", 387, 69), ("bar", 461, 68)):
        place(f"mix_scene_{field}", [left, 84, width, 20], fontsize=12)
    place("mix_scene_toggle", [535, 81, 73, 25])
    place("mix_scene_advance", [614, 81, 82, 25])

    place("surface_master_output", [714, 54, 362, 60])
    place("master_label", [724, 59, 69, 19])
    place("master", [724, 81, 65, 25])
    for index, side in enumerate(("left", "right")):
        y = 67 + index * 21
        place(f"master_channel_label_{side}", [798, y, 14, 16], fontsize=11)
        place(f"master_meter_{side}", [815, y + 3, 194, 12])
        place(f"master_clip_{side}", [1019, y + 4, 11, 11])
        place(f"master_clip_label_{side}", [1034, y, 32, 16], fontsize=11)
