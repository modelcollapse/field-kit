// Max message-rate adapter. All loop playback, modulation, and mixing run in MSP.
autowatch = 0;
inlets = 1;
outlets = 4;

var WINDOWS = 4;
var FIELD_PRESET_COUNT = 4;
var ALL_WINDOWS = (1 << WINDOWS) - 1;
var DEFAULT_POSITIONS = [[0, 25], [25, 50], [50, 75], [75, 100]];
var DEMOS = [
    {name: "Demo", file: "fk_demo.wav"},
    {id: "glass-circuit", name: "Glass Circuit", file: "fk_demo_glass_circuit.wav", bpm: 120},
    {id: "tidal-lanterns", name: "Tidal Lanterns", file: "fk_demo_tidal_lanterns.wav", bpm: 75}
];
var INSPECTOR_FIELDS = ["start", "end", "rate", "direction", "fade", "drive", "filter", "level", "pan", "echo_send", "room_send"];
var BUFFER_OBJECTS = ["buffer", "set_buffer"];
var INFO_OBJECTS = ["source_info", "set_source_info"];
var INPUT_LIMIT_SECONDS = 60;
var NORMAL_FADE_MS = 16;
var host = this;
var bufferIds = new Global("field_kit_buffer_ids");
var bufferNames = [];
var activeBuffer = 0;
var bufferName = "";
var duration = 0;
var pendingPath = "";
var pendingName = "";
var pendingDemo = null;
var pendingSet = false;
var pendingBuffer = -1;
var readStarted = false;
var stagedSource = null;
var sourcePath = "";
var sourceLabel = "No source";
var sourceDemo = null;
var inputSampleRate = 0;
var inputCount = -1;
var inputChannels = [1, 2];
var INPUT_MENUS = ["input_left", "input_right"];
var inputTake = null;
var inputWritePath = "";
var ready = false;
var audioOn = false;
var audioStarting = false;
var audioStartFailed = false;
var queuedWindows = 0;
var queuedNormal = false;
var normalPlaying = false;
var normalStopping = false;
var drawing = false;
var inspectedWindow = 1;
var positions = DEFAULT_POSITIONS.map(function (range) { return range.slice(); });
var waveRanges = DEFAULT_POSITIONS.map(function (range) { return range.slice(); });
var wavePressX = [null, null, null, null];
var waveDragged = [false, false, false, false];
var WAVE_DRAG_THRESHOLD = 0.0025;
var waveTheme = null;
var waveRevisions = [0, 0, 0, 0];
var pendingWaveEdits = 0;
var playing = [false, false, false, false];
var fieldPresets = [null, null, null, null];
var fieldPresetArmed = false;
var fieldPresetSelected = 0;
var boot = new Task(boot_source, host);
var read = new Task(read_source, host);
var waitForRead = new Task(read_timeout, host);
var commitSet = new Task(commit_set_source, host);
var waitForAudio = new Task(audio_timeout, host);
var settleAudio = new Task(audio_settled, host);
var commitWave = new Task(commit_wave_edits, host);
var inputLimit = new Task(stop_input_record, host);
var inputReply = new Task(input_record_timeout, host);
var inputCommit = new Task(commit_input_record, host);
var inputSaveTimeout = new Task(input_save_failed, host);

function send(name, selector) {
    var object = host.patcher.getnamed(name);
    if (object) {
        var args = arrayfromargs(arguments).slice(1);
        object.message.apply(object, args);
    }
}
send.local = 1;

function label(name, text) {
    send(name, "set", text);
}
label.local = 1;

function initialize() {
    boot.schedule(50);
}

function boot_source() {
    if (bufferName) {
        return;
    }
    bufferIds.last = (bufferIds.last || 0) + 1;
    bufferNames = ["field-kit-source-" + bufferIds.last, "field-kit-set-source-" + bufferIds.last];
    for (var slot = 0; slot < BUFFER_OBJECTS.length; slot++) {
        send(BUFFER_OBJECTS[slot], "name", bufferNames[slot]);
        send(INFO_OBJECTS[slot], "set", bufferNames[slot]);
    }
    bind_source(0);
    send("input_device_channels", "bang");
    for (var index = 1; index <= WINDOWS; index++) {
        draw_region(index);
    }
    inspect_window(inspectedWindow - 1);
    stop_all();
    load_demo();
}
boot_source.local = 1;

function bind_source(index) {
    activeBuffer = index;
    bufferName = bufferNames[index];
    send("normal_voice", "set", bufferName);
    for (var voice = 1; voice <= WINDOWS; voice++) {
        send("voice_" + voice, "source", bufferName);
    }
}
bind_source.local = 1;

