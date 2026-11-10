// Scene clock. The sequencer recalls patterns and leaves loop transport running on stop.
autowatch = 0;
inlets = 1;
outlets = 0;

var STEP_COUNT = 8;
var START_TIMEOUT_MS = 4500;
var START_POLL_MS = 40;
var host = this;
var settings = defaults();
var run = null;
var clock = new Task(tick, host);

function defaults() {
    var steps = [];
    for (var i = 0; i < STEP_COUNT; i++) steps.push({ slot: 0, bars: 4 });
    return { bpm: 120, beats: 4, repeat: 1, steps: steps };
}

function numberIn(value, low, high) {
    return typeof value === "number" && isFinite(value) && value >= low && value <= high;
}

function integerIn(value, low, high) {
    return numberIn(value, low, high) && value === Math.floor(value);
}

function hasFields(value, keys) {
    return value && typeof value === "object" && !Array.isArray(value) &&
        Object.keys(value).length === keys.length && keys.every(function (key) {
            return Object.prototype.hasOwnProperty.call(value, key);
        });
}

function sequence_valid(data) {
    if (!hasFields(data, ["bpm", "beats", "repeat", "steps"]) || !numberIn(data.bpm, 20, 300) ||
        !integerIn(data.beats, 1, 12) || !integerIn(data.repeat, 0, 1) ||
        !Array.isArray(data.steps) || data.steps.length !== STEP_COUNT) return false;
    for (var i = 0; i < STEP_COUNT; i++) {
        var step = data.steps[i];
        if (!hasFields(step, ["slot", "bars"]) || !integerIn(step.slot, 0, STEP_COUNT) ||
            !integerIn(step.bars, 1, 32)) return false;
    }
    return true;
}

function copySettings(data) {
    return {
        bpm: data.bpm, beats: data.beats, repeat: data.repeat,
        steps: data.steps.map(function (step) { return { slot: step.slot, bars: step.bars }; })
    };
}

function sequence_snapshot() {
    return copySettings(settings);
}

function restore_sequence(data) {
    if (data != null && !sequence_valid(data)) return false;
    clock.cancel();
    run = null;
    settings = data == null ? defaults() : copySettings(data);
    loadbang();
    return true;
}

function loadbang() {
    var panel = panelPatcher();
    send(panel, "seq_bpm", "set", settings.bpm);
    send(panel, "seq_beats", "set", settings.beats);
    send(panel, "seq_repeat", "set", settings.repeat);
    settings.steps.forEach(function (step, index) {
        send(panel, "seq_slot_" + index, "set", step.slot);
        send(panel, "seq_bars_" + index, "set", step.bars);
    });
    render(idleStatus());
}

function panelPatcher() {
    var box = host.patcher.getnamed("sequence_panel");
    return box ? box.subpatcher() : null;
}

function send(patcher, name, selector, value) {
    var object = patcher && patcher.getnamed(name);
    if (object) object.message(selector, value);
}

function render(status, now) {
    var panel = panelPatcher();
    send(panel, "seq_status", "set", status);
    send(panel, "seq_start", "active", run ? 0 : 1);
    send(panel, "seq_stop", "active", run ? 1 : 0);
    send(panel, "seq_next", "active", run && run.stepStart !== null ? 1 : 0);
    for (var index = 0; index < STEP_COUNT; index++) {
        var current = run && run.index === index;
        send(panel, "seq_step_label_" + index, "set", (current ? "▶ " : "") + "Step " + (index + 1));
    }
    renderMix(typeof now === "number" ? now : Date.now());
}

function idleStatus() {
    return settings.steps.some(function (step) { return step.slot > 0; }) ?
        "Press Start to play assigned scenes. Empty slots are skipped." :
        "Assign stored patterns to scene steps.";
}

function set_bpm(bpm) {
    if (!numberIn(bpm, 20, 300) || settings.bpm === bpm) return;
    settings.bpm = bpm;
    renderCurrent(Date.now());
}

function set_beats(beats) {
    if (!integerIn(beats, 1, 12) || settings.beats === beats) return;
    settings.beats = beats;
    renderCurrent(Date.now());
}

function set_repeat(repeat) {
    if (!integerIn(repeat, 0, 1) || settings.repeat === repeat) return;
    settings.repeat = repeat;
    refresh_mix();
}

