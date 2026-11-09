// Route amounts and breakpoint curves are edited here. MSP runs the oscillators and mix.
autowatch = 0;
inlets = 1;
outlets = 2;

var WINDOWS = 4;
var DEFAULT_RATES = [0.12, 0.31, 0.73, 0.18, 0.43, 0.67, 1.1, 1.7];
var DEFAULT_SHAPES = [0, 1, 2, 0, 1, 0, 1, 0];
var SHAPE_LABELS = ["Sine", "Triangle", "Saw", "Square", "S&H  ·  example", "Breakpoint curve"];
var BREAKPOINT = 5;
var LFOS = DEFAULT_RATES.length;
var TARGETS = ["Start", "End", "Speed", "Direction", "Crossfade", "Drive", "Filter", "Level", "Pan", "Echo send", "Room send"];
var GLOBAL_TARGETS = [
    "Master", "Input gain", "Tone tilt", "Echo mix", "Echo time", "Echo feedback", "Room mix", "Room decay",
    "Drift mix", "Drift feedback", "Drift blur", "Drift amount", "Drift drive", "Drift dynamics",
    "Drift input trim", "Drift output trim", "Drift width", "Drift pitch", "Drift HPF Hz", "Drift LPF Hz",
    "Drift BPM", "Drift beats/bar"
];
var DRIFT_UNITS = ["%", "%", "%", "%", "%", "%", " dB", " dB", "%", " st", " Hz", " Hz", " BPM", " beats"];
var VOICE_TARGETS = 9;
var MAIN_TARGETS = 8;
var SEND_TARGETS = TARGETS.length - VOICE_TARGETS;
var MAIN_START = WINDOWS * VOICE_TARGETS;
var SEND_START = MAIN_START + MAIN_TARGETS;
var DRIFT_START = SEND_START + WINDOWS * SEND_TARGETS;
var DIRECTIONS = ["Forward", "Reverse", "Ping-pong"];
var TABLE_SIZE = 1025;
var CURVE_FADE_MS = 24;
var DEFAULT_CURVE = [0, 0, 0.25, 1, 0.5, 0, 0.75, -1, 1, 0];
var bufferIds = new Global("field_kit_curve_ids");
var selected = 0;
var currentLfo = 0;
var targetIndex = 0;
var gains = [];
var globalGains = [];
var curves = [];
var tables = [];
var rates = DEFAULT_RATES.slice();
var shapes = DEFAULT_SHAPES.slice();
var activeRoutes = [];
var enabled = false;
var painting = false;
var dumpReceived = false;
var initialized = false;

for (var i = 0; i < WINDOWS * LFOS * TARGETS.length; i++) {
    gains.push(0);
}
for (var k = 0; k < LFOS * GLOBAL_TARGETS.length; k++) {
    globalGains.push(0);
}
for (var j = 0; j < LFOS; j++) {
    curves.push(DEFAULT_CURVE.slice());
}

function send(name) {
    var box = patcher.getnamed(name);
    if (box && box.valid) {
        box.message.apply(box, arrayfromargs(arguments).slice(1));
    }
}
send.local = 1;

function label(name, value) {
    send(name, "set", value);
}
label.local = 1;

function indexIn(value, size) {
    return typeof value === "number" && value % 1 === 0 && value >= 0 && value < size;
}
indexIn.local = 1;

function offset(windowIndex, lfo, destination) {
    if (windowIndex === WINDOWS) return lfo * GLOBAL_TARGETS.length + destination;
    return (windowIndex * LFOS + lfo) * TARGETS.length + destination;
}
offset.local = 1;

function destinations(windowIndex) {
    return windowIndex === WINDOWS ? GLOBAL_TARGETS : TARGETS;
}
destinations.local = 1;

function routeGains(windowIndex) {
    return windowIndex === WINDOWS ? globalGains : gains;
}
routeGains.local = 1;

function channel(windowIndex, destination) {
    if (windowIndex === WINDOWS) {
        return destination < MAIN_TARGETS ? MAIN_START + destination : DRIFT_START + destination - MAIN_TARGETS;
    }
    if (destination < VOICE_TARGETS) return windowIndex * VOICE_TARGETS + destination;
    return SEND_START + windowIndex * SEND_TARGETS + destination - VOICE_TARGETS;
}
channel.local = 1;

function currentDepth() {
    return routeGains(selected)[offset(selected, currentLfo, targetIndex)];
}
currentDepth.local = 1;