function inspect_window(index) {
    if (typeof index !== "number" || index % 1 !== 0 || index < 0 || index >= WINDOWS) {
        return;
    }
    inspectedWindow = index + 1;
    send("inspector_tabs", "set", index);
    label("inspector_title", "Editing Loop " + inspectedWindow);
    for (var voice = 1; voice <= WINDOWS; voice++) {
        send("loop_edit_" + voice, "set", voice === inspectedWindow ? 1 : 0);
    }
    paint_wave_selection();
    send("loop_fade_voice", inspectedWindow);
    INSPECTOR_FIELDS.forEach(function (key) {
        var control = host.patcher.getnamed(key + "_" + inspectedWindow);
        if (control && control.getvalueof) {
            var value = control.getvalueof();
            set_inspector_value(key, Array.isArray(value) ? value[0] : value);
        }
    });
    update_fade_preview();
}

function inspector_edit(key, value) {
    if (INSPECTOR_FIELDS.indexOf(key) !== -1 && typeof value === "number" && isFinite(value)) {
        send(key + "_" + inspectedWindow, value);
    }
}

function inspector_filter_type(index) {
    if (index !== 0 && index !== 1 && index !== 2) return;
    var control = host.patcher.getnamed("filter_" + inspectedWindow);
    if (!control || !control.getvalueof) return;
    var value = control.getvalueof();
    if (Array.isArray(value)) value = value[0];
    var strength = typeof value === "number" && isFinite(value) && value !== 0 ? Math.abs(value) : 40;
    inspector_edit("filter", (index - 1) * strength);
}

function set_inspector_value(key, value) {
    send("inspect_" + key, "set", value);
    if (key === "filter") {
        send("inspect_filter_value", "set", value);
        send("inspect_filter_type", "set", value < 0 ? 0 : value > 0 ? 2 : 1);
    }
}
set_inspector_value.local = 1;

function inspector_sync(voice, key, value) {
    if (voice === inspectedWindow && typeof value === "number" && isFinite(value)) {
        set_inspector_value(key, value);
        if (key === "rate" || key === "fade") update_fade_preview();
    }
}

function wave_theme() {
    var colors = arrayfromargs(arguments);
    if (colors.length !== 16) return;
    waveTheme = [colors.slice(0, 4), colors.slice(4, 8), colors.slice(8, 12), colors.slice(12, 16)];
    paint_wave_selection();
}

function paint_wave_selection() {
    if (!waveTheme) return;
    for (var voice = 1; voice <= WINDOWS; voice++) {
        var selected = voice === inspectedWindow;
        var target = host.patcher.getnamed("wave_" + voice);
        target.message.apply(target, ["bgcolor"].concat(waveTheme[selected ? 1 : 0]));
        var row = host.patcher.getnamed("loop_row_" + voice);
        row.message.apply(row, ["bordercolor"].concat(selected ? waveTheme[2] : [0, 0, 0, 0]));
        var button = host.patcher.getnamed("loop_edit_" + voice);
        var background = waveTheme[selected ? 2 : 1];
        var foreground = waveTheme[selected ? 0 : 3];
        button.message.apply(button, ["activebgcolor"].concat(background));
        button.message.apply(button, ["activebgoncolor"].concat(background));
        button.message.apply(button, ["activetextcolor"].concat(foreground));
        button.message.apply(button, ["activetextoncolor"].concat(foreground));
    }
}
paint_wave_selection.local = 1;

function control_value(name, fallback) {
    var control = host.patcher.getnamed(name);
    if (!control || !control.getvalueof) return fallback;
    var value = control.getvalueof();
    return Number(Array.isArray(value) ? value[0] : value);
}
control_value.local = 1;

function update_fade_preview() {
    var range = positions[inspectedWindow - 1];
    var fade = control_value("fade_" + inspectedWindow, 30);
    var rate = control_value("rate_" + inspectedWindow, 1);
    var estimate = Math.min(fade, 0.45 * duration * (range[1] - range[0]) * 0.01 / rate);
    send("loop_fade_preview", "preview", estimate, ready ? 1 : 0);
}
update_fade_preview.local = 1;

function choose() {
    if (bufferName && !pendingPath && !inputTake && !inputWritePath) {
        send("audio_file", "bang");
    }
}

function load_demo() {
    begin_direct_source(demo_path(DEMOS[0].file), DEMOS[0], false);
}

function select_demo(item) {
    send("demo", "set", 0);
    if (item !== Math.floor(item) || item < 1 || item > DEMOS.length) return;
    var demo = DEMOS[item - 1];
    begin_direct_source(demo_path(demo.file), demo, true);
}

function demo_path(name) {
    var file = host.patcher.filepath;
    var folder = file.slice(0, file.lastIndexOf("/") + 1);
    var demo = folder + name;
    if (typeof File === "function") {
        var candidates = [demo, folder + "Support/" + name];
        // Standalones resolve bundled media by name inside their collective.
        demo = name;
        for (var index = 0; index < candidates.length; index++) {
            var fileOnDisk = new File(candidates[index], "read");
            if (fileOnDisk.isopen) {
                fileOnDisk.close();
                demo = candidates[index];
                break;
            }
        }
    }
    return demo;
}
demo_path.local = 1;

function get_set_source() {
    if (!ready) return null;
    if (sourceDemo === DEMOS[0]) return {kind: "demo"};
    if (sourceDemo) return {kind: "builtin", id: sourceDemo.id};
    return sourcePath ? {kind: "file", path: sourcePath} : null;
}

