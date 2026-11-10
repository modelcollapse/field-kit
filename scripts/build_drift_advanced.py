"""Lay out the existing Drifting Memory controls in the Mix drawer."""

DRIFT_ADVANCED_WIDTH = 440
DRIFT_ADVANCED_HEIGHT = 212
DRIFT_ADVANCED_TABS = ("Time", "Texture", "I/O")

# A caption creates a new label. A blank caption identifies an existing control.
_LAYOUT = (
    (
        ("drift_size_label", (12, 43, 185, 16), "Delay size"),
        ("size", (12, 62, 186, 25), ""),
        ("drift_transport_label", (211, 43, 217, 16), "Wet playback"),
        ("reverse", (211, 62, 95, 25), ""),
        ("half_speed", (314, 62, 114, 25), ""),
        ("drift_rhythm_style_label", (12, 95, 416, 16), "Rhythmic style"),
        ("rhythm_style", (12, 113, 416, 24), ""),
        ("drift_rhythm_length_label", (12, 145, 150, 16), "Rhythmic length"),
        ("rhythm_free", (12, 163, 150, 24), ""),
        ("drift_tempo_label", (181, 145, 101, 16), "BPM"),
        ("tempo", (181, 163, 101, 24), ""),
        ("drift_beats_label", (299, 145, 129, 16), "Beats / bar"),
        ("beats_per_bar", (299, 163, 129, 24), ""),
        ("drift_rhythm_help", (12, 190, 416, 16), "Rhythmic settings apply in Rhythmic mode."),
    ),
    (
        ("blur", (12, 44, 80, 57), ""),
        ("width", (96, 44, 80, 57), ""),
        ("pitch", (180, 44, 80, 57), ""),
        ("drive", (264, 44, 80, 57), ""),
        ("dynamics", (348, 44, 80, 57), ""),
        ("drift_hpf_label", (12, 108, 296, 16), "High-pass filter"),
        ("hpf", (12, 126, 296, 23), ""),
        ("drift_hpf_cutoff_label", (320, 108, 108, 16), "Cutoff (Hz)"),
        ("hpf_hz", (320, 126, 108, 23), ""),
        ("drift_lpf_label", (12, 153, 296, 16), "Low-pass filter"),
        ("lpf", (12, 171, 296, 23), ""),
        ("drift_lpf_cutoff_label", (320, 153, 108, 16), "Cutoff (Hz)"),
        ("lpf_hz", (320, 171, 108, 23), ""),
    ),
    (
        ("drift_input_label", (12, 44, 113, 16), "Input"),
        ("drift_input_trim_label", (143, 44, 67, 16), "Trim"),
        ("drift_input_left_label", (12, 63, 15, 14), "L"),
        ("input_meter_left", (30, 66, 101, 9), ""),
        ("drift_input_right_label", (12, 82, 15, 14), "R"),
        ("input_meter_right", (30, 85, 101, 9), ""),
        ("input_trim", (143, 67, 67, 23), ""),
        ("drift_output_label", (228, 44, 113, 16), "Output"),
        ("drift_output_trim_label", (359, 44, 69, 16), "Trim"),
        ("drift_output_left_label", (228, 63, 15, 14), "L"),
        ("output_meter_left", (246, 66, 101, 9), ""),
        ("drift_output_right_label", (228, 82, 15, 14), "R"),
        ("output_meter_right", (246, 85, 101, 9), ""),
        ("output_trim", (359, 67, 69, 23), ""),
        ("drift_input_gate_label", (12, 104, 198, 16), "Input gate"),
        ("input_gate", (12, 123, 198, 24), ""),
        ("drift_input_route_label", (228, 104, 200, 16), "Input routing"),
        ("mono_input", (228, 123, 200, 24), ""),
        ("drift_memory_actions_label", (12, 155, 416, 16), "Memory actions"),
        ("erase", (12, 174, 132, 25), ""),
        ("clear", (154, 174, 132, 25), ""),
        ("panic", (296, 174, 132, 25), ""),
    ),
)
DRIFT_ADVANCED_PAGES = tuple(tuple(name for name, _, _ in page) for page in _LAYOUT)


