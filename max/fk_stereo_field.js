// Stereo field for Field Kit's four existing mixer strips.
inlets = 1;
outlets = 1;

mgraphics.init();
mgraphics.relative_coords = 0;
mgraphics.autofill = 0;

var palettes = [
    ["202936", "151E2A", "303F51", "F3F7FC", "B6C5D5", "8FB9F0", "365D88"],
    ["1E2C27", "13231E", "2D4439", "F2F9F3", "B5CBC0", "99D4AE", "325E4B"],
    ["30231F", "231914", "46312A", "FCF5EE", "D5BFB1", "F1AB82", "6E4534"]
];
var ink;
var pathColors = ["8FB9F0", "99D4AE", "F4C579", "DAB1F1"].map(rgba);
var showAllPaths = false;

var FRAME_MS = 20;
var RETURN_MS = 100;
var BUTTON_HEIGHT = 25;
var PRESET_COUNT = 4;
var PRESET_TOP = 10;
var PRESET_LEFT = 100;
var PRESET_SLOT_WIDTH = 42;
var PRESET_STORE_LEFT = PRESET_LEFT + PRESET_COUNT * PRESET_SLOT_WIDTH + 8;
var PRESET_STORE_WIDTH = 82;
var LOOP_TABS_TOP = 48;
var READOUT_TOP = 85;
var MOTION_TOP = 139;
var RECORD_LIMIT_MS = 30000;
var presets = { armed: false, active: 0, stored: [false, false, false, false], status: "Shift-click to store" };
var loops = [
    { pan: -45, level: 70, clip: null, playback: null },
    { pan: -15, level: 70, clip: null, playback: null },
    { pan: 15, level: 70, clip: null, playback: null },
    { pan: 45, level: 70, clip: null, playback: null }
];
var selected = 1;
var drag = null;
var armed = 0;
var recording = null;
var sendingLoop = 0;
var clockRunning = false;
var windowConfigured = false;
var windowWidth = 0;
var windowHeight = 0;
var motionClock = new Task(motionFrame, this);
motionClock.interval = FRAME_MS;
var windowClock = new Task(fitWindow, this);
windowClock.interval = 80;
theme(0);

function rgba(hex) {
    var color = parseInt(hex, 16);
    return [(color >> 16) / 255, ((color >> 8) & 255) / 255, (color & 255) / 255, 1];
}

function theme(index) {
    if (index !== Math.floor(index) || index < 0 || index >= palettes.length) return;
    var palette = palettes[index].map(rgba);
    ink = {
        background: palette[0], field: palette[1], button: palette[2],
        text: palette[3], muted: palette[4], accent: palette[5], axis: palette[6], record: rgba("FFAB9E")
    };
    ink.trail = ink.accent.slice();
    ink.trail[3] = 0.65;
    mgraphics.redraw();
}

function validLoop(loop) {
    return loop >= 1 && loop <= loops.length && loop === Math.floor(loop);
}

function clamp(value, minimum, maximum) {
    return Math.min(maximum, Math.max(minimum, value));
}

function source(loop, pan, level) {
    if (!validLoop(loop) || !isFinite(pan) || !isFinite(level)) return;
    var point = loops[loop - 1];
    pan = clamp(pan, -100, 100);
    level = clamp(level, 0, 100);
    if (point.pan === pan && point.level === level) return;
    if (sendingLoop !== loop && point.playback) {
        point.playback = null;
        syncClock();
    }
    point.pan = pan;
    point.level = level;
    mgraphics.redraw();
}

function select(loop) {
    if (!validLoop(loop) || loop === selected) return;
    if (armed && armed !== loop) armed = 0;
    selected = loop;
    mgraphics.redraw();
}

function toggle_paths() {
    showAllPaths = !showAllPaths;
    var button = patcher.getnamed("stereo_field_paths");
    var caption = showAllPaths ? "Show selected path" : "Show all paths";
    button.message("text", caption);
    button.message("texton", caption);
    mgraphics.redraw();
}

