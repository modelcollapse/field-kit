autowatch = 0;
inlets = 1;
outlets = 0;

var host = this;
var state = "idle";
var status = "Enable audio to record";
var dspOn = false;
var path = "";
var lastSavedPath = "";
var elapsedMs = 0;
var nativeElapsedMs = 0;
var lastProgressAt = 0;
var endReason = "";
var verifyAttempts = 0;
var watchProgress = new Task(checkProgress, host);
var verifyFile = new Task(finish, host);
watchProgress.interval = 300;

function send(name) {
    var target = host.patcher.getnamed(name);
    if (target) {
        target.message.apply(target, arrayfromargs(arguments).slice(1));
    }
}
send.local = 1;

function pad(number) {
    return number < 10 ? "0" + number : String(number);
}
pad.local = 1;

function renderTime() {
    var tenths = Math.floor(elapsedMs / 100);
    var seconds = Math.floor(tenths / 10);
    var duration = pad(Math.floor(seconds / 60)) + ":" + pad(seconds % 60) + "." + (tenths % 10);
    send("record_time", "set", duration);
}
renderTime.local = 1;

function render() {
    send("record_button", "active", dspOn && state === "idle" ? 1 : 0);
    send("stop_button", "active", state === "starting" || state === "recording" ? 1 : 0);
    send("record_status", "set", status);
    var currentPath = path || lastSavedPath;
    if (currentPath) {
        var name = currentPath.replace(/^.*[\\/]/, "");
        send("record_file", "set", name.length > 56 ? name.slice(0, 48) + "…" + name.slice(-7) : name);
        send("record_file", "hint", currentPath);
    } else {
        send("record_file", "set", "Choose Record… to name your take");
        send("record_file", "hint", "The filename of your current or last take");
    }
    renderTime();
}
render.local = 1;

function idleStatus() {
    if (!dspOn) {
        return "Enable audio to record";
    }
    return lastSavedPath ? "Saved stereo WAV" : "Ready to record";
}
idleStatus.local = 1;

function defaultName() {
    var now = new Date();
    return "Field Kit " + now.getFullYear() + "-" + pad(now.getMonth() + 1) + "-" +
        pad(now.getDate()) + " " + pad(now.getHours()) + pad(now.getMinutes()) +
        pad(now.getSeconds()) + ".wav";
}
defaultName.local = 1;

function dsp_enabled(enabled) {
    dspOn = Boolean(enabled);
    if (!dspOn && (state === "starting" || state === "recording")) {
        stopTake("Audio turned off");
    } else if (state === "idle") {
        status = idleStatus();
        render();
    }
}

function choose() {
    if (!dspOn || state !== "idle") {
        return;
    }
    state = "choosing";
    status = "Choose a location for your take";
    render();
    send("save_dialog", "name", defaultName());
    send("save_dialog", "bang");
}

function cancel() {
    if (state === "choosing") {
        state = "idle";
        status = idleStatus();
        render();
    }
}

function start_path(filePath) {
    if (state !== "idle" && state !== "choosing") {
        return;
    }
    state = "idle";
    if (!dspOn) {
        status = idleStatus();
        render();
        return;
    }
    // Use the exact path that the Save dialog confirmed, including its extension.
    if (typeof filePath !== "string" || !/\.wav$/i.test(filePath) || !/\//.test(filePath)) {
        status = "Choose a filename ending in .wav";
        render();
        return;
    }
    path = filePath;
    elapsedMs = 0;
    lastProgressAt = Date.now();
    state = "starting";
    status = "Starting…";
    render();
    send("writer", "samptype", "int24");
    send("writer", "open", "wave", path);
    send("writer", 1);
    watchProgress.repeat();
}

function elapsed(value) {
    var advancing = value !== nativeElapsedMs && value > 0;
    nativeElapsedMs = value;
    if (!advancing || (state !== "starting" && state !== "recording")) {
        return;
    }
    elapsedMs = value;
    lastProgressAt = Date.now();
    if (state === "starting") {
        state = "recording";
        status = "●  Recording final mix";
        render();
    } else {
        renderTime();
    }
}

function checkProgress() {
    if (Date.now() - lastProgressAt > 1800) {
        stopTake(state === "starting" ? "Couldn’t start recording" : "Recording stopped early");
    }
}
checkProgress.local = 1;

function stop_record() {
    if (state === "starting" || state === "recording") {
        stopTake("");
    }
}

function stopTake(reason) {
    watchProgress.cancel();
    state = "finishing";
    status = "Saving WAV…";
    endReason = reason;
    verifyAttempts = 0;
    send("writer", 0);
    render();
    verifyFile.schedule(150);
}
stopTake.local = 1;

function hasAudio(filePath) {
    try {
        var file = new File(filePath, "read");
        if (!file.isopen) {
            return false;
        }
        var present = file.eof > 44;
        file.close();
        return present;
    } catch (error) {
        return false;
    }
}
hasAudio.local = 1;

function finish() {
    var saved = endReason !== "Couldn’t start recording" && hasAudio(path);
    if (!saved && ++verifyAttempts < 4) {
        verifyFile.schedule(150);
        return;
    }
    if (saved) {
        lastSavedPath = path;
        status = endReason ? "Saved WAV · " + endReason : "Saved stereo WAV";
    } else {
        status = "Couldn’t save audio · Check the save folder";
    }
    path = "";
    state = "idle";
    render();
}
finish.local = 1;
