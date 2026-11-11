// Eight snapshots of the controls. A bank contains settings, never source audio.
autowatch = 0;
inlets = 1;
outlets = 0;

var SLOT_COUNT = 8;
var VOICE_COUNT = 4;
var LFO_COUNT = 8;
var LEGACY_LFO_COUNT = 3;
var TARGET_COUNT = 11;
var GLOBAL_TARGET_COUNT = 22;
var LEGACY_TARGET_COUNT = 9;
var LEGACY_GLOBAL_TARGET_COUNT = 8;
var PITCH_SCALE_COUNT = 7;
var BANK_FORMAT = "field-kit-patterns";
var BANK_VERSION = 2;
var LEGACY_BANK_VERSION = 1;
var SET_FORMAT = "field-kit-set";
var SET_VERSION = 1;
var LOOP_SET_VERSION = 2;
var EMPTY_LOOP_SET_VERSION = 3;
var PATTERN_HINT = "Click to recall. Shift-click to store.";
// Allow all eight slots to hold eight full curves with unrounded values.
var MAX_BANK_BYTES = 8 * 1024 * 1024;
var RECALL_SETTLE_MS = 24;
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
var LOOP_SENDS = ["echo_send", "room_send"];
var DRIFT_CONTROLS = [
    ["drift_mix", 0, 100, 35], ["mode", 0, 4, 0, 1], ["size", 0, 2, 0, 1],
    ["reverse", 0, 1, 0, 1], ["half_speed", 0, 1, 0, 1], ["feedback", 0, 110, 82],
    ["blur", 0, 100, 32], ["drift", 0, 100, 45], ["drive", 0, 100, 0],
    ["dynamics", -100, 100, 0], ["hpf", 0, 4, 0, 1], ["lpf", 0, 4, 0, 1],
    ["input_trim", -24, 12, 0], ["output_trim", -24, 6, 0],
    ["input_gate", 0, 2, 1, 1], ["mono_input", 0, 1, 0, 1],
    ["width", 0, 200, 100], ["pitch", -12, 0, 0],
    ["hpf_hz", 20, 2000, 65], ["lpf_hz", 200, 20000, 5600],
    ["rhythm_style", 0, 6, 0, 1], ["rhythm_free", 0, 1, 0, 1],
    ["tempo", 20, 400, 120], ["beats_per_bar", 0.5, 32, 4],
    ["drift_enabled", 0, 1, 0, 1]
];

var host = this;
var slots = [];
var armed = false;
var bankDirty = false;
var patternStatusText = PATTERN_HINT;
var lastSlot = -1;
var activeSetPath = "";
var pendingSet = null;
var writingSet = null;
var writeTimeout = null;
var pendingRecall = null;
var recallStage = "idle";
var voiceRecall = null;
var recallGeneration = 0;
var voiceRecallPhases = [0, 0, 0, 0];
var releaseTail = new Task(release_recall_tail, host);
for (var index = 0; index < SLOT_COUNT; index++) {
    slots.push(null);
}

function loadbang() {
    set_armed(false);
    render_slots();
    bank_status(PATTERN_HINT);
}

function theme() {
    var colors = arrayfromargs(arguments);
    if (colors.length !== 20) return;
    EMPTY_BUTTON = colors.slice(0, 4);
    STORED_BUTTON = colors.slice(4, 8);
    SELECTED_BUTTON = colors.slice(8, 12);
    LIGHT_TEXT = colors.slice(12, 16);
    DARK_TEXT = colors.slice(16, 20);
    set_armed(armed);
    render_slots();
}

function status(text, showDirty) {
    patternStatusText = text;
    var display = showDirty && bankDirty ? text.replace(/\.$/, "") + " · bank unsaved" : text;
    host.patcher.getnamed("pattern_status").message("set", display);
}
status.local = 1;

function bank_status(text) {
    status(text, true);
}
bank_status.local = 1;

function set_status(text) {
    host.patcher.getnamed("set_status").message("set", text);
}
set_status.local = 1;

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
    bank_status(armed ? "Choose a square to store or replace." : "Store cancelled.");
}

function set_armed(value) {
    armed = value;
    paint_button("pattern_store", armed ? "Cancel store" : "Store pattern",
                 armed ? SELECTED_BUTTON : EMPTY_BUTTON, armed ? DARK_TEXT : LIGHT_TEXT);
}
set_armed.local = 1;