function formatDepth(value) {
    return (value > 0 ? "+" : "") + value + "%";
}
formatDepth.local = 1;

function renderRoute() {
    var value = currentDepth();
    label("fk_mod_depth", value);
    var scope = selected === WINDOWS ? "Global" : "W" + (selected + 1);
    label("fk_mod_status", "LFO " + (currentLfo + 1) + " → " + scope + " " +
        destinations(selected)[targetIndex] + "  /  " + (value ? formatDepth(value) : "Off"));
}
renderRoute.local = 1;

function renderActiveRoutes() {
    activeRoutes = [];
    send("fk_active_routes", "clear");
    for (var w = 0; w <= WINDOWS; w++) {
        for (var d = 0; d < destinations(w).length; d++) {
            if (routeGains(w)[offset(w, currentLfo, d)]) {
                activeRoutes.push([w, d]);
            }
        }
    }
    send("fk_active_routes", "append", activeRoutes.length ? "Jump to an active route…" : "No active routes");
    for (var i = 0; i < activeRoutes.length; i++) {
        var route = activeRoutes[i];
        var scope = route[0] === WINDOWS ? "Global" : "Window " + (route[0] + 1);
        send("fk_active_routes", "append", scope + "  ·  " + destinations(route[0])[route[1]]);
    }
    label("fk_active_routes", 0);
    label("fk_active_label", "Active routes on LFO " + (currentLfo + 1) + "  /  " + activeRoutes.length);
}
renderActiveRoutes.local = 1;

function paintCurve() {
    painting = true;
    send("fk_curve", "clear");
    var points = curves[currentLfo];
    for (var i = 0; i < points.length; i += 2) {
        send("fk_curve", "list", points[i], points[i + 1]);
    }
    send("fk_curve", "cursor", -1);
    painting = false;
}
paintCurve.local = 1;

function renderShape() {
    var shape = shapes[currentLfo];
    var custom = shape === BREAKPOINT;
    label("fk_mod_shape", shape);
    label("fk_curve_label", "LFO " + (currentLfo + 1) + "  ·  " + SHAPE_LABELS[shape]);
    var curve = patcher.getnamed("fk_curve");
    if (curve && curve.valid) {
        curve.hidden = !custom;
        curve.ignoreclick = !custom;
    }
    var preview = patcher.getnamed("fk_lfo_preview");
    if (preview && preview.valid) preview.hidden = custom;
    if (custom) {
        paintCurve();
    } else {
        send("fk_lfo_preview", "shape", shape);
        send("fk_lfo_preview", "phase", -1);
    }
}
renderShape.local = 1;

function renderLfo() {
    label("fk_mod_lfo", currentLfo);
    send("fk_lfo_watch", currentLfo + 1);
    send("fk_phase_watch", currentLfo + 1);
    label("fk_mod_rate", rates[currentLfo]);
    label("fk_signal_label", "LFO " + (currentLfo + 1) + "  ·  live signal");
    label("fk_lfo_value", enabled ? "LFO signal  —" : "LFO signal  ·  Audio off");
    renderShape();
    renderActiveRoutes();
}
renderLfo.local = 1;

function watch() {
    label("fk_mod_window", selected);
    label("fk_mod_target", targetIndex);
    label("fk_applied_value", enabled ? "Applied value  —" : "Applied value  ·  Audio off");
    outlet(1, channel(selected, targetIndex) + 1);
    renderRoute();
}
watch.local = 1;

function renderDestinations() {
    var targets = destinations(selected);
    send("fk_mod_target", "clear");
    for (var i = 0; i < targets.length; i++) {
        send("fk_mod_target", "append", targets[i]);
    }
}
renderDestinations.local = 1;

function bang() {
    if (!initialized) {
        for (var i = 0; i < LFOS; i++) {
            var buffers = [];
            for (var slot = 0; slot < 2; slot++) {
                bufferIds.last = (bufferIds.last || 0) + 1;
                var name = "field-kit-curve-" + bufferIds.last;
                var suffix = (i + 1) + "_" + slot;
                send("fk_curve_buffer_" + suffix, "name", name);
                send("fk_curve_wave_" + suffix, "set", name);
                buffers.push(new Buffer(name));
            }
            tables.push({ buffers: buffers, active: 0, fading: false, dirty: false });
            writeCurveTable(i, 0);
        }
        renderDestinations();
        initialized = true;
    }
    renderLfo();
    watch();
}

