autowatch = 0;
inlets = 2;
outlets = 0;

var patch = this.patcher;
var midiDevices = [];
var midiPort = "";
var pressed = {};
var selected = 0;
var armed = false;
var mappings = {};
var targets = [
    ["Global speed", "global_speed", 0.5, 2],
    ["Master level", "master", -70, 0],
    ["Play all", "play"],
    ["Stop all", "stop"],
    ["Main FX on/off", "fx_enabled"],
    ["Echo mix / return", "fx_echo", 0, 100],
    ["Room mix / return", "fx_space", 0, 100],
    ["Distortion", "fx_distortion", 0, 100]
];
for (var voice = 1; voice <= 4; voice++) {
    var title = "Loop " + voice + " ";
    targets.push([title + "play / stop", "play_" + voice],
                 [title + "level", "level_" + voice, 0, 100],
                 [title + "pan", "pan_" + voice, -100, 100],
                 [title + "Echo send", "echo_send_" + voice, 0, 100],
                 [title + "Room send", "room_send_" + voice, 0, 100]);
}
var refreshMidi = new Task(renderPorts, this);
var refreshChannels = new Task(updateChannels, this);

function panel() {
    return patch.getnamed("io_setup_panel").subpatcher();
}
panel.local = 1;

function label(name, text) {
    panel().getnamed(name).message("set", text);
}
label.local = 1;

function updateChannels() {
    patch.getnamed("input_device_channels").message("bang");
}
updateChannels.local = 1;

function bang() {
    panel().getnamed("io_input_setting").message("loadbang");
    panel().getnamed("io_output_setting").message("loadbang");
    var menu = panel().getnamed("io_target");
    menu.message("clear");
    targets.forEach(function (entry) { menu.message("append", entry[0]); });
    menu.message("set", selected);
    renderMapping();
    patch.getnamed("io_midi_query").message("bang");
    updateChannels();
}

function input_device(index) {
    changeAudioDevice("input", index);
}

function output_device(index) {
    changeAudioDevice("output", index);
}

function changeAudioDevice(side, index) {
    var setting = panel().getnamed("io_" + side + "_setting");
    var source = patch.getnamed("source_control").js;
    var recorder = patch.getnamed("recorder").subpatcher().getnamed("rec_controller").js;
    if (source.inputTake || recorder.state !== "idle") {
        setting.message("bang");
        label("io_audio_status", "Finish the current recording before changing devices.");
        return;
    }
    setting.message(index);
    label("io_audio_status", "Choose recording channels in the main Input section.");
    refreshChannels.schedule(220);
}
changeAudioDevice.local = 1;

function clear() {
    if (inlet !== 1) return;
    midiDevices = [];
    refreshMidi.schedule(30);
}

function append(name) {
    if (inlet === 1 && typeof name === "string") midiDevices.push(name);
}

function set() {
    if (inlet !== 1) return;
    refreshMidi.cancel();
    renderPorts();
}

function renderPorts() {
    var menu = panel().getnamed("io_midi_input");
    menu.message("clear");
    menu.message("append", "Off");
    midiDevices.forEach(function (name) { menu.message("append", name); });
    var index = midiDevices.indexOf(midiPort);
    if (midiPort && index < 0) {
        midi_device(0);
        label("io_midi_status", "MIDI device disconnected. Choose a port to reconnect.");
    }
    menu.message("set", index + 1);
}
renderPorts.local = 1;

function midi_device(index) {
    var next = midiDevices[index - 1] || "";
    if (next === midiPort) return;
    midiPort = next;
    pressed = {};
    armed = false;
    patch.getnamed("io_midi_note_in").message("port", midiPort || "none");
    patch.getnamed("io_midi_cc_in").message("port", midiPort || "none");
    renderMapping();
}

function target(index) {
    if (!targets[index]) return;
    selected = index;
    armed = false;
    renderMapping();
}

function bindingKey(index) {
    return JSON.stringify([midiPort, index]);
}
bindingKey.local = 1;

function renderMapping() {
    var learnButton = panel().getnamed("io_learn");
    var binding = mappings[bindingKey(selected)];
    var caption = armed ? "Cancel" : "Learn";
    learnButton.message("text", caption);
    learnButton.message("texton", caption);
    learnButton.message("active", midiPort ? 1 : 0);
    panel().getnamed("io_forget").message("active", binding ? 1 : 0);
    var status = "Choose a MIDI input to begin.";
    if (midiPort) {
        if (armed) {
            status = targets[selected].length === 4 ? "Move a knob or fader." : "Press a note or a MIDI button.";
        } else if (binding) {
            status = (binding[0] === "cc" ? "CC " : "Note ") + binding[1] + " · Channel " + binding[2];
        } else {
            status = "Unmapped · Click Learn to assign this control.";
        }
    }
    label("io_midi_status", status);
}
renderMapping.local = 1;

function learn() {
    if (!midiPort) return;
    armed = !armed;
    renderMapping();
}

function forget() {
    delete mappings[bindingKey(selected)];
    armed = false;
    renderMapping();
}

function note(number, velocity, channel) {
    receiveMidi("note", number, velocity, channel);
}

function cc(value, number, channel) {
    receiveMidi("cc", number, value, channel);
}

function receiveMidi(kind, number, value, channel) {
    if (!midiPort || number < 0 || number > 127 || value < 0 || value > 127) return;
    var key = kind + ":" + number + ":" + channel;
    var down = kind === "note" ? value > 0 : value >= 64;
    var firstPress = down && !pressed[key];
    if (down) pressed[key] = true;
    else delete pressed[key];

    if (armed) {
        var continuous = targets[selected].length === 4;
        if (continuous ? kind === "cc" : firstPress) {
            targets.forEach(function (_, index) {
                var existing = mappings[bindingKey(index)];
                if (existing && existing[0] === kind && existing[1] === number && existing[2] === channel) {
                    delete mappings[bindingKey(index)];
                }
            });
            mappings[bindingKey(selected)] = [kind, number, channel];
            armed = false;
            renderMapping();
        }
        return;
    }

    targets.forEach(function (entry, index) {
        var binding = mappings[bindingKey(index)];
        if (!binding || binding[0] !== kind || binding[1] !== number || binding[2] !== channel) return;
        var name = entry[1];
        var owner = name.indexOf("fx_") === 0 ? patch.getnamed("mix_fx").subpatcher() : patch;
        var control = owner.getnamed(name);
        if (entry.length === 4) {
            control.message(entry[2] + (entry[3] - entry[2]) * value / 127);
        } else if (firstPress) {
            if (name === "play" || name === "stop") {
                control.message("bang");
            } else if (name === "fx_enabled") {
                control.message(Number(control.getvalueof()) ? 0 : 1);
            } else {
                var voice = Number(name.slice(5));
                var source = patch.getnamed("source_control");
                var running = source.js.playing[voice - 1] || (source.js.queuedWindows & (1 << (voice - 1)));
                source.message("edit_play", voice, running ? 0 : 1);
            }
        }
    });
}
receiveMidi.local = 1;
