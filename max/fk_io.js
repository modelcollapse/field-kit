autowatch = 0;
inlets = 1;
outlets = 0;

include(String(jsarguments[0]).replace(/[^/\\]+$/, "fk_midi_targets.js"));

var patch = this.patcher;
var picking = false;
var picked = "";
var bindingToReplace = "";
var choiceMenu = "";
var pending = null;
var bindings = [];
var undoStack = [];
var inputs = [];
var outputs = [];
var pressed = {};
var held = {};
var pickup = {};
var feedbackSent = {};
var echoGuard = {};
var rows = [];
var selectedRow = null;
var options = null;
var filter = 0;
var search = "";
var finding = false;
var foundSource = null;
var importPort = "";
var exportScope = 0;
var windowOpen = false;
var rendering = false;
var status = "";
var activity = "";
var lastActivityTime = 0;
var preferencesReady = false;
var loadAttempts = 0;
var requests = {};
var requestId = 0;
var loadRequest = 0;
var loadDictionary = null;
var feedbackRunning = false;

var refreshChannels = new Task(updateChannels, this);
var loadPreferences = new Task(load_profiles, this);
var openWindow = new Task(show_mappings, this);
var feedbackTask = new Task(refresh_feedback, this);
feedbackTask.interval = 60;

var ENCODERS = ["absolute", "relative_twos", "relative_offset", "relative_sign"];
var BUTTONS = ["trigger", "toggle", "hold"];

function audio_panel() {
    return patch.getnamed("io_setup_panel").subpatcher();
}
audio_panel.local = 1;

function panel() {
    return patch.getnamed("midi_mappings_panel").subpatcher();
}
panel.local = 1;

function label(scope, name, caption) {
    var object = scope.getnamed(name);
    if (object && object.valid) object.message("set", caption);
}
label.local = 1;

function set_button(scope, name, caption) {
    var object = scope.getnamed(name);
    if (!object || !object.valid) return;
    object.message("text", caption);
    object.message("texton", caption);
}
set_button.local = 1;

function updateChannels() {
    patch.getnamed("input_device_channels").message("bang");
}
updateChannels.local = 1;

function loadbang() {
    loadPreferences.schedule(200);
}

function bang() {
    audio_panel().getnamed("io_input_setting").message("loadbang");
    audio_panel().getnamed("io_output_setting").message("loadbang");
    var ports = patch.getnamed("io_midi_ports_control");
    if (ports && ports.valid) ports.message("refresh_devices");
    if (!preferencesReady) loadPreferences.schedule(100);
    updateChannels();
}

function input_device(index) {
    change_audio_device("input", index);
}

function output_device(index) {
    change_audio_device("output", index);
}

function change_audio_device(side, index) {
    var setup = audio_panel();
    var setting = setup.getnamed("io_" + side + "_setting");
    var source = patch.getnamed("source_control").js;
    var recorder = patch.getnamed("recorder").subpatcher().getnamed("rec_controller").js;
    if (source.inputTake || recorder.state !== "idle") {
        setting.message("bang");
        label(setup, "io_audio_status", "Finish the current recording before changing devices.");
        return;
    }
    setting.message(index);
    label(setup, "io_audio_status", "Choose recording channels in the main Input section.");
    refreshChannels.schedule(220);
}
change_audio_device.local = 1;

function lookup(owner, name) {
    var scope = patch;
    for (var index = 0; index < owner.length; index++) {
        var box = scope.getnamed(owner[index]);
        if (!box || !box.valid) return null;
        scope = box.subpatcher();
        if (!scope) return null;
    }
    var control = scope.getnamed(name);
    return control && control.valid ? control : null;
}
lookup.local = 1;

function target_for(id) {
    if (Object.prototype.hasOwnProperty.call(MIDI_TARGETS, id)) return MIDI_TARGETS[id];
    var match = /^(.+):choice:(\d+)$/.exec(id);
    if (!match || !Object.prototype.hasOwnProperty.call(MIDI_TARGETS, match[1])) return null;
    var base = MIDI_TARGETS[match[1]];
    var index = Number(match[2]);
    var names = target_choices(base);
    // Dynamic choices have a stable identity only while the corresponding items exist.
    if (index >= names.length || (base.actionMenu && !index)) return null;
    return {
        label: base.label + " › " + names[index], owner: base.owner,
        control: base.control, read: base.read, readOwner: base.readOwner,
        message: base.message, kind: "trigger", choice: index, base: match[1]
    };
}
target_for.local = 1;

function target_choices(target) {
    if (target.dynamicOptions) {
        var control = lookup(target.readOwner || target.owner, target.read || target.control);
        var items = control && control.getattr("items");
        if (typeof items === "string") items = items.split(/\s*,\s*/);
        if (Array.isArray(items) && items.length)
            return items.filter(function (item) { return item !== ","; }).map(String);
    }
    return target.options || [];
}
target_choices.local = 1;