function view(windowNumber) {
    if (indexIn(windowNumber - 1, WINDOWS + 1)) {
        select_scope(windowNumber - 1);
        watch();
    }
}

function select_scope(windowIndex) {
    var oldTargets = destinations(selected);
    selected = windowIndex;
    if (oldTargets !== destinations(selected)) {
        targetIndex = 0;
        renderDestinations();
    }
}
select_scope.local = 1;

function select_destination(index) {
    if (indexIn(index, destinations(selected).length)) {
        targetIndex = index;
        watch();
    }
}

function select_lfo(index) {
    if (indexIn(index, LFOS) && index !== currentLfo) {
        currentLfo = index;
        renderLfo();
        renderRoute();
    }
}

function jump_route(index) {
    var route = activeRoutes[index - 1];
    if (route) {
        select_scope(route[0]);
        targetIndex = route[1];
        watch();
    }
    label("fk_active_routes", 0);
}

function set_depth(percent) {
    depth(selected + 1, currentLfo + 1, targetIndex + 1, percent);
}

function add_route() {
    if (!currentDepth()) {
        set_depth(25);
    }
}

function clear_route() {
    set_depth(0);
}

function edit(lfoNumber, destinationNumber, percent) {
    depth(selected + 1, lfoNumber, destinationNumber, percent);
}

function depth(windowNumber, lfoNumber, destinationNumber, percent) {
    var windowIndex = windowNumber - 1;
    var lfo = lfoNumber - 1;
    var destination = destinationNumber - 1;
    if (!indexIn(windowIndex, WINDOWS + 1) || !indexIn(lfo, LFOS) ||
        !indexIn(destination, destinations(windowIndex).length) ||
        typeof percent !== "number" || !isFinite(percent)) {
        return;
    }

    var index = offset(windowIndex, lfo, destination);
    var bounded = Math.round(Math.max(-100, Math.min(100, percent)));
    var routes = routeGains(windowIndex);
    var previous = routes[index];
    if (bounded !== previous) {
        routes[index] = bounded;
        outlet(0, [lfo, channel(windowIndex, destination), bounded / 100]);
        if (lfo === currentLfo && Boolean(bounded) !== Boolean(previous)) {
            renderActiveRoutes();
        }
    }
    if (windowIndex === selected && lfo === currentLfo && destination === targetIndex) {
        renderRoute();
    }
}

function set_rate(hz) {
    rate_state(currentLfo, hz);
}

function rate_state(lfo, hz) {
    if (indexIn(lfo, LFOS) && typeof hz === "number" && isFinite(hz)) {
        rates[lfo] = Math.max(0.01, Math.min(20, hz));
        send("fk_lfo_phase_" + (lfo + 1), rates[lfo]);
        if (lfo === currentLfo) {
            label("fk_mod_rate", rates[lfo]);
        }
    }
}

function shape_state(lfo, shape) {
    if (indexIn(lfo, LFOS) && indexIn(shape, SHAPE_LABELS.length)) {
        shapes[lfo] = shape;
        send("fk_lfo_shape_signal_" + (lfo + 1), shape + 1);
        if (lfo === currentLfo) {
            renderShape();
        }
    }
}

function set_shape(index) {
    shape_state(currentLfo, index);
}

function use_curve() {
    set_shape(BREAKPOINT);
}

function curve_edited() {
    if (!painting && shapes[currentLfo] === BREAKPOINT) {
        // listdump outputs nothing when all points have been removed.
        dumpReceived = false;
        send("fk_curve", "listdump");
        if (!dumpReceived) {
            setCurve(currentLfo, []);
        }
    }
}

function curve_dump() {
    if (shapes[currentLfo] === BREAKPOINT) {
        curve_points.apply(this, arrayfromargs(arguments));
    }
}

function curve_points() {
    if (painting) {
        return;
    }
    dumpReceived = true;
    var values = arrayfromargs(arguments);
    var points = [];
    for (var i = 0; i + 1 < values.length; i += 2) {
        if (typeof values[i] === "number" && typeof values[i + 1] === "number" &&
            isFinite(values[i]) && isFinite(values[i + 1])) {
            points.push([Math.max(0, Math.min(1, values[i])),
                Math.max(-1, Math.min(1, values[i + 1]))]);
        }
    }
    points.sort(function (a, b) { return a[0] - b[0]; });
    var result = [];
    for (var j = 0; j < points.length; j++) {
        var point = points[j];
        if (result.length && result[result.length - 2] === point[0]) {
            result[result.length - 1] = point[1];
        } else {
            result.push(point[0], point[1]);
        }
    }
    setCurve(currentLfo, result);
}