function builtin_demo(id) {
    for (var index = 1; index < DEMOS.length; index++) {
        if (DEMOS[index].id === id) return DEMOS[index];
    }
    return null;
}
builtin_demo.local = 1;

function valid_builtin_demo(id) {
    return builtin_demo(id) !== null;
}

function open_set_demo(id) {
    var demo = id === undefined ? DEMOS[0] : builtin_demo(id);
    if (!demo) {
        send("pattern_control", "set_source_loaded", 0);
        return;
    }
    begin_set_source(demo_path(demo.file), demo);
}

function open_set_source(path) {
    begin_set_source(path, null);
}

function begin_set_source(path, demo) {
    if (!can_open_source(path)) {
        send("pattern_control", "set_source_loaded", 0);
        return;
    }
    if (!demo && typeof File === "function") {
        try {
            var file = new File(path, "read");
            if (!file.isopen) {
                throw new Error("Could not open set audio");
            }
            file.close();
        } catch (error) {
            send("pattern_control", "set_source_loaded", 0);
            return;
        }
    }
    queuedWindows = 0;
    queuedNormal = false;
    begin_source_read(path, demo, 1 - activeBuffer, true);
}
begin_set_source.local = 1;

function can_open_source(path) {
    return !!bufferName && !pendingPath && !inputTake && !inputWritePath &&
        typeof path === "string" && !!path.length;
}
can_open_source.local = 1;

function open_source(path) {
    begin_direct_source(path, null, true);
}

function begin_direct_source(path, demo, autoplay) {
    if (!can_open_source(path)) {
        return;
    }
    stop_all();
    commitWave.cancel();
    pendingWaveEdits = 0;
    ready = false;
    duration = 0;
    queuedWindows = autoplay ? ALL_WINDOWS : 0;
    begin_source_read(path, demo, activeBuffer, false);
}
begin_direct_source.local = 1;

function begin_source_read(path, demo, target, isSet) {
    pendingPath = path;
    pendingDemo = demo;
    pendingBuffer = target;
    pendingSet = isSet;
    pendingName = demo ? demo.name : path.split("/").pop();
    label("source_label", "Loading " + pendingName + "…");
    update_status();
    // Normal loads release the voices first. A set reads into the idle buffer.
    read.schedule(isSet ? 0 : 40);
}
begin_source_read.local = 1;

function read_source() {
    var target = pendingBuffer;
    // A failed replace must never validate audio left by an earlier load.
    send(BUFFER_OBJECTS[target], "sizeinsamps", 1);
    readStarted = true;
    send(BUFFER_OBJECTS[target], "replace", pendingPath);
    if (readStarted) {
        waitForRead.schedule(15000);
    }
}
read_source.local = 1;

function source_loaded(sampleRate) {
    finish_source_read(0, sampleRate);
}

function set_source_read(sampleRate) {
    finish_source_read(1, sampleRate);
}

function finish_source_read(target, sampleRate) {
    if (inputWritePath && target === activeBuffer) {
        finish_input_save();
        return;
    }
    if (!pendingPath || !readStarted || target !== pendingBuffer) {
        return;
    }
    var buffer = new Buffer(bufferNames[target]);
    var frames = buffer.framecount();
    var channels = buffer.channelcount();
    if (!isFinite(sampleRate) || sampleRate <= 0 || !isFinite(frames) || frames < 2 || !isFinite(channels) || channels < 1) {
        read_timeout();
        return;
    }

    waitForRead.cancel();
    readStarted = false;
    if (pendingSet) {
        stop_all();
        commitWave.cancel();
        pendingWaveEdits = 0;
        stagedSource = {sampleRate: sampleRate, frames: frames, channels: channels};
        commitSet.schedule(40);
    } else {
        accept_source(sampleRate, frames, channels);
    }
}
finish_source_read.local = 1;

function commit_set_source() {
    var source = stagedSource;
    stagedSource = null;
    bind_source(pendingBuffer);
    accept_source(source.sampleRate, source.frames, source.channels);
    send(BUFFER_OBJECTS[1 - activeBuffer], "sizeinsamps", 1);
    send("pattern_control", "set_source_loaded", 1);
}
commit_set_source.local = 1;

function accept_source(sampleRate, frames, channels) {
    sourceDemo = pendingDemo;
    sourcePath = pendingPath;
    var name = pendingName;
    if (!pendingSet && sourceDemo && sourceDemo.bpm) set_demo_timing(sourceDemo.bpm);
    clear_pending_source();
    activate_source(sampleRate, frames, channels, name);
}
accept_source.local = 1;

function set_demo_timing(bpm) {
    // The four stems use equal-length, pre-looped sections at the source tempo.
    reset_regions();
    for (var voice = 1; voice <= WINDOWS; voice++) {
        send("rate_" + voice, 1);
        send("direction_" + voice, 0);
        send("fade_" + voice, 0);
    }
    var panel = host.patcher.getnamed("sequence_panel").subpatcher();
    panel.getnamed("seq_bpm").message(bpm);
    panel.getnamed("seq_beats").message(4);
}
set_demo_timing.local = 1;

