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
var nativeElapsedMs = null;
var normalStatusColor = null;
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
    var recording = state === "recording";
    send("record_button", "active", dspOn && state === "idle" ? 1 : 0);
    send("stop_button", "active", state === "starting" || recording ? 1 : 0);
    if (recording && normalStatusColor === null) {
        normalStatusColor = host.patcher.getnamed("record_status").getattr("textcolor");
        send("record_status", "bgcolor", 0.64, 0.10, 0.16, 1);
        send("record_status", "textcolor", 1, 1, 1, 1);
    } else if (!recording && normalStatusColor !== null) {
        send("record_status", "bgcolor", 0, 0, 0, 0);
        send.apply(null, ["record_status", "textcolor"].concat(normalStatusColor));
        normalStatusColor = null;
    }
    send("record_status", "set", status);
    var currentPath = path || lastSavedPath;
    if (currentPath) {
        var name = (path ? "" : "Last saved: ") + currentPath.replace(/^.*[\\/]/, "");
        send("record_file", "set", name.length > 56 ? name.slice(0, 48) + "…" + name.slice(-7) : name);
        send("record_file", "hint", currentPath);
    } else {
        send("record_file", "set", "");
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
    nativeElapsedMs = null;
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
    if (typeof value !== "number" || !isFinite(value) || value < 0 ||
        (state !== "starting" && state !== "recording")) {
        return;
    }
    // sfrecord~ holds its last elapsed value when stopped. Require two
    // observations from this take before showing the recording indicator.
    var previous = nativeElapsedMs;
    nativeElapsedMs = value;
    if (previous === null || value <= previous || value <= elapsedMs) {
        return;
    }
    elapsedMs = value;
    lastProgressAt = Date.now();
    if (state === "starting") {
        state = "recording";
        status = "● RECORDING";
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
    var file;
    try {
        file = new File(filePath, "read");
        if (!file.isopen) {
            return false;
        }
        // Empty Max WAVs can include a padded header larger than 44 bytes.
        var container = file.readstring(4);
        file.position = 8;
        if ((container !== "RIFF" && container !== "RF64") || file.readstring(4) !== "WAVE") {
            return false;
        }
        file.byteorder = "little";
        var extendedSize = 0;
        var fileSize = file.eof;
        while (file.position + 8 <= fileSize) {
            var chunk = file.readstring(4);
            var size = file.readint32(1)[0] >>> 0;
            var start = file.position;
            if (chunk === "data") {
                var bytes = container === "RF64" && size === 0xffffffff ? extendedSize : size;
                return bytes >= 6 && start + bytes <= fileSize;
            }
            if (start + size + size % 2 > fileSize) {
                return false;
            }
            if (chunk === "ds64" && container === "RF64" && size >= 28) {
                file.position = start + 8;
                var words = file.readint32(2);
                extendedSize = (words[0] >>> 0) + (words[1] >>> 0) * 4294967296;
            }
            file.position = start + size + size % 2;
        }
        return false;
    } catch (error) {
        return false;
    } finally {
        if (file && file.isopen) {
            file.close();
        }
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
        status = endReason ? "Saved partial WAV · " + endReason : "Saved stereo WAV";
    } else {
        status = endReason ? "No WAV saved · " + endReason : "No WAV saved · Check the save folder";
    }
    path = "";
    state = "idle";
    render();
}
finish.local = 1;