function slot(number, shift) {
    if (!in_range(number, 1, SLOT_COUNT) || number % 1) {
        return;
    }
    var index = number - 1;
    if (armed || shift === 1) {
        if (pendingRecall || voiceRecall) {
            bank_status("Wait for the pattern switch to finish.");
            return;
        }
        var snapshot = capture_pattern();
        if (!valid_pattern(snapshot, LFO_COUNT)) {
            bank_status("Pattern not ready. Try again.");
            return;
        }
        var replacing = slots[index] !== null;
        slots[index] = snapshot;
        bankDirty = true;
        lastSlot = index;
        set_armed(false);
        bank_status("Pattern " + number + (replacing ? " replaced." : " stored."));
        if (!replacing) host.patcher.getnamed("sequence_control").message("refresh_mix");
    } else if (slots[index]) {
        host.patcher.getnamed("sequence_control").message("stop");
        request_recall(index);
        return;
    } else {
        bank_status("Square " + number + " is empty. Shift-click to store.");
        return;
    }
    render_slots();
}

function sequence_has_slot(number) {
    return in_range(number, 1, SLOT_COUNT) && number % 1 === 0 && slots[number - 1] !== null;
}

function sequence_recall(number) {
    if (sequence_has_slot(number)) request_recall(number - 1);
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
    var drifting = patch.getnamed("drifting_memory").subpatcher();
    var mixer = patch.getnamed("mixer_control").js;
    var windows = [];
    for (var i = 0; i < VOICE_COUNT; i++) {
        var window = { region: source.positions[i].slice() };
        VOICE_CONTROLS.forEach(function (spec) {
            window[spec[0]] = value_of(patch.getnamed(spec[0] + "_" + (i + 1)));
        });
        LOOP_SENDS.forEach(function (key) {
            window[key] = value_of(patch.getnamed(key + "_" + (i + 1)));
        });
        windows.push(window);
    }
    var effects = {};
    FX_CONTROLS.forEach(function (spec) {
        effects[spec[0]] = value_of(fx.getnamed(spec[0]));
    });
    effects.fx_mode = value_of(fx.getnamed("fx_mode"));
    effects.fx_distortion = value_of(fx.getnamed("fx_distortion"));
    var drift = {};
    DRIFT_CONTROLS.forEach(function (spec) {
        drift[spec[0]] = value_of(drifting.getnamed(spec[0]));
    });
    var selection = { window: router.selected, lfo: router.currentLfo, target: router.targetIndex };
    if (router.selected === VOICE_COUNT) {
        selection.window = 0;
        selection.target = 0;
        selection.globalTarget = router.targetIndex;
    }
    return {
        windows: windows,
        gains: router.gains.slice(),
        globalGains: router.globalGains.slice(),
        rates: router.rates.slice(),
        shapes: router.shapes.slice(),
        curves: router.curves.map(function (curve) { return curve.slice(); }),
        selection: selection,
        effects: effects,
        drifting: drift,
        mixerMutes: mixer.mutes.slice(),
        pitchScale: value_of(patch.getnamed("pitch_scale")),
        master: value_of(patch.getnamed("master"))
    };
}
capture_pattern.local = 1;

function request_recall(index) {
    pendingRecall = { index: index, pattern: slots[index] };
    if (!host.patcher.getnamed("source_control").js.audioOn) {
        recall_dsp(0);
    } else if (recallStage === "idle") {
        begin_pending_recall();
    }
}
request_recall.local = 1;

function begin_pending_recall() {
    var source = host.patcher.getnamed("source_control").js;
    if (source.playing.some(Boolean) && !source.normalPlaying && !source.normalStopping) {
        begin_voice_recall();
    } else if (source.normalPlaying || source.normalStopping) {
        recallStage = "covering";
        host.patcher.getnamed("pattern_transition_command").message(1);
        host.patcher.getnamed("pattern_transition_sample").message("start");
    } else {
        // A stopped transport must never replay the previous loop audio.
        apply_pending_recall();
    }
}
begin_pending_recall.local = 1;

// Capture on the audio thread before changing any controls. Each voice then
// commits at its own loop boundary, independently of the Max scheduler.
function begin_voice_recall() {
    voiceRecall = pendingRecall;
    pendingRecall = null;
    recallGeneration = recallGeneration % 1000000 + 1;
    voiceRecallPhases = [0, 0, 0, 0];
    recallStage = "voice_capture";
    bank_status("Pattern " + (voiceRecall.index + 1) + " queued · finishing loops.");
    for (var i = 1; i <= VOICE_COUNT; i++) {
        host.patcher.getnamed("scene_sample_" + i).message("start");
        host.patcher.getnamed("voice_" + i).message("scene_command", recallGeneration * 2);
    }
}
begin_voice_recall.local = 1;

function recall_voice_phase(number, encoded) {
    var generation = Math.floor(encoded / 4);
    var phase = encoded % 4;
    if (!voiceRecall || generation !== recallGeneration ||
        number < 1 || number > VOICE_COUNT || phase < 1) return;
    voiceRecallPhases[number - 1] = phase;
    if (recallStage === "voice_capture" && voiceRecallPhases.every(function (value) { return value >= 1; })) {
        // A newer click received before staging can replace this cue.
        if (pendingRecall) {
            voiceRecall = pendingRecall;
            pendingRecall = null;
        }
        bank_status("Pattern " + (voiceRecall.index + 1) + " queued · finishing loops.");
        recallStage = "voice_settling";
        try {
            apply_pattern(voiceRecall.pattern, true);
        } finally {
            releaseTail.schedule(RECALL_SETTLE_MS);
        }
    } else if (recallStage === "voice_wait" &&
               voiceRecallPhases.every(function (value) { return value === 3; })) {
        finish_voice_recall();
        if (pendingRecall) begin_pending_recall();
    }
}