function numeric(value) {
    if (Array.isArray(value)) value = value[0];
    return typeof value === "number" && isFinite(value) ? value : null;
}
numeric.local = 1;

function value_of(target) {
    if (target.state) {
        var state = target.state;
        var controller = lookup(state.owner || target.owner, state.control);
        if (!controller || !controller.js) return null;
        if (state.method) {
            var script = controller.js;
            var read = script[state.method];
            return typeof read === "function" ? numeric(read.apply(script, state.args || [])) : null;
        }
        var value = controller.js[state.property];
        if (state.index !== undefined && value !== null && value !== undefined) value = value[state.index];
        if (state.bitmask && (controller.js[state.bitmask] & (1 << state.index))) value = 1;
        return typeof value === "boolean" ? Number(value) : numeric(value);
    }
    var box = lookup(target.readOwner || target.owner, target.read || target.control);
    return box && box.getvalueof ? numeric(box.getvalueof()) : null;
}
value_of.local = 1;

function send_target(target, value) {
    var view = target.active && lookup(target.readOwner || target.owner, target.read || target.control);
    if (view && Number(view.getattr("active")) === 0) return;
    var box = lookup(target.owner, target.control);
    if (!box) return;
    var args = (target.message || []).slice();
    if (value !== undefined) args.push(value);
    else if (target.choice !== undefined) args.push(target.choice);
    if (!args.length) args.push("bang");
    box.message.apply(box, args);
}
send_target.local = 1;

function clamp(value, low, high) {
    return Math.max(low, Math.min(high, value));
}
clamp.local = 1;

function isMapped(id) {
    return bindings.some(function (binding) {
        return binding.enabled && (binding.target === id || binding.target.indexOf(id + ":choice:") === 0);
    });
}

function is_picked() {
    return picking || picked || pending || finding;
}
is_picked.local = 1;

function midi_escape() {
    if (is_picked()) {
        stop_learning();
        finding = false;
        foundSource = null;
        status = "";
        render();
        return;
    }
    patch.getnamed("theme_control").message("exit_full_screen");
}

function learn() {
    if (picking || picked || pending) {
        stop_learning();
        status = "";
    } else {
        finding = false;
        foundSource = null;
        release_holds();
        picking = true;
        status = inputs.length ? "Click a control to learn it. Esc exits." : "Connect a MIDI controller, then click a control.";
    }
    render();
}

function stop_learning() {
    picking = false;
    picked = "";
    bindingToReplace = "";
    choiceMenu = "";
    pending = null;
}
stop_learning.local = 1;

function midi_pick(id, scope) {
    if (!picking || pending) return;
    var target = target_for(id);
    if (!target) return;
    if (scope === "fixed" && target.alternateIds) {
        var source = patch.getnamed("source_control").js;
        id = target.alternateIds[source.inspectedWindow - 1] || id;
        target = target_for(id);
    }
    if (target.actionMenu) {
        choiceMenu = id;
        picked = "";
        status = "Select a choice to learn from " + target.label + ".";
        open_mappings();
        render();
        return;
    }
    arm(id, "");
}

function midi_navigate(id, choice) {
    var target = target_for(id);
    if (!target || !target.navigation) return;
    if (target.kind === "toggle") send_target(target, value_of(target) ? 0 : 1);
    else if (target.kind === "step" && choice !== undefined) send_target(target, choice);
    else if (target.kind === "trigger") send_target(target);
}

function arm(id, replace) {
    var target = target_for(id);
    if (!target || target.actionMenu) return;
    release_holds();
    finding = false;
    foundSource = null;
    choiceMenu = "";
    picked = id;
    bindingToReplace = replace;
    var isValue = target.kind === "continuous" || target.kind === "step";
    status = target.label + " · " + (isValue ? "Move a knob or fader." : "Press a MIDI button.");
    render();
}
arm.local = 1;

function open_mappings() {
    var theme = patch.getnamed("theme_control");
    var delay = theme.js.fullScreen ? 180 : 0;
    if (delay) theme.message("exit_full_screen");
    openWindow.cancel();
    openWindow.schedule(delay);
}

function show_mappings() {
    patch.getnamed("midi_mappings_window").message("open");
    windowOpen = true;
    render();
}
show_mappings.local = 1;

function mapping_window_closed() {
    windowOpen = false;
    finding = false;
    foundSource = null;
    if (pending || !picking || choiceMenu) {
        stop_learning();
        status = "";
    }
    render();
}

