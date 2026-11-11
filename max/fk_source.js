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
var INSPECTOR_FIELDS = ["start", "end", "rate", "direction", "fade", "drive", "filter", "level", "pan"];
var BUFFER_OBJECTS = ["buffer", "set_buffer"];
var INFO_OBJECTS = ["source_info", "set_source_info"];
var NORMAL_FADE_MS = 16;
var host = this;
var bufferIds = new Global("field_kit_buffer_ids");
var bufferNames = [];
var activeBuffer = 0;
var bufferName = "";
var duration = 0;
var baseSampleRate = 0;
var loopBuffers = [];
var loopSources = [null, null, null, null];
var loopCleared = [false, false, false, false];
var emptyBufferName = "";
var loopPending = null;
var loopDestination = 0;
var loopSet = null;
var loopWrite = null;
var lateLoopReads = {};
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
var inputRequest = 0;
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
var inputPrepare = new Task(input_prepare_timeout, host);
var inputWatch = new Task(watch_input_progress, host);
var inputFinish = new Task(finish_input_record, host);
var inputSaveTimeout = new Task(input_save_failed, host);
var loopReadTimeout = new Task(loop_read_expired, host);
var loopSwitch = new Task(commit_loop_switch, host);
var loopWriteTimeout = new Task(loop_write_expired, host);

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
    for (var loopSlot = 0; loopSlot < 8; loopSlot++) {
        var name = "field-kit-loop-" + bufferIds.last + "-" + loopSlot;
        loopBuffers.push(name);
        send("loop_buffer_" + loopSlot, "name", name);
        send("loop_info_" + loopSlot, "set", name);
    }
    emptyBufferName = "field-kit-empty-" + bufferIds.last;
    send("empty_loop_buffer", "name", emptyBufferName);
    send("empty_loop_buffer", "sizeinsamps", 1);
    bind_source(0);
    for (var voice = 1; voice <= WINDOWS; voice++) bind_loop(voice);
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
    send("tuner_selected_loop", inspectedWindow);
    INSPECTOR_FIELDS.forEach(function (key) {
        var control = host.patcher.getnamed(key + "_" + inspectedWindow);
        if (control && control.getvalueof) {
            var value = control.getvalueof();
            set_inspector_value(key, Array.isArray(value) ? value[0] : value);
        }
    });
    update_fade_preview();
    update_status();
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
    var estimate = Math.min(fade, 0.45 * loop_duration(inspectedWindow) * (range[1] - range[0]) * 0.01 / rate);
    send("loop_fade_preview", "preview", estimate, ready ? 1 : 0);
}
update_fade_preview.local = 1;

function folder_paths(importPath, recordingPath, banksPath, status) {
    var panel = host.patcher.getnamed("working_folders_panel").subpatcher();
    var recordingDialog = host.patcher.getnamed("recorder").subpatcher().getnamed("save_dialog");
    function apply(dialog, path) {
        if (path) dialog.message("setpath", path);
        else dialog.message("setpath");
    }
    [[ "import", importPath, "audio_file" ], [ "recording", recordingPath, "input_save_dialog" ],
     [ "banks", banksPath, "pattern_save_dialog" ]]
        .forEach(function (entry) {
            var path = entry[1];
            apply(host.patcher.getnamed(entry[2]), path);
            apply(panel.getnamed(entry[0] + "_folder_dialog"), path);
            var caption = panel.getnamed(entry[0] + "_path");
            caption.message("set", path.length > 47 ? "…" + path.slice(-46) : path || "System default");
            caption.message("hint", path || "Uses the last location remembered by the system");
        });
    apply(recordingDialog, recordingPath);
    apply(host.patcher.getnamed("pattern_load_dialog"), banksPath);
    apply(host.patcher.getnamed("loop_file"), importPath);
    panel.getnamed("folders_status").message("set", status);
}