function field_presets(armed, active, stored1, stored2, stored3, stored4, status) {
    presets.armed = armed === 1;
    presets.active = active;
    presets.stored = [stored1 === 1, stored2 === 1, stored3 === 1, stored4 === 1];
    presets.status = status || "Shift-click to store";
    mgraphics.redraw();
}

function window_active(active) {
    windowClock.cancel();
    if (!active) return;
    if (!windowConfigured) {
        var controller = patcher.getnamed("stereo_field_thispatcher");
        if (controller && controller.valid) {
            windowConfigured = true;
            controller.message("window", "constrain", 540, 458, 4096, 4096);
            controller.message("window", "exec");
        }
    }
    fitWindow();
    windowClock.repeat();
}

function fitWindow() {
    var wind = patcher.wind;
    if (!wind) return;
    var size = wind.size;
    var width = Math.floor(size[0]);
    var height = Math.floor(size[1]);
    if (width <= 24 || height <= 80 || (width === windowWidth && height === windowHeight)) return;
    windowWidth = width;
    windowHeight = height;

    // jsui needs matching patching and presentation sizes for hit testing.
    var dirty = wind.dirty;
    var canvas = [12, 44, width - 24, height - 80];
    box.setboxattr("patching_rect", canvas);
    box.setboxattr("presentation_rect", canvas);
    var paths = patcher.getnamed("stereo_field_paths");
    if (paths && paths.valid) paths.setboxattr("presentation_rect", [width - 234, 11, 136, 23]);
    var close = patcher.getnamed("stereo_field_close");
    if (close && close.valid) close.setboxattr("presentation_rect", [width - 90, 11, 78, 23]);
    wind.dirty = dirty;
}

function bounds() {
    var size = mgraphics.size;
    var width = size && size[0] ? size[0] : box.rect[2] - box.rect[0];
    var height = size && size[1] ? size[1] : box.rect[3] - box.rect[1];
    return {
        width: width, height: height,
        left: 64, right: Math.max(65, width - 24),
        top: 189, bottom: Math.max(190, height - 49),
        tabLeft: 14, tabWidth: (width - 28) / loops.length,
        motionWidth: (width - 28) / 5.5,
        markerRadius: clamp(11 + (Math.min(width, height) - 346) / 50, 11, 16)
    };
}

function trackPosition(point, grid) {
    return [
        grid.left + (point.pan + 100) * (grid.right - grid.left) / 200,
        grid.bottom - point.level * (grid.bottom - grid.top) / 100
    ];
}

function colour(value) {
    mgraphics.set_source_rgba(value[0], value[1], value[2], value[3]);
}

function label(text, x, y, value, centered) {
    colour(value);
    if (centered) x -= mgraphics.text_measure(text)[0] / 2;
    mgraphics.move_to(x, y);
    mgraphics.show_text(text);
}

function rectangle(x, y, width, height, value) {
    colour(value);
    mgraphics.rectangle(x, y, width, height);
    mgraphics.fill();
}

function rule(x1, y1, x2, y2, value) {
    colour(value);
    mgraphics.set_line_width(1);
    mgraphics.move_to(x1, y1);
    mgraphics.line_to(x2, y2);
    mgraphics.stroke();
}

function loopColor(loop) {
    if (recording && recording.loop === loop) return ink.record;
    return showAllPaths ? pathColors[loop - 1] : ink.accent;
}

function marker(loop, grid) {
    var track = loops[loop - 1];
    var point = trackPosition(track, grid);
    var active = loop === selected;
    var radius = grid.markerRadius - (active ? 0 : 2);
    var accent = loopColor(loop);
    mgraphics.ellipse(point[0] - radius, point[1] - radius, radius * 2, radius * 2);
    colour(active ? accent : ink.field);
    mgraphics.fill_preserve();
    colour(accent);
    mgraphics.set_line_width(1);
    mgraphics.stroke();
    label(String(loop), point[0], point[1] + 3.5, active ? ink.field : accent, true);
}