function activate_source(sampleRate, frames, channels, name) {
    duration = 1000 * frames / sampleRate;
    send("source_rate", sampleRate);
    send("normal_right_channel", channels === 1 ? 1 : 2);

    drawing = true;
    for (var index = 1; index <= WINDOWS; index++) {
        send("wave_" + index, "set", bufferName);
        send("wave_" + index, "mouseoutput", "continuous");
        send("wave_" + index, "line", "phase");
        send("wave_" + index, "line", -1);
    }
    drawing = false;
    ready = true;
    for (var voice = 1; voice <= WINDOWS; voice++) {
        draw_region(voice);
    }
    var format = channels === 1 ? "mono" : channels === 2 ? "stereo" : channels + " ch";
    sourceLabel = name + "   ·   " + (duration / 1000).toFixed(2) + " s   ·   " + format;
    label("source_label", sourceLabel);
    start_queued_playback();
    update_status();
}
activate_source.local = 1;

function clear_pending_source() {
    pendingPath = "";
    pendingName = "";
    pendingSet = false;
    pendingDemo = null;
    pendingBuffer = -1;
    readStarted = false;
}
clear_pending_source.local = 1;

function read_timeout() {
    waitForRead.cancel();
    var isSet = pendingSet;
    clear_pending_source();
    queuedWindows = 0;
    queuedNormal = false;
    if (isSet) {
        update_status();
        label("source_label", sourceLabel);
        label("status", "Couldn’t load set audio.");
        send("pattern_control", "set_source_loaded", 0);
        return;
    }
    ready = false;
    duration = 0;
    sourceLabel = "No source";
    for (var voice = 1; voice <= WINDOWS; voice++) {
        send("wave_" + voice, "set");
    }
    update_status();
    label("source_label", sourceLabel);
    label("status", "Couldn’t load audio. Try another file.");
    update_fade_preview();
}
read_timeout.local = 1;

function update_status() {
    var recording = inputTake && inputTake.state === "recording";
    var capturing = recording && inputTake.started;
    if (recording) {
        label("input_record_state", capturing ? "● RECORDING" : "Starting…");
    } else if (inputTake) {
        label("input_record_state", "Preparing take…");
    } else if (inputWritePath) {
        label("input_record_state", "Saving WAV…");
    } else if (!audioOn || audioStarting) {
        label("input_record_state", "Enable audio to record");
    } else {
        label("input_record_state", inputCount > 0 ? "Ready to record" : "Choose an input device");
    }
    if (capturing) {
        send("input_record_state", "bgcolor", 0.64, 0.10, 0.16, 1);
    } else {
        send("input_record_state", "bgcolor", 0, 0, 0, 0);
    }
    var inputButton = recording ? "Stop source" : "Record source";
    send("input_record_button", "text", inputButton);
    send("input_record_button", "texton", inputButton);
    send("input_record_button", "active", recording || (audioOn && !audioStarting &&
        inputSampleRate > 0 && inputCount > 0 && !pendingPath && !inputWritePath && !inputTake) ? 1 : 0);
    send("input_save_button", "active", ready && !sourceDemo && !sourcePath &&
        !pendingPath && !inputTake && !inputWritePath ? 1 : 0);
    send("demo", "ignoreclick", pendingPath || inputTake || inputWritePath ? 1 : 0);
    INPUT_MENUS.forEach(function (name) {
        send(name, "ignoreclick", inputTake || inputCount < 1 ? 1 : 0);
    });
    var count = playing.filter(function (state) { return state; }).length;
    if (inputTake) {
        label("status", recording ? "● Recording source · Click Stop source." : "Preparing recorded source…");
    } else if (inputWritePath) {
        label("status", "Saving recorded source…");
    } else if (pendingPath) {
        label("status", (queuedWindows || queuedNormal) ? "Loading audio… Playback queued." : "Loading audio…");
    } else if (audioStarting) {
        label("status", "Starting audio…");
    } else if (audioStartFailed) {
        label("status", "Audio didn’t start. Open Audio Setup…");
    } else if (normalPlaying) {
        label("status", "Playing original sample");
    } else if (count) {
        label("status", count + " of " + WINDOWS + " windows playing");
    } else if (ready) {
        label("status", sourceDemo ? "Click Play all to hear the demo." :
            sourcePath ? "Ready · Click Play all." : "Input ready · Save a WAV to keep the take.");
    } else if (bufferName) {
        label("status", "Choose Load audio… or Demos…");
    }
}
update_status.local = 1;

function input_sample_rate(rate) {
    if (typeof rate === "number" && isFinite(rate) && rate > 0 && rate !== inputSampleRate) {
        inputSampleRate = rate;
        if (inputTake && inputTake.state === "recording") stop_input_record();
        update_status();
    }
}

