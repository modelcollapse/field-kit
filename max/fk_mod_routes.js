// Route amounts and breakpoint curves are edited here. MSP runs the oscillators and mix.
autowatch = 0;
inlets = 1;
outlets = 2;

var WINDOWS = 4;
var DEFAULT_RATES = [0.12, 0.31, 0.73, 0.18, 0.43, 0.67, 1.1, 1.7];
var DEFAULT_SHAPES = [0, 1, 2, 0, 1, 0, 1, 0];
var LFOS = DEFAULT_RATES.length;
var TARGETS = ["Start", "End", "Speed", "Direction", "Crossfade", "Drive", "Filter", "Level", "Pan"];
var DIRECTIONS = ["Forward", "Reverse", "Ping-pong"];
var TABLE_SIZE = 1025;
var DEFAULT_CURVE = [0, 0, 0.25, 1, 0.5, 0, 0.75, -1, 1, 0];
var bufferIds = new Global("field_kit_curve_ids");
var selected = 0;
var currentLfo = 0;
var targetIndex = 0;
var gains = [];
var curves = [];
var tables = [];
var rates = DEFAULT_RATES.slice();
var shapes = DEFAULT_SHAPES.slice();
var activeRoutes = [];
var enabled = false;
var painting = false;
var initialized = false;

for (var i = 0; i < WINDOWS * LFOS * TARGETS.length; i++) {
    gains.push(0);
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
    return (windowIndex * LFOS + lfo) * TARGETS.length + destination;
}
offset.local = 1;

function currentDepth() {
    return gains[offset(selected, currentLfo, targetIndex)];
}
currentDepth.local = 1;

function formatDepth(value) {
    return (value > 0 ? "+" : "") + value + "%";
}
formatDepth.local = 1;

function renderRoute() {
    var value = currentDepth();
    label("fk_mod_depth", value);
    label("fk_mod_status", "LFO " + (currentLfo + 1) + " → W" + (selected + 1) + " " +
        TARGETS[targetIndex] + "  /  " + (value ? formatDepth(value) : "Off"));
}
renderRoute.local = 1;

function renderActiveRoutes() {
    activeRoutes = [];
    send("fk_active_routes", "clear");
    for (var w = 0; w < WINDOWS; w++) {
        for (var d = 0; d < TARGETS.length; d++) {
            if (gains[offset(w, currentLfo, d)]) {
                activeRoutes.push([w, d]);
            }
        }
    }
    send("fk_active_routes", "append", activeRoutes.length ? "Jump to an active route…" : "No active routes");
    for (var i = 0; i < activeRoutes.length; i++) {
        var route = activeRoutes[i];
        send("fk_active_routes", "append", "Window " + (route[0] + 1) + "  ·  " + TARGETS[route[1]]);
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

function renderLfo() {
    label("fk_mod_lfo", currentLfo);
    send("fk_lfo_watch", currentLfo + 1);
    send("fk_phase_watch", currentLfo + 1);
    label("fk_mod_rate", rates[currentLfo]);
    label("fk_mod_shape", shapes[currentLfo]);
    label("fk_signal_label", "LFO " + (currentLfo + 1) + "  ·  live signal");
    label("fk_curve_label", "LFO " + (currentLfo + 1) + "  ·  Breakpoint curve");
    label("fk_lfo_value", enabled ? "LFO signal  —" : "LFO signal  ·  Audio off");
    paintCurve();
    renderActiveRoutes();
}
renderLfo.local = 1;

function watch() {
    label("fk_mod_window", selected);
    label("fk_mod_target", targetIndex);
    label("fk_applied_value", enabled ? "Applied value  —" : "Applied value  ·  Audio off");
    outlet(1, selected * TARGETS.length + targetIndex + 1);
    renderRoute();
}
watch.local = 1;

function bang() {
    if (!initialized) {
        for (var i = 0; i < LFOS; i++) {
            bufferIds.last = (bufferIds.last || 0) + 1;
            var name = "field-kit-curve-" + bufferIds.last;
            send("fk_curve_buffer_" + (i + 1), "name", name);
            send("fk_curve_wave_" + (i + 1), "set", name);
            tables.push(new Buffer(name));
            writeCurve(i);
        }
        initialized = true;
    }
    renderLfo();
    watch();
}

function view(windowNumber) {
    if (indexIn(windowNumber - 1, WINDOWS)) {
        selected = windowNumber - 1;
        watch();
    }
}

function select_destination(index) {
    if (indexIn(index, TARGETS.length)) {
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
        selected = route[0];
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
    if (!indexIn(windowIndex, WINDOWS) || !indexIn(lfo, LFOS) ||
        !indexIn(destination, TARGETS.length) || typeof percent !== "number" || !isFinite(percent)) {
        return;
    }

    var index = offset(windowIndex, lfo, destination);
    var bounded = Math.round(Math.max(-100, Math.min(100, percent)));
    var previous = gains[index];
    if (bounded !== previous) {
        gains[index] = bounded;
        outlet(0, [lfo, windowIndex * TARGETS.length + destination, bounded / 100]);
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
    if (indexIn(lfo, LFOS) && indexIn(shape, 6)) {
        shapes[lfo] = shape;
        send("fk_lfo_shape_signal_" + (lfo + 1), shape + 1);
        if (lfo === currentLfo) {
            label("fk_mod_shape", shape);
            send("fk_curve", "cursor", -1);
        }
    }
}

function set_shape(index) {
    shape_state(currentLfo, index);
}

function use_curve() {
    set_shape(5);
}

function curve_edited() {
    if (!painting) {
        // listdump outputs nothing when all points have been removed.
        var previous = curves[currentLfo];
        curves[currentLfo] = [];
        send("fk_curve", "listdump");
        if (curves[currentLfo].length === 0 && previous.length > 0) {
            writeCurve(currentLfo);
        }
    }
}

function curve_points() {
    if (painting) {
        return;
    }
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
    curves[currentLfo] = result;
    writeCurve(currentLfo);
}

function writeCurve(index) {
    if (!tables[index] || tables[index].framecount() !== TABLE_SIZE) {
        return;
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
    tables[index].poke(1, 0, values);
}
writeCurve.local = 1;

function running(value) {
    enabled = !!value;
    if (!enabled) {
        label("fk_lfo_value", "LFO signal  ·  Audio off");
        label("fk_applied_value", "Applied value  ·  Audio off");
        send("fk_curve", "cursor", -1);
    }
}

function effective(value) {
    if (!enabled || !isFinite(value)) {
        return;
    }
    var display;
    if (targetIndex === 3) {
        display = DIRECTIONS[Math.max(0, Math.min(2, Math.round(value)))];
    } else if (targetIndex === 2) {
        display = value.toFixed(2) + "×";
    } else if (targetIndex === 4) {
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
    if (enabled && shapes[currentLfo] === 5) {
        send("fk_curve", "cursor", value);
    }
}