function paintPresets(grid) {
    var baseline = PRESET_TOP + 16;
    label("Field presets", grid.tabLeft, baseline, ink.text);
    for (var index = 0; index < PRESET_COUNT; index++) {
        var x = PRESET_LEFT + index * PRESET_SLOT_WIDTH;
        var active = presets.active === index + 1;
        var available = presets.armed || presets.stored[index];
        var background = active ? ink.accent : available ? ink.button : ink.field;
        var foreground = active ? ink.field : available ? ink.text : ink.muted;
        var text = String(index + 1) + (presets.stored[index] ? "  •" : "");
        rectangle(x + 1, PRESET_TOP, PRESET_SLOT_WIDTH - 2, BUTTON_HEIGHT, background);
        label(text, x + PRESET_SLOT_WIDTH / 2, baseline, foreground, true);
    }
    rectangle(PRESET_STORE_LEFT, PRESET_TOP, PRESET_STORE_WIDTH, BUTTON_HEIGHT, presets.armed ? ink.accent : ink.button);
    label(presets.armed ? "Cancel" : "Store preset", PRESET_STORE_LEFT + PRESET_STORE_WIDTH / 2, baseline,
          presets.armed ? ink.field : ink.text, true);
    mgraphics.set_font_size(10);
    label(presets.status, PRESET_STORE_LEFT + PRESET_STORE_WIDTH + 10, baseline, ink.muted);
    mgraphics.set_font_size(11);
}

function motionControls() {
    var track = loops[selected - 1];
    var ready = armed === selected;
    var capturing = !!recording;
    var hasClips = loops.some(function (loop) { return !!loop.clip; });
    var allPlaying = hasClips && loops.every(function (loop) { return !loop.clip || !!loop.playback; });
    return [
        { text: capturing ? "■ Finish" : ready ? "Cancel" : "● Record", active: ready || capturing,
            enabled: true, action: recordMotion },
        { text: track.playback ? "■ Stop" : "▶ Play", active: !!track.playback,
            enabled: !!track.clip && !ready && !capturing, action: togglePlayback },
        { text: "Clear", enabled: !!track.clip && !ready && !capturing, action: clearMotion },
        { text: allPlaying ? "■ Stop paths" : "▶ Play paths", active: allPlaying,
            enabled: hasClips && !ready && !capturing, action: allPlaying ? stop_motion : playAllMotion }
    ];
}

function paintMotion(grid) {
    var controls = motionControls();
    for (var index = 0; index < controls.length; index++) {
        var control = controls[index];
        var x = grid.tabLeft + grid.motionWidth * index;
        var activeInk = index === 0 ? ink.record : ink.accent;
        var background = control.active ? activeInk : control.enabled ? ink.button : ink.field;
        var foreground = control.active ? ink.field : control.enabled ? ink.text : ink.muted;
        rectangle(x + 1, MOTION_TOP, grid.motionWidth - 2, BUTTON_HEIGHT, background);
        label(control.text, x + grid.motionWidth / 2, MOTION_TOP + 16, foreground, true);
    }
    var track = loops[selected - 1];
    var caption = "No recording";
    if (recording) caption = recording.loop === selected ? "Finish to loop" : "Recording Loop " + recording.loop;
    else if (armed === selected) caption = "Drag Loop " + selected;
    else if (track.clip) caption = track.clip.duration < 100 ? "<0.1 s" : (track.clip.duration / 1000).toFixed(1) + " s";
    label(caption, grid.tabLeft + controls.length * grid.motionWidth + 8, MOTION_TOP + 16, ink.muted);
}

function paintTrail(loop, grid) {
    var track = loops[loop - 1];
    var capture = recording && recording.loop === loop ? recording : track.clip;
    if (!capture || capture.samples.length < 2) return;
    var samples = capture.samples;
    var first = trackPosition(samples[0], grid);
    var lastIndex = samples.length - 1;
    var stride = Math.ceil(lastIndex / 240);
    var focused = loop === selected;
    var trail = showAllPaths ? loopColor(loop).slice() : ink.trail;
    if (showAllPaths) trail[3] = focused ? 0.95 : 0.62;
    colour(trail);
    mgraphics.set_line_width(showAllPaths && focused ? 2.5 : 1.5);
    mgraphics.move_to(first[0], first[1]);
    for (var index = stride; index < lastIndex; index += stride) {
        var point = trackPosition(samples[index], grid);
        mgraphics.line_to(point[0], point[1]);
    }
    var last = trackPosition(samples[lastIndex], grid);
    mgraphics.line_to(last[0], last[1]);
    mgraphics.stroke();
}