function finish_voice_recall() {
    if (!voiceRecall) return;
    apply_shared_pattern(voiceRecall.pattern);
    lastSlot = voiceRecall.index;
    voiceRecall = null;
    clear_voice_recall();
    recallStage = "idle";
    bank_status("Pattern " + (lastSlot + 1) + " recalled.");
    render_slots();
}
finish_voice_recall.local = 1;

function clear_voice_recall(force) {
    for (var i = 1; i <= VOICE_COUNT; i++) {
        host.patcher.getnamed("voice_" + i).message("scene_command", force ? -1 : 0);
        host.patcher.getnamed("scene_sample_" + i).message("stop");
    }
}
clear_voice_recall.local = 1;

function recall_phase(phase) {
    if (phase === 1 && recallStage === "covering") {
        // The buffer now supplies both channels. Apply settings off the audible path.
        recallStage = "settling";
        try {
            apply_pending_recall();
        } finally {
            releaseTail.schedule(RECALL_SETTLE_MS);
        }
    } else if (phase === 0 && (recallStage === "fading" || recallStage === "draining")) {
        if (recallStage === "draining") host.patcher.getnamed("pattern_transition_command").message(0);
        recallStage = "idle";
        host.patcher.getnamed("pattern_transition_sample").message("stop");
        // Only the latest request survives a burst of clicks during the fade.
        if (pendingRecall) begin_pending_recall();
    }
}

function recall_dsp(state) {
    if (state) {
        if (recallStage === "idle") host.patcher.getnamed("pattern_transition_command").message(0);
    } else {
        try {
            if (voiceRecall) {
                apply_pattern(voiceRecall.pattern);
                lastSlot = voiceRecall.index;
                voiceRecall = null;
                clear_voice_recall(true);
            }
            apply_pending_recall();
        } finally {
            cancel_recall(false);
        }
    }
}

function apply_pending_recall() {
    if (!pendingRecall) return;
    var recall = pendingRecall;
    pendingRecall = null;
    apply_pattern(recall.pattern);
    lastSlot = recall.index;
    bank_status("Pattern " + (recall.index + 1) + " recalled.");
    render_slots();
}
apply_pending_recall.local = 1;

function release_recall_tail() {
    if (recallStage === "voice_settling") {
        recallStage = "voice_wait";
        for (var i = 1; i <= VOICE_COUNT; i++) {
            host.patcher.getnamed("voice_" + i).message("scene_command", recallGeneration * 2 + 1);
        }
        return;
    }
    if (recallStage !== "settling") return;
    recallStage = "fading";
    host.patcher.getnamed("pattern_transition_command").message(0);
}
release_recall_tail.local = 1;

function cancel_recall(audioOn, discardHistory) {
    if (audioOn === undefined) audioOn = host.patcher.getnamed("source_control").js.audioOn;
    releaseTail.cancel();
    if (voiceRecall) {
        if (recallStage !== "voice_capture") apply_shared_pattern(voiceRecall.pattern);
        voiceRecall = null;
        clear_voice_recall(!audioOn);
        recallStage = "idle";
    }
    pendingRecall = null;
    if (!audioOn) {
        recallStage = "idle";
        host.patcher.getnamed("pattern_transition_sample").message("stop");
        host.patcher.getnamed("pattern_transition_command").message(2);
    } else if (discardHistory || recallStage !== "idle") {
        var wasIdle = recallStage === "idle";
        recallStage = "draining";
        host.patcher.getnamed("pattern_transition_command").message(-1);
        if (wasIdle) host.patcher.getnamed("pattern_transition_sample").message("start");
    }
}
cancel_recall.local = 1;

function transport_stopped() {
    cancel_recall(true, true);
}