function input_channel_count(count) {
    if (typeof count !== "number" || !isFinite(count)) return;
    count = Math.max(0, Math.min(1024, Math.floor(count)));
    if (count === inputCount) return;
    inputCount = count;
    stop_input_record();
    INPUT_MENUS.forEach(function (name, side) {
        send(name, "clear");
        if (!count) {
            send(name, "append", "No input");
            send(name, "set", 0);
            return;
        }
        for (var channel = 1; channel <= count; channel++) send(name, "append", channel);
        inputChannels[side] = Math.min(inputChannels[side], count);
        send(name, "set", inputChannels[side] - 1);
        send("input_adc", "set", side + 1, inputChannels[side]);
    });
    update_status();
}

function set_input_channel(outletNumber, index) {
    if (outletNumber !== 1 && outletNumber !== 2) return;
    var side = outletNumber - 1;
    if (inputTake || typeof index !== "number" || index % 1 || index < 0 || index >= inputCount) {
        send(INPUT_MENUS[side], "set", inputCount > 0 ? inputChannels[side] - 1 : 0);
        return;
    }
    inputChannels[side] = index + 1;
    send("input_adc", "set", outletNumber, inputChannels[side]);
}

function toggle_input_record() {
    if (inputTake) {
        if (inputTake.state === "recording") stop_input_record();
        return;
    }
    if (!bufferName || pendingPath || inputWritePath || !audioOn ||
        audioStarting || !inputSampleRate || inputCount < 1) {
        return;
    }
    var target = 1 - activeBuffer;
    var frames = Math.round(inputSampleRate * INPUT_LIMIT_SECONDS);
    var object = BUFFER_OBJECTS[target];
    send(object, "sr", inputSampleRate);
    send(object, "sizeinsamps", frames, 2);
    send(object, "clear");
    send("input_recorder", "set", bufferNames[target]);
    send("input_recorder", "reset");
    send("input_progress", "bang");
    inputTake = {
        state: "recording", target: target, frames: frames,
        sampleRate: inputSampleRate, started: false, tenths: 0
    };
    label("input_record_time", "00:00.0");
    send("input_recorder", 1);
    inputLimit.schedule(INPUT_LIMIT_SECONDS * 1000);
    update_status();
    send("input_clock", "start");
}

function stop_input_record() {
    if (!inputTake || inputTake.state !== "recording") return;
    inputLimit.cancel();
    inputTake.state = "stopping";
    send("input_clock", "stop");
    update_status();
    inputReply.schedule(500);
    send("input_recorder", 0);
    send("input_progress", "bang");
}
stop_input_record.local = 1;

function input_elapsed_phase(phase) {
    if (!inputTake || inputTake.state !== "recording" ||
        typeof phase !== "number" || !isFinite(phase) || phase <= 0) return;
    if (!inputTake.started) {
        inputTake.started = true;
        update_status();
    }
    update_input_time(Math.min(phase, 1) * inputTake.frames);
}

function update_input_time(frames) {
    var tenths = Math.floor(frames * 10 / inputTake.sampleRate);
    if (tenths <= inputTake.tenths) return;
    inputTake.tenths = tenths;
    var minutes = ("0" + Math.floor(tenths / 600)).slice(-2);
    var seconds = ("0" + Math.floor(tenths / 10) % 60).slice(-2);
    label("input_record_time", minutes + ":" + seconds + "." + tenths % 10);
}
update_input_time.local = 1;

function input_record_progress(phase) {
    if (!inputTake || inputTake.state !== "stopping") return;
    inputReply.cancel();
    var frames = Math.min(inputTake.frames, Math.round(phase * inputTake.frames) + 1);
    if (!isFinite(frames) || frames < 2) {
        input_record_timeout();
        return;
    }
    inputTake.state = "committing";
    update_input_time(frames);
    send(BUFFER_OBJECTS[inputTake.target], "crop_samples", 0, frames);
    stop_all();
    commitWave.cancel();
    pendingWaveEdits = 0;
    inputCommit.schedule(40);
}

function input_record_timeout() {
    inputTake = null;
    update_status();
    label("status", "No input captured. Try a longer take.");
}
input_record_timeout.local = 1;

function commit_input_record() {
    var take = inputTake;
    var buffer = new Buffer(bufferNames[take.target]);
    var frames = buffer.framecount();
    var channels = buffer.channelcount();
    if (!isFinite(frames) || frames < 2 || channels !== 2) {
        input_record_timeout();
        return;
    }
    inputTake = null;
    bind_source(take.target);
    sourceDemo = null;
    sourcePath = "";
    activate_source(take.sampleRate, frames, channels, "Recorded input");
    send(BUFFER_OBJECTS[1 - activeBuffer], "sizeinsamps", 1);
}
commit_input_record.local = 1;

function choose_input_save() {
    if (!ready || sourceDemo || sourcePath || pendingPath || inputTake || inputWritePath) return;
    send("input_save_dialog", "name", "Field Kit Source.wav");
    send("input_save_dialog", "bang");
}

