"""Build the Mix workspace controls for the embedded Drifting Memory effect."""

# Mirror the detailed effect controls through its existing remote inlet. The
# return messages use the same selectors and update the strip without output.
DRIFT_CONTROLS = (
    ("enabled", "drift_enabled"),
    ("mode", "mode"),
    ("record", "record"),
    ("hold", "hold"),
    ("mix", "drift_mix"),
    ("feedback", "feedback"),
    ("drift", "drift"),
)
STATE_SELECTORS = [selector for selector, _ in DRIFT_CONTROLS] + ["capture_clock"]


def append_drifting_strip(panel, parameter):
    def label(name, text, rect, size=12, bold=False):
        panel.add(f"drift_strip_{name}", "comment", rect, view=rect, outs=0,
                  text=text, fontsize=size, fontface=int(bold))

    def control(selector, cls, rect, outputs, **attrs):
        name = f"drift_strip_{selector}"
        panel.add(name, cls, rect, view=rect, outs=len(outputs), types=outputs, **attrs)
        command = name + "_command"
        panel.obj(command, f"prepend {selector}", rect[0], rect[1] + 230, ins=2)
        panel.connect(name, 0, command)
        panel.connect(command, 0, "drift_strip_command")

    def action(selector, caption, rect, hint):
        name = f"drift_strip_{selector}"
        panel.add(name, "live.text", rect, view=rect, outs=2, types=["bang", ""],
                  text=caption, texton=caption, mode=0, parameter_enable=0, hint=hint)
        command = name + "_command"
        panel.add(command, "message", [rect[0], rect[1] + 230, 76, 22], ins=2, text=selector)
        panel.connect(name, 0, command)
        panel.connect(command, 0, "drift_strip_command")

    panel.add("drift_strip_command", "outlet", [8, 465, 26, 26], outs=0, index=1,
              comment="Drifting Memory settings and Advanced toggle")
    panel.add("drift_strip_state", "inlet", [158, 495, 26, 26], ins=0, types=[""], index=3,
              comment="Drifting Memory control and capture status")

    label("heading", "Drifting Memory", [12, 10, 210, 25], size=17, bold=True)
    label("mode_label", "Delay mode", [12, 44, 163, 18])
    label("record_label", "Arm capture", [190, 44, 199, 18])
    label("capture_help", "Capture Off lets the tail play.", [212, 181, 177, 18])

    control("advanced", "live.text", [463, 9, 125, 28], ["int", ""],
            text="Advanced", texton="Hide advanced", mode=1, parameter_mappable=0,
            hint="Show or hide advanced Drifting Memory controls beside this strip.",
            **parameter("Drifting Memory Advanced view", 0, 0, 1, options=["Off", "On"]))
    control("enabled", "live.text", [225, 9, 144, 28], ["int", ""],
            text="Drift · Off", texton="Drift · On", fontface=1, mode=1, parameter_mappable=0,
            hint="Enable the delay in the main mix. Bypassing it retains the memory.",
            **parameter("Mix workspace delay enabled", 0, 0, 1, options=["Off", "On"]))
    control("mode", "umenu", [12, 64, 163, 26], ["int", "", ""],
            items=["Two Delays", ",", "Four Delays", ",", "Giant Reverb", ",",
                   "Granular Delay", ",", "Rhythmic"], allowdrag=0, parameter_enable=0,
            hint="Select the Drifting Memory delay program.")
    control("record", "live.tab", [190, 64, 199, 26], ["int", "", "float"],
            parameter_mappable=0, multiline=0, num_lines_patching=1, num_lines_presentation=1,
            hint="Choose which memory banks capture the mix.",
            **parameter("Mix workspace delay capture", 0, 0, 3, options=["Off", "A", "B", "All"]))
    for selector, name, x, initial, high, hint in (
        ("mix", "Mix", 20, 35, 100, "Blend the delay return into the main mix."),
        ("feedback", "Feedback", 142, 82, 110, "Set how much delay feeds back into its memory."),
        ("drift", "Drift", 264, 45, 100, "Set how much the delay moves."),
    ):
        control(selector, "live.dial", [x, 103, 94, 68], ["float", "float"],
                appearance=3, needlemode=1, showname=1, shownumber=1, parameter_mappable=0, hint=hint,
                **parameter(f"Mix workspace delay {name.lower()}", initial, 0, high,
                            short=name, unit_style=5))

    control("hold", "live.text", [12, 176, 88, 26], ["int", ""],
            text="Hold", texton="Holding", mode=1, parameter_mappable=0,
            hint="Pause new capture while the current memory circulates. Release to resume.",
            **parameter("Mix workspace delay hold", 0, 0, 1, options=["Off", "On"]))
    action("cut_tail", "Cut Tail", [108, 176, 96, 26],
           "Clear the delay tail and turn capture Off. Rearm capture to build a new tail.")

    label("monitor_heading", "Delay monitor", [419, 50, 156, 19], size=13, bold=True)
    label("capture_clock", "Capture 0.0 s", [419, 163, 156, 23], size=14, bold=True)
    for index, (name, title, y, hint) in enumerate((
        ("memory", "Memory", 76, "Level inside the delay before Mix."),
        ("return", "Wet return", 117, "Stereo peak of the delay return after Mix and bypass."),
    ), start=1):
        label(f"{name}_label", title, [419, y, 156, 17])
        rect = [419, y + 18, 156, 11]
        signal = f"drift_strip_{name}_signal"
        meter = f"drift_strip_{name}_meter"
        panel.add(signal, "inlet", [8 + 52 * index, 495, 26, 26], ins=0, types=["signal"],
                  index=index, comment=hint)
        panel.add(meter, "live.meter~", rect, view=rect, outs=2, types=["float", "int"],
                  orientation=1, hint=hint)
        panel.connect(signal, 0, meter)

    panel.obj("drift_strip_state_route", "route " + " ".join(STATE_SELECTORS), 158, 531,
              outs=len(STATE_SELECTORS) + 1, types=[""] * (len(STATE_SELECTORS) + 1))
    panel.connect("drift_strip_state", 0, "drift_strip_state_route")
    for index, selector in enumerate(STATE_SELECTORS):
        setter = f"drift_strip_{selector}_set"
        panel.obj(setter, "prepend set", 8 + index * 90, 562, ins=2)
        panel.connect("drift_strip_state_route", index, setter)
        panel.connect(setter, 0, f"drift_strip_{selector}")