function readout(heading, value, x, width) {
    rectangle(x, READOUT_TOP, width, 44, ink.field);
    mgraphics.set_font_size(10);
    label(heading, x + 12, READOUT_TOP + 16, ink.muted);
    mgraphics.set_font_size(16);
    label(value, x + 12, READOUT_TOP + 35, ink.text);
}

function percent(value) {
    return String(Math.round(value * 10) / 10) + "%";
}

function paint() {
    var grid = bounds();
    rectangle(0, 0, grid.width, grid.height, ink.background);
    mgraphics.select_font_face("Arial");
    mgraphics.set_font_size(11);
    paintPresets(grid);

    for (var loop = 1; loop <= loops.length; loop++) {
        var x = grid.tabLeft + grid.tabWidth * (loop - 1);
        var active = loop === selected;
        var track = loops[loop - 1];
        var accent = showAllPaths ? loopColor(loop) : ink.accent;
        rectangle(x + 1, LOOP_TABS_TOP, grid.tabWidth - 2, BUTTON_HEIGHT, active ? accent : ink.button);
        var status = track.playback ? "  ▶" : track.clip ? "  •" : "";
        var labelColor = active ? ink.field : showAllPaths && track.clip ? accent : ink.text;
        label("Loop " + loop + status, x + grid.tabWidth / 2, LOOP_TABS_TOP + 16, labelColor, true);
    }

    var track = loops[selected - 1];
    var pan = Math.round(track.pan * 10) / 10;
    var panText = pan === 0 ? "Center" : (pan < 0 ? "Left " : "Right ") + percent(Math.abs(pan));
    var readoutWidth = 2 * grid.tabWidth - 4;
    readout("X · PAN", panText, grid.tabLeft, readoutWidth);
    readout("Y · LEVEL", percent(track.level), grid.tabLeft + readoutWidth + 8, readoutWidth);

    mgraphics.set_font_size(11);
    paintMotion(grid);

    rectangle(grid.left, grid.top, grid.right - grid.left, grid.bottom - grid.top, ink.field);
    for (var step = 0; step <= 4; step++) {
        var xLine = grid.left + (grid.right - grid.left) * step / 4;
        var yLine = grid.top + (grid.bottom - grid.top) * step / 4;
        rule(xLine, grid.top, xLine, grid.bottom, step === 2 ? ink.axis : ink.button);
        rule(grid.left, yLine, grid.right, yLine, ink.button);
    }
    var centerX = (grid.left + grid.right) / 2;
    var centerY = (grid.top + grid.bottom) / 2;
    mgraphics.set_font_size(11);
    label("100%", 14, grid.top + 4, ink.muted);
    label("Y · Level", 14, centerY + 4, ink.text);
    label("0%", 14, grid.bottom + 4, ink.muted);
    label("Left", grid.left, grid.bottom + 19, ink.muted, true);
    label("Center", centerX, grid.bottom + 19, ink.muted, true);
    label("Right", grid.right, grid.bottom + 19, ink.muted, true);
    label("X · Pan", centerX, grid.bottom + 36, ink.text, true);

    if (showAllPaths) {
        for (var pathLoop = 1; pathLoop <= loops.length; pathLoop++) {
            if (pathLoop !== selected) paintTrail(pathLoop, grid);
        }
    }
    paintTrail(selected, grid);
    for (var other = 1; other <= loops.length; other++) {
        if (other !== selected) marker(other, grid);
    }
    marker(selected, grid);
}

function nearLoop(loop, x, y, grid) {
    var point = trackPosition(loops[loop - 1], grid);
    var dx = point[0] - x;
    var dy = point[1] - y;
    var hitRadius = grid.markerRadius + 3;
    return dx * dx + dy * dy <= hitRadius * hitRadius;
}

function syncClock() {
    var needed = !!recording || loops.some(function (track) { return !!track.playback; });
    if (needed === clockRunning) return;
    clockRunning = needed;
    if (needed) motionClock.repeat();
    else motionClock.cancel();
}