function midi_devices(direction) {
    var names = arrayfromargs(arguments).slice(1).map(String);
    if (direction === "input") {
        inputs.filter(function (name) { return names.indexOf(name) < 0; }).forEach(function (name) {
            release_holds(name);
            Object.keys(pressed).forEach(function (key) {
                if (JSON.parse(key)[0] === name) delete pressed[key];
            });
        });
        inputs = names;
        if (importPort && inputs.indexOf(importPort) < 0) importPort = "";
    } else {
        outputs = names;
        Object.keys(feedbackSent).forEach(function (key) {
            if (outputs.indexOf(feedbackSent[key].port) < 0) delete feedbackSent[key];
        });
    }
    update_feedback_task();
    render();
}

function midi_input(port, kind, number, value, channel) {
    if (inputs.indexOf(port) < 0 || (kind !== "note" && kind !== "cc") ||
        numeric(number) === null || number % 1 || number < 0 || number > 127 ||
        numeric(value) === null || value % 1 || value < 0 || value > 127 ||
        numeric(channel) === null || channel % 1 || channel < 1 || channel > 16) return;
    var source = { port: port, kind: kind, number: number, channel: channel };
    var key = source_key(source);
    var now = Date.now();
    if (echoGuard[key] && now - echoGuard[key].time < 28 && echoGuard[key].value === value) {
        delete echoGuard[key];
        return;
    }
    var down = kind === "note" ? value > 0 : value >= 64;
    var firstPress = down && !pressed[key];
    var release = !down && pressed[key];
    if (down) pressed[key] = true;
    else delete pressed[key];

    if (now - lastActivityTime >= 60) {
        lastActivityTime = now;
        activity = port + " · Ch " + channel + " · " + midi_caption(source) + " · " + value;
        if (windowOpen) label(panel(), "midi_activity_status", activity);
    }
    if (finding) {
        if ((kind === "cc" || firstPress) && (!foundSource || source_key(foundSource) !== key)) {
            foundSource = source;
            var count = bindings.filter(function (entry) { return source_key(entry) === key; }).length;
            status = count ? count + " mapping" + (count === 1 ? "" : "s") + " for " + midi_caption(source) + "." :
                "No mappings use " + midi_caption(source) + " on " + port + ".";
            render();
        }
        return;
    }
    if (pending) return;
    if (picked) {
        var target = target_for(picked);
        if (target && ((target.kind === "continuous" || target.kind === "step") ? kind === "cc" : firstPress)) {
            propose_binding(source, target);
        }
        return;
    }
    if (picking) return;
    bindings.forEach(function (binding) {
        if (binding.enabled && source_key(binding) === key) dispatch_binding(binding, value, firstPress, release);
    });
}

function binding_key(binding) {
    return JSON.stringify([binding.port, binding.target]);
}
binding_key.local = 1;

function source_key(source) {
    return JSON.stringify([source.port, source.kind, source.number, source.channel]);
}
source_key.local = 1;

function midi_caption(binding) {
    return (binding.kind === "cc" ? "CC " : "Note ") + binding.number;
}
midi_caption.local = 1;

function selected_binding() {
    if (!selectedRow || !selectedRow.binding) return null;
    return bindings.filter(function (binding) { return binding_key(binding) === selectedRow.binding; })[0] || null;
}
selected_binding.local = 1;

function defaults(source, id, target) {
    return {
        port: source.port, kind: source.kind, number: source.number, channel: source.channel,
        target: id, enabled: true, invert: false, min: target.min, max: max_of(target),
        mode: target.kind === "toggle" ? "toggle" : target.kind === "trigger" ? "trigger" : "absolute",
        pickup: target.kind === "continuous", feedback: false, feedbackPort: ""
    };
}
defaults.local = 1;

function max_of(target) {
    return target.dynamicOptions ? Math.max(target.max, target_choices(target).length - 1) : target.max;
}
max_of.local = 1;

function propose_binding(source, target) {
    var prior = bindings.filter(function (binding) {
        return binding_key(binding) === bindingToReplace ||
            (binding.target === picked && binding.port === source.port);
    })[0];
    var next = prior ? copy(prior) : defaults(source, picked, target);
    next.port = source.port;
    next.kind = source.kind;
    next.number = source.number;
    next.channel = source.channel;
    var key = binding_key(next);
    var input = source_key(next);
    var conflicts = bindings.filter(function (entry) {
        return source_key(entry) === input && binding_key(entry) !== key && binding_key(entry) !== bindingToReplace;
    });
    pending = { next: next, conflicts: conflicts.map(binding_key), replace: bindingToReplace };
    if (!conflicts.length) {
        commit_candidate(false);
        return;
    }
    status = midi_caption(source) + " already controls " + display_target(conflicts[0].target) +
        (conflicts.length > 1 ? " and " + (conflicts.length - 1) + " more." : ".");
    if (!windowOpen) open_mappings();
    render();
}
propose_binding.local = 1;