function set_step(index, slot) {
    if (!integerIn(index, 0, STEP_COUNT - 1) || !integerIn(slot, 0, STEP_COUNT) ||
        settings.steps[index].slot === slot) return;
    settings.steps[index].slot = slot;
    sceneEdited();
}

function set_bars(index, bars) {
    if (!integerIn(index, 0, STEP_COUNT - 1) || !integerIn(bars, 1, 32) ||
        settings.steps[index].bars === bars) return;
    settings.steps[index].bars = bars;
    sceneEdited();
}

function sceneEdited() {
    if (run) finish("Sequence edited. Press Start to run it again.");
    else render(idleStatus());
}

function sourceReady(source) {
    return source && source.ready && !source.pendingPath && !source.pendingSet && !source.inputTake;
}

function loopsPlaying(source) {
    return source.playing.some(Boolean);
}

function playableSteps(patterns) {
    var playable = [];
    settings.steps.forEach(function (step, index) {
        if (step.slot && patterns.sequence_has_slot(step.slot)) playable.push(index);
    });
    return playable;
}

function firstPlayableAfter(playable, index) {
    var cursor = 0;
    while (cursor < playable.length && playable[cursor] <= index) cursor++;
    return cursor;
}

function refresh_mix() {
    renderMix(Date.now());
}

function renderMix(now) {
    var patch = host.patcher;
    var patternBox = patch.getnamed("pattern_control");
    var patterns = patternBox && patternBox.js;
    var playable = patterns ? playableSteps(patterns) : [];
    var cursor = run ? firstPlayableAfter(playable, run.index) : 0;
    if (cursor === playable.length && settings.repeat) cursor = 0;
    var upcoming = settings.steps[playable[cursor]];
    var current = run && settings.steps[run.index];
    var queued = run && run.queuedAt !== null;
    var started = run && run.stepStart !== null;
    var toggleLabel = run ? "Stop" : "Start";
    var advanceLabel = queued ? "Queued" : "Next bar";

    send(patch, "mix_scene_current", "set", current ? "Now " + current.slot : "Now —");
    send(patch, "mix_scene_next", "set", upcoming ? "Next " + upcoming.slot : (run ? "End of set" : "Next —"));
    send(patch, "mix_scene_bar", "set", started ? "Bar " + currentBar(now) + "/" + current.bars :
        (run ? "Starting…" : "Bar —"));
    send(patch, "mix_scene_toggle", "text", toggleLabel);
    send(patch, "mix_scene_toggle", "texton", toggleLabel);
    send(patch, "mix_scene_toggle", "active", run || upcoming ? 1 : 0);
    send(patch, "mix_scene_advance", "text", advanceLabel);
    send(patch, "mix_scene_advance", "texton", advanceLabel);
    send(patch, "mix_scene_advance", "active", started && upcoming && !queued ? 1 : 0);
}

function start() {
    if (run) return;
    var source = host.patcher.getnamed("source_control").js;
    var patternBox = host.patcher.getnamed("pattern_control");
    var patterns = patternBox.js;
    if (!sourceReady(source) || patterns.pendingSet || patterns.pendingRecall) {
        render("Wait for the source, recording, or pattern switch to finish.");
        return;
    }
    var playable = playableSteps(patterns);
    if (!playable.length) {
        render("Assign a stored pattern before starting the sequencer.");
        return;
    }

    var now = Date.now();
    run = {
        index: playable[0], bpm: settings.bpm, beats: settings.beats,
        barMs: settings.beats * 60000 / settings.bpm,
        stepStart: loopsPlaying(source) ? now : null, queuedAt: null,
        waitUntil: now + START_TIMEOUT_MS, startRequested: false
    };
    patternBox.message("sequence_recall", settings.steps[run.index].slot);
    if (run && run.stepStart === null) renderCurrent(now);
    tick();
}

function stop() {
    if (run) finish("Sequence stopped. Current loops keep playing.");
}

function toggle() {
    if (run) stop();
    else start();
}

function finish(status) {
    clock.cancel();
    run = null;
    render(status);
}

function stepEnd() {
    return run.stepStart + settings.steps[run.index].bars * run.barMs;
}

function barIndex(now) {
    return Math.max(0, Math.floor((now - run.stepStart) / run.barMs));
}

