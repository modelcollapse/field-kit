"""Generate the stock Max LFO routing and breakpoint editor."""

import json
from pathlib import Path

OUT = Path(__file__).resolve().parents[1] / "max"
BOXES = []
LINES = []
DESTINATIONS = ("Start", "End", "Speed", "Direction", "Crossfade", "Drive", "Filter", "Level", "Pan")
SHAPES = ("Sine", "Triangle", "Saw", "Square", "S&H", "Breakpoint")
# Match the defaults used by the router when resetting or loading patterns.
RATES = (0.12, 0.31, 0.73, 0.18, 0.43, 0.67, 1.1, 1.7)
DEFAULT_SHAPES = (0, 1, 2, 0, 1, 0, 1, 0)
LFO_COUNT = len(RATES)
MOD_CHANNELS = 4 * len(DESTINATIONS)


def box(maxclass, rect, numinlets=1, numoutlets=0, **attrs):
    obj_id = f"obj-{len(BOXES) + 1}"
    BOXES.append({"box": {
        "id": obj_id, "maxclass": maxclass, "numinlets": numinlets,
        "numoutlets": numoutlets, "patching_rect": rect, **attrs,
    }})
    return obj_id


def connect(source, target, outlet=0, inlet=0):
    LINES.append({"patchline": {"source": [source, outlet], "destination": [target, inlet]}})


def obj(text, x, y, width=120, numinlets=1, outputs=("",), **attrs):
    return box("newobj", [x, y, width, 22], numinlets, len(outputs),
               text=text, outlettype=outputs, **attrs)


def msp(text, x, y, width=90, numinlets=1, **attrs):
    return obj(text, x, y, width, numinlets, ["signal"], **attrs)


def control(maxclass, col, row, width=1, height=1, **attrs):
    rect = [col * 48, row * 24, width * 48 - 4, height * 24 - 4]
    return box(maxclass, rect, presentation=1, presentation_rect=rect, **attrs)


def label(text, col, row, width=1, y_offset=0, **attrs):
    rect = [col * 48, row * 24 + y_offset, width * 48 - 4, 20]
    return box("comment", rect, presentation=1, presentation_rect=rect, text=text, **attrs)


def param(name, typ, low, high, initial, items=None, units=None):
    settings = dict(parameter_longname=name, parameter_shortname=name, parameter_type=typ,
                    parameter_mmin=low, parameter_mmax=high,
                    parameter_initial=[initial], parameter_initial_enable=1,
                    parameter_invisible=1)
    if items:
        settings["parameter_enum"] = list(items)
    if units:
        settings.update(parameter_unitstyle=9, parameter_units=units)
    return dict(parameter_enable=1, saved_attribute_attributes=dict(valueof=settings))


def menu(name, items, col, width, **attrs):
    menu_items = [atom for item in items for atom in (item, ",")][:-1]
    return control("umenu", col, 2, width, numoutlets=3,
                   outlettype=["int", "", ""], varname=name, items=menu_items, **attrs)


def wire_message(source, selector, router, x, y, outlet=0):
    node = obj("prepend " + selector, x, y, 144, numinlets=2)
    connect(source, node, outlet)
    connect(node, router)


def action(text, selector, col, row, width, router):
    button = control("live.text", col, row, width, numoutlets=2, outlettype=["", ""],
                     text=text, texton=text, mode=0, parameter_enable=0,
                     varname="fk_action_" + selector)
    node = box("message", [col * 48, 360 + 30 * (row - 2), 100, 22],
               numinlets=2, numoutlets=1, text=selector)
    connect(button, node)
    connect(node, router)