function apply_pattern(pattern, deferShared) {
    var patch = host.patcher;
    var source = patch.getnamed("source_control");
    var router = patch.getnamed("patchbay").subpatcher().getnamed("fk_router");
    source.message("stop_pad_motion");
    source.message("exit_normal");
    // Banks written before Pitch Snap was added omit this field.
    patch.getnamed("pitch_scale").message(pattern.pitchScale === undefined ? 0 : pattern.pitchScale);
    pattern.windows.forEach(function (window, i) {
        var voice = i + 1;
        source.message("set_region", voice, window.region[0], window.region[1]);
        VOICE_CONTROLS.forEach(function (spec) {
            patch.getnamed(spec[0] + "_" + voice).message(window[spec[0]]);
        });
        LOOP_SENDS.forEach(function (key) {
            patch.getnamed(key + "_" + voice).message(window[key] === undefined ? 0 : window[key]);
        });
    });
    if (!deferShared) apply_shared_pattern(pattern);

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
    if (pattern.selection.globalTarget === undefined) {
        router.message("view", pattern.selection.window + 1);
        router.message("select_destination", pattern.selection.target);
    } else {
        router.message("view", VOICE_COUNT + 1);
        router.message("select_destination", pattern.selection.globalTarget);
    }
    router.message("bang");

    var mixer = patch.getnamed("mixer_control");
    mixer.message.apply(mixer, ["recall_mutes"].concat(pattern.mixerMutes || DEFAULT_MIXER_MUTES));
}
apply_pattern.local = 1;

function apply_shared_pattern(pattern) {
    var patch = host.patcher;
    var router = patch.getnamed("patchbay").subpatcher().getnamed("fk_router");
    var fx = patch.getnamed("mix_fx").subpatcher();
    var drifting = patch.getnamed("drifting_memory").subpatcher();
    patch.getnamed("master").message(pattern.master);
    FX_CONTROLS.forEach(function (spec) {
        fx.getnamed(spec[0]).message(pattern.effects[spec[0]]);
    });
    fx.getnamed("fx_mode").message(pattern.effects.fx_mode === undefined ? 0 : pattern.effects.fx_mode);
    fx.getnamed("fx_distortion").message(pattern.effects.fx_distortion === undefined ? 0 : pattern.effects.fx_distortion);
    DRIFT_CONTROLS.forEach(function (spec) {
        drifting.getnamed(spec[0]).message(pattern.drifting ? pattern.drifting[spec[0]] : spec[3]);
    });

    var savedGlobalGains = pattern.globalGains || [];
    var currentGlobalGains = router.js.globalGains.slice();
    for (var globalRoute = 0; globalRoute < currentGlobalGains.length; globalRoute++) {
        var depth = savedGlobalGains[globalRoute] || 0;
        if (depth !== currentGlobalGains[globalRoute]) {
            router.message("depth", VOICE_COUNT + 1, Math.floor(globalRoute / GLOBAL_TARGET_COUNT) + 1,
                           globalRoute % GLOBAL_TARGET_COUNT + 1, depth);
        }
    }
}
apply_shared_pattern.local = 1;

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
    patch.getnamed("sequence_control").message("stop");
    patch.getnamed("source_control").message("stop_all");
    cancel_recall();
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
    patch.getnamed("global_speed").message(1);
    patch.getnamed("speed_mode").message(0);
    patch.getnamed("pitch_lock").message(0);
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
    var existing = new File(path, "read");
    if (existing.isopen) {
        existing.close();
        status("Bank exists · choose a new filename to keep the original.");
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
        bankDirty = false;
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
    if (typeof path !== "string" || !path || set_busy(bank_status)) {
        return;
    }
    var file;
    try {
        file = new File(path, "read");
        if (!file.isopen || file.eof < 1 || file.eof > MAX_BANK_BYTES) {
            throw new Error("Invalid bank file");
        }
        var bank = JSON.parse(read_bank_text(file));
        if (bank && bank.format === SET_FORMAT) {
            bank_status("This is a set. Choose Open Set.");
            return;
        }
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
        var nextSlots = bank.slots.map(function (pattern) { return upgrade_pattern(pattern, count); });
        host.patcher.getnamed("sequence_control").message("stop");
        cancel_recall();
        slots = nextSlots;
        lastSlot = -1;
        bankDirty = false;
        set_armed(false);
        render_slots();
        status("Bank loaded. Click a filled square to recall.");
        host.patcher.getnamed("sequence_control").message("refresh_mix");
    } catch (error) {
        status("Couldn’t open that pattern bank.");
    } finally {
        if (file && file.isopen) {
            file.close();
        }
    }
}

function set_busy(report) {
    if (pendingSet || writingSet) {
        (report || set_status)(pendingSet ? "Opening a Set…" : "Saving a Set…");
        return true;
    }
    return false;
}
set_busy.local = 1;

function file_name(path) {
    return path.slice(Math.max(path.lastIndexOf("/"), path.lastIndexOf("\\")) + 1);
}
file_name.local = 1;

function folder_of(path) {
    return path.slice(0, path.length - file_name(path).length);
}
folder_of.local = 1;

function save_set() {
    if (set_busy()) return;
    if (voiceRecall) {
        set_status("Wait for the scene change before saving the Set.");
        return;
    }
    var source = host.patcher.getnamed("source_control").js;
    if (!source.get_set_source() || !source.get_set_loops()) {
        set_status("Save any recorded loop WAVs before saving the Set.");
        return;
    }
    var dialog = host.patcher.getnamed("set_save_dialog");
    dialog.message("name", activeSetPath ? file_name(activeSetPath) : "Field Kit Set.json");
    if (activeSetPath) dialog.message("setpath", folder_of(activeSetPath));
    dialog.message("bang");
}

