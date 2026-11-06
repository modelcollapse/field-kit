// Eight snapshots of the controls. A bank contains settings, never source audio.
autowatch = 0;
inlets = 1;
outlets = 0;

var SLOT_COUNT = 8;
var VOICE_COUNT = 4;
var LFO_COUNT = 8;
var LEGACY_LFO_COUNT = 3;
var TARGET_COUNT = 9;
var PITCH_SCALE_COUNT = 7;
var BANK_FORMAT = "field-kit-patterns";
var BANK_VERSION = 2;
var LEGACY_BANK_VERSION = 1;
// Allow all eight slots to hold eight full curves with unrounded values.
var MAX_BANK_BYTES = 8 * 1024 * 1024;
var EMPTY_BUTTON = [0.25, 0.25, 0.25, 1];
var STORED_BUTTON = [0.40, 0.29, 0.09, 1];
var SELECTED_BUTTON = [0.92, 0.62, 0.08, 1];
var LIGHT_TEXT = [0.92, 0.92, 0.92, 1];
var DARK_TEXT = [0.07, 0.07, 0.07, 1];
var DEFAULT_PANS = [-45, -15, 15, 45];
var DEFAULT_MIXER_MUTES = [0, 0, 0, 0];
var VOICE_CONTROLS = [
    ["rate", 0.125, 4, 1],
    ["direction", 0, 2, 0],
    ["fade", 0, 500, 30],
    ["drive", 0, 100, 0],
    ["filter", -100, 100, 0],
    ["level", 0, 100, 70],
    ["pan", -100, 100, 0]
];
var FX_CONTROLS = [
    ["fx_enabled", 0, 1, 0],
    ["fx_tone", -100, 100, 0],
    ["fx_echo", 0, 100, 20],
    ["fx_time_ms", 45, 850, 310],
    ["fx_repeats", 0, 78, 28],
    ["fx_space", 0, 100, 18],
    ["fx_decay", 0.25, 5, 1.7]
];

var host = this;
var slots = [];
var armed = false;
var lastSlot = -1;
for (var index = 0; index < SLOT_COUNT; index++) {
    slots.push(null);
}

function loadbang() {
    set_armed(false);
    render_slots();
}

function status(text) {
    host.patcher.getnamed("pattern_status").message("set", text);
}
status.local = 1;

function render_slots() {
    for (var i = 0; i < SLOT_COUNT; i++) {
        var filled = slots[i] !== null;
        var selected = i === lastSlot;
        paint_button("pattern_" + (i + 1), String(i + 1) + (filled ? " •" : ""),
                     selected ? SELECTED_BUTTON : filled ? STORED_BUTTON : EMPTY_BUTTON,
                     selected ? DARK_TEXT : LIGHT_TEXT);
    }
}
render_slots.local = 1;

function paint_button(name, text, background, foreground) {
    var button = host.patcher.getnamed(name);
    button.message("text", text);
    button.message("texton", text);
    button.message.apply(button, ["activebgcolor"].concat(background));
    button.message.apply(button, ["activetextcolor"].concat(foreground));
    button.message.apply(button, ["activebgoncolor"].concat(background));
    button.message.apply(button, ["activetextoncolor"].concat(foreground));
}
paint_button.local = 1;

function toggle_store() {
    arm(!armed);
}

function arm(value) {
    set_armed(!!value);
    status(armed ? "Choose a square. Filled squares will be replaced." : "Store cancelled. Click a filled square to recall.");
}

function set_armed(value) {
    armed = value;
    paint_button("pattern_store", armed ? "Cancel store" : "Store pattern",
                 armed ? SELECTED_BUTTON : EMPTY_BUTTON, armed ? DARK_TEXT : LIGHT_TEXT);
}
set_armed.local = 1;

function slot(number) {
    if (!in_range(number, 1, SLOT_COUNT) || number % 1) {
        return;
    }
    var index = number - 1;
    if (armed) {
        var snapshot = capture_pattern();
        if (!valid_pattern(snapshot, LFO_COUNT)) {
            status("Pattern not ready. Try again.");
            return;
        }
        var replacing = slots[index] !== null;
        slots[index] = snapshot;
        lastSlot = index;
        set_armed(false);
        status("Pattern " + number + (replacing ? " replaced." : " stored."));
    } else if (slots[index]) {
        apply_pattern(slots[index]);
        lastSlot = index;
        status("Pattern " + number + " recalled.");
    } else {
        status("Square " + number + " is empty. Click Store pattern first.");
        return;
    }
    render_slots();
}