function conflict_replace() {
    commit_candidate(true);
}

function conflict_share() {
    commit_candidate(false);
}

function conflict_cancel() {
    if (!pending) return;
    pending = null;
    picked = "";
    bindingToReplace = "";
    status = picking ? "Click another control, or press Esc." : "";
    render();
}

function commit_candidate(replaceConflicts) {
    if (!pending) return;
    var proposal = pending;
    var key = binding_key(proposal.next);
    var next = bindings.filter(function (binding) {
        var existing = binding_key(binding);
        return existing !== key && existing !== proposal.replace &&
            (!replaceConflicts || proposal.conflicts.indexOf(existing) < 0);
    });
    next.push(proposal.next);
    selectedRow = { target: proposal.next.target, binding: key };
    pending = null;
    picked = "";
    bindingToReplace = "";
    status = display_target(proposal.next.target) + " mapped to " + midi_caption(proposal.next) + ".";
    change_bindings(next);
}
commit_candidate.local = 1;

function dispatch_binding(binding, raw, firstPress, release) {
    var target = target_for(binding.target);
    if (!target) return;
    var key = binding_key(binding);
    if (target.kind === "trigger") {
        if (firstPress) send_target(target);
        return;
    }
    if (target.kind === "toggle") {
        if (binding.mode === "hold") {
            if (firstPress) {
                held[key] = binding;
                send_target(target, 1);
            } else if (release && held[key]) {
                delete held[key];
                if (!target_held(binding.target)) send_target(target, 0);
            }
        } else if (firstPress) send_target(target, binding.mode === "trigger" || !value_of(target) ? 1 : 0);
        return;
    }

    var low = binding.min === undefined ? target.min : binding.min;
    var high = binding.max === undefined ? max_of(target) : binding.max;
    if (target.dynamicOptions) {
        var choices = target_choices(target);
        if (choices.length) high = Math.min(high, choices.length - 1);
        if (high < low) return;
    }
    var scale = high - low;
    var current = value_of(target);
    var value;
    if (binding.mode === "absolute") {
        value = low + scale * (binding.invert ? 127 - raw : raw) / 127;
        if (binding.pickup && current !== null && scale > 0) {
            var state = pickup[key] || { previous: null, delivered: null, engaged: false };
            var expected = clamp(current, low, high);
            var tolerance = Math.max(scale / 127 * 0.51, target.integer ? 0.5 : 0.0001);
            if (state.delivered !== null && Math.abs(current - state.delivered) > tolerance) state.engaged = false;
            if (!state.engaged) {
                state.engaged = Math.abs(value - expected) <= tolerance ||
                    (state.previous !== null && (value - expected) * (state.previous - expected) <= 0);
            }
            state.previous = value;
            pickup[key] = state;
            if (!state.engaged) return;
        }
    } else {
        var delta = relative_delta(binding.mode, raw);
        if (!delta) return;
        value = (current === null ? low : current) + (binding.invert ? -delta : delta) *
            (target.integer || target.kind === "step" ? 1 : scale / 127);
    }
    value = clamp(value, low, high);
    if (target.integer || target.kind === "step") value = Math.round(value);
    if (value !== current) send_target(target, value);
    if (pickup[key]) {
        var actual = value_of(target);
        pickup[key].delivered = actual === null ? value : actual;
    }
}
dispatch_binding.local = 1;

function relative_delta(mode, value) {
    if (mode === "relative_offset") return value - 64;
    if (mode === "relative_sign") return value >= 64 ? -(value - 64) : value;
    return value >= 64 ? value - 128 : value;
}
relative_delta.local = 1;

function target_held(id) {
    return Object.keys(held).some(function (key) { return held[key].target === id; });
}
target_held.local = 1;

function release_holds(port) {
    Object.keys(held).forEach(function (key) {
        var binding = held[key];
        if (port && binding.port !== port) return;
        delete held[key];
        var target = target_for(binding.target);
        if (target && !target_held(binding.target)) send_target(target, 0);
    });
}
release_holds.local = 1;

function notifydeleted() {
    release_holds();
    loadPreferences.cancel();
    refreshChannels.cancel();
    openWindow.cancel();
    feedbackTask.cancel();
}

function copy(value) {
    return JSON.parse(JSON.stringify(value));
}
copy.local = 1;

function change_bindings(next) {
    undoStack.push(copy(bindings));
    if (undoStack.length > 100) undoStack.shift();
    set_bindings(next);
    save_profiles();
}
change_bindings.local = 1;