function set_gesture_pads() {
    var patch = host.patcher;
    var fx = patch.getnamed("mix_fx").subpatcher();
    return {
        fx: fx.getnamed("fx_pad_panel").subpatcher().getnamed("fx_pad_canvas").js,
        field: patch.getnamed("stereo_field_panel").subpatcher().getnamed("canvas").js
    };
}
set_gesture_pads.local = 1;

function write_set(path) {
    if (typeof path !== "string" || !path || set_busy()) return;
    if (voiceRecall) {
        set_status("Wait for the scene change before saving the Set.");
        return;
    }
    var folder = folder_of(path);
    var controller = host.patcher.getnamed("source_control").js;
    var source = controller.get_set_source();
    var loops = controller.get_set_loops();
    var cleared = controller.get_set_cleared();
    var current = capture_pattern();
    if (!source || !loops || !valid_pattern(current, LFO_COUNT)) {
        set_status("Set isn’t ready. Save any recorded loop WAVs first.");
        return;
    }
    if (source.kind === "file" && folder && source.path.indexOf(folder) === 0) {
        source.relative = source.path.slice(folder.length);
    }
    var snapshot = slots.slice();
    var pads = set_gesture_pads();
    var data = {
        format: SET_FORMAT, version: SET_VERSION, source: source,
        slots: snapshot, current: current, selectedSlot: lastSlot,
        sequence: host.patcher.getnamed("sequence_control").js.sequence_snapshot(),
        fieldPresets: host.patcher.getnamed("source_control").js.field_presets_snapshot(),
        gestures: { fx: pads.fx.gesture_snapshot(), field: pads.field.gesture_snapshot() },
        globalSpeed: [
            value_of(host.patcher.getnamed("global_speed")),
            value_of(host.patcher.getnamed("speed_mode"))
        ],
        pitchLock: value_of(host.patcher.getnamed("pitch_lock"))
    };
    if (loops.some(Boolean) || cleared.some(Boolean)) {
        data.version = LOOP_SET_VERSION;
        data.loopSources = loops.map(function (loopPath) {
            if (!loopPath) return null;
            var reference = {kind: "file", path: loopPath};
            if (folder && loopPath.indexOf(folder) === 0) reference.relative = loopPath.slice(folder.length);
            return reference;
        });
    }
    if (cleared.some(Boolean)) {
        data.version = EMPTY_LOOP_SET_VERSION;
        data.clearedLoops = cleared;
    }
    var stage = folder + ".field-kit-" + Date.now() + "-" + Math.floor(Math.random() * 1e9) + ".tmp";
    try {
        // File positions are byte offsets. ASCII JSON also preserves Unicode paths.
        var contents = JSON.stringify(data, null, 2).replace(/[^\x00-\x7f]/g, function (character) {
            return "\\u" + ("0000" + character.charCodeAt(0).toString(16)).slice(-4);
        }) + "\n";
        write_set_stage(stage, contents);
    } catch (error) {
        set_status("Can’t save Set. Choose a writable folder.");
        return;
    }
    writingSet = { path: path, stage: stage, slots: snapshot };
    if (!writeTimeout) writeTimeout = new Task(set_write_timed_out, host);
    writeTimeout.schedule(7000);
    set_status("Saving " + file_name(path) + "…");
    host.patcher.getnamed("set_writer").message("commit_set", stage, path);
}

function write_set_stage(path, contents) {
    var file = new File(path, "write", "TEXT");
    try {
        if (!file.isopen) throw new Error("Could not create staging file");
        file.position = 0;
        file.writestring(contents);
        if (file.position !== contents.length) throw new Error("Incomplete write");
        file.eof = file.position;
    } finally {
        if (file.isopen) file.close();
    }
}
write_set_stage.local = 1;

function set_written(ok, stage) {
    if (!writingSet || writingSet.stage !== stage) return;
    writeTimeout.cancel();
    var saved = writingSet;
    writingSet = null;
    if (!ok) {
        set_status("Couldn’t save Set. Try another folder.");
        return;
    }
    activeSetPath = saved.path;
    if (slots.every(function (pattern, index) { return pattern === saved.slots[index]; })) {
        bankDirty = false;
        status(patternStatusText);
    }
    set_status("Set saved · " + file_name(activeSetPath));
}

function set_write_timed_out() {
    writingSet = null;
    set_status("Save timed out. Try Save Set again.");
}
set_write_timed_out.local = 1;

function open_set() {
    if (!set_busy() && !recording_set_guard() && !loop_set_guard()) {
        var dialog = host.patcher.getnamed("set_open_dialog");
        if (activeSetPath) dialog.message("setpath", folder_of(activeSetPath));
        dialog.message("bang");
    }
}

