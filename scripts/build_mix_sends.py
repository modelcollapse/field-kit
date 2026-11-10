"""Build the FX routing overview beside the Drifting Memory strip."""

from build_fx import PERFORMANCE_FX_CONTROLS


SLATE_INK = [243 / 255, 247 / 255, 252 / 255, 1.0]


def append_sends_strip(panel, parameter):
    panel.add("performance_in", "inlet", [12, 235, 26, 26], ins=0, index=1)
    panel.add("performance_out", "outlet", [12, 465, 26, 26], outs=0, index=1)
    selectors = PERFORMANCE_FX_CONTROLS
    panel.obj("performance_state", "route " + " ".join(selectors), 12, 274,
              outs=len(selectors) + 1)
    panel.connect("performance_in", 0, "performance_state")

    def label(name, value, rect, **attrs):
        panel.add(name, "comment", rect, view=rect, outs=0, text=value, textcolor=SLATE_INK, **attrs)

    def mirror(name):
        index = selectors.index(name)
        panel.obj(f"performance_set_{name}", "prepend set", 12 + 100 * index, 326, ins=2)
        panel.connect("performance_state", index, f"performance_set_{name}")
        panel.connect(f"performance_set_{name}", 0, f"performance_{name}")
        panel.obj(f"performance_edit_{name}", f"prepend {name}", 12 + 100 * index, 403, ins=2)
        panel.connect(f"performance_{name}", 0, f"performance_edit_{name}")
        panel.connect(f"performance_edit_{name}", 0, "performance_out")

    def amount(name, title, initial, x, y):
        rect = [x, y, 128, 26]
        panel.add(f"performance_{name}", "live.numbox", rect, view=rect, outs=2,
                  types=["float", "float"], parameter_mappable=0, hint=title,
                  **parameter(title, initial, 0, 100, unit_style=5))
        mirror(name)

    label("performance_sends_heading", "FX routing", [12, 8, 180, 24], fontsize=16, fontface=1)
    rect = [203, 9, 225, 23]
    panel.add("performance_fx_mode", "live.tab", rect, view=rect, outs=3, types=["int", "", "float"],
              parameter_mappable=0, multiline=0, num_lines_patching=1, num_lines_presentation=1,
              hint="Feed Echo and Room from the full mix or from these sends.",
              **parameter("Performance FX routing", 0, 0, 1, options=["Full mix", "Loop sends"]))
    mirror("fx_mode")
    label("performance_fx_status", "Main FX is off · the mix starts dry", [12, 43, 412, 20])
    for name, caption, x in (("echo", "Echo", 154), ("room", "Room", 297)):
        label(f"performance_{name}_label", caption, [x, 77, 127, 19], fontface=1)
    label("performance_returns_label", "Mix level", [12, 104, 132, 20], fontface=1)
    amount("fx_echo", "Performance Echo amount", 20, 154, 101)
    amount("fx_space", "Performance Room amount", 18, 297, 101)
    label("performance_send_help", "Set each loop’s sends in the Echo and Room mixer columns.",
          [12, 146, 412, 20])

    panel.obj("performance_mode_select", "sel 0 1", 850, 402, outs=3, types=["bang", "bang", ""])
    panel.connect("performance_state", selectors.index("fx_mode"), "performance_mode_select")
    for index, caption in enumerate(("Mix level", "Return level")):
        key = f"performance_mode_caption_{index}"
        panel.add(key, "message", [850, 435 + 32 * index, 125, 22], ins=2, text=f"set {caption}")
        panel.connect("performance_mode_select", index, key)
        panel.connect(key, 0, "performance_returns_label")

    panel.obj("performance_routing", "pak 0 0", 1028, 367, ins=2, types=["list"])
    panel.obj("performance_routing_state", "expr $i1 * 2 + $i2", 1028, 402, ins=2, types=["int"])
    panel.obj("performance_routing_select", "sel 0 1 2 3", 1028, 435, outs=5,
              types=["bang", "bang", "bang", "bang", ""])
    panel.connect("performance_state", selectors.index("fx_mode"), "performance_routing", 0)
    panel.connect("performance_state", selectors.index("fx_enabled"), "performance_routing", 1)
    panel.connect("performance_routing", 0, "performance_routing_state")
    panel.connect("performance_routing_state", 0, "performance_routing_select")
    for index, status in enumerate(("Main FX is off · the mix stays dry",
                                    "Full mix · Echo and Room receive the whole mix",
                                    "Loop sends selected · turn on Main FX to hear them",
                                    "Loop sends active · Echo and Room use the mixer sends")):
        key = f"performance_routing_label_{index}"
        panel.add(key, "message", [1028, 468 + 32 * index, 324, 22], ins=2, text=f"set {status}")
        panel.connect("performance_routing_select", index, key)
        panel.connect(key, 0, "performance_fx_status")