function set_bindings(next) {
    release_holds();
    bindings = next;
    pickup = {};
    options = null;
    update_feedback_task();
    render();
}
set_bindings.local = 1;

function undo() {
    if (!undoStack.length) return;
    status = "Mapping edit undone.";
    set_bindings(undoStack.pop());
    save_profiles();
}

function find_hardware() {
    var next = !finding;
    stop_learning();
    release_holds();
    finding = next;
    foundSource = null;
    status = finding ? "Move a knob or press a pad to find its mappings." : "";
    render();
}

function mapping_search() {
    if (rendering) return;
    search = arrayfromargs(arguments).join(" ").trim().toLowerCase();
    choiceMenu = "";
    render_table();
}

function mapping_filter(index) {
    if (rendering || index < 0 || index > 2) return;
    filter = index;
    choiceMenu = "";
    render_table();
}

function mapping_row(column, index) {
    if (rendering || index < 1 || index > rows.length) return;
    selectedRow = rows[index - 1];
    options = null;
    if (picking && choiceMenu) arm(selectedRow.target, selectedRow.binding || "");
    else render_options();
}

function remap() {
    if (!selectedRow || pending) return;
    arm(selectedRow.target, selectedRow.binding || "");
}

function forget() {
    var current = selected_binding();
    if (!current || pending) return;
    var key = binding_key(current);
    status = display_target(current.target) + " mapping cleared.";
    selectedRow = null;
    change_bindings(bindings.filter(function (binding) { return binding_key(binding) !== key; }));
}

function mapping_option(name, value) {
    if (rendering || !options) return;
    switch (name) {
    case "enabled": case "invert": case "pickup":
        options[name] = !!value;
        break;
    case "min": case "max":
        options[name] = Number(value);
        break;
    case "encoder":
        options.mode = ENCODERS[value] || "absolute";
        panel().getnamed("midi_pickup").message("active", options.mode === "absolute" ? 1 : 0);
        break;
    case "button":
        options.mode = BUTTONS[value] || "toggle";
        break;
    case "feedback":
        options.feedbackPort = feedback_ports(options)[value - 1] || "";
        options.feedback = !!options.feedbackPort;
        break;
    }
    panel().getnamed("midi_apply_options").message("active", 1);
}

function apply_options() {
    var current = selected_binding();
    var target = current && target_for(current.target);
    if (!target || !options) return;
    if ((target.kind === "continuous" || target.kind === "step") &&
        (numeric(options.min) === null || numeric(options.max) === null ||
         options.min < target.min || options.max > max_of(target) || options.min > options.max ||
         ((target.kind === "step" || target.integer) && (options.min % 1 || options.max % 1)))) {
        status = "Choose a valid range from " + target.min + " to " + max_of(target) + ".";
        render_status();
        return;
    }
    var key = binding_key(current);
    status = "Mapping options applied.";
    change_bindings(bindings.map(function (binding) { return binding_key(binding) === key ? options : binding; }));
}

function feedback_ports(binding) {
    var ports = outputs.slice();
    if (binding && binding.feedbackPort && ports.indexOf(binding.feedbackPort) < 0) ports.push(binding.feedbackPort);
    return ports;
}
feedback_ports.local = 1;

function update_feedback_task() {
    var enabled = bindings.some(function (binding) {
        return binding.enabled && binding.feedback && outputs.indexOf(binding.feedbackPort) >= 0;
    });
    if (enabled && !feedbackRunning) {
        feedbackRunning = true;
        feedbackTask.repeat();
    } else if (!enabled && feedbackRunning) {
        feedbackRunning = false;
        feedbackTask.cancel();
    }
    refresh_feedback();
}
update_feedback_task.local = 1;

function refresh_feedback() {
    var desired = {};
    bindings.forEach(function (binding) {
        var target = binding.enabled && binding.feedback && target_for(binding.target);
        var port = binding.feedbackPort;
        if (!target || target.kind !== "toggle" || outputs.indexOf(port) < 0) return;
        var value = value_of(target);
        if (value === null) return;
        var statusByte = (binding.kind === "cc" ? 176 : 144) + binding.channel - 1;
        var key = JSON.stringify([port, statusByte, binding.number]);
        if (!desired[key]) desired[key] = {
            port: port, status: statusByte, number: binding.number, value: 0, sources: []
        };
        desired[key].value = desired[key].value || (value ? 127 : 0);
        desired[key].sources.push(source_key(binding));
    });
    Object.keys(desired).forEach(function (key) {
        if (!feedbackSent[key] || feedbackSent[key].value !== desired[key].value) {
            send_feedback(desired[key], desired[key].value);
        }
    });
    Object.keys(feedbackSent).forEach(function (key) {
        if (!desired[key]) send_feedback(feedbackSent[key], 0);
    });
    feedbackSent = desired;
}
refresh_feedback.local = 1;