function recording_set_guard() {
    var recorder = host.patcher.getnamed("recorder").subpatcher().getnamed("rec_controller").js;
    if (recorder.state !== "recording" && recorder.state !== "starting") return false;
    set_status("Stop recording before opening a Set.");
    return true;
}
recording_set_guard.local = 1;

function loop_set_guard() {
    if (!host.patcher.getnamed("source_control").js.loop_busy()) return false;
    set_status("Finish or discard the current take before opening a Set.");
    return true;
}
loop_set_guard.local = 1;

function read_set(path) {
    if (typeof path !== "string" || !path || set_busy() || recording_set_guard() || loop_set_guard()) return;
    var file, data;
    try {
        file = new File(path, "read");
        if (!file.isopen || file.eof < 1 || file.eof > 2 * MAX_BANK_BYTES) {
            throw new Error("Invalid set file");
        }
        data = JSON.parse(read_bank_text(file));
        if (data && data.format === BANK_FORMAT) {
            set_status("Pattern bank. Use Banks… to import it.");
            return;
        }
        if (!valid_set(data)) throw new Error("Invalid set contents");
        data.current = upgrade_pattern(data.current, LFO_COUNT);
        data.slots = data.slots.map(function (pattern) { return upgrade_pattern(pattern, LFO_COUNT); });
    } catch (error) {
        set_status("Couldn’t open that Field Kit Set.");
        return;
    } finally {
        if (file && file.isopen) file.close();
    }
    pendingSet = { path: path, data: data, relinking: false };
    if (data.version >= LOOP_SET_VERSION) {
        pendingSet.references = [data.source].concat(data.loopSources);
        pendingSet.resolved = {};
        resolve_set_loops();
        return;
    }
    var source = data.source;
    if (source.kind === "demo" || source.kind === "builtin") {
        begin_set_source();
        return;
    }
    var relative = source.relative && folder_of(path) + source.relative;
    if (relative && file_exists(relative)) {
        begin_set_source(relative);
    } else if (file_exists(source.path)) {
        begin_set_source(source.path);
    } else {
        pendingSet.relinking = true;
        set_status("Locate sample · " + file_name(source.path));
        host.patcher.getnamed("set_relink_dialog").message("bang");
    }
}

function resolve_set_loops() {
    var opening = pendingSet;
    var folder = folder_of(opening.path);
    var refs = opening.references;
    var paths = [];
    for (var i = 0; i < refs.length; i++) {
        var ref = refs[i];
        if (!ref || ref.kind !== "file") {
            paths.push(null);
            continue;
        }
        var key = JSON.stringify(ref.path);
        var relative = ref.relative && folder + ref.relative;
        var candidate = opening.resolved[key] || (relative && file_exists(relative) ? relative :
            file_exists(ref.path) ? ref.path : "");
        if (!candidate) {
            opening.relinking = true;
            opening.relinkKey = key;
            set_status("Locate " + (i === 0 ? "shared source" : "Loop " + i) + " · " + file_name(ref.path));
            host.patcher.getnamed("set_relink_dialog").message("bang");
            return;
        }
        opening.resolved[key] = candidate;
        paths.push(candidate);
    }
    set_status("Opening " + file_name(opening.path) + "…");
    host.patcher.getnamed("source_control").js.open_set_loops(paths[0], opening.data.source.id || null, paths.slice(1),
        opening.data.version === EMPTY_LOOP_SET_VERSION ? opening.data.clearedLoops : undefined);
}
resolve_set_loops.local = 1;

function file_exists(path) {
    var file = new File(path, "read");
    if (!file.isopen) return false;
    file.close();
    return true;
}
file_exists.local = 1;

function valid_set(data) {
    if (!data || data.format !== SET_FORMAT || (data.version !== SET_VERSION && data.version !== LOOP_SET_VERSION && data.version !== EMPTY_LOOP_SET_VERSION) ||
        !data.source || !valid_pattern(data.current, LFO_COUNT) ||
        !Array.isArray(data.slots) || data.slots.length !== SLOT_COUNT ||
        !data.slots.every(function (pattern) { return pattern === null || valid_pattern(pattern, LFO_COUNT); }) ||
        (data.sequence !== undefined && !host.patcher.getnamed("sequence_control").js.sequence_valid(data.sequence)) ||
        !host.patcher.getnamed("source_control").js.field_presets_valid(data.fieldPresets) ||
        !gestures_valid(data.gestures) ||
        (data.pitchLock !== undefined && !index_valid(data.pitchLock, 2)) ||
        (data.globalSpeed !== undefined && (!Array.isArray(data.globalSpeed) || data.globalSpeed.length !== 2 ||
            !in_range(data.globalSpeed[0], 0.5, 2) || !index_valid(data.globalSpeed[1], 2))) ||
        (data.selectedSlot !== -1 &&
            (!index_valid(data.selectedSlot, SLOT_COUNT) || !data.slots[data.selectedSlot]))) return false;
    if (data.version >= LOOP_SET_VERSION &&
        (!Array.isArray(data.loopSources) || data.loopSources.length !== VOICE_COUNT ||
            !data.loopSources.every(function (ref) { return ref === null || valid_file_reference(ref); }))) return false;
    if (data.version === EMPTY_LOOP_SET_VERSION &&
        (!Array.isArray(data.clearedLoops) || data.clearedLoops.length !== VOICE_COUNT ||
            !data.clearedLoops.every(function (value, i) {
                return typeof value === "boolean" && (!value || data.loopSources[i] === null);
            }))) return false;
    var source = data.source;
    return source.kind === "demo" ||
        (source.kind === "builtin" && host.patcher.getnamed("source_control").js.valid_builtin_demo(source.id)) ||
        valid_file_reference(source);
}
function valid_file_reference(source) {
    return !!source && source.kind === "file" && typeof source.path === "string" && source.path.length > 0 &&
        (source.relative === undefined || (typeof source.relative === "string" &&
            source.relative.length > 0 && !/^(\/|\\)|:|(^|[\/\\])\.\.([\/\\]|$)/.test(source.relative)));
}
valid_file_reference.local = 1;
valid_set.local = 1;