function value_of(object) {
    var value = object.getvalueof();
    return Array.isArray(value) ? value[0] : value;
}
value_of.local = 1;

function capture_pattern() {
    var patch = host.patcher;
    var source = patch.getnamed("source_control").js;
    var router = patch.getnamed("patchbay").subpatcher().getnamed("fk_router").js;
    var fx = patch.getnamed("mix_fx").subpatcher();
    var mixer = patch.getnamed("mixer_control").js;
    var windows = [];
    for (var i = 0; i < VOICE_COUNT; i++) {
        var window = { region: source.positions[i].slice() };
        VOICE_CONTROLS.forEach(function (spec) {
            window[spec[0]] = value_of(patch.getnamed(spec[0] + "_" + (i + 1)));
        });
        windows.push(window);
    }
    var effects = {};
    FX_CONTROLS.forEach(function (spec) {
        effects[spec[0]] = value_of(fx.getnamed(spec[0]));
    });
    return {
        windows: windows,
        gains: router.gains.slice(),
        rates: router.rates.slice(),
        shapes: router.shapes.slice(),
        curves: router.curves.map(function (curve) { return curve.slice(); }),
        selection: { window: router.selected, lfo: router.currentLfo, target: router.targetIndex },
        effects: effects,
        mixerMutes: mixer.mutes.slice(),
        pitchScale: value_of(patch.getnamed("pitch_scale")),
        master: value_of(patch.getnamed("master"))
    };
}
capture_pattern.local = 1;

function apply_pattern(pattern) {
    var patch = host.patcher;
    var source = patch.getnamed("source_control");
    var router = patch.getnamed("patchbay").subpatcher().getnamed("fk_router");
    var fx = patch.getnamed("mix_fx").subpatcher();
    source.message("exit_normal");
    // Banks written before Pitch Snap was added omit this field.
    patch.getnamed("pitch_scale").message(pattern.pitchScale === undefined ? 0 : pattern.pitchScale);
    pattern.windows.forEach(function (window, i) {
        var voice = i + 1;
        source.message("set_region", voice, window.region[0], window.region[1]);
        VOICE_CONTROLS.forEach(function (spec) {
            patch.getnamed(spec[0] + "_" + voice).message(window[spec[0]]);
        });
    });
    patch.getnamed("master").message(pattern.master);
    FX_CONTROLS.forEach(function (spec) {
        fx.getnamed(spec[0]).message(pattern.effects[spec[0]]);
    });

    for (var i = 0; i < LFO_COUNT; i++) {
        router.message("rate_state", i, pattern.rates[i]);
        router.message("shape_state", i, pattern.shapes[i]);
        router.message("select_lfo", i);
        router.message.apply(router, ["curve_points"].concat(pattern.curves[i]));
    }
    var currentGains = router.js.gains.slice();
    for (var route = 0; route < pattern.gains.length; route++) {
        if (pattern.gains[route] !== currentGains[route]) {
            var group = Math.floor(route / TARGET_COUNT);
            router.message("depth", Math.floor(group / LFO_COUNT) + 1,
                           group % LFO_COUNT + 1, route % TARGET_COUNT + 1, pattern.gains[route]);
        }
    }
    router.message("select_lfo", pattern.selection.lfo);
    router.message("view", pattern.selection.window + 1);
    router.message("select_destination", pattern.selection.target);
    router.message("bang");

    var mixer = patch.getnamed("mixer_control");
    mixer.message.apply(mixer, ["recall_mutes"].concat(pattern.mixerMutes || DEFAULT_MIXER_MUTES));
}
apply_pattern.local = 1;

function modulation_defaults() {
    var router = host.patcher.getnamed("patchbay").subpatcher().getnamed("fk_router").js;
    return {
        rates: router.DEFAULT_RATES.slice(),
        shapes: router.DEFAULT_SHAPES.slice(),
        curves: router.DEFAULT_RATES.map(function () { return router.DEFAULT_CURVE.slice(); })
    };
}
modulation_defaults.local = 1;