function recordMotion() {
    if (recording) {
        finishRecording(Date.now());
        return;
    }
    armed = armed === selected ? 0 : selected;
    loops[selected - 1].playback = null;
    syncClock();
    mgraphics.redraw();
}

function beginRecording(loop) {
    var track = loops[loop - 1];
    armed = 0;
    recording = {
        loop: loop, start: Date.now(), heldUntil: 0,
        samples: [{ time: 0, pan: track.pan, level: track.level }], moved: false
    };
    syncClock();
    mgraphics.redraw();
}

function recordSample(now) {
    var samples = recording.samples;
    var last = samples[samples.length - 1];
    var time = clamp(now - recording.start, recording.heldUntil, RECORD_LIMIT_MS);
    var track = loops[recording.loop - 1];
    if (track.pan !== last.pan || track.level !== last.level) {
        // Retain the end of a hold so replay keeps its stillness before the next move.
        var hold = Math.min(recording.heldUntil, time - 1);
        if (hold > last.time) {
            samples.push({ time: hold, pan: last.pan, level: last.level });
        }
        var point = { time: time, pan: track.pan, level: track.level };
        if (last.time === time) samples[samples.length - 1] = point;
        else samples.push(point);
        recording.moved = true;
    }
    recording.heldUntil = time;
}

function finishRecording(now) {
    if (!recording) return;
    recordSample(now);
    var take = recording;
    recording = null;
    if (take.moved && take.heldUntil > 0) {
        loops[take.loop - 1].clip = { samples: take.samples, duration: take.heldUntil };
        playMotion(take.loop);
        return;
    }
    syncClock();
    mgraphics.redraw();
}

function playMotion(loop, start) {
    var track = loops[(loop || selected) - 1];
    if (!track.clip || track.playback) return;
    armed = 0;
    track.playback = { start: start === undefined ? Date.now() : start, from: { pan: track.pan, level: track.level } };
    syncClock();
    mgraphics.redraw();
}

function playAllMotion() {
    var start = Date.now();
    loops.forEach(function (track, index) {
        playMotion(index + 1, start);
    });
}

function togglePlayback() {
    var track = loops[selected - 1];
    if (!track.playback) {
        playMotion(selected);
        return;
    }
    track.playback = null;
    syncClock();
    mgraphics.redraw();
}

function clearMotion() {
    var track = loops[selected - 1];
    track.playback = null;
    track.clip = null;
    syncClock();
    mgraphics.redraw();
}

function stop_motion() {
    armed = 0;
    recording = null;
    drag = null;
    loops.forEach(function (track) { track.playback = null; });
    syncClock();
    mgraphics.redraw();
}

function gesture_snapshot() {
    return loops.map(function (track) { return track.clip; });
}

function gesture_restore(saved) {
    stop_motion();
    loops.forEach(function (track, index) {
        track.clip = saved ? saved[index] : null;
    });
    mgraphics.redraw();
}

function interpolate(first, second, fraction) {
    return {
        pan: first.pan + (second.pan - first.pan) * fraction,
        level: first.level + (second.level - first.level) * fraction
    };
}

function pointAt(clip, time) {
    var samples = clip.samples;
    var last = samples[samples.length - 1];
    if (time >= clip.duration) {
        return interpolate(last, samples[0], (time - clip.duration) / RETURN_MS);
    }
    if (time >= last.time) return last;

    var low = 0;
    var high = samples.length - 1;
    while (high - low > 1) {
        var middle = Math.floor((low + high) / 2);
        if (samples[middle].time <= time) low = middle;
        else high = middle;
    }
    var before = samples[low];
    var after = samples[high];
    return interpolate(before, after, (time - before.time) / (after.time - before.time));
}

function motionFrame() {
    var now = Date.now();
    if (recording) {
        if (now - recording.start >= RECORD_LIMIT_MS) finishRecording(now);
        else recordSample(now);
    }
    for (var index = 0; index < loops.length; index++) {
        var track = loops[index];
        var playing = track.playback;
        if (!playing) continue;
        var elapsed = Math.max(0, now - playing.start);
        var point = elapsed < RETURN_MS ?
            interpolate(playing.from, track.clip.samples[0], elapsed / RETURN_MS) :
            pointAt(track.clip, (elapsed - RETURN_MS) % (track.clip.duration + RETURN_MS));
        publishPosition(index + 1, point.pan, point.level);
    }
}