function setCurve(index, points) {
    var previous = curves[index];
    if (previous.length === points.length && points.every(function (value, i) {
        return value === previous[i];
    })) {
        return;
    }
    curves[index] = points;
    if (tables[index]) {
        tables[index].dirty = true;
        fadeCurve(index);
    }
}
setCurve.local = 1;

function writeCurveTable(index, slot) {
    var buffer = tables[index].buffers[slot];
    if (buffer.framecount() !== TABLE_SIZE) {
        return false;
    }
    var points = curves[index];
    var values = [];
    var segment = 0;
    for (var frame = 0; frame < TABLE_SIZE; frame++) {
        var phase = frame / (TABLE_SIZE - 1);
        while (segment + 3 < points.length && phase > points[segment + 2]) {
            segment += 2;
        }
        var value = points.length ? points[segment + 1] : 0;
        if (segment + 3 < points.length && phase > points[segment]) {
            var fraction = (phase - points[segment]) / (points[segment + 2] - points[segment]);
            value += fraction * (points[segment + 3] - value);
        }
        values.push(value);
    }
    buffer.poke(1, 0, values);
    return true;
}
writeCurveTable.local = 1;

function rampCurve(index) {
    send("fk_curve_fade_" + (index + 1), 1 - tables[index].active, CURVE_FADE_MS);
}
rampCurve.local = 1;

function fadeCurve(index) {
    var table = tables[index];
    // Only write to the silent table. Edits received during the ramp replace
    // the pending curve so the next ramp uses the latest set of points.
    if (enabled && table.dirty && !table.fading && writeCurveTable(index, 1 - table.active)) {
        table.dirty = false;
        table.fading = true;
        rampCurve(index);
    }
}
fadeCurve.local = 1;

function curve_ready(index) {
    if (indexIn(index, tables.length) && tables[index].fading) {
        var table = tables[index];
        table.active = 1 - table.active;
        table.fading = false;
        fadeCurve(index);
    }
}

function running(value) {
    var wasEnabled = enabled;
    enabled = !!value;
    if (!enabled) {
        label("fk_lfo_value", "LFO signal  ·  Audio off");
        label("fk_applied_value", "Applied value  ·  Audio off");
        send("fk_curve", "cursor", -1);
        send("fk_lfo_preview", "phase", -1);
    } else if (!wasEnabled) {
        for (var i = 0; i < tables.length; i++) {
            if (tables[i].fading) {
                rampCurve(i);
            } else {
                fadeCurve(i);
            }
        }
    }
}

function effective(value) {
    if (!enabled || !isFinite(value)) {
        return;
    }
    var display;
    if (selected === WINDOWS && targetIndex >= MAIN_TARGETS) {
        var unit = DRIFT_UNITS[targetIndex - MAIN_TARGETS];
        var number = unit === "%" ? value * 100 : value;
        display = number.toFixed(unit === " Hz" ? 0 : unit === " beats" ? 2 : 1) + unit;
    } else if (selected === WINDOWS && targetIndex < 2) {
        display = value.toFixed(1) + " dB";
    } else if (selected === WINDOWS && targetIndex === 4) {
        display = value.toFixed(1) + " ms";
    } else if (selected === WINDOWS && targetIndex === 7) {
        display = value.toFixed(2) + " s";
    } else if (selected !== WINDOWS && targetIndex === 3) {
        display = DIRECTIONS[Math.max(0, Math.min(2, Math.round(value)))];
    } else if (selected !== WINDOWS && targetIndex === 2) {
        display = value.toFixed(2) + "×";
    } else if (selected !== WINDOWS && targetIndex === 4) {
        display = value.toFixed(1) + " ms";
    } else {
        display = (value * 100).toFixed(1) + "%";
    }
    label("fk_applied_value", "Applied value  ·  " + display);
}

function lfo_sample(value) {
    if (enabled && isFinite(value)) {
        label("fk_lfo_value", "LFO signal  ·  " + (value >= 0 ? "+" : "") + value.toFixed(2));
    }
}

function lfo_phase(value) {
    if (!enabled || !isFinite(value)) return;
    if (shapes[currentLfo] === BREAKPOINT) send("fk_curve", "cursor", value);
    else send("fk_lfo_preview", "phase", value);
}