function save_input_path(path) {
    if (!ready || sourceDemo || sourcePath || pendingPath || inputTake || inputWritePath ||
        typeof path !== "string" || !/\.wav$/i.test(path)) return;
    inputWritePath = path;
    update_status();
    inputSaveTimeout.schedule(10000);
    send(BUFFER_OBJECTS[activeBuffer], "samptype", "int24");
    send(BUFFER_OBJECTS[activeBuffer], "writewave", path);
}

function finish_input_save() {
    var buffer = new Buffer(bufferName);
    if (!has_input_audio(inputWritePath, buffer.framecount() * 6)) {
        input_save_failed();
        return;
    }
    inputSaveTimeout.cancel();
    sourcePath = inputWritePath;
    inputWritePath = "";
    sourceLabel = sourcePath.split("/").pop() + "   ·   " + (duration / 1000).toFixed(2) + " s   ·   stereo";
    label("source_label", sourceLabel);
    update_status();
    label("status", "Saved source WAV · Ready for Save Set.");
}
finish_input_save.local = 1;

function has_input_audio(path, expectedBytes) {
    var file = new File(path, "read");
    if (!file.isopen) return false;
    try {
        if (file.eof < 44 + expectedBytes || file.readstring(4) !== "RIFF") return false;
        file.position = 8;
        if (file.readstring(4) !== "WAVE") return false;
        file.byteorder = "little";
        while (file.position + 8 <= file.eof) {
            var chunk = file.readstring(4);
            var size = file.readint32(1)[0];
            if (size < 0 || file.position + size > file.eof) return false;
            if (chunk === "data") return size === expectedBytes;
            file.position += size + (size % 2);
        }
        return false;
    } finally {
        file.close();
    }
}
has_input_audio.local = 1;

function input_save_failed() {
    inputSaveTimeout.cancel();
    inputWritePath = "";
    update_status();
    label("status", "Couldn’t save source WAV. Try another location.");
}
input_save_failed.local = 1;

function dsp_enabled(state) {
    var wasAudioOn = audioOn;
    audioOn = !!state;
    if (audioOn !== wasAudioOn) send("loop_fade_preview", "running", audioOn ? 1 : 0);
    if (audioOn) send("input_device_channels", "bang");
    if (audioStarting) {
        // Core Audio can report on, off, on while Max rebuilds its DSP graph.
        // Leave the requested transport queued until the graph stays on.
        settleAudio.cancel();
        if (audioOn) {
            settleAudio.schedule(80);
        }
        return;
    }
    send("audio_switch", "set", audioOn ? 1 : 0);
    if (audioOn) {
        audioStartFailed = false;
        start_queued_playback();
    } else if (wasAudioOn) {
        stop_input_record();
        stop_all();
    }
    update_status();
}

function audio_settled() {
    if (!audioStarting || !audioOn) {
        return;
    }
    waitForAudio.cancel();
    audioStarting = false;
    audioStartFailed = false;
    send("audio_switch", "set", 1);
    start_queued_playback();
    update_status();
}
audio_settled.local = 1;

function set_audio(state) {
    if (!bufferName) {
        return;
    }
    if (state) {
        send("audio_switch", "set", audioOn ? 1 : 0);
        if (audioOn || audioStarting) {
            return;
        }
        audioStarting = true;
        audioStartFailed = false;
        update_status();
        waitForAudio.schedule(3000);
        send("dac", "start");
    } else {
        stop_input_record();
        waitForAudio.cancel();
        settleAudio.cancel();
        audioStarting = false;
        audioStartFailed = false;
        audioOn = false;
        stop_all();
        send("audio_switch", "set", 0);
        send("dac", "stop");
    }
}

function audio_timeout() {
    settleAudio.cancel();
    audioStarting = false;
    audioStartFailed = true;
    queuedWindows = 0;
    queuedNormal = false;
    update_status();
}
audio_timeout.local = 1;

function start_queued_playback() {
    if ((!queuedWindows && !queuedNormal) || !ready || audioStarting || pendingSet ||
        (inputTake && inputTake.state === "committing")) {
        return;
    }
    if (!audioOn) {
        set_audio(1);
        return;
    }
    if (queuedNormal) {
        if (normalStopping) {
            return;
        }
        queuedNormal = false;
        normalPlaying = true;
        // Keep both fades within the sample, including very short sources.
        var fade = Math.min(NORMAL_FADE_MS, duration * 0.5);
        send("normal_blend", "list", 1, fade, 1, duration - 2 * fade, 0, fade);
        send("normal_voice", "start");
        return;
    }
    var windows = queuedWindows;
    queuedWindows = 0;
    for (var voice = 1; voice <= WINDOWS; voice++) {
        if (windows & (1 << (voice - 1))) {
            set_play(voice, true);
        }
    }
}
start_queued_playback.local = 1;

function stop_normal() {
    queuedNormal = false;
    if (normalPlaying) {
        normalPlaying = false;
        normalStopping = true;
        if (audioOn) {
            send("normal_blend", "list", 0, NORMAL_FADE_MS);
        }
    }
    if (normalStopping && !audioOn) {
        send("normal_blend", 0);
        normal_faded();
    }
}
stop_normal.local = 1;