def layout_drift_advanced(drift, parameter):
    """Present the canonical effect controls without moving their patch cords."""
    width, height = DRIFT_ADVANCED_WIDTH, DRIFT_ADVANCED_HEIGHT
    drift.update(rect=[0, 0, width, height], openrect=[0, 0, width, height],
                 openinpresentation=1, enablehscroll=0, enablevscroll=0, toolbarvisible=0)
    named = {}
    for entry in drift["boxes"]:
        box = entry["box"]
        if box.get("presentation"):
            box["presentation"] = 0
        if "varname" in box:
            named[box["varname"]] = box

    def add(name, cls, rect, ins=1, outputs=(), **attrs):
        box = dict(id=f"mix-drift-advanced-{name}", varname=name, maxclass=cls,
                   patching_rect=list(rect), numinlets=ins, numoutlets=len(outputs), **attrs)
        if outputs:
            box["outlettype"] = list(outputs)
        drift["boxes"].append({"box": box})
        return box

    def present(box, rect, hidden=False):
        box.update(presentation=1, presentation_rect=list(rect), hidden=int(hidden))

    def label(name, text, rect, hidden=False, fontsize=11, bold=False):
        x, y, w, h = rect
        box = add(name, "comment", [1600 + x, y, w, h], text=text,
                  fontsize=fontsize, fontface=int(bold))
        present(box, rect, hidden)

    def connect(source, outlet, target):
        drift["lines"].append({"patchline": {"source": [source["id"], outlet],
                                             "destination": [target["id"], 0]}})

    surface = add("surface_mix_drift_advanced", "panel", [1600, 0, width, height], background=1,
                  ignoreclick=1, border=0, rounded=8, bgcolor=[0.18, 0.22, 0.29, 1.0])
    present(surface, [0, 0, width, height])
    label("drift_advanced_heading", "Advanced", [12, 9, 144, 25], fontsize=16, bold=True)
    tabs = add("drift_advanced_tabs", "live.tab", [1764, 8, 264, 28], outputs=("int", "", "float"),
               parameter_mappable=0, multiline=0, num_lines_patching=1, num_lines_presentation=1,
               **parameter("Drifting Memory advanced page", 0, 0, 2, options=list(DRIFT_ADVANCED_TABS)))
    present(tabs, [164, 8, 264, 28])

    for index, page in enumerate(_LAYOUT):
        for name, rect, caption in page:
            if caption:
                label(name, caption, rect, hidden=index != 0, fontsize=10 if name.endswith("_help") else 11)
            else:
                control = named[name]
                if control["maxclass"] == "live.dial":
                    control["needlemode"] = 2 if name == "dynamics" else 1
                present(control, rect, hidden=index != 0)

    route = add("drift_advanced_page_select", "newobj", [1764, 234, 89, 22], ins=4,
                outputs=("bang", "bang", "bang", ""), text="sel 0 1 2")
    outlet = add("drift_advanced_page_out", "outlet", [925, 963, 30, 30], index=6,
                 comment="Advanced control visibility for the main presentation")
    connect(tabs, 0, route)
    for index in range(len(DRIFT_ADVANCED_PAGES)):
        # Only the main window owns visibility, so switching tabs leaves DSP and
        # the underlying control values untouched.
        commands = [f"drift_control_visible {name} {int(page_index == index)}"
                    for page_index, names in enumerate(DRIFT_ADVANCED_PAGES) for name in names]
        message = add(f"drift_advanced_page_{index}", "message", [1764, 272 + 34 * index, 350, 22],
                      ins=2, outputs=("",), text=", ".join(commands))
        connect(route, index, message)
        connect(message, 0, outlet)
