// Sets the mix-effect dials. LFO modulation is applied separately in the effects patch.
inlets = 1;
outlets = 1;

mgraphics.init();
mgraphics.relative_coords = 0;
mgraphics.autofill = 0;

var palettes = [
    { canvas: "141A23", inset: "151E2A", grid: "303F51", ink: "F3F7FC", muted: "B6C5D5", accent: "8FB9F0" },
    { canvas: "131E1B", inset: "13231E", grid: "2D4439", ink: "F2F9F3", muted: "B5CBC0", accent: "99D4AE" },
    { canvas: "211915", inset: "231914", grid: "46312A", ink: "FCF5EE", muted: "D5BFB1", accent: "F1AB82" }
];
var colors = palettes[0];
var targets = [
    { name: "Tone tilt", selector: "tone", min: -100, max: 100, value: 0 },
    { name: "Echo mix", selector: "echo", min: 0, max: 100, value: 20 },
    { name: "Room mix", selector: "space", min: 0, max: 100, value: 18 }
];
var axes = [1, 2];
var fxOn = false;
var enableButton = [238, 13, 104, 25];
var dragging = false;
var publishing = false;
var armed = false;
var recording = null;
var clip = null;
var playback = null;
var FRAME_MS = 20;
var RETURN_MS = 100;
var RECORD_LIMIT_MS = 30000;
var motionClock = new Task(motionFrame, this);
motionClock.interval = FRAME_MS;

function clamp(target, value) {
    return Math.max(target.min, Math.min(target.max, value));
}

function source(tone, echo, space) {
    if (!isFinite(tone) || !isFinite(echo) || !isFinite(space)) return;
    var incoming = [tone, echo, space];
    var changed = false;
    var assignedChanged = false;
    targets.forEach(function (target, index) {
        var value = clamp(target, incoming[index]);
        if (target.value !== value) {
            target.value = value;
            changed = true;
            if (index === axes[0] || index === axes[1]) assignedChanged = true;
        }
    });
    if (!publishing && assignedChanged && (playback || recording)) stop_motion();
    if (changed) mgraphics.redraw();
}

function assign(axis, index) {
    if ((axis !== 0 && axis !== 1) || index !== Math.floor(index) || index < 0 || index >= targets.length) return;
    if (axes[axis] === index) return;
    stop_motion();
    var other = 1 - axis;
    if (axes[other] === index) axes[other] = axes[axis];
    axes[axis] = index;
    publishMenus();
    mgraphics.redraw();
}

function publishMenus() {
    outlet(0, "xmenu", axes[0]);
    outlet(0, "ymenu", axes[1]);
}

function enabled(value) {
    var active = value === 1;
    if (fxOn === active) return;
    fxOn = active;
    mgraphics.redraw();
}

function theme(index) {
    if (index < 0 || index >= palettes.length || index % 1 !== 0) return;
    colors = palettes[index];
    mgraphics.redraw();
}

function bounds() {
    var size = mgraphics.size;
    return {
        width: size[0], height: size[1], left: 62, top: 134,
        right: Math.max(63, size[0] - 24), bottom: Math.max(135, size[1] - 74),
        buttonLeft: 24, buttonTop: 84, buttonHeight: 25,
        buttonPitch: (size[0] - 40) / 4, buttonGap: 8
    };
}

function color(value) {
    var rgb = parseInt(value, 16);
    mgraphics.set_source_rgba((rgb >> 16) / 255, ((rgb >> 8) & 255) / 255, (rgb & 255) / 255, 1);
}

function rectangle(x, y, width, height, value) {
    color(value);
    mgraphics.rectangle(x, y, width, height);
    mgraphics.fill();
}

function rule(x1, y1, x2, y2, value) {
    color(value);
    mgraphics.set_line_width(1);
    mgraphics.move_to(x1, y1);
    mgraphics.line_to(x2, y2);
    mgraphics.stroke();
}

function label(text, x, y, value) {
    color(value);
    mgraphics.move_to(x, y);
    mgraphics.show_text(text);
}

function formatValue(target, value) {
    var rounded = Math.round(value * 10) / 10;
    if (target.selector !== "tone") return rounded + "%";
    if (rounded === 0) return "Neutral";
    return (rounded < 0 ? "−" : "+") + Math.abs(rounded);
}

function motionControls() {
    return [
        { text: recording ? "Recording" : armed ? "Armed" : "Record", enabled: !recording,
          color: armed || recording ? "FFAB9E" : null, action: record_motion },
        { text: "Play", enabled: !!clip && !recording && !playback,
          color: playback ? colors.accent : null, action: play_motion },
        { text: "Stop", enabled: !!(armed || recording || playback), action: stopGesture },
        { text: "Clear", enabled: !!clip && !recording, action: clear_motion }
    ];
}