function send_feedback(event, value) {
    if (outputs.indexOf(event.port) < 0) return;
    var now = Date.now();
    event.sources.forEach(function (key) { echoGuard[key] = { time: now, value: value }; });
    patch.getnamed("io_midi_ports_control").message("send_feedback", event.port, event.status, event.number, value);
}
send_feedback.local = 1;

function display_target(id) {
    var target = target_for(id);
    return target ? target.label : id;
}
display_target.local = 1;

function row_for(binding) {
    return {
        target: binding.target, binding: binding_key(binding), name: display_target(binding.target),
        port: binding.port, channel: "Ch " + binding.channel, input: midi_caption(binding),
        state: !binding.enabled ? "Disabled" : inputs.indexOf(binding.port) >= 0 ? "Connected" : "Offline"
    };
}
row_for.local = 1;

function all_targets() {
    var result = [];
    Object.keys(MIDI_TARGETS).forEach(function (id) {
        var target = MIDI_TARGETS[id];
        if (!target.actionMenu && !choiceMenu) result.push(id);
        if (choiceMenu && choiceMenu !== id) return;
        // Device and route lists can reorder, so an indexed choice would not have a stable meaning.
        if (target.dynamicOptions) return;
        target_choices(target).forEach(function (_, index) {
            if (!target.actionMenu || index) result.push(id + ":choice:" + index);
        });
    });
    return result;
}
all_targets.local = 1;

function render() {
    set_button(patch, "midi_learn_header", picking || picked ? "Done learning" : "MIDI Learn");
    var header = patch.getnamed("midi_learn_header");
    if (header && header.valid) header.message("hint", "Learn a control by clicking it, then moving a MIDI control.");
    var hint = patch.getnamed("midi_learning_status");
    if (hint && hint.valid) {
        hint.hidden = !(picking || picked || pending);
        hint.message("set", picked && !pending ? "Move MIDI · " + display_target(picked) :
            pending ? "Choose a conflict action in Mappings." : "Click a control · Esc exits");
    }
    patch.applydeep(function (object) {
        if (object.varname === "midi_learn_overlay") object.message("refresh");
    });
    if (!windowOpen) return;
    render_status();
    render_table();
    populate_ports(panel().getnamed("midi_import_port"), ["Keep devices"].concat(inputs),
        importPort ? inputs.indexOf(importPort) + 1 : 0);
}
render.local = 1;

function render_status() {
    if (!windowOpen) return;
    var view = panel();
    set_button(view, "midi_learn", picking || picked ? "Done learning" : "MIDI Learn");
    set_button(view, "midi_find", finding ? "Done finding" : "Find by MIDI");
    label(view, "midi_mapping_status", status ||
        (inputs.length ? inputs.length + " MIDI input" + (inputs.length === 1 ? " connected" : "s connected") + "." :
            "Connect a MIDI controller to start learning."));
    label(view, "midi_activity_status", activity || "Waiting for MIDI input.");
    ["replace", "share", "cancel"].forEach(function (action) {
        view.getnamed("midi_conflict_" + action).message("active", pending ? 1 : 0);
    });
    view.getnamed("midi_undo").message("active", undoStack.length ? 1 : 0);
}
render_status.local = 1;

function render_table() {
    if (!windowOpen) return;
    var mapped = {};
    bindings.forEach(function (binding) { mapped[binding.target] = true; });
    if (finding && foundSource) {
        rows = bindings.filter(function (binding) { return source_key(binding) === source_key(foundSource); }).map(row_for);
    } else {
        rows = filter === 2 || choiceMenu ? [] : bindings.map(row_for);
        if (filter !== 0 || choiceMenu) {
            all_targets().forEach(function (id) {
                if (!mapped[id] || choiceMenu) rows.push({
                    target: id, binding: "", name: display_target(id),
                    port: "", channel: "", input: "", state: mapped[id] ? "Mapped" : "Unmapped"
                });
            });
        }
        if (search && !choiceMenu) rows = rows.filter(function (row) {
            return [row.name, row.port, row.channel, row.input, row.state].join(" ").toLowerCase().indexOf(search) >= 0;
        });
    }
    rows.sort(function (a, b) { return a.name.localeCompare(b.name) || a.port.localeCompare(b.port); });
    var table = panel().getnamed("midi_mapping_table");
    rendering = true;
    table.message("clear", "all");
    table.message("rows", Math.max(rows.length + 1, 2));
    ["Control", "Controller", "Channel", "MIDI", "Status"].forEach(function (caption, col) {
        table.message("set", col, 0, caption);
    });
    var selectedIndex = -1;
    rows.forEach(function (row, index) {
        if (selectedRow && row.target === selectedRow.target && row.binding === selectedRow.binding) selectedIndex = index + 1;
        [row.name, row.port, row.channel, row.input, row.state].forEach(function (value, col) {
            if (value) table.message("set", col, index + 1, value);
        });
    });
    if (selectedIndex > 0) table.message("select", 0, selectedIndex);
    else {
        selectedRow = null;
        options = null;
    }
    rendering = false;
    render_options();
}
render_table.local = 1;