function normal_faded() {
    if (normalStopping) {
        // Keep play~ running until its output has faded out.
        normalStopping = false;
        send("normal_voice", "stop");
        start_queued_playback();
        update_status();
    }
}

function normal_finished() {
    if (normalPlaying) {
        normalPlaying = false;
        update_status();
    }
}

function set_play(voice, state) {
    var actual = !!(state && ready && audioOn);
    if (playing[voice - 1] !== actual) {
        playing[voice - 1] = actual;
        send("run_" + voice, actual ? 1 : 0);
        send("playhead_gate_" + voice, actual ? 1 : 0);
    }
    send("play_" + voice, "set", actual ? 1 : 0);
    if (!actual) {
        send("wave_" + voice, "line", -1);
    }
}
set_play.local = 1;

function edit_play(voice, value) {
    if (voice < 1 || voice > WINDOWS || voice % 1 || typeof value !== "number") {
        return;
    }
    if (pendingSet && value) {
        send("play_" + voice, "set", playing[voice - 1] ? 1 : 0);
        return;
    }
    var windowBit = 1 << (voice - 1);
    if (value && (ready || pendingPath)) {
        stop_normal();
        queuedWindows |= windowBit;
        start_queued_playback();
    } else if (!value) {
        queuedWindows &= ~windowBit;
    }
    if (!value || !playing[voice - 1]) {
        set_play(voice, false);
    }
    update_status();
}

function play_all() {
    if (!pendingSet && (ready || pendingPath)) {
        stop_normal();
        queuedWindows = ALL_WINDOWS;
        start_queued_playback();
    }
    update_status();
}

function play_normal() {
    if (!pendingSet && !normalPlaying && !queuedNormal && (ready || pendingPath)) {
        stop_all();
        queuedNormal = true;
        start_queued_playback();
    }
    update_status();
}

function exit_normal() {
    stop_normal();
    update_status();
}

function stop_pad_motion() {
    send("pad_motion_stop", "bang");
}

function field_presets_snapshot() {
    return fieldPresets.map(function (preset) { return preset ? preset.slice() : null; });
}

function valid_field_preset(preset) {
    return Array.isArray(preset) && preset.length === 2 * WINDOWS &&
        preset.every(function (value, i) {
            return typeof value === "number" && isFinite(value) &&
                value >= (i % 2 === 0 ? -100 : 0) && value <= 100;
        });
}
valid_field_preset.local = 1;

function field_presets_valid(slots) {
    return slots === undefined || (Array.isArray(slots) && slots.length === FIELD_PRESET_COUNT &&
        slots.every(function (preset) { return preset === null || valid_field_preset(preset); }));
}

function field_presets_restore(slots) {
    if (!field_presets_valid(slots)) return;
    fieldPresets = slots === undefined ? [null, null, null, null] :
        slots.map(function (preset) { return preset ? preset.slice() : null; });
    fieldPresetArmed = false;
    fieldPresetSelected = 0;
    render_field_presets("Shift-click to store");
}

function field_message() {
    var canvas = host.patcher.getnamed("stereo_field_panel").subpatcher().getnamed("canvas");
    canvas.message.apply(canvas, arrayfromargs(arguments));
}
field_message.local = 1;

function render_field_presets(status) {
    field_message("field_presets", fieldPresetArmed ? 1 : 0, fieldPresetSelected,
                  fieldPresets[0] ? 1 : 0, fieldPresets[1] ? 1 : 0, fieldPresets[2] ? 1 : 0,
                  fieldPresets[3] ? 1 : 0, status);
}
render_field_presets.local = 1;

function field_preset_arm() {
    fieldPresetArmed = !fieldPresetArmed;
    render_field_presets(fieldPresetArmed ? "Choose a slot to store" : "Shift-click to store");
}

function field_preset_slot(slot, shift) {
    if (typeof slot !== "number" || slot % 1 !== 0 || slot < 1 || slot > FIELD_PRESET_COUNT) return;
    if (fieldPresetArmed || shift === 1) {
        var values = [];
        for (var i = 1; i <= WINDOWS; i++) {
            values.push(control_value("pan_" + i, 0), control_value("level_" + i, 70));
        }
        if (!valid_field_preset(values)) {
            render_field_presets("Positions not ready");
            return;
        }
        fieldPresets[slot - 1] = values;
        fieldPresetSelected = slot;
        fieldPresetArmed = false;
        render_field_presets("Stored " + slot + " · Save Set to keep");
        return;
    }
    var preset = fieldPresets[slot - 1];
    if (!preset) {
        render_field_presets("Slot " + slot + " is empty");
        return;
    }
    // An active field gesture would otherwise overwrite the recalled positions.
    field_message("stop_motion");
    for (var voice = 1; voice <= WINDOWS; voice++) {
        send("pan_" + voice, preset[2 * (voice - 1)]);
        send("level_" + voice, preset[2 * (voice - 1) + 1]);
    }
    fieldPresetSelected = slot;
    render_field_presets("Recalled " + slot);
}

