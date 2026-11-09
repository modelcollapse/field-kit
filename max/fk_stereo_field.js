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

var FRAME_MS = 20;
var RETURN_MS = 100;
var MOTION_TOP = 101;
var MOTION_HEIGHT = 25;
var RECORD_LIMIT_MS = 30000;
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
var motionClock = new Task(motionFrame, this);
motionClock.interval = FRAME_MS;
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

function bounds() {
    var size = mgraphics.size;
    var width = size && size[0] ? size[0] : box.rect[2] - box.rect[0];
    var height = size && size[1] ? size[1] : box.rect[3] - box.rect[1];
    return {
        width: width, height: height,
        left: 64, right: Math.max(65, width - 24),
        top: 151, bottom: Math.max(152, height - 49),
        tabLeft: 14, tabWidth: (width - 28) / loops.length,
        motionWidth: (width - 28) / 5.2
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

function marker(loop, grid) {
    var track = loops[loop - 1];
    var point = trackPosition(track, grid);
    var active = loop === selected;
    var radius = active ? 11 : 9;
    var accent = recording && recording.loop === loop ? ink.record : ink.accent;
    mgraphics.ellipse(point[0] - radius, point[1] - radius, radius * 2, radius * 2);
    colour(active ? accent : ink.field);
    mgraphics.fill_preserve();
    colour(accent);
    mgraphics.set_line_width(1);
    mgraphics.stroke();
    label(String(loop), point[0], point[1] + 3.5, active ? ink.field : accent, true);
}

function motionControls() {
    var track = loops[selected - 1];
    var ready = armed === selected;
    var capturing = recording && recording.loop === selected;
    return [
        { text: capturing ? "Recording" : ready ? "Armed" : "Record", active: ready || capturing,
            enabled: !capturing, action: armMotion },
        { text: "Play", active: !!track.playback, enabled: !!track.clip && !capturing, action: playMotion },
        { text: "Stop", enabled: ready || capturing || !!track.playback, action: stopSelected },
        { text: "Clear", enabled: !!track.clip && !capturing, action: clearMotion }
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
        rectangle(x + 1, MOTION_TOP, grid.motionWidth - 2, MOTION_HEIGHT, background);
        label(control.text, x + grid.motionWidth / 2, MOTION_TOP + 16, foreground, true);
    }
    var track = loops[selected - 1];
    var caption = "No recording";
    if (recording && recording.loop === selected) caption = "Release to save";
    else if (armed === selected) caption = "Drag Loop " + selected;
    else if (track.clip) caption = track.clip.duration < 100 ? "<0.1 s" : (track.clip.duration / 1000).toFixed(1) + " s";
    label(caption, grid.tabLeft + controls.length * grid.motionWidth + 8, MOTION_TOP + 16, ink.muted);
}

function paintTrail(grid) {
    var track = loops[selected - 1];
    var capture = recording && recording.loop === selected ? recording : track.clip;
    if (!capture || capture.samples.length < 2) return;
    var samples = capture.samples;
    var first = trackPosition(samples[0], grid);
    var lastIndex = samples.length - 1;
    var stride = Math.ceil(lastIndex / 240);
    colour(ink.trail);
    mgraphics.set_line_width(1.5);
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
    rectangle(x, 47, width, 44, ink.field);
    mgraphics.set_font_size(10);
    label(heading, x + 12, 63, ink.muted);
    mgraphics.set_font_size(16);
    label(value, x + 12, 82, ink.text);
}

function percent(value) {
    return String(Math.round(value * 10) / 10) + "%";
}

function paint() {
    var grid = bounds();
    rectangle(0, 0, grid.width, grid.height, ink.background);
    mgraphics.select_font_face("Arial");
    mgraphics.set_font_size(11);

    for (var loop = 1; loop <= loops.length; loop++) {
        var x = grid.tabLeft + grid.tabWidth * (loop - 1);
        var active = loop === selected;
        rectangle(x + 1, 10, grid.tabWidth - 2, 25, active ? ink.accent : ink.button);
        var track = loops[loop - 1];
        var status = track.playback ? "  ▶" : track.clip ? "  •" : "";
        label("Loop " + loop + status, x + grid.tabWidth / 2, 26, active ? ink.field : ink.text, true);
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

    paintTrail(grid);
    for (var other = 1; other <= loops.length; other++) {
        if (other !== selected) marker(other, grid);
    }
    marker(selected, grid);
}

function nearLoop(loop, x, y, grid) {
    var point = trackPosition(loops[loop - 1], grid);
    var dx = point[0] - x;
    var dy = point[1] - y;
    return dx * dx + dy * dy <= 14 * 14;
}

function syncClock() {
    var needed = !!recording || loops.some(function (track) { return !!track.playback; });
    if (needed === clockRunning) return;
    clockRunning = needed;
    if (needed) motionClock.repeat();
    else motionClock.cancel();
}

function armMotion() {
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
    }
    syncClock();
    mgraphics.redraw();
}

function playMotion() {
    var track = loops[selected - 1];
    if (!track.clip || track.playback) return;
    armed = 0;
    track.playback = { start: Date.now(), from: { pan: track.pan, level: track.level } };
    syncClock();
    mgraphics.redraw();
}

function stopSelected() {
    if (armed === selected) armed = 0;
    if (recording && recording.loop === selected) finishRecording(Date.now());
    loops[selected - 1].playback = null;
    syncClock();
    mgraphics.redraw();
}

function clearMotion() {
    stopSelected();
    loops[selected - 1].clip = null;
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

function onclick(x, y) {
    var grid = bounds();
    drag = null;
    if (y >= 10 && y <= 35 && x >= grid.tabLeft && x < grid.width - grid.tabLeft) {
        select(1 + Math.floor((x - grid.tabLeft) / grid.tabWidth));
        outlet(0, "select", selected);
        return;
    }
    if (y >= MOTION_TOP && y <= MOTION_TOP + MOTION_HEIGHT && x >= grid.tabLeft) {
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
    if (drag && recording && recording.loop === drag.loop) finishRecording(Date.now());
    drag = null;
}

function onresize() {
    mgraphics.redraw();
}

validLoop.local = clamp.local = bounds.local = trackPosition.local = 1;
colour.local = label.local = rectangle.local = rule.local = marker.local = 1;
nearLoop.local = moveLoop.local = 1;
rgba.local = readout.local = percent.local = 1;
motionControls.local = paintMotion.local = paintTrail.local = 1;
syncClock.local = armMotion.local = beginRecording.local = recordSample.local = 1;
finishRecording.local = playMotion.local = stopSelected.local = clearMotion.local = 1;
interpolate.local = pointAt.local = motionFrame.local = publishPosition.local = 1;
