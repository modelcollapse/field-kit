"""Dock the existing loop inspector alongside the waveform rows."""

_DOCK_WIDTH = 408
_DOCK_HEIGHT = 310

# Relative to the dock. Keep each group on its existing theme surface.
_DOCK_RECTS = {
    "surface_editor_playback": (0, 0, 408, 104),
    "inspector_title": (12, 7, 384, 23),
    "inspector_label_start": (12, 34, 64, 17),
    "inspector_label_end": (84, 34, 64, 17),
    "inspector_label_direction": (156, 34, 120, 17),
    "inspect_start": (12, 52, 64, 22),
    "inspect_end": (84, 52, 64, 22),
    "inspect_direction": (156, 52, 120, 22),
    "pitch_scale_label": (12, 78, 130, 20),
    "pitch_scale": (145, 78, 131, 20),
    "inspect_rate": (282, 33, 56, 66),
    "inspect_fade": (342, 33, 55, 66),

    "surface_editor_fx": (0, 109, 408, 87),
    "loop_fx_heading": (12, 115, 61, 17),
    "inspect_drive": (10, 134, 58, 55),
    "filter_type_heading": (76, 115, 320, 17),
    "inspect_filter_type": (76, 133, 320, 22),
    "filter_sweep_heading": (76, 160, 87, 19),
    "inspect_filter": (168, 160, 165, 20),
    "inspect_filter_value": (340, 160, 56, 20),

    "surface_editor_mix": (0, 201, 103, 109),
    "loop_mix_heading": (10, 207, 83, 19),
    "inspect_level": (5, 230, 44, 69),
    "inspect_pan": (54, 230, 44, 69),
    "surface_editor_fade": (108, 201, 300, 109),
    "fade_preview_heading": (118, 207, 280, 19),
    "loop_fade_preview": (116, 229, 284, 73),
}


def layout_loop_editor(p, x=668, y=176, width=_DOCK_WIDTH, height=_DOCK_HEIGHT):
    """Change presentation geometry while keeping the inspector's controls and connections."""
    boxes = {entry["box"].get("varname"): entry["box"] for entry in p.boxes}
    for name, (left, top, w, h) in _DOCK_RECTS.items():
        left_px = round(left * width / _DOCK_WIDTH)
        top_px = round(top * height / _DOCK_HEIGHT)
        right_px = round((left + w) * width / _DOCK_WIDTH)
        bottom_px = round((top + h) * height / _DOCK_HEIGHT)
        rect = [x + left_px, y + top_px, right_px - left_px, bottom_px - top_px]
        box = boxes[name]
        box["presentation_rect"] = rect
        if name == "loop_fade_preview":
            # Max's jsui draws at the patching size even in presentation mode.
            box["patching_rect"][2:] = rect[2:]