def build_lfo(row, curve_done):
    number = row + 1
    freq = RATES[row]
    x = 350 * row
    phase = msp(f"phasor~ {freq}", x, 458, numinlets=2, varname=f"fk_lfo_phase_{number}")
    selected_shape = msp(f"selector~ {len(SHAPES)} {DEFAULT_SHAPES[row] + 1}", x, 820, 150,
                         len(SHAPES) + 1, varname=f"fk_lfo_shape_signal_{number}")

    shifted = msp("+~ 0.75", x, 502, 64, 2)
    sine = msp("cos~", x, 538, 50)
    triangle = msp("triangle~ 0.5", x + 68, 502, numinlets=2)
    saw_scale = msp("*~ 2.", x + 68, 538, 54, 2)
    saw = msp("-~ 1.", x + 68, 574, 54, 2)
    comparator = msp("<~ 0.5", x + 162, 502, 56, 2)
    square_scale = msp("*~ 2.", x + 162, 538, 54, 2)
    square = msp("-~ 1.", x + 162, 574, 54, 2)
    random = msp("noise~", x, 574, 54, numinlets=0)
    hold = msp("sah~ 0.000001", x, 610, 100, 2)
    waves = []
    for slot in range(2):
        y = 610 + 55 * slot
        suffix = f"{number}_{slot}"
        obj("buffer~ fk-unbound-curve @samps 1025", x + 120, y, 222, 1,
            ["float", "bang"], varname=f"fk_curve_buffer_{suffix}")
        wave = msp("wave~ fk-unbound-curve @interp 1", x + 120, y + 27, 215, 3,
                   varname=f"fk_curve_wave_{suffix}")
        connect(phase, wave)
        waves.append(wave)

    # Start at the first table and use the same phasor for both readers.
    # A + (B - A) * ramp preserves the waveform phase during edits.
    fade = obj("line~ 0.", x + 220, 720, 100, 2, ["signal", "bang"],
               varname=f"fk_curve_fade_{number}")
    complete = box("message", [x + 220, 755, 100, 22], 2, 1, text=f"curve_ready {row}")
    connect(fade, complete, 1)
    connect(complete, curve_done)
    difference = msp("-~", x + 120, 720, 44, 2)
    scaled = msp("*~", x + 120, 755, 44, 2)
    custom = msp("+~", x + 120, 788, 44, 2)
    connect(waves[1], difference)
    connect(waves[0], difference, inlet=1)
    connect(difference, scaled)
    connect(fade, scaled, inlet=1)
    connect(waves[0], custom)
    connect(scaled, custom, inlet=1)

    for node in (shifted, triangle, saw_scale, comparator):
        connect(phase, node)
    connect(shifted, sine)
    connect(saw_scale, saw)
    connect(comparator, square_scale)
    connect(square_scale, square)
    connect(random, hold)
    connect(phase, hold, inlet=1)
    for inlet, node in enumerate((sine, triangle, saw, square, hold, custom), start=1):
        connect(node, selected_shape, inlet=inlet)
    return phase, selected_shape