function publishPosition(loop, pan, level) {
    pan = Math.round(pan * 10) / 10;
    level = Math.round(level * 10) / 10;
    var track = loops[loop - 1];
    if (track.pan === pan && track.level === level) return;
    var previous = sendingLoop;
    sendingLoop = loop;
    try {
        source(loop, pan, level);
        outlet(0, "position", loop, pan, level);
    } finally {
        sendingLoop = previous;
    }
}

function onclick(x, y, button, mod1, shift) {
    var grid = bounds();
    drag = null;
    if (y >= PRESET_TOP && y < PRESET_TOP + BUTTON_HEIGHT) {
        if (x >= PRESET_LEFT && x < PRESET_LEFT + PRESET_COUNT * PRESET_SLOT_WIDTH) {
            outlet(0, "field_preset_slot", 1 + Math.floor((x - PRESET_LEFT) / PRESET_SLOT_WIDTH), shift ? 1 : 0);
        } else if (x >= PRESET_STORE_LEFT && x < PRESET_STORE_LEFT + PRESET_STORE_WIDTH) {
            outlet(0, "field_preset_arm");
        }
        return;
    }
    if (y >= LOOP_TABS_TOP && y < LOOP_TABS_TOP + BUTTON_HEIGHT && x >= grid.tabLeft && x < grid.width - grid.tabLeft) {
        select(1 + Math.floor((x - grid.tabLeft) / grid.tabWidth));
        outlet(0, "select", selected);
        return;
    }
    if (y >= MOTION_TOP && y < MOTION_TOP + BUTTON_HEIGHT && x >= grid.tabLeft) {
        var control = motionControls()[Math.floor((x - grid.tabLeft) / grid.motionWidth)];
        if (control && control.enabled) control.action();
        return;
    }

    var loop = selected;
    if (!nearLoop(loop, x, y, grid)) {
        for (loop = loops.length; loop > 0; loop--) {
            if (nearLoop(loop, x, y, grid)) break;
        }
    }
    if (loop === 0) return;

    select(loop);
    var track = loops[loop - 1];
    track.playback = null;
    drag = {
        loop: loop, x: x, y: y, last: 0,
        pan: track.pan, level: track.level
    };
    if (armed === loop) beginRecording(loop);
    else syncClock();
    mgraphics.redraw();
    outlet(0, "select", loop);
}

function moveLoop(x, y, force) {
    if (!drag) return;
    var now = Date.now();
    if (!force && now - drag.last < FRAME_MS) return;
    var grid = bounds();
    var pan = clamp(drag.pan + 200 * (x - drag.x) / (grid.right - grid.left), -100, 100);
    var level = clamp(drag.level - 100 * (y - drag.y) / (grid.bottom - grid.top), 0, 100);
    drag.last = now;
    publishPosition(drag.loop, pan, level);
    if (recording && recording.loop === drag.loop) recordSample(now);
}

function ondrag(x, y, button) {
    if (button) moveLoop(x, y, false);
    else onmouseup(x, y);
}

function onmouseup(x, y) {
    moveLoop(x, y, true);
    drag = null;
}

function onresize() {
    mgraphics.redraw();
}

validLoop.local = clamp.local = bounds.local = trackPosition.local = 1;
fitWindow.local = 1;
colour.local = label.local = rectangle.local = rule.local = marker.local = 1;
nearLoop.local = moveLoop.local = loopColor.local = 1;
rgba.local = readout.local = percent.local = 1;
motionControls.local = paintMotion.local = paintTrail.local = paintPresets.local = 1;
syncClock.local = recordMotion.local = beginRecording.local = recordSample.local = 1;
finishRecording.local = playMotion.local = playAllMotion.local = togglePlayback.local = clearMotion.local = 1;
interpolate.local = pointAt.local = motionFrame.local = publishPosition.local = 1;