function reset() {
    var patch = host.patcher;
    patch.getnamed("source_control").message("stop_all");
    var windows = [];
    for (var i = 0; i < VOICE_COUNT; i++) {
        var span = 100 / VOICE_COUNT;
        var window = { region: [i * span, (i + 1) * span] };
        VOICE_CONTROLS.forEach(function (spec) { window[spec[0]] = spec[3]; });
        window.pan = DEFAULT_PANS[i];
        windows.push(window);
    }
    var effects = {};
    FX_CONTROLS.forEach(function (spec) { effects[spec[0]] = spec[3]; });
    var gains = [];
    for (var j = 0; j < VOICE_COUNT * LFO_COUNT * TARGET_COUNT; j++) {
        gains.push(0);
    }
    var defaults = modulation_defaults();
    apply_pattern({
        windows: windows, gains: gains, rates: defaults.rates, shapes: defaults.shapes, curves: defaults.curves,
        selection: { window: 0, lfo: 0, target: 0 }, effects: effects, mixerMutes: DEFAULT_MIXER_MUTES,
        pitchScale: 0, master: -12
    });
    patch.getnamed("source_control").message("inspect_window", 0);
    lastSlot = -1;
    set_armed(false);
    render_slots();
    status("Reset · Play all to hear the loops");
}

function save_bank() {
    if (!slots.some(function (pattern) { return pattern !== null; })) {
        status("Store a pattern before saving.");
        return;
    }
    var dialog = host.patcher.getnamed("pattern_save_dialog");
    dialog.message("name", "Field Kit Patterns.json");
    dialog.message("bang");
}

function load_bank() {
    host.patcher.getnamed("pattern_load_dialog").message("bang");
}

function write_bank(path) {
    if (typeof path !== "string" || !path) {
        return;
    }
    var file;
    try {
        file = new File(path, "write", "TEXT");
        if (!file.isopen) {
            throw new Error("Could not open file");
        }
        var contents = JSON.stringify({ format: BANK_FORMAT, version: BANK_VERSION, slots: slots }, null, 2) + "\n";
        file.position = 0;
        file.writestring(contents);
        if (file.position !== contents.length) {
            throw new Error("Incomplete write");
        }
        file.eof = file.position;
        status("Pattern bank saved.");
    } catch (error) {
        status("Couldn’t save the pattern bank.");
    } finally {
        if (file && file.isopen) {
            file.close();
        }
    }
}

function read_bank(path) {
    if (typeof path !== "string" || !path) {
        return;
    }
    var file;
    try {
        file = new File(path, "read");
        if (!file.isopen || file.eof < 1 || file.eof > MAX_BANK_BYTES) {
            throw new Error("Invalid bank file");
        }
        var bank = JSON.parse(read_bank_text(file));
        if (!bank || bank.format !== BANK_FORMAT ||
            (bank.version !== BANK_VERSION && bank.version !== LEGACY_BANK_VERSION) ||
            !Array.isArray(bank.slots) || bank.slots.length !== SLOT_COUNT) {
            throw new Error("Invalid bank contents");
        }
        var legacy = bank.version === LEGACY_BANK_VERSION;
        var count = legacy ? LEGACY_LFO_COUNT : LFO_COUNT;
        if (!bank.slots.every(function (pattern) { return pattern === null || valid_pattern(pattern, count); })) {
            throw new Error("Invalid bank patterns");
        }
        slots = legacy ? bank.slots.map(upgrade_pattern) : bank.slots;
        lastSlot = -1;
        set_armed(false);
        render_slots();
        status("Bank loaded. Click a filled square to recall.");
    } catch (error) {
        status("Couldn’t open that pattern bank.");
    } finally {
        if (file && file.isopen) {
            file.close();
        }
    }
}