function paintMotionControls(grid) {
    var controls = motionControls();
    controls.forEach(function (control, index) {
        var x = grid.buttonLeft + grid.buttonPitch * index;
        var width = grid.buttonPitch - grid.buttonGap;
        var fill = control.color || (control.enabled ? colors.grid : colors.inset);
        var text = control.color ? colors.inset : control.enabled ? colors.ink : colors.muted;
        rectangle(x, grid.buttonTop, width, grid.buttonHeight, fill);
        label(control.text, x + (width - mgraphics.text_measure(control.text)[0]) / 2, grid.buttonTop + 17, text);
    });
}

function paint() {
    var grid = bounds();
    var width = grid.right - grid.left;
    var height = grid.bottom - grid.top;
    var xTarget = targets[axes[0]];
    var yTarget = targets[axes[1]];
    var pointX = grid.left + width * (xTarget.value - xTarget.min) / (xTarget.max - xTarget.min);
    var pointY = grid.bottom - height * (yTarget.value - yTarget.min) / (yTarget.max - yTarget.min);
    rectangle(0, 0, grid.width, grid.height, colors.canvas);

    mgraphics.select_font_face("Arial");
    mgraphics.set_font_size(19);
    label("Effects pad", 24, 33, colors.ink);
    mgraphics.set_font_size(12);
    var fxLabel = fxOn ? "FX on" : "Enable FX";
    rectangle(enableButton[0], enableButton[1], enableButton[2], enableButton[3],
              fxOn ? colors.accent : colors.grid);
    label(fxLabel, enableButton[0] + (enableButton[2] - mgraphics.text_measure(fxLabel)[0]) / 2,
          enableButton[1] + 17, fxOn ? colors.inset : colors.ink);
    label("X", 24, 66, colors.accent);
    label("Y", 218, 66, colors.accent);
    paintMotionControls(grid);

    rectangle(grid.left, grid.top, width, height, colors.inset);
    for (var step = 0; step <= 4; step++) {
        var x = grid.left + width * step / 4;
        var y = grid.top + height * step / 4;
        rule(x, grid.top, x, grid.bottom, colors.grid);
        rule(grid.left, y, grid.right, y, colors.grid);
    }
    rule(grid.left, pointY, grid.right, pointY, colors.accent);
    rule(pointX, grid.top, pointX, grid.bottom, colors.accent);
    color(colors.accent);
    mgraphics.ellipse(pointX - 6, pointY - 6, 12, 12);
    mgraphics.fill();

    label(formatValue(yTarget, yTarget.max), 24, grid.top + 4, colors.muted);
    label(formatValue(yTarget, yTarget.min), 24, grid.bottom + 4, colors.muted);
    var xMax = formatValue(xTarget, xTarget.max);
    label(formatValue(xTarget, xTarget.min), grid.left, grid.bottom + 17, colors.muted);
    label(xMax, grid.right - mgraphics.text_measure(xMax)[0], grid.bottom + 17, colors.muted);
    label("X · " + xTarget.name + "  " + formatValue(xTarget, xTarget.value), 24, grid.height - 34, colors.ink);
    label("Y · " + yTarget.name + "  " + formatValue(yTarget, yTarget.value), 218, grid.height - 34, colors.ink);
    var caption = fxOn ? "Drag to blend the assigned effects. The dials follow."
                      : "Turn on FX above to hear the assigned effects.";
    if (recording) caption = "Release to save motion.";
    else if (armed) caption = "Drag the pad to record motion.";
    else if (clip) {
        var length = clip.duration < 100 ? "<0.1 s" : (clip.duration / 1000).toFixed(1) + " s";
        caption = (playback ? "Looping " : "Recorded motion · ") + length;
    }
    label(caption, 24, grid.height - 12, colors.muted);
}

function moveAxis(target, requested) {
    var value = clamp(target, Math.round(requested));
    if (target.value === value) return false;
    target.value = value;
    outlet(0, target.selector, value);
    return true;
}

function publishPoint(x, y) {
    var changedX, changedY;
    publishing = true;
    try {
        changedX = moveAxis(targets[axes[0]], x);
        changedY = moveAxis(targets[axes[1]], y);
    } finally {
        publishing = false;
    }
    if (changedX || changedY) mgraphics.redraw();
}

function movePad(x, y, grid) {
    var xTarget = targets[axes[0]];
    var yTarget = targets[axes[1]];
    publishPoint(xTarget.min + (xTarget.max - xTarget.min) * (x - grid.left) / (grid.right - grid.left),
                 yTarget.min + (yTarget.max - yTarget.min) * (grid.bottom - y) / (grid.bottom - grid.top));
}

