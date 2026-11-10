"""Build the read-only FX routing status beside Drifting Memory."""


def append_sends_strip(panel):
    panel.add("performance_in", "inlet", [12, 235, 26, 26], ins=0, index=1)
    panel.obj("performance_state", "route fx_mode fx_enabled", 12, 274, outs=3)
    panel.connect("performance_in", 0, "performance_state")

    def label(name, value, rect, **attrs):
        panel.add(name, "comment", rect, view=rect, outs=0, text=value, **attrs)

    label("performance_sends_heading", "FX routing", [12, 8, 180, 24], fontsize=16, fontface=1)
    label("performance_fx_status", "Full mix · Main FX off", [12, 43, 412, 22], fontsize=14)
    label("performance_send_help", "Set Echo and Room Mix % in Main FX.", [12, 72, 412, 22])

    panel.obj("performance_routing", "pak 0 0", 12, 367, ins=2, types=["list"])
    panel.obj("performance_routing_state", "expr $i1 * 2 + $i2", 12, 402, ins=2, types=["int"])
    panel.obj("performance_routing_select", "sel 0 1 2 3", 12, 435, outs=5,
              types=["bang", "bang", "bang", "bang", ""])
    panel.connect("performance_state", 0, "performance_routing", 0)
    panel.connect("performance_state", 1, "performance_routing", 1)
    panel.connect("performance_routing", 0, "performance_routing_state")
    panel.connect("performance_routing_state", 0, "performance_routing_select")
    for index, status in enumerate(("Full mix · Main FX off", "Full mix · Main FX on",
                                    "Loop sends · Main FX off", "Loop sends · Main FX on")):
        key = f"performance_routing_label_{index}"
        panel.add(key, "message", [12, 468 + 32 * index, 224, 22], ins=2, text=f"set {status}")
        panel.connect("performance_routing_select", index, key)
        panel.connect(key, 0, "performance_fx_status")

    panel.obj("performance_mode_select", "sel 0 1", 280, 367, outs=3, types=["bang", "bang", ""])
    panel.connect("performance_state", 0, "performance_mode_select")
    for index, help_text in enumerate(("Set Echo and Room Mix % in Main FX.",
                                       "Set sends in Mixer and Return % in Main FX.")):
        key = f"performance_routing_help_{index}"
        panel.add(key, "message", [280, 402 + 32 * index, 276, 22], ins=2, text=f"set {help_text}")
        panel.connect("performance_mode_select", index, key)
        panel.connect(key, 0, "performance_send_help")