function gesture_clip_valid(clip, x, y, minimumX, minimumY) {
    if (!clip || !index_valid(clip.duration, 30001) || clip.duration === 0 ||
        !Array.isArray(clip.samples) || clip.samples.length < 1 ||
        clip.samples.length > clip.duration + 1) return false;
    var previous = -1;
    return clip.samples.every(function (point, index) {
        if (!point || !index_valid(point.time, clip.duration + 1) ||
            (index === 0 && point.time !== 0) || point.time <= previous ||
            !in_range(point[x], minimumX, 100) || !in_range(point[y], minimumY, 100)) return false;
        previous = point.time;
        return true;
    });
}
gesture_clip_valid.local = 1;

function gestures_valid(gestures) {
    if (gestures === undefined) return true;
    if (!gestures || !Array.isArray(gestures.field) || gestures.field.length !== VOICE_COUNT ||
        !gestures.field.every(function (clip) {
            return clip === null || gesture_clip_valid(clip, "pan", "level", -100, 0);
        })) return false;
    var fx = gestures.fx;
    return fx === null || (!!fx && Array.isArray(fx.axes) && fx.axes.length === 2 &&
        index_valid(fx.axes[0], 4) && index_valid(fx.axes[1], 4) && fx.axes[0] !== fx.axes[1] &&
        gesture_clip_valid(fx, "x", "y", fx.axes[0] === 0 ? -100 : 0, fx.axes[1] === 0 ? -100 : 0) &&
        fx.samples[fx.samples.length - 1].time === fx.duration);
}
gestures_valid.local = 1;

function relink_set(path) {
    if (!pendingSet || !pendingSet.relinking) return;
    if (recording_set_guard()) {
        pendingSet = null;
        return;
    }
    if (pendingSet.references) {
        if (!file_exists(path)) {
            pendingSet = null;
            set_status("Couldn’t open the replacement sample.");
            return;
        }
        pendingSet.resolved[pendingSet.relinkKey] = path;
        pendingSet.relinking = false;
        resolve_set_loops();
        return;
    }
    pendingSet.relinking = false;
    begin_set_source(path);
}

function cancel_relink() {
    if (!pendingSet || !pendingSet.relinking) return;
    pendingSet = null;
    set_status("Open Set canceled.");
}

function begin_set_source(path) {
    set_status("Opening " + file_name(pendingSet.path) + "…");
    var source = host.patcher.getnamed("source_control");
    if (path) source.message("open_set_source", path);
    else if (pendingSet.data.source.kind === "builtin") source.message("open_set_demo", pendingSet.data.source.id);
    else source.message("open_set_demo");
}
begin_set_source.local = 1;

function set_source_loaded(ok) {
    if (!pendingSet || pendingSet.relinking) return;
    var opened = pendingSet;
    pendingSet = null;
    if (!ok) {
        set_status("Couldn’t load the Set’s sample.");
        return;
    }
    cancel_recall();
    apply_pattern(opened.data.current);
    var speed = opened.data.globalSpeed || [1, 0];
    host.patcher.getnamed("global_speed").message(speed[0]);
    host.patcher.getnamed("speed_mode").message(speed[1]);
    host.patcher.getnamed("pitch_lock").message(opened.data.pitchLock === 1 ? 1 : 0);
    slots = opened.data.slots;
    lastSlot = opened.data.selectedSlot;
    activeSetPath = opened.path;
    bankDirty = false;
    host.patcher.getnamed("sequence_control").js.restore_sequence(opened.data.sequence);
    host.patcher.getnamed("source_control").js.field_presets_restore(opened.data.fieldPresets);
    var pads = set_gesture_pads();
    var gestures = opened.data.gestures || {};
    pads.fx.gesture_restore(gestures.fx);
    pads.field.gesture_restore(gestures.field);
    set_armed(false);
    render_slots();
    status(PATTERN_HINT);
    set_status("Set opened · " + file_name(activeSetPath));
}