function currentPoint(time) {
    return { time: time, x: targets[axes[0]].value, y: targets[axes[1]].value };
}

function record_motion() {
    if (recording) return;
    var arm = !armed;
    stop_motion();
    armed = arm;
    mgraphics.redraw();
}

function play_motion() {
    if (!clip || recording || playback) return;
    stop_motion();
    axes = clip.axes.slice();
    publishMenus();
    playback = { start: Date.now(), from: currentPoint(0) };
    motionClock.repeat();
    mgraphics.redraw();
}

function stop_motion() {
    var active = armed || recording || playback;
    armed = false;
    recording = null;
    playback = null;
    dragging = false;
    motionClock.cancel();
    if (active) mgraphics.redraw();
}

function stopGesture() {
    if (recording) finishRecording(Date.now());
    stop_motion();
}

function clear_motion() {
    stop_motion();
    clip = null;
    mgraphics.redraw();
}

function sampleRecording(now, force) {
    var samples = recording.samples;
    var last = samples[samples.length - 1];
    var time = Math.min(RECORD_LIMIT_MS, Math.max(last.time, force ? 1 : 0, now - recording.start));
    if (!force && time - last.time < FRAME_MS) return;
    if (last.time === time) samples[samples.length - 1] = currentPoint(time);
    else samples.push(currentPoint(time));
}

function finishRecording(now) {
    sampleRecording(now, true);
    var samples = recording.samples;
    var first = samples[0];
    if (samples.some(function (sample) { return sample.x !== first.x || sample.y !== first.y; })) {
        clip = { axes: recording.axes, samples: samples, duration: samples[samples.length - 1].time };
    }
    recording = null;
    motionClock.cancel();
    mgraphics.redraw();
}

function interpolate(from, to, fraction) {
    return { x: from.x + (to.x - from.x) * fraction, y: from.y + (to.y - from.y) * fraction };
}

function clipPoint(time) {
    var samples = clip.samples;
    var end = samples.length - 1;
    if (time >= clip.duration) return interpolate(samples[end], samples[0], (time - clip.duration) / RETURN_MS);
    var low = 0;
    var high = end;
    while (high - low > 1) {
        var middle = Math.floor((low + high) / 2);
        if (samples[middle].time <= time) low = middle;
        else high = middle;
    }
    var from = samples[low];
    var to = samples[high];
    return interpolate(from, to, (time - from.time) / (to.time - from.time));
}

function motionFrame() {
    var now = Date.now();
    if (recording) {
        if (now - recording.start >= RECORD_LIMIT_MS) finishRecording(now);
        else sampleRecording(now, false);
    }
    if (!playback) return;
    var elapsed = Math.max(0, now - playback.start);
    var point = elapsed < RETURN_MS ? interpolate(playback.from, clip.samples[0], elapsed / RETURN_MS)
        : clipPoint((elapsed - RETURN_MS) % (clip.duration + RETURN_MS));
    publishPoint(point.x, point.y);
}

function onclick(x, y) {
    var grid = bounds();
    if (x >= enableButton[0] && x < enableButton[0] + enableButton[2] &&
        y >= enableButton[1] && y < enableButton[1] + enableButton[3]) {
        outlet(0, "fx_enabled", fxOn ? 0 : 1);
        return;
    }
    if (y >= grid.buttonTop && y < grid.buttonTop + grid.buttonHeight && x >= grid.buttonLeft) {
        var offset = x - grid.buttonLeft;
        var control = motionControls()[Math.floor(offset / grid.buttonPitch)];
        if (control && control.enabled && offset % grid.buttonPitch < grid.buttonPitch - grid.buttonGap) control.action();
        return;
    }
    if (x < grid.left || x > grid.right || y < grid.top || y > grid.bottom) return;
    var capture = armed;
    stop_motion();
    dragging = true;
    movePad(x, y, grid);
    if (capture) {
        recording = { axes: axes.slice(), start: Date.now(), samples: [currentPoint(0)] };
        motionClock.repeat();
        mgraphics.redraw();
    }
}

function ondrag(x, y, button) {
    if (!dragging) return;
    movePad(x, y, bounds());
    if (!button) {
        dragging = false;
        if (recording) finishRecording(Date.now());
    }
}

function onmouseup(x, y) {
    ondrag(x, y, 0);
}

function onresize() {
    mgraphics.redraw();
}

clamp.local = bounds.local = color.local = rectangle.local = rule.local = label.local = 1;
formatValue.local = motionControls.local = paintMotionControls.local = publishMenus.local = stopGesture.local = 1;
moveAxis.local = publishPoint.local = movePad.local = currentPoint.local = 1;
sampleRecording.local = finishRecording.local = interpolate.local = clipPoint.local = motionFrame.local = 1;
