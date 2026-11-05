// Max message-rate adapter. All loop playback, modulation, and mixing run in MSP.
autowatch = 0;
inlets = 1;
outlets = 4;

var WINDOWS = 4;
var ALL_WINDOWS = (1 << WINDOWS) - 1;
var DEFAULT_POSITIONS = [[0, 25], [25, 50], [50, 75], [75, 100]];
var INSPECTOR_FIELDS = ["start", "end", "rate", "direction", "fade", "drive", "filter", "level", "pan"];
var host = this;
var bufferIds = new Global("field_kit_buffer_ids");
var bufferName = "";
var duration = 0;
var pendingPath = "";
var pendingName = "";
var sourceIsDemo = false;
var ready = false;
var audioOn = false;
var audioStarting = false;
var audioStartFailed = false;
var queuedWindows = 0;
var queuedNormal = false;
var normalPlaying = false;
var drawing = false;
var inspectedWindow = 1;
var positions = DEFAULT_POSITIONS.map(function (range) { return range.slice(); });
var playing = [false, false, false, false];
var boot = new Task(boot_source, host);
var read = new Task(read_source, host);
var waitForRead = new Task(read_timeout, host);
var waitForAudio = new Task(audio_timeout, host);
var settleAudio = new Task(audio_settled, host);

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
    bufferName = "field-kit-source-" + bufferIds.last;
    send("buffer", "name", bufferName);
    send("source_info", "set", bufferName);
    send("normal_voice", "set", bufferName);
    for (var index = 1; index <= WINDOWS; index++) {
        send("voice_" + index, "source", bufferName);
        draw_region(index);
    }
    inspect_window(inspectedWindow - 1);
    stop_all();
    load_demo();
}
boot_source.local = 1;

function inspect_window(index) {
    if (typeof index !== "number" || index % 1 !== 0 || index < 0 || index >= WINDOWS) {
        return;
    }
    inspectedWindow = index + 1;
    send("inspector_tabs", "set", index);
    INSPECTOR_FIELDS.forEach(function (key) {
        var control = host.patcher.getnamed(key + "_" + inspectedWindow);
        if (control && control.getvalueof) {
            var value = control.getvalueof();
            inspector_sync(inspectedWindow, key, Array.isArray(value) ? value[0] : value);
        }
    });
}

function inspector_edit(key, value) {
    if (INSPECTOR_FIELDS.indexOf(key) !== -1 && typeof value === "number" && isFinite(value)) {
        send(key + "_" + inspectedWindow, value);
    }
}

function inspector_sync(voice, key, value) {
    if (voice === inspectedWindow && typeof value === "number" && isFinite(value)) {
        send("inspect_" + key, "set", value);
    }
}

function choose() {
    if (bufferName && !pendingPath) {
        send("audio_file", "bang");
    }
}

function load_demo() {
    var file = host.patcher.filepath;
    var folder = file.slice(0, file.lastIndexOf("/") + 1);
    var demo = folder + "fk_demo.wav";
    if (typeof File === "function") {
        var candidates = [demo, folder + "Support/fk_demo.wav"];
        // Standalones resolve bundled media by name inside their collective.
        demo = "fk_demo.wav";
        for (var index = 0; index < candidates.length; index++) {
            var fileOnDisk = new File(candidates[index], "read");
            if (fileOnDisk.isopen) {
                fileOnDisk.close();
                demo = candidates[index];
                break;
            }
        }
    }
    open_source(demo, true);
}

function open_source(path, isDemo) {
    if (!bufferName || pendingPath || typeof path !== "string" || !path.length) {
        return;
    }
    stop_all();
    ready = false;
    duration = 0;
    pendingPath = path;
    sourceIsDemo = !!isDemo;
    pendingName = sourceIsDemo ? "Demo" : path.split("/").pop();
    label("source_label", "Loading " + pendingName + "…");
    update_status();
    // Release the voices before replacing memory under the Gen readers.
    read.schedule(40);
}

function read_source() {
    send("buffer", "replace", pendingPath);
    if (pendingPath) {
        waitForRead.schedule(15000);
    }
}
read_source.local = 1;

function source_loaded(sampleRate) {
    if (!pendingPath) {
        return;
    }
    var buffer = new Buffer(bufferName);
    var frames = buffer.framecount();
    if (!isFinite(sampleRate) || sampleRate <= 0 || !isFinite(frames) || frames < 2) {
        read_timeout();
        return;
    }

    waitForRead.cancel();
    duration = 1000 * frames / sampleRate;
    var channels = buffer.channelcount();
    send("normal_right_channel", channels === 1 ? 1 : 2);
    var name = pendingName;
    pendingPath = "";
    pendingName = "";

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
    label("source_label", name + "   ·   " + (duration / 1000).toFixed(2) + " s   ·   " + format);
    start_queued_playback();
    update_status();
}