function stop_all() {
    send("sequence_control", "stop");
    if (audioOn) send("pattern_control", "transport_stopped");
    stop_pad_motion();
    queuedWindows = 0;
    stop_normal();
    for (var voice = 1; voice <= WINDOWS; voice++) {
        set_play(voice, false);
    }
    update_status();
}

function reset_regions() {
    positions = DEFAULT_POSITIONS.map(function (range) { return range.slice(); });
    for (var voice = 1; voice <= WINDOWS; voice++) {
        draw_region(voice);
    }
}

function clip(value, low, high) {
    return Math.max(low, Math.min(value, high));
}
clip.local = 1;

function min_width() {
    return duration > 0 ? Math.min(100, 100 / duration) : 0.01;
}
min_width.local = 1;

function draw_region(voice) {
    var index = voice - 1;
    var range = positions[index];
    waveRanges[index] = range.slice();
    pendingWaveEdits &= ~(1 << index);
    wavePressX[index] = null;
    waveDragged[index] = false;
    send("base_start_" + voice, range[0]);
    send("base_end_" + voice, range[1]);
    send("start_" + voice, "set", range[0]);
    send("end_" + voice, "set", range[1]);
    inspector_sync(voice, "start", range[0]);
    inspector_sync(voice, "end", range[1]);
    if (voice === inspectedWindow) update_fade_preview();
    draw_wave_selection(voice, range);
}
draw_region.local = 1;

function draw_wave_selection(voice, range) {
    if (ready) {
        drawing = true;
        outlet(voice - 1, [range[0] * duration * 0.01, range[1] * duration * 0.01]);
        drawing = false;
    }
}
draw_wave_selection.local = 1;

function edit_start(voice, value) {
    if (voice >= 1 && voice <= WINDOWS && voice % 1 === 0 && typeof value === "number" && isFinite(value)) {
        var range = positions[voice - 1];
        set_region(voice, clip(value, 0, Math.max(0, range[1] - min_width())), range[1]);
    }
}

function edit_end(voice, value) {
    if (voice >= 1 && voice <= WINDOWS && voice % 1 === 0 && typeof value === "number" && isFinite(value)) {
        var range = positions[voice - 1];
        set_region(voice, range[0], clip(value, Math.min(100, range[0] + min_width()), 100));
    }
}

function set_region(voice, start, end) {
    if (!(voice >= 1 && voice <= WINDOWS && voice % 1 === 0) ||
        typeof start !== "number" || typeof end !== "number" ||
        !isFinite(start) || !isFinite(end) || start > end) {
        return;
    }
    var low = clip(start, 0, 100);
    var high = clip(end, 0, 100);
    var width = min_width();
    if (high - low < width) {
        high = Math.min(100, low + width);
        low = Math.max(0, high - width);
    }
    var index = voice - 1;
    var previous = positions[index];
    if (Math.abs(low - previous[0]) >= 0.00001 || Math.abs(high - previous[1]) >= 0.00001) {
        waveRevisions[index] = (waveRevisions[index] + 1) % 1048576;
        send("wave_edit_revision_" + voice, waveRevisions[index]);
    }
    positions[index] = [low, high];
    draw_region(voice);
}

function track_wave(voice, displayStart, displayLength, start, end) {
    if (drawing || !ready || voice < 1 || voice > WINDOWS || !isFinite(start) || !isFinite(end)) {
        return;
    }
    waveRanges[voice - 1] = [Math.min(start, end) / duration * 100,
                            Math.max(start, end) / duration * 100];
}

function wave_mouse(voice, x, y, phase) {
    if (!ready || voice < 1 || voice > WINDOWS) {
        return;
    }
    var index = voice - 1;
    var bit = 1 << index;
    if (phase === 1) {
        pendingWaveEdits &= ~bit;
        wavePressX[index] = x;
        waveDragged[index] = false;
        inspect_window(index);
        return;
    }
    if (wavePressX[index] !== null && Math.abs(x - wavePressX[index]) >= WAVE_DRAG_THRESHOLD) {
        waveDragged[index] = true;
    }
    if (phase === 0) {
        wavePressX[index] = null;
        pendingWaveEdits |= bit;
        // Let waveform~ finish emitting its selection for this mouse event.
        commitWave.schedule(0);
    }
}

function commit_wave_edits() {
    var edits = pendingWaveEdits;
    pendingWaveEdits = 0;
    for (var index = 0; ready && index < WINDOWS; index++) {
        if (!(edits & (1 << index))) {
            continue;
        }
        var range = positions[index];
        var next = waveRanges[index];
        var dragged = waveDragged[index];
        waveDragged[index] = false;
        if (!dragged) {
            waveRanges[index] = range.slice();
            draw_wave_selection(index + 1, range);
            continue;
        }
        if (Math.abs(range[0] - next[0]) < 0.00001 && Math.abs(range[1] - next[1]) < 0.00001) {
            continue;
        }
        var voice = index + 1;
        set_region(voice, next[0], next[1]);
    }
}
commit_wave_edits.local = 1;