function upgrade_pattern(pattern) {
    if (pattern === null) {
        return null;
    }
    var defaults = modulation_defaults();
    var gains = [];
    var legacyBlock = LEGACY_LFO_COUNT * TARGET_COUNT;
    var newRoutes = (LFO_COUNT - LEGACY_LFO_COUNT) * TARGET_COUNT;
    // Routes are grouped by window. Extend each window's block so its old
    // LFO and destination indices still point to the same controls.
    for (var window = 0; window < VOICE_COUNT; window++) {
        var firstRoute = window * legacyBlock;
        gains = gains.concat(pattern.gains.slice(firstRoute, firstRoute + legacyBlock));
        for (var route = 0; route < newRoutes; route++) {
            gains.push(0);
        }
    }
    pattern.gains = gains;
    pattern.rates = pattern.rates.concat(defaults.rates.slice(LEGACY_LFO_COUNT));
    pattern.shapes = pattern.shapes.concat(defaults.shapes.slice(LEGACY_LFO_COUNT));
    pattern.curves = pattern.curves.concat(defaults.curves.slice(LEGACY_LFO_COUNT));
    return pattern;
}
upgrade_pattern.local = 1;

function read_bank_text(file) {
    var size = file.eof;
    var contents = file.readstring(size);
    if (typeof contents === "string" && file.position === size) {
        return contents.replace(/^\uFEFF/, "");
    }

    // The bank schema only writes ASCII keys and numeric values. Chunked
    // byte reads avoid native readstring limits on some Max versions.
    file.position = 0;
    var chunks = [];
    while (file.position < size) {
        var offset = file.position;
        var bytes = file.readbytes(Math.min(4096, size - offset));
        if (!bytes || !bytes.length || file.position <= offset) {
            throw new Error("Incomplete read");
        }
        chunks.push(String.fromCharCode.apply(null, bytes));
    }
    return chunks.join("").replace(/^\xEF\xBB\xBF/, "");
}
read_bank_text.local = 1;

function in_range(value, low, high) {
    return typeof value === "number" && isFinite(value) && value >= low && value <= high;
}
in_range.local = 1;

function index_valid(value, count) {
    return in_range(value, 0, count - 1) && value % 1 === 0;
}
index_valid.local = 1;

function numbers_valid(values, count, low, high) {
    return Array.isArray(values) && values.length === count &&
        values.every(function (value) { return in_range(value, low, high); });
}
numbers_valid.local = 1;

function controls_valid(values, controls) {
    return values && controls.every(function (spec) {
        return in_range(values[spec[0]], spec[1], spec[2]);
    });
}
controls_valid.local = 1;

function valid_curve(curve) {
    return Array.isArray(curve) && curve.length % 2 === 0 && curve.length <= 2050 &&
        curve.every(function (value, i) {
            if (i % 2) {
                return in_range(value, -1, 1);
            }
            return in_range(value, 0, 1) && (i === 0 || value > curve[i - 2]);
        });
}
valid_curve.local = 1;

function valid_pattern(pattern, lfoCount) {
    return !!pattern && Array.isArray(pattern.windows) && pattern.windows.length === VOICE_COUNT &&
        pattern.windows.every(function (window) {
            return controls_valid(window, VOICE_CONTROLS) && window.direction % 1 === 0 &&
                numbers_valid(window.region, 2, 0, 100) && window.region[0] < window.region[1];
        }) && numbers_valid(pattern.gains, VOICE_COUNT * lfoCount * TARGET_COUNT, -100, 100) &&
        pattern.gains.every(function (gain) { return gain % 1 === 0; }) &&
        numbers_valid(pattern.rates, lfoCount, 0.01, 20) &&
        numbers_valid(pattern.shapes, lfoCount, 0, 5) &&
        pattern.shapes.every(function (shape) { return shape % 1 === 0; }) &&
        Array.isArray(pattern.curves) && pattern.curves.length === lfoCount &&
        pattern.curves.every(valid_curve) && pattern.selection &&
        index_valid(pattern.selection.window, VOICE_COUNT) && index_valid(pattern.selection.lfo, lfoCount) &&
        index_valid(pattern.selection.target, TARGET_COUNT) && controls_valid(pattern.effects, FX_CONTROLS) &&
        pattern.effects.fx_enabled % 1 === 0 && in_range(pattern.master, -70, 0) &&
        (pattern.pitchScale === undefined || index_valid(pattern.pitchScale, PITCH_SCALE_COUNT)) &&
        (pattern.mixerMutes === undefined ||
            (Array.isArray(pattern.mixerMutes) && pattern.mixerMutes.length === VOICE_COUNT &&
                pattern.mixerMutes.every(function (mute) { return index_valid(mute, 2); })));
}
valid_pattern.local = 1;