function choose() {
    if (bufferName && !loop_busy()) {
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

function loop_busy() {
    return !!(loopPending || loopSet || loopWrite || inputTake || inputWritePath || pendingPath);
}

function loop_duration(voice) {
    if (loopCleared[voice - 1]) return 0;
    var entry = loopSources[voice - 1];
    return entry ? entry.frames * 1000 / entry.sampleRate : duration;
}
loop_duration.local = 1;

function pool_slot() {
    for (var index = 0; index < loopBuffers.length; index++) {
        if (!lateLoopReads[index] && !loopSources.some(function (entry) { return entry && entry.slot === index; }) &&
            !(loopSet && loopSet.sources.some(function (entry) { return entry && entry.slot === index; }))) return index;
    }
    return -1;
}
pool_slot.local = 1;

function release_loop_buffer(entry) {
    if (entry && !loopSources.some(function (source) { return source === entry; })) {
        send("loop_buffer_" + entry.slot, "sizeinsamps", 1);
    }
}
release_loop_buffer.local = 1;

function set_loop_destination(index) {
    if (loop_busy() || typeof index !== "number" || index % 1 || index < 0 || index > WINDOWS + 1) {
        send("loop_destination", "set", loopDestination);
        return;
    }
    loopDestination = index;
    update_status();
}

function import_loop_audio() {
    choose_loop_audio(loopDestination || inspectedWindow);
}

function choose_loop_audio(voice) {
    if (!ready || loop_busy()) return;
    loopPending = {state: "choosing", voice: voice || inspectedWindow};
    send("loop_file", "bang");
}

function stage_loop_file(path) {
    if (!loopPending || loopPending.state !== "choosing") return;
    var voice = loopPending.voice;
    var slot = pool_slot();
    if (slot < 0 || typeof path !== "string" || !path) {
        discard_loop_audio();
        label("status", "Couldn’t prepare that audio file.");
        return;
    }
    start_loop_read(path, slot, voice);
}

function start_loop_read(path, slot, voice, recordedBytes) {
    loopPending = {state: "reading", voice: voice, slot: slot, path: path, recordedBytes: recordedBytes};
    send("loop_buffer_" + slot, "sizeinsamps", 1);
    loopReadTimeout.schedule(12000);
    send("loop_buffer_" + slot, "replace", path);
    update_status();
}
start_loop_read.local = 1;

function loop_buffer_ready(slot, sampleRate) {
    if (lateLoopReads[slot]) {
        delete lateLoopReads[slot];
        return;
    }
    if (loopWrite && loopWrite.entry.slot === slot) {
        var writing = loopWrite;
        loopWriteTimeout.cancel();
        loopWrite = null;
        var saved = has_input_audio(writing.path, writing.entry.frames * 6);
        if (saved) {
            writing.entry.path = writing.path;
            writing.entry.name = loop_file_name(writing.path);
        }
        update_status();
        label("status", saved ? "Loop WAV saved · Ready for Save Set." : "Couldn’t save the loop WAV.");
        return;
    }
    if (!loopPending || loopPending.state !== "reading" || loopPending.slot !== slot) return;
    loopReadTimeout.cancel();
    var audio = new Buffer(loopBuffers[slot]);
    var frames = audio.framecount();
    var channels = audio.channelcount();
    var recorded = loopPending.recordedBytes;
    if (!isFinite(sampleRate) || sampleRate <= 0 || !isFinite(frames) || frames < 2 ||
        channels < 1 || (recorded && (channels !== 2 || frames * 6 !== recorded))) {
        fail_loop_read(false);
        return;
    }
    var path = loopPending.path;
    var entry = {slot: slot, path: path, sampleRate: sampleRate, frames: frames, name: loop_file_name(path)};
    if (loopSet) {
        loopSet.sources[loopPending.voice - 1] = entry;
        loopPending = null;
        read_next_set_loop();
    } else {
        if (recorded) {
            send("set_writer", "remove_input_temp", path);
            entry.path = "";
            entry.name = "Recorded take";
        }
        stage_loop_entry(loopPending.voice, entry);
    }
}

function loop_read_expired() {
    fail_loop_read(true);
}
loop_read_expired.local = 1;

function fail_loop_read(late) {
    if (!loopPending || loopPending.state !== "reading") return;
    var failed = loopPending;
    if (late) lateLoopReads[loopPending.slot] = true;
    loopPending = null;
    if (loopSet) {
        abandon_loop_set();
        send("pattern_control", "set_source_loaded", 0);
    }
    update_status();
    if (failed.recordedBytes) {
        send("status", "hint", failed.path);
        label("status", "Couldn’t stage take · WAV kept.");
    } else {
        label("status", "Couldn’t load the loop audio.");
    }
}
fail_loop_read.local = 1;

function loop_file_name(path) {
    return path.split(/[\\/]/).pop();
}
loop_file_name.local = 1;

function loop_target_name(voice) {
    return voice === WINDOWS + 1 ? "all loops" : "Loop " + voice;
}
loop_target_name.local = 1;

function stage_loop_entry(voice, entry) {
    loopPending = {state: "staged", voice: voice, entry: entry, range: [0, 100]};
    var panel = host.patcher.getnamed("loop_take_panel").subpatcher();
    var destination = loop_target_name(voice);
    var caption = "Use on " + destination;
    panel.getnamed("take_title").message("set", "New audio for " + destination);
    panel.getnamed("take_detail").message("set", entry.name + " · " + (entry.frames / entry.sampleRate).toFixed(2) + " s");
    panel.getnamed("take_discard").message("text", "Discard");
    panel.getnamed("take_discard").message("texton", "Discard");
    panel.getnamed("take_confirm").message("text", caption);
    panel.getnamed("take_confirm").message("texton", caption);
    send("theme_control", "open_loop_take");
    update_status();
}
stage_loop_entry.local = 1;

function close_loop_take() {
    var panel = host.patcher.getnamed("loop_take_panel").subpatcher();
    if (panel.wind && panel.wind.visible) panel.getnamed("take_thispatcher").message("wclose");
}
close_loop_take.local = 1;

function clear_loop() {
    if (!ready || loop_busy() || loopCleared[inspectedWindow - 1]) return;
    var voice = inspectedWindow;
    loopPending = {state: "clearing", voice: voice};
    var panel = host.patcher.getnamed("loop_take_panel").subpatcher();
    panel.getnamed("take_title").message("set", "Clear Loop " + voice + "?");
    panel.getnamed("take_detail").message("set", loopSources[voice - 1] && !loopSources[voice - 1].path ?
        "Unsaved audio will be removed. Saved WAVs are kept." :
        "Empties this track. Saved audio files stay on disk.");
    panel.getnamed("take_discard").message("text", "Cancel");
    panel.getnamed("take_discard").message("texton", "Cancel");
    panel.getnamed("take_confirm").message("text", "Clear Loop " + voice);
    panel.getnamed("take_confirm").message("texton", "Clear Loop " + voice);
    send("theme_control", "open_loop_take");
    update_status();
}

function confirm_loop_audio() {
    if (loopPending && loopPending.state === "clearing") {
        switch_loop_audio(loopPending.voice, null, [0, 100], true);
        close_loop_take();
        return;
    }
    if (!loopPending || loopPending.state !== "staged") return;
    var change = loopPending;
    switch_loop_audio(change.voice, change.entry, change.range);
    close_loop_take();
}

function loop_take_closed() {
    if (loopPending && (loopPending.state === "staged" || loopPending.state === "clearing")) discard_loop_audio(false);
}

function discard_loop_audio(close) {
    if (!loopPending || (loopPending.state !== "staged" && loopPending.state !== "choosing" && loopPending.state !== "clearing")) return;
    var change = loopPending;
    loopPending = null;
    if (close !== false) close_loop_take();
    if (change.entry) release_loop_buffer(change.entry);
    update_status();
}

function copy_loop_to(voice) {
    send("loop_copy", "set", 0);
    if (voice === WINDOWS + 1) {
        clear_loop();
        return;
    }
    if (!ready || loop_busy() || voice < 1 || voice > WINDOWS || voice % 1 || voice === inspectedWindow) return;
    var index = inspectedWindow - 1;
    if (loopCleared[index]) return;
    switch_loop_audio(voice, loopSources[index], positions[index].slice());
}

function switch_loop_audio(voice, entry, range, clearing) {
    var voices = voice === WINDOWS + 1 ? [1, 2, 3, 4] : [voice];
    loopPending = {state: "switching", voices: voices, entry: entry, range: range, clearing: !!clearing};
    var running = voices.filter(function (target) { return audioOn && playing[target - 1]; });
    if (clearing) {
        queuedWindows &= ~(1 << (voice - 1));
        set_play(voice, false);
    }
    if (running.length) {
        running.forEach(function (target) { send("run_" + target, 0); });
        loopSwitch.schedule(40);
    } else {
        commit_loop_switch();
    }
    update_status();
}
switch_loop_audio.local = 1;

function commit_loop_switch() {
    var change = loopPending;
    var previous = [];
    change.voices.forEach(function (voice) {
        var old = loopSources[voice - 1];
        if (old && previous.indexOf(old) === -1) previous.push(old);
        loopSources[voice - 1] = change.entry;
        loopCleared[voice - 1] = change.clearing;
        bind_loop(voice);
        var range = change.voices.length === 1 ? change.range :
            [(voice - 1) * 100 / WINDOWS, voice * 100 / WINDOWS];
        set_region(voice, range[0], range[1]);
    });
    loopPending = null;
    change.voices.forEach(function (voice) {
        send("run_" + voice, audioOn && playing[voice - 1] ? 1 : 0);
    });
    previous.forEach(release_loop_buffer);
    update_status();
}
commit_loop_switch.local = 1;

function bind_loop(voice) {
    var entry = loopSources[voice - 1];
    var name = loopCleared[voice - 1] ? emptyBufferName : entry ? loopBuffers[entry.slot] : bufferName;
    send("voice_" + voice, "source", name);
    send("source_rate_" + voice, entry ? entry.sampleRate : baseSampleRate);
    var wasDrawing = drawing;
    drawing = true;
    send("wave_" + voice, "set", name);
    send("wave_" + voice, "line", -1);
    drawing = wasDrawing;
}
bind_loop.local = 1;

function update_loop_buttons() {
    var busy = loop_busy();
    for (var voice = 1; voice <= WINDOWS; voice++) {
        var empty = loopCleared[voice - 1];
        send("play_" + voice, "active", ready && !empty ? 1 : 0);
        send("play_" + voice, "text", empty ? "Empty" : "▶ Play");
        send("play_" + voice, "texton", empty ? "Empty" : "■ Stop");
    }
    label("inspector_title", loopCleared[inspectedWindow - 1] ?
        "Loop " + inspectedWindow + " · Empty" : "Editing Loop " + inspectedWindow);
    var entry = loopSources[inspectedWindow - 1];
    send("loop_copy", "ignoreclick", busy || !ready ? 1 : 0);
    send("loop_replace", "active", !busy && ready ? 1 : 0);
    send("load", "active", !busy && ready ? 1 : 0);
    send("loop_destination", "ignoreclick", busy ? 1 : 0);
    var saveCaption = !entry && ready && !sourceDemo && !sourcePath ? "Save source WAV…" : "Save Loop WAV…";
    send("input_save_button", "text", saveCaption);
    send("input_save_button", "texton", saveCaption);
    send("input_save_button", "active", !busy && ready && !loopCleared[inspectedWindow - 1] &&
        ((entry && !entry.path) || (!entry && !sourceDemo && !sourcePath)) ? 1 : 0);
}
update_loop_buttons.local = 1;

function get_set_cleared() {
    return loopCleared.slice();
}

function get_set_loops() {
    if (loop_busy() || loopSources.some(function (entry) { return entry && !entry.path; })) return null;
    return loopSources.map(function (entry) { return entry ? entry.path : null; });
}

function open_set_loops(base, demoId, paths, cleared) {
    if (!Array.isArray(paths) || paths.length !== WINDOWS || loop_busy()) {
        send("pattern_control", "set_source_loaded", 0);
        return;
    }
    loopSet = {base: base, demoId: demoId, paths: paths, sources: [null, null, null, null],
        cleared: cleared ? cleared.slice() : [false, false, false, false]};
    read_next_set_loop();
}

function read_next_set_loop() {
    for (var index = 0; index < WINDOWS; index++) {
        var path = loopSet.paths[index];
        if (!path || loopSet.sources[index]) continue;
        var duplicate = loopSet.paths.indexOf(path);
        if (duplicate < index) {
            loopSet.sources[index] = loopSet.sources[duplicate];
        } else {
            var slot = pool_slot();
            if (slot < 0) {
                abandon_loop_set();
                send("pattern_control", "set_source_loaded", 0);
                return;
            }
            start_loop_read(path, slot, index + 1);
            return;
        }
    }
    if (loopSet.base) open_set_source(loopSet.base);
    else if (loopSet.demoId) open_set_demo(loopSet.demoId);
    else open_set_demo();
}
read_next_set_loop.local = 1;

function abandon_loop_set() {
    if (!loopSet) return;
    var staged = loopSet.sources;
    loopSet = null;
    staged.forEach(release_loop_buffer);
}
abandon_loop_set.local = 1;

function finish_loop_set() {
    var previous = loopSources;
    loopSources = loopSet ? loopSet.sources : [null, null, null, null];
    loopCleared = loopSet ? loopSet.cleared : [false, false, false, false];
    loopSet = null;
    previous.forEach(release_loop_buffer);
}
finish_loop_set.local = 1;

function loop_write_expired() {
    if (loopWrite) lateLoopReads[loopWrite.entry.slot] = true;
    loopWrite = null;
    update_status();
    label("status", "Couldn’t save the loop WAV.");
}
loop_write_expired.local = 1;

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
        abandon_loop_set();
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
        abandon_loop_set();
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
            abandon_loop_set();
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
    return !!bufferName && !pendingPath && !inputTake && !inputWritePath && !loopPending && !loopWrite &&
        typeof path === "string" && !!path.length;
}
can_open_source.local = 1;

function open_source(path) {
    begin_direct_source(path, null, true);
}

function begin_direct_source(path, demo, autoplay) {
    if (loopSet || !can_open_source(path)) {
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
    finish_loop_set();
    accept_source(source.sampleRate, source.frames, source.channels);
    send(BUFFER_OBJECTS[1 - activeBuffer], "sizeinsamps", 1);
    send("pattern_control", "set_source_loaded", 1);
}
commit_set_source.local = 1;

function accept_source(sampleRate, frames, channels) {
    sourceDemo = pendingDemo;
    sourcePath = pendingPath;
    var name = pendingName;
    if (!pendingSet) {
        finish_loop_set();
        if (sourceDemo && sourceDemo.bpm) set_demo_timing(sourceDemo.bpm);
    }
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
    baseSampleRate = sampleRate;
    send("normal_right_channel", channels === 1 ? 1 : 2);

    drawing = true;
    for (var index = 1; index <= WINDOWS; index++) {
        bind_loop(index);
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
        abandon_loop_set();
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
    var staged = loopPending && loopPending.state === "staged";
    if (recording) {
        label("input_record_state", capturing ? (inputTake.voice ?
            "Recording to " + loop_target_name(inputTake.voice) : "Recording") : "Starting…");
    } else if (inputTake) {
        label("input_record_state", inputTake.state === "allocating" ? "Starting…" : "Preparing take…");
    } else if (loopPending && loopPending.state === "reading" && loopPending.recordedBytes) {
        label("input_record_state", "Preparing take…");
    } else if (staged) {
        label("input_record_state", (loopPending.entry.path ? "File" : "Take") +
            " ready · " + loop_target_name(loopPending.voice));
    } else if (inputWritePath || loopWrite) {
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
    var destination = loop_target_name(loopDestination || inspectedWindow);
    var inputButton = recording ? "Stop recording" : "Record to " + destination;
    var importButton = "Import to " + destination + "…";
    send("input_record_button", "text", inputButton);
    send("input_record_button", "texton", inputButton);
    send("load", "text", importButton);
    send("load", "texton", importButton);
    send("input_record_button", "active", recording || (audioOn && !audioStarting &&
        inputSampleRate > 0 && inputCount > 0 && !loop_busy()) ? 1 : 0);
    update_loop_buttons();
    send("demo", "ignoreclick", loop_busy() ? 1 : 0);
    INPUT_MENUS.forEach(function (name) {
        send(name, "ignoreclick", inputTake || inputCount < 1 ? 1 : 0);
    });
    var count = playing.filter(function (state) { return state; }).length;
    if (inputTake) {
        label("status", recording ? "● Recording · Click Stop recording." : "Preparing recorded audio…");
    } else if (inputWritePath) {
        label("status", "Saving recorded source…");
    } else if (staged) {
        label("status", (loopPending.entry.path ? "File" : "Take") + " ready · Confirm or discard.");
    } else if (loopPending && loopPending.state === "clearing") {
        label("status", "Clear Loop " + loopPending.voice + "? Confirm or cancel.");
    } else if (pendingPath) {
        label("status", (queuedWindows || queuedNormal) ? "Loading audio… Playback queued." : "Loading audio…");
    } else if (audioStarting) {
        label("status", "Starting audio…");
    } else if (audioStartFailed) {
        label("status", "Audio didn’t start. Open Audio Setup…");
    } else if (normalPlaying) {
        label("status", "Playing original sample");
    } else if (count) {
        label("status", count + " of " + WINDOWS + " loops playing");
    } else if (ready) {
        label("status", loopCleared.every(Boolean) ? "Empty tracks · Record or import audio." :
            sourceDemo ? "Click Play all to hear the demo." :
            sourcePath ? "Ready · Click Play all." : "Input ready · Save a WAV to keep the take.");
    } else if (bufferName) {
        label("status", "Choose a demo to get started.");
    }
}
update_status.local = 1;

function input_sample_rate(rate) {
    if (typeof rate === "number" && isFinite(rate) && rate > 0 && rate !== inputSampleRate) {
        inputSampleRate = rate;
        if (inputTake && inputTake.state === "recording") stop_input_record();
        else if (inputTake && inputTake.state === "allocating") {
            inputPrepare.cancel();
            input_prepare_timeout();
        }
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

function toggle_loop_record() {
    if (inputTake) {
        if (inputTake.state === "recording") stop_input_record();
        return;
    }
    if (!ready || loop_busy() || !audioOn || audioStarting || !inputSampleRate || inputCount < 1) return;
    var target = pool_slot();
    if (target < 0) {
        label("status", "No space to stage another take.");
        return;
    }
    inputTake = {state: "allocating", request: ++inputRequest, target: target,
        voice: loopDestination || inspectedWindow};
    label("input_record_time", "00:00.0");
    send("status", "hint", "");
    update_status();
    inputPrepare.schedule(5000);
    send("set_writer", "create_input_temp", inputRequest);
}

function input_temp_ready(request, path) {
    if (!inputTake || inputTake.state !== "allocating" || inputTake.request !== request) {
        if (path) send("set_writer", "remove_input_temp", path);
        return;
    }
    inputPrepare.cancel();
    if (!path || !audioOn) {
        if (path) send("set_writer", "remove_input_temp", path);
        input_prepare_timeout();
        return;
    }
    inputTake.state = "recording";
    inputTake.path = path;
    inputTake.lastElapsed = null;
    inputTake.lastProgress = Date.now();
    inputTake.tenths = 0;
    send("input_recorder", "samptype", "int24");
    send("input_recorder", "open", "wave", path);
    send("input_recorder", 1);
    send("input_clock", "start");
    inputWatch.schedule(300);
    update_status();
}

function input_prepare_timeout() {
    inputTake = null;
    update_status();
    label("status", "Couldn’t prepare the loop recording.");
}
input_prepare_timeout.local = 1;

function stop_input_record() {
    if (!inputTake) return;
    if (inputTake.state === "allocating") {
        inputPrepare.cancel();
        input_prepare_timeout();
        return;
    }
    if (inputTake.state !== "recording") return;
    inputWatch.cancel();
    inputTake.state = "stopping";
    inputTake.attempts = 0;
    send("input_clock", "stop");
    send("input_recorder", 0);
    update_status();
    inputFinish.schedule(150);
}
stop_input_record.local = 1;

function input_elapsed(ms) {
    if (!inputTake || inputTake.state !== "recording" ||
        typeof ms !== "number" || !isFinite(ms) || ms < 0) return;
    var previous = inputTake.lastElapsed;
    inputTake.lastElapsed = ms;
    if (previous === null || ms <= previous) return;
    inputTake.lastProgress = Date.now();
    if (!inputTake.started) {
        inputTake.started = true;
        update_status();
    }
    var tenths = Math.floor(ms / 100);
    if (tenths <= inputTake.tenths) return;
    inputTake.tenths = tenths;
    var minutes = Math.floor(tenths / 600);
    var seconds = ("0" + Math.floor(tenths / 10) % 60).slice(-2);
    label("input_record_time", (minutes < 10 ? "0" : "") + minutes + ":" + seconds + "." + tenths % 10);
}

function watch_input_progress() {
    if (Date.now() - inputTake.lastProgress > 1800) stop_input_record();
    else inputWatch.schedule(300);
}
watch_input_progress.local = 1;

function finish_input_record() {
    var take = inputTake;
    var bytes = input_wav_bytes(take.path);
    if (bytes >= 12 && bytes % 6 === 0) {
        inputTake = null;
        start_loop_read(take.path, take.target, take.voice, bytes);
    } else if (++take.attempts < 8) {
        inputFinish.schedule(150);
    } else {
        inputTake = null;
        update_status();
        if (bytes === 0 || bytes === 6) {
            send("set_writer", "remove_input_temp", take.path);
            label("status", "No take saved · Check disk space and audio input.");
        } else {
            send("status", "hint", take.path);
            label("status", "Couldn’t read take · WAV kept.");
        }
    }
}
finish_input_record.local = 1;

function choose_input_save() {
    var entry = loopSources[inspectedWindow - 1];
    if (entry && !entry.path && !loop_busy()) {
        send("input_save_dialog", "name", "Field Kit Loop " + inspectedWindow + ".wav");
        send("input_save_dialog", "bang");
        return;
    }
    if (!ready || entry || sourceDemo || sourcePath || loop_busy()) return;
    send("input_save_dialog", "name", "Field Kit Source.wav");
    send("input_save_dialog", "bang");
}

function save_input_path(path) {
    var entry = loopSources[inspectedWindow - 1];
    if (entry && !entry.path && !loop_busy() && typeof path === "string" && /\.wav$/i.test(path)) {
        loopWrite = {entry: entry, path: path};
        loopWriteTimeout.schedule(10000);
        send("loop_buffer_" + entry.slot, "samptype", "int24");
        send("loop_buffer_" + entry.slot, "writewave", path);
        update_status();
        return;
    }
    if (!ready || entry || sourceDemo || sourcePath || loop_busy() ||
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
    return expectedBytes >= 6 && input_wav_bytes(path) === expectedBytes;
}
has_input_audio.local = 1;

function input_wav_bytes(path) {
    var file = new File(path, "read");
    if (!file.isopen) return 0;
    try {
        var container = file.readstring(4);
        file.position = 8;
        if ((container !== "RIFF" && container !== "RF64") || file.readstring(4) !== "WAVE") return -1;
        file.byteorder = "little";
        var extended = 0;
        while (file.position + 8 <= file.eof) {
            var chunk = file.readstring(4);
            var size = file.readint32(1)[0] >>> 0;
            var start = file.position;
            if (chunk === "data") {
                var bytes = container === "RF64" && size === 0xffffffff ? extended : size;
                return start + bytes <= file.eof ? bytes : -1;
            }
            if (start + size + size % 2 > file.eof) return -1;
            if (chunk === "ds64" && container === "RF64" && size >= 28) {
                file.position = start + 8;
                var words = file.readint32(2);
                extended = (words[0] >>> 0) + (words[1] >>> 0) * 4294967296;
            }
            file.position = start + size + size % 2;
        }
        return -1;
    } catch (_) {
        return -1;
    } finally {
        file.close();
    }
}
input_wav_bytes.local = 1;

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
    if ((!queuedWindows && !queuedNormal) || !ready || audioStarting || pendingSet) {
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
    var actual = !!(state && ready && audioOn && !loopCleared[voice - 1]);
    if (playing[voice - 1] !== actual) {
        playing[voice - 1] = actual;
        send("run_" + voice, actual && !(loopPending && loopPending.state === "switching" &&
            loopPending.voices.indexOf(voice) !== -1) ? 1 : 0);
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

function min_width(voice) {
    var length = loop_duration(voice);
    return length > 0 ? Math.min(100, 100 / length) : 0.01;
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
        var length = loop_duration(voice);
        outlet(voice - 1, [range[0] * length * 0.01, range[1] * length * 0.01]);
        drawing = false;
    }
}
draw_wave_selection.local = 1;

function edit_start(voice, value) {
    if (voice >= 1 && voice <= WINDOWS && voice % 1 === 0 && typeof value === "number" && isFinite(value)) {
        var range = positions[voice - 1];
        set_region(voice, clip(value, 0, Math.max(0, range[1] - min_width(voice))), range[1]);
    }
}

function edit_end(voice, value) {
    if (voice >= 1 && voice <= WINDOWS && voice % 1 === 0 && typeof value === "number" && isFinite(value)) {
        var range = positions[voice - 1];
        set_region(voice, range[0], clip(value, Math.min(100, range[0] + min_width(voice)), 100));
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
    var width = min_width(voice);
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
    var length = loop_duration(voice);
    if (length > 0) waveRanges[voice - 1] = [Math.min(start, end) / length * 100,
                                            Math.max(start, end) / length * 100];
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

function output_split_done(success, message) {
    host.patcher.getnamed("recorder").subpatcher().getnamed("rec_controller").message("split_done", success, message);
}
