// Preview the two gain curves used by the Gen loop seam.
inlets = 1;
outlets = 0;

mgraphics.init();
mgraphics.relative_coords = 0;
mgraphics.autofill = 0;

var colors = [];
var sourceReady = false;
var audioRunning = false;
var estimated = 0;
var applied = null;

function theme() {
    var palette = arrayfromargs(arguments);
    if (palette.length !== 20) return;
    colors = [];
    for (var i = 0; i < palette.length; i += 4) colors.push(palette.slice(i, i + 4));
    mgraphics.redraw();
}

function preview(estimate, ready) {
    estimated = estimate;
    sourceReady = ready === 1;
    applied = null;
    mgraphics.redraw();
}

function running(state) {
    audioRunning = state === 1;
    applied = null;
    mgraphics.redraw();
}

function duration() {
    return audioRunning && applied !== null ? applied : estimated;
}
duration.local = 1;

function milliseconds(value) {
    if (value <= 0) return "Off";
    if (value < 0.1) return "<0.1 ms";
    return (value < 10 ? (Math.round(value * 10) / 10) : Math.round(value)) + " ms";
}
milliseconds.local = 1;

function msg_float(value) {
    if (!audioRunning || !isFinite(value) || value < 0) return;
    var before = milliseconds(duration());
    applied = value;
    if (before !== milliseconds(value)) mgraphics.redraw();
}

function ink(color) {
    mgraphics.set_source_rgba(color[0], color[1], color[2], color[3]);
}
ink.local = 1;

function label(value, x, y, color) {
    ink(color);
    mgraphics.move_to(x, y);
    mgraphics.show_text(value);
}
label.local = 1;

function curve(incoming, x, y, width, height, color) {
    ink(color);
    mgraphics.set_line_width(1.6);
    for (var i = 0; i <= 24; i++) {
        var t = i / 24;
        var weight = t * t * (3 - 2 * t);
        var gain = incoming ? weight : 1 - weight;
        if (i === 0) mgraphics.move_to(x, y + height * (1 - gain));
        else mgraphics.line_to(x + width * t, y + height * (1 - gain));
    }
    mgraphics.stroke();
}
curve.local = 1;

function paint() {
    var size = mgraphics.size;
    var background = colors[0] || [0.08, 0.12, 0.17, 1];
    var grid = colors[1] || [0.19, 0.25, 0.32, 1];
    var text = colors[2] || [0.95, 0.97, 0.99, 1];
    var outgoing = colors[3] || [0.71, 0.77, 0.84, 1];
    var incoming = colors[4] || [0.56, 0.73, 0.94, 1];
    ink(background);
    mgraphics.rectangle(0, 0, size[0], size[1]);
    mgraphics.fill();

    mgraphics.select_font_face("Arial");
    mgraphics.set_font_size(11);
    label("Loop crossfade", 8, 15, text);
    var value = sourceReady ? milliseconds(duration()) : "No source";
    label(value, size[0] - mgraphics.text_measure(value)[0] - 8, 15, text);

    var graphWidth = size[0] - 72;
    var graphHeight = size[1] - 33;
    ink(grid);
    mgraphics.set_line_width(1);
    mgraphics.rectangle(8, 24, graphWidth, graphHeight);
    mgraphics.stroke();
    if (!sourceReady || duration() <= 0) return;

    curve(false, 8, 24, graphWidth, graphHeight, outgoing);
    curve(true, 8, 24, graphWidth, graphHeight, incoming);
    label("Fade in", size[0] - 53, 36, incoming);
    label("Fade out", size[0] - 53, 53, outgoing);
}

function onresize() {
    mgraphics.redraw();
}