def build():
    router = obj("js fk_mod_routes.js", 50, 318, 142, 1, ["list", "int"], varname="fk_router")
    inlet = box("inlet", [0, 272, 30, 30], 0, 1, outlettype=[""], index=1,
                comment="Routing controls and live destination feedback")
    connect(inlet, router)
    init = obj("loadbang", 206, 318, 60, 1, ["bang"])
    defer = obj("deferlow", 274, 318, 65)
    connect(init, defer)
    connect(defer, router)

    label("Modulation patchbay", 0, 0, 7, fontsize=16, fontface=1)
    label("Route", 7, 0, 2, fontsize=16, fontface=1)
    label("LFO 1 → W1 Start  /  Off", 9, 0, 5, y_offset=4, varname="fk_mod_status")
    label("Feedback", 14, 0, 8, fontsize=16, fontface=1)
    for text, col, width in (
        ("LFO", 0, 3), ("Shape", 3, 3), ("Rate", 6, 1),
        ("Window", 7, 2), ("Destination", 9, 3), ("Depth (%)", 12, 2),
    ):
        label(text, col, 1, width)
    lfo = menu("fk_mod_lfo", (f"LFO {i + 1}" for i in range(LFO_COUNT)), 0, 3,
               hint="Choose which LFO to edit. All eight run independently.")
    window = menu("fk_mod_window", [f"Window {i}" for i in range(1, 5)], 7, 2)
    target = menu("fk_mod_target", DESTINATIONS, 9, 3)
    depth = control("live.dial", 12, 2, 2, 2, numoutlets=2, outlettype=["float", "float"],
                    appearance=3, showname=0, shownumber=1,
                    varname="fk_mod_depth", **param("Route depth", 1, -100, 100, 0))
    rate = control("live.dial", 6, 2, 1, 2, numoutlets=2, outlettype=["float", "float"],
                   appearance=3, showname=0, shownumber=1, hint="LFO rate in hertz",
                   varname="fk_mod_rate",
                   **param("Selected LFO rate", 0, 0.01, 20, RATES[0], units="%.2f Hz"))
    shape = menu("fk_mod_shape", SHAPES, 3, 3)
    action("Add route", "add_route", 7, 3, 2, router)
    action("Remove route", "clear_route", 9, 3, 3, router)
    select_window = obj("+ 1", 149, 280, 38, 2, ["int"])
    connect(window, select_window)
    wire_message(select_window, "view", router, 195, 280)
    for node, selector, x in ((lfo, "select_lfo", 0), (target, "select_destination", 350),
                              (depth, "set_depth", 500), (rate, "set_rate", 650),
                              (shape, "set_shape", 800)):
        wire_message(node, selector, router, x, 280)

    label("LFO 1  ·  live signal", 14, 4, 8, varname="fk_signal_label")
    label("LFO 1  ·  Sine", 0, 4, 11, varname="fk_curve_label")
    label("Applied value  ·  Audio off", 14, 1, 4, varname="fk_applied_value")
    label("LFO signal  ·  Audio off", 18, 1, 4, varname="fk_lfo_value")
    label("Active routes on LFO 1  /  0", 14, 2, 8, varname="fk_active_label")
    routes = control("umenu", 14, 3, 8, numoutlets=3, outlettype=["int", "", ""],
                     varname="fk_active_routes", items=["No active routes"])
    wire_message(routes, "jump_route", router, 420, 318)

    scope = control("scope~", 14, 5, 8, 4, numinlets=2, range=[-1.0, 1.0],
                    bufsize=128, calccount=256, varname="fk_lfo_scope")
    curve = control("function", 0, 5, 14, 4, numoutlets=4, outlettype=["float", "", "", "bang"],
                    hint="Click to add a point. Drag to edit. Shift-click to delete.",
                    varname="fk_curve", domain=1.0, range=[-1.0, 1.0], mode=0,
                    hidden=1, ignoreclick=1,
                    clicksustain=0, addpoints=[0, 0, 0, .25, 1, 0, .5, 0, 0, .75, -1, 0, 1, 0, 0])
    control("jsui", 0, 5, 14, 4, filename="fk_lfo_preview.js", varname="fk_lfo_preview",
            ignoreclick=1, border=0, parameter_enable=0)
    done = box("message", [570, 318, 94, 22], numinlets=2, numoutlets=1, text="curve_edited")
    connect(curve, done, 3)
    connect(done, router)
    wire_message(curve, "curve_dump", router, 675, 318, 2)
    action("Use curve", "use_curve", 11, 4, 3, router)

    lfo_watch = msp(f"selector~ {LFO_COUNT} 1", 0, 864, 140, LFO_COUNT + 1, varname="fk_lfo_watch")
    phase_watch = msp(f"selector~ {LFO_COUNT} 1", 220, 864, 140, LFO_COUNT + 1, varname="fk_phase_watch")
    connect(lfo_watch, scope)
    for node, selector, x in ((lfo_watch, "lfo_sample", 0), (phase_watch, "lfo_phase", 220)):
        snap = obj("snapshot~ 50", x, 900, 120, 2, ["float"])
        connect(node, snap)
        wire_message(snap, selector, router, x, 934)
    matrix = obj(f"matrix~ {LFO_COUNT} {MOD_CHANNELS} 1. @ramp 20", 0, 980, 1052, LFO_COUNT,
                 ["signal"] * MOD_CHANNELS + [""])
    connect(router, matrix)
    curve_done = obj("deferlow", 920, 318, 65)
    connect(curve_done, router)
    for row in range(LFO_COUNT):
        phase, signal = build_lfo(row, curve_done)
        connect(signal, matrix, inlet=row)
        connect(signal, lfo_watch, inlet=row + 1)
        connect(phase, phase_watch, inlet=row + 1)

    packed = obj(f"mc.pack~ {MOD_CHANNELS}", 0, 1028, 1052, MOD_CHANNELS, ["multichannelsignal"])
    signal_out = box("outlet", [0, 1070, 30, 30], 1, 0, index=1,
                     comment=f"{MOD_CHANNELS} signed modulation channels")
    target_out = box("outlet", [190, 1070, 30, 30], 1, 0, index=2, comment="Selected feedback signal index")
    for index in range(MOD_CHANNELS):
        connect(matrix, packed, index, index)
    connect(packed, signal_out)
    connect(router, target_out, 1)
    patch = dict(fileversion=1, appversion=dict(major=9, minor=2, revision=0,
                 architecture="arm64", modernui=1), classnamespace="box",
                 rect=[100, 100, 1052, 212], openinpresentation=1,
                 description="LFO route selection, live feedback and breakpoint editing",
                 boxes=BOXES, lines=LINES)
    (OUT / "fk_modulation.maxpat").write_text(json.dumps({"patcher": patch}, indent=2) + "\n")


build()