function upgrade_pattern(pattern, lfoCount) {
    if (pattern === null) {
        return null;
    }
    pattern.gains = expand_route_rows(pattern.gains, VOICE_COUNT, lfoCount, TARGET_COUNT);
    if (pattern.globalGains) {
        pattern.globalGains = expand_route_rows(pattern.globalGains, 1, lfoCount, GLOBAL_TARGET_COUNT);
    }
    if (lfoCount < LFO_COUNT) {
        var defaults = modulation_defaults();
        pattern.rates = pattern.rates.concat(defaults.rates.slice(lfoCount));
        pattern.shapes = pattern.shapes.concat(defaults.shapes.slice(lfoCount));
        pattern.curves = pattern.curves.concat(defaults.curves.slice(lfoCount));
    }
    return pattern;
}
upgrade_pattern.local = 1;

function expand_route_rows(gains, scopes, lfoCount, targetCount) {
    var previousWidth = gains.length / (scopes * lfoCount);
    if (previousWidth === targetCount && lfoCount === LFO_COUNT) return gains;
    var expanded = [];
    // Every scope owns one row per LFO. Extend each row before moving to the next one.
    for (var scope = 0; scope < scopes; scope++) {
        for (var lfo = 0; lfo < LFO_COUNT; lfo++) {
            var row = (scope * lfoCount + lfo) * previousWidth;
            for (var target = 0; target < targetCount; target++) {
                expanded.push(lfo < lfoCount && target < previousWidth ? gains[row + target] : 0);
            }
        }
    }
    return expanded;
}
expand_route_rows.local = 1;

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
        var value = values[spec[0]];
        return in_range(value, spec[1], spec[2]) && (!spec[4] || value % 1 === 0);
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

function route_gains_valid(values, rows, targetCount, legacyTargetCount) {
    return Array.isArray(values) &&
        (values.length === rows * targetCount || values.length === rows * legacyTargetCount) &&
        values.every(function (gain) { return in_range(gain, -100, 100) && gain % 1 === 0; });
}
route_gains_valid.local = 1;

function valid_pattern(pattern, lfoCount) {
    return !!pattern && Array.isArray(pattern.windows) && pattern.windows.length === VOICE_COUNT &&
        pattern.windows.every(function (window) {
            return controls_valid(window, VOICE_CONTROLS) && window.direction % 1 === 0 &&
                LOOP_SENDS.every(function (key) { return window[key] === undefined || in_range(window[key], 0, 100); }) &&
                numbers_valid(window.region, 2, 0, 100) && window.region[0] < window.region[1];
        }) && route_gains_valid(pattern.gains, VOICE_COUNT * lfoCount, TARGET_COUNT, LEGACY_TARGET_COUNT) &&
        (pattern.globalGains === undefined ||
            route_gains_valid(pattern.globalGains, lfoCount, GLOBAL_TARGET_COUNT, LEGACY_GLOBAL_TARGET_COUNT)) &&
        numbers_valid(pattern.rates, lfoCount, 0.01, 20) &&
        numbers_valid(pattern.shapes, lfoCount, 0, 5) &&
        pattern.shapes.every(function (shape) { return shape % 1 === 0; }) &&
        Array.isArray(pattern.curves) && pattern.curves.length === lfoCount &&
        pattern.curves.every(valid_curve) && pattern.selection &&
        index_valid(pattern.selection.window, VOICE_COUNT) && index_valid(pattern.selection.lfo, lfoCount) &&
        (pattern.selection.globalTarget === undefined || index_valid(pattern.selection.globalTarget, GLOBAL_TARGET_COUNT)) &&
        index_valid(pattern.selection.target, TARGET_COUNT) && controls_valid(pattern.effects, FX_CONTROLS) &&
        pattern.effects.fx_enabled % 1 === 0 && in_range(pattern.master, -70, 0) &&
        (pattern.effects.fx_mode === undefined || index_valid(pattern.effects.fx_mode, 2)) &&
        (pattern.effects.fx_distortion === undefined || in_range(pattern.effects.fx_distortion, 0, 100)) &&
        (pattern.drifting === undefined || controls_valid(pattern.drifting, DRIFT_CONTROLS)) &&
        (pattern.pitchScale === undefined || index_valid(pattern.pitchScale, PITCH_SCALE_COUNT)) &&
        (pattern.mixerMutes === undefined ||
            (Array.isArray(pattern.mixerMutes) && pattern.mixerMutes.length === VOICE_COUNT &&
                pattern.mixerMutes.every(function (mute) { return index_valid(mute, 2); })));
}
valid_pattern.local = 1;