def append_drifting_taps(drift):
    """Connect the performance strip to the existing effect."""
    boxes = {entry["box"].get("varname", entry["box"]["id"]): entry["box"]
             for entry in drift["boxes"]}

    def box(name, cls, rect, ins=1, outputs=(), **attrs):
        ident = f"mix-strip-{name}"
        value = dict(id=ident, maxclass=cls, patching_rect=rect, numinlets=ins,
                     numoutlets=len(outputs), **attrs)
        if outputs:
            value["outlettype"] = list(outputs)
        drift["boxes"].append({"box": value})
        boxes[name] = value

    def connect(source, outlet, target, inlet=0):
        drift["lines"].append({"patchline": {
            "source": [boxes[source]["id"], outlet],
            "destination": [boxes[target]["id"], inlet],
        }})

    box("memory_out", "outlet", [745, 963, 30, 30], index=3,
        comment="Circulating Drifting Memory signal before Mix")
    box("wet_out", "outlet", [805, 963, 30, 30], index=4,
        comment="Stereo peak of Drifting Memory wet return after Mix and bypass")
    box("state_out", "outlet", [865, 963, 30, 30], index=5,
        comment="Drifting Memory settings and capture clock")
    connect("engine", 3, "memory_out")

    for index in (1, 2):
        name = f"wet_abs_{index}"
        box(name, "newobj", [730 + index * 58, 883, 48, 22], outputs=("signal",), text="abs~")
        connect(f"wet-{index}", 0, name)
    box("wet_peak", "newobj", [805, 922, 78, 22], ins=2, outputs=("signal",), text="maximum~")
    connect("wet_abs_1", 0, "wet_peak")
    connect("wet_abs_2", 0, "wet_peak", 1)
    connect("wet_peak", 0, "wet_out")

    for index, (selector, source) in enumerate(DRIFT_CONTROLS + (("capture_clock", "clock-format"),)):
        name = f"state_{selector}"
        box(name, "newobj", [970, 735 + index * 30, 140, 22], ins=2, outputs=("",),
            text=f"prepend {selector}")
        connect(source, 0, name)
        connect(name, 0, "state_out")

    # Reuse Panic's wet reset, without applying its Hold and Erase resets.
    remote_route = boxes["remote-route"]
    cut_tail_outlet = remote_route["numoutlets"] - 1
    remote_route["text"] += " cut_tail"
    remote_route["numoutlets"] += 1
    remote_route["outlettype"].append("")
    box("cut_tail", "newobj", [830, 325, 50, 22], outputs=("bang", "bang"), text="t b b")
    box("cut_tail_capture_off", "message", [830, 360, 30, 22], ins=2, outputs=("",), text="0")
    connect("remote-route", cut_tail_outlet, "cut_tail")
    connect("cut_tail", 1, "panic_count")
    connect("cut_tail", 0, "cut_tail_capture_off")
    connect("cut_tail_capture_off", 0, "record")
