"""Build the Loop sends panel for the Mix workspace."""

from build_fx import PERFORMANCE_FX_CONTROLS


PERFORMANCE_SENDS = tuple(f"{send}_send_{voice}" for voice in range(1, 5) for send in ("echo", "room"))
SLATE_INK = [243 / 255, 247 / 255, 252 / 255, 1.0]


def append_sends_strip(panel, parameter):
    panel.add("performance_in", "inlet", [12, 235, 26, 26], ins=0, index=1)
    panel.add("performance_out", "outlet", [12, 465, 26, 26], outs=0, index=1)
    selectors = PERFORMANCE_FX_CONTROLS + PERFORMANCE_SENDS
    panel.obj("performance_state", "route " + " ".join(selectors), 12, 274,
              outs=len(selectors) + 1, width=690)
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
        rect = [x, y, 128, 20]
        panel.add(f"performance_{name}", "live.numbox", rect, view=rect, outs=2,
                  types=["float", "float"], parameter_mappable=0, hint=title,
                  **parameter(title, initial, 0, 100, unit_style=5))
        mirror(name)

    label("performance_sends_heading", "Loop sends", [12, 8, 180, 24], fontsize=16, fontface=1)
    rect = [203, 9, 225, 23]
    panel.add("performance_fx_mode", "live.tab", rect, view=rect, outs=3, types=["int", "", "float"],
              parameter_mappable=0, multiline=0, num_lines_patching=1, num_lines_presentation=1,
              hint="Feed Echo and Room from the full mix or from these sends.",
              **parameter("Performance FX routing", 0, 0, 1, options=["Full mix", "Loop sends"]))
    mirror("fx_mode")
    label("performance_fx_status", "Main FX is off · send values stay stored", [12, 36, 412, 20])
    for name, caption, x in (("loop", "Loop", 12), ("echo", "Echo %", 154), ("room", "Room %", 297)):
        label(f"performance_{name}_label", caption, [x, 58, 127, 19], fontface=1)
    for voice in range(1, 5):
        y = 77 + (voice - 1) * 23
        label(f"performance_loop_{voice}_label", f"Loop {voice}", [12, y, 129, 20])
        amount(f"echo_send_{voice}", f"Performance Loop {voice} Echo send", 0, 154, y)
        amount(f"room_send_{voice}", f"Performance Loop {voice} Room send", 0, 297, y)
    label("performance_returns_label", "Return level", [12, 177, 132, 20], fontface=1)
    amount("fx_echo", "Performance Echo return mix", 20, 154, 177)
    amount("fx_space", "Performance Room return mix", 18, 297, 177)

    panel.obj("performance_routing", "pak 0 0", 1028, 367, ins=2, types=["list"])
    panel.obj("performance_routing_state", "expr $i1 * 2 + $i2", 1028, 402, ins=2, types=["int"])
    panel.obj("performance_routing_select", "sel 0 1 2 3", 1028, 435, outs=5,
              types=["bang", "bang", "bang", "bang", ""])
    panel.connect("performance_state", selectors.index("fx_mode"), "performance_routing", 0)
    panel.connect("performance_state", selectors.index("fx_enabled"), "performance_routing", 1)
    panel.connect("performance_routing", 0, "performance_routing_state")
    panel.connect("performance_routing_state", 0, "performance_routing_select")
    for index, status in enumerate(("Main FX is off · send values stay stored",
                                    "Full mix · individual loop sends are bypassed",
                                    "Loop sends selected · enable Main FX to hear them",
                                    "Loop sends active · Echo and Room use these amounts")):
        key = f"performance_routing_label_{index}"
        panel.add(key, "message", [1028, 468 + 32 * index, 324, 22], ins=2, text=f"set {status}")
        panel.connect("performance_routing_select", index, key)
        panel.connect(key, 0, "performance_fx_status")