function read_timeout() {
    waitForRead.cancel();
    pendingPath = "";
    pendingName = "";
    queuedWindows = 0;
    queuedNormal = false;
    ready = false;
    duration = 0;
    for (var voice = 1; voice <= WINDOWS; voice++) {
        send("wave_" + voice, "set");
    }
    label("source_label", "No source");
    label("status", "Couldn’t load audio. Try another file.");
}
read_timeout.local = 1;

function update_status() {
    var count = playing.filter(function (state) { return state; }).length;
    if (pendingPath) {
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
        label("status", sourceIsDemo ? "Click Play all to hear the demo." : "Ready · Click Play all.");
    } else if (bufferName) {
        label("status", "Choose Load audio… or Load demo.");
    }
}
update_status.local = 1;

function dsp_enabled(state) {
    var wasAudioOn = audioOn;
    audioOn = !!state;
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
    if ((!queuedWindows && !queuedNormal) || !ready || audioStarting) {
        return;
    }
    if (!audioOn) {
        set_audio(1);
        return;
    }
    if (queuedNormal) {
        queuedNormal = false;
        normalPlaying = true;
        select_mix(2);
        send("normal_voice", "start");
        return;
    }
    select_mix(1);
    var windows = queuedWindows;
    queuedWindows = 0;
    for (var voice = 1; voice <= WINDOWS; voice++) {
        if (windows & (1 << (voice - 1))) {
            set_play(voice, true);
        }
    }
}
start_queued_playback.local = 1;

function select_mix(input) {
    send("normal_mix_l", input);
    send("normal_mix_r", input);
}
select_mix.local = 1;

function stop_normal() {
    queuedNormal = false;
    if (normalPlaying) {
        normalPlaying = false;
        select_mix(0);
        send("normal_voice", "stop");
    }
}
stop_normal.local = 1;

function normal_finished() {
    if (normalPlaying) {
        normalPlaying = false;
        select_mix(0);
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
    if (ready || pendingPath) {
        stop_normal();
        queuedWindows = ALL_WINDOWS;
        start_queued_playback();
    }
    update_status();
}

function play_normal() {
    if (!normalPlaying && !queuedNormal && (ready || pendingPath)) {
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

function stop_all() {
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
    var range = positions[voice - 1];
    send("base_start_" + voice, range[0]);
    send("base_end_" + voice, range[1]);
    send("start_" + voice, "set", range[0]);
    send("end_" + voice, "set", range[1]);
    inspector_sync(voice, "start", range[0]);
    inspector_sync(voice, "end", range[1]);
    if (ready) {
        drawing = true;
        outlet(voice - 1, [range[0] * duration * 0.01, range[1] * duration * 0.01]);
        drawing = false;
    }
}
draw_region.local = 1;

function edit_start(voice, value) {
    if (voice >= 1 && voice <= WINDOWS && typeof value === "number" && isFinite(value)) {
        var range = positions[voice - 1];
        range[0] = clip(value, 0, Math.max(0, range[1] - min_width()));
        draw_region(voice);
    }
}

function edit_end(voice, value) {
    if (voice >= 1 && voice <= WINDOWS && typeof value === "number" && isFinite(value)) {
        var range = positions[voice - 1];
        range[1] = clip(value, Math.min(100, range[0] + min_width()), 100);
        draw_region(voice);
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
    positions[voice - 1] = [low, high];
    draw_region(voice);
}

function edit_wave(voice, displayStart, displayLength, start, end) {
    if (drawing || !ready || voice < 1 || voice > WINDOWS || !isFinite(start) || !isFinite(end)) {
        return;
    }
    var low = clip(Math.min(start, end) / duration * 100, 0, 100);
    var high = clip(Math.max(start, end) / duration * 100, 0, 100);
    if (high - low < min_width()) {
        high = Math.min(100, low + min_width());
        low = Math.max(0, high - min_width());
    }
    var range = positions[voice - 1];
    if (Math.abs(range[0] - low) < 0.00001 && Math.abs(range[1] - high) < 0.00001) {
        return;
    }
    positions[voice - 1] = [low, high];
    draw_region(voice);
    if (voice !== inspectedWindow) {
        inspect_window(voice - 1);
    }
}