function currentBar(now) {
    return Math.min(settings.steps[run.index].bars, barIndex(now) + 1);
}

function nextBar(now) {
    return run.stepStart + (barIndex(now) + 1) * run.barMs;
}

function dueAt() {
    return run.queuedAt === null ? stepEnd() : run.queuedAt;
}

function next() {
    if (!run || run.stepStart === null || run.queuedAt !== null) return;
    var now = Date.now();
    if (now >= dueAt()) tick();
    if (!run || run.stepStart === null) return;
    run.queuedAt = Math.min(nextBar(now), stepEnd());
    renderCurrent(now);
    schedule(run.queuedAt);
}

function schedule(at) {
    clock.cancel();
    clock.schedule(Math.max(1, Math.ceil(at - Date.now())));
}

function renderCurrent(now) {
    if (!run) {
        render(idleStatus());
        return;
    }
    var step = settings.steps[run.index];
    var label = "Step " + (run.index + 1) + " · Scene " + step.slot;
    if (run.stepStart === null) {
        render("Waiting for audio… · " + label, now);
        return;
    }
    label += " · Bar " + currentBar(now) + "/" + step.bars;
    label += " · " + run.bpm + " BPM";
    if (run.queuedAt !== null) label += " · Next queued";
    if (settings.bpm !== run.bpm || settings.beats !== run.beats) label += " · Timing next Start";
    render(label, now);
}

function advance(now, boundary, patternBox) {
    var playable = playableSteps(patternBox.js);
    if (!playable.length) {
        finish("No stored patterns remain in this sequence.");
        return;
    }
    var cursor = firstPlayableAfter(playable, run.index);
    if (settings.repeat) {
        var cycleBars = playable.reduce(function (bars, index) {
            return bars + settings.steps[index].bars;
        }, 0);
        var cycleMs = cycleBars * run.barMs;
        boundary += Math.floor((now - boundary) / cycleMs) * cycleMs;
    }

    // A delayed callback resolves the current scene without replaying missed recalls.
    for (var checked = 0; checked <= playable.length; checked++) {
        if (cursor === playable.length) {
            if (!settings.repeat) break;
            cursor = 0;
        }
        var index = playable[cursor++];
        var end = boundary + settings.steps[index].bars * run.barMs;
        if (now < end) {
            run.index = index;
            run.stepStart = boundary;
            run.queuedAt = null;
            patternBox.message("sequence_recall", settings.steps[index].slot);
            return;
        }
        boundary = end;
    }
    finish("Sequence complete. Current loops keep playing.");
}

function tick() {
    if (!run) return;
    var now = Date.now();
    var sourceBox = host.patcher.getnamed("source_control");
    var source = sourceBox.js;
    var patternBox = host.patcher.getnamed("pattern_control");
    if (!sourceReady(source)) {
        finish("Sequence stopped while the source changed.");
        return;
    }
    if (run.stepStart === null) {
        if (!loopsPlaying(source) && !run.startRequested && !patternBox.js.pendingRecall) {
            run.startRequested = true;
            if (!source.queuedWindows) sourceBox.message("play_all");
            if (!run) return;
            now = Date.now();
        }
        if (loopsPlaying(source)) {
            run.stepStart = now;
        } else if ((run.startRequested && source.audioStartFailed) || now >= run.waitUntil) {
            finish("Audio didn’t start. Check Audio Setup…");
            return;
        } else {
            schedule(now + START_POLL_MS);
            return;
        }
    } else if (!loopsPlaying(source)) {
        finish("Sequence stopped with loop playback.");
        return;
    }

    var boundary = dueAt();
    if (now >= boundary) advance(now, boundary, patternBox);
    if (!run) return;
    renderCurrent(now);
    schedule(Math.min(nextBar(now), dueAt()));
}

defaults.local = numberIn.local = integerIn.local = hasFields.local = copySettings.local = 1;
panelPatcher.local = send.local = render.local = idleStatus.local = sceneEdited.local = 1;
sourceReady.local = loopsPlaying.local = playableSteps.local = firstPlayableAfter.local = renderMix.local = finish.local = 1;
stepEnd.local = barIndex.local = currentBar.local = nextBar.local = dueAt.local = schedule.local = 1;
renderCurrent.local = advance.local = tick.local = 1;
