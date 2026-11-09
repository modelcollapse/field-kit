"""Connect Field Kit's LFO bus to the embedded Drifting Memory effect."""

import re


# DSP units match the existing Gen parameters. Cutoff depths are in octaves.
_PARAMETERS = (
    ("Mix", "return_mix", 0, 1, 1),
    ("Feedback", "feedback", 0, 1.1, 0.5),
    ("Blur", "blur", 0, 1, 1),
    ("Drift", "drift", 0, 1, 1),
    ("Drive", "drive", 0, 1, 1),
    ("Dynamics", "dynamics", -1, 1, 1),
    ("Input Trim", "input_db", -24, 12, 12),
    ("Output Trim", "output_db", -24, 6, 12),
    ("Width", "width", 0, 2, 1),
    ("Pitch", "pitch", -12, 0, 12),
    ("HPF Hz", "hpf_hz", 20, 2000, 3),
    ("LPF Hz", "lpf_hz", 200, 20000, 3),
    ("BPM", "tempo", 20, 400, 60),
    ("Beats/bar", "beats_per_bar", 0.5, 32, 3),
)
DRIFT_MOD_TARGETS = [label for label, *_ in _PARAMETERS]


def _box(patcher, ident, cls, rect, *, ins=1, outputs=(), **attrs):
    box = dict(id=ident, maxclass=cls, patching_rect=rect, numinlets=ins,
               numoutlets=len(outputs), **attrs)
    if outputs:
        box["outlettype"] = list(outputs)
    patcher["boxes"].append({"box": box})


def _connect(patcher, source, target, *, outlet=0, inlet=0):
    patcher["lines"].append({"patchline": {
        "source": [source, outlet], "destination": [target, inlet],
    }})


def _modulate_code(code):
    # The imported engine declares the base parameters and does its own
    # smoothing. Substitute the effective signal wherever it uses each base.
    marker = "control = 1 - exp(-1 / (0.020 * samplerate));\n"
    setup, found, processing = code.partition(marker)
    if not found:
        raise ValueError("Drifting Memory Gen smoothing anchor is missing")
    if "Param mix(1);" not in setup:
        raise ValueError("Drifting Memory Gen mix anchor is missing")
    setup = setup.replace("Param mix(1);", """Param mix(1);
Param return_mix(35, min=0, max=100);
History mod_mix_state(0.35);
History mod_tempo_offset(0);
History mod_beats_per_bar_offset(0);""")

    effective = []
    outputs = []
    aliases = {}
    for index, (_, param, low, high, depth) in enumerate(_PARAMETERS, start=3):
        value = f"mod_{param}"
        offset = f"clamp(fixnan(in{index}), -1, 1)"
        if param == "return_mix":
            base = f"return_mix * 0.01 + {offset}"
        elif param.endswith("_hz"):
            base = f"{param} * pow(2, {depth} * {offset})"
        elif param in ("tempo", "beats_per_bar"):
            # Keep the existing response to manual tempo/meter edits. Slew the
            # added modulation so a square LFO cannot jump the Rhythmic head.
            state = f"{value}_offset"
            slewed = f"{state}_next"
            effective.extend((f"{slewed} = {state} + control * ({offset} - {state});",
                              f"{state} = {slewed};"))
            base = f"{param} + {depth} * {slewed}"
        else:
            base = f"{param} + {depth} * {offset}"
        effective.append(f"{value} = clamp({base}, {low}, {high});")
        if param == "return_mix":
            effective.extend(("mod_mix_smoothed = mod_mix_state + control * (mod_return_mix - mod_mix_state);",
                              "mod_mix_state = mod_mix_smoothed;"))
            value = "mod_mix_smoothed"
        else:
            aliases[param] = value
        outputs.append(f"out{index + 2} = {value};")

    replaced = set()

    def alias(match):
        param = match.group(1)
        if param is None:
            return match.group()
        replaced.add(param)
        return aliases[param]

    processing = re.sub(r"//[^\n]*|\b(" + "|".join(aliases) + r")\b", alias, processing)
    if missing := aliases.keys() - replaced:
        raise ValueError("Drifting Memory Gen no longer uses " + ", ".join(sorted(missing)))
    return setup + marker + "\n".join(effective) + "\n" + processing + "\n".join(outputs) + "\n"


def append_drift_modulation(panel):
    """Append signed LFO inputs and effective-value outputs to the effect."""
    engine = next(entry["box"] for entry in panel["boxes"] if entry["box"].get("varname") == "engine")
    gen = engine["patcher"]
    code = next(entry["box"] for entry in gen["boxes"] if entry["box"]["maxclass"] == "codebox")
    code["code"] = _modulate_code(code["code"])
    count = len(_PARAMETERS)
    for node, signal_type in ((engine, "signal"), (code, "")):
        node["numinlets"] += count
        node["numoutlets"] += count
        node["outlettype"].extend([signal_type] * count)
        node["patching_rect"][2] = max(node["patching_rect"][2], 970)
    gen["rect"][2] = max(gen["rect"][2], 1040)

    # Max orders embedded bpatcher ports from left to right. Keep new ports
    # after the original audio, control, and meter ports on each edge.
    port_x = max(entry["box"]["patching_rect"][0] for entry in panel["boxes"]
                 if entry["box"]["maxclass"] in ("inlet", "outlet")) + 70
    for i, label in enumerate(DRIFT_MOD_TARGETS):
        source = f"drift-mod-in-{i}"
        target = f"drift-mod-out-{i}"
        x = port_x + i * 38
        _box(panel, source, "inlet", [x, 1020, 30, 30], ins=0, outputs=("signal",), index=4 + i,
             comment=f"LFO offset for Drifting Memory {label}")
        _box(panel, target, "outlet", [x, 1080, 30, 30], index=7 + i,
             comment=f"Effective Drifting Memory {label}")
        _connect(panel, source, engine["id"], inlet=2 + i)
        _connect(panel, engine["id"], target, outlet=4 + i)

        x = 500 + i * 36
        _box(gen, source, "newobj", [x, 20, 35, 22], ins=0, outputs=("",), text=f"in {3 + i}")
        _box(gen, target, "newobj", [x, 510, 35, 22], text=f"out {5 + i}")
        _connect(gen, source, code["id"], inlet=2 + i)
        _connect(gen, code["id"], target, outlet=4 + i)

    # The imported engine stays fully wet. Multiply the effective Mix by the
    # existing enable ramp so bypass remains dry and does not erase the memory.
    removed = {"mix-state", "wet-value"}
    panel["boxes"][:] = [entry for entry in panel["boxes"] if entry["box"]["id"] not in removed]
    panel["lines"][:] = [entry for entry in panel["lines"]
                        if not any(entry["patchline"][end][0] in removed for end in ("source", "destination"))]
    _box(panel, "drift-mod-base-mix", "newobj", [390, 785, 119, 22], ins=2, outputs=("",),
         text="prepend return_mix")
    _box(panel, "drift-mod-wet-gain", "newobj", [390, 863, 45, 22], ins=2, outputs=("signal",), text="*~")
    _connect(panel, "drift-mix", "drift-mod-base-mix")
    _connect(panel, "drift-mod-base-mix", engine["id"])
    _connect(panel, "drift-enable", "wet-ramp")
    for entry in panel["lines"]:
        line = entry["patchline"]
        if line["source"][0] == "wet-gain":
            line["source"][0] = "drift-mod-wet-gain"
    _connect(panel, "wet-gain", "drift-mod-wet-gain")
    _connect(panel, engine["id"], "drift-mod-wet-gain", outlet=4, inlet=1)