function populate_ports(menu, items, index) {
    menu.message("clear");
    items.forEach(function (name) { menu.message("append", name); });
    menu.message("set", index);
}
populate_ports.local = 1;

function render_options() {
    if (!windowOpen) return;
    var view = panel();
    var binding = selected_binding();
    var target = selectedRow && target_for(selectedRow.target);
    if (!options && binding) options = copy(binding);
    var edit = options || {};
    var value = !!(binding && target && (target.kind === "continuous" || target.kind === "step"));
    var toggle = !!(binding && target && target.kind === "toggle");
    label(view, "midi_mapping_selection", selectedRow ? display_target(selectedRow.target) +
        (binding ? " · " + binding.port : "") : "Select a mapping or an unmapped control.");
    view.getnamed("midi_remap").message("active", target && !pending ? 1 : 0);
    set_button(view, "midi_remap", binding ? "Remap" : "Learn selection");
    view.getnamed("midi_forget").message("active", binding && !pending ? 1 : 0);
    view.getnamed("midi_export").message("active", bindings.length && (!exportScope || binding) ? 1 : 0);
    var ports = feedback_ports(edit);
    populate_ports(view.getnamed("midi_feedback"), ["Off"].concat(ports), ports.indexOf(edit.feedbackPort) + 1);
    var controls = {
        enabled: [binding, Number(!!edit.enabled)],
        invert: [value, Number(!!edit.invert)],
        min: [value, edit.min === undefined ? 0 : edit.min],
        max: [value, edit.max === undefined ? 0 : edit.max],
        encoder: [value, Math.max(0, ENCODERS.indexOf(edit.mode))],
        button: [toggle, Math.max(0, BUTTONS.indexOf(edit.mode))],
        pickup: [value && edit.mode === "absolute", Number(!!edit.pickup)],
        feedback: [toggle, null]
    };
    rendering = true;
    Object.keys(controls).forEach(function (name) {
        var setting = controls[name];
        var object = view.getnamed("midi_" + name);
        var active = setting[0] && !pending;
        if (["min", "max", "encoder", "button", "feedback"].indexOf(name) >= 0)
            object.setboxattr("ignoreclick", active ? 0 : 1);
        else object.message("active", active ? 1 : 0);
        if (setting[1] !== null) object.message("set", setting[1]);
    });
    rendering = false;
    view.getnamed("midi_apply_options").message("active", binding && !pending &&
        JSON.stringify(binding) !== JSON.stringify(options) ? 1 : 0);
}
render_options.local = 1;

function mapping_import_port(index) {
    importPort = inputs[index - 1] || "";
}

function mapping_export_scope(index) {
    exportScope = index ? 1 : 0;
    render_options();
}

function profile_message(verb, id, dict, path) {
    var node = patch.getnamed("set_writer");
    if (path === undefined) node.message(verb, id, dict.name);
    else node.message(verb, id, dict.name, path);
}
profile_message.local = 1;

function profile_dict(entries) {
    var dict = new Dict();
    if (entries) dict.parse(JSON.stringify({ version: 1, mappings: entries }));
    return dict;
}
profile_dict.local = 1;

function finish_request(id) {
    var request = requests[id];
    if (request) {
        delete requests[id];
        request.dict.freepeer();
    }
    return request;
}
finish_request.local = 1;

function load_profiles() {
    if (preferencesReady) return;
    if (loadAttempts >= 20) {
        status = "MIDI settings storage is unavailable.";
        render_status();
        return;
    }
    loadAttempts++;
    if (!loadDictionary) {
        loadRequest = ++requestId;
        loadDictionary = profile_dict();
    }
    profile_message("midi_profile_get", loadRequest, loadDictionary);
    loadPreferences.schedule(400);
}
load_profiles.local = 1;

function save_profiles() {
    if (!preferencesReady) return;
    var id = ++requestId;
    var dict = profile_dict(bindings);
    requests[id] = { verb: "save", dict: dict };
    profile_message("midi_profile_put", id, dict);
}
save_profiles.local = 1;

function import_mappings(path) {
    if (!path) return;
    var id = ++requestId;
    var dict = profile_dict();
    requests[id] = { verb: "import", port: importPort, dict: dict };
    profile_message("midi_profile_import", id, dict, path);
}

function export_mappings(path) {
    if (!path || !bindings.length) return;
    var selected = exportScope ? selected_binding() : null;
    if (exportScope && !selected) return;
    var entries = selected ? bindings.filter(function (entry) { return entry.port === selected.port; }) : bindings;
    var id = ++requestId;
    var dict = profile_dict(entries);
    requests[id] = { verb: "export", dict: dict };
    profile_message("midi_profile_export", id, dict, path);
}

function parse_profile(json, port) {
    var profile = JSON.parse(String(json));
    if (!profile) return [];
    if (profile.version !== 1 || !Array.isArray(profile.mappings)) throw new Error("Unsupported MIDI layout.");
    var result = {};
    profile.mappings.forEach(function (entry) {
        if (!entry || typeof entry.port !== "string" || !entry.port || typeof entry.target !== "string" ||
            !/^(cc|note)$/.test(entry.kind) || numeric(entry.number) === null ||
            entry.number % 1 !== 0 || entry.number < 0 || entry.number > 127 ||
            numeric(entry.channel) === null || entry.channel % 1 !== 0 ||
            entry.channel < 1 || entry.channel > 16) throw new Error("Invalid MIDI assignment.");
        var target = target_for(entry.target);
        var next = target ? defaults(entry, entry.target, target) : copy(entry);
        if (target && (target.kind === "continuous" || target.kind === "step")) {
            if (entry.kind !== "cc") throw new Error("A value control needs a MIDI CC.");
            if (ENCODERS.indexOf(entry.mode) >= 0) next.mode = entry.mode;
            if (numeric(entry.min) !== null && numeric(entry.max) !== null && entry.min <= entry.max) {
                var high = target.dynamicOptions ? Math.max(max_of(target), entry.max) : max_of(target);
                next.min = clamp(entry.min, target.min, high);
                next.max = clamp(entry.max, target.min, high);
                if (target.integer || target.kind === "step") {
                    next.min = Math.round(next.min);
                    next.max = Math.round(next.max);
                }
            }
        } else if (target && target.kind === "toggle" && BUTTONS.indexOf(entry.mode) >= 0) next.mode = entry.mode;
        next.enabled = entry.enabled !== false && entry.enabled !== 0;
        next.pickup = entry.pickup !== false && entry.pickup !== 0 &&
            (!target || target.kind === "continuous" || target.kind === "step");
        next.invert = entry.invert === true || entry.invert === 1;
        next.feedbackPort = typeof entry.feedbackPort === "string" ? entry.feedbackPort : "";
        next.feedback = (entry.feedback === true || entry.feedback === 1) && !!next.feedbackPort;
        if (port && port !== entry.port) {
            next.port = port;
            next.feedback = false;
            next.feedbackPort = "";
        }
        var key = binding_key(next);
        if (result[key]) throw new Error("More than one assignment for a control on the chosen input.");
        result[key] = next;
    });
    return Object.keys(result).map(function (key) { return result[key]; });
}
parse_profile.local = 1;

function midi_profile_loaded(id, name) {
    if (preferencesReady || !loadDictionary || id !== loadRequest || name !== loadDictionary.name) return;
    loadPreferences.cancel();
    try {
        var saved = parse_profile(loadDictionary.stringify(), "");
        var merge = function (entries) {
            var edited = {};
            entries.forEach(function (entry) { edited[binding_key(entry)] = true; });
            return saved.filter(function (entry) { return !edited[binding_key(entry)]; }).concat(entries);
        };
        var hadEdits = bindings.length > 0;
        preferencesReady = true;
        undoStack = undoStack.map(merge);
        set_bindings(merge(bindings));
        if (hadEdits) save_profiles();
    } catch (error) {
        status = "Couldn’t read MIDI settings. " + error.message;
        render_status();
    }
}

function midi_profile_saved(id) {
    finish_request(id);
}

function midi_profile_imported(id, name) {
    var request = requests[id];
    if (!request || request.verb !== "import" || name !== request.dict.name) return;
    try {
        var added = parse_profile(request.dict.stringify(), request.port);
        var targets = {};
        added.forEach(function (entry) { targets[binding_key(entry)] = true; });
        status = "Imported " + added.length + " mapping" + (added.length === 1 ? "" : "s") + ".";
        change_bindings(bindings.filter(function (entry) { return !targets[binding_key(entry)]; }).concat(added));
    } catch (error) {
        status = "Couldn’t import MIDI layout. " + error.message;
        render_status();
    } finally {
        finish_request(id);
    }
}

function midi_profile_exported(id) {
    finish_request(id);
    status = "MIDI layout exported.";
    render_status();
}

function midi_profile_error(id, text) {
    finish_request(id);
    status = String(text);
    render_status();
}
