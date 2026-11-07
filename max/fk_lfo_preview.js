// Read-only shape preview. The signal scope remains in the adjacent panel.
inlets = 1;
outlets = 0;

mgraphics.init();
mgraphics.relative_coords = 0;
mgraphics.autofill = 0;

var background = [0.125, 0.125, 0.125, 1];
var grid = [0.205, 0.205, 0.205, 1];
var zeroLine = [0.28, 0.28, 0.28, 1];
var waveform = [0.56, 0.71, 0.96, 1];
var cursor = [0.92, 0.65, 0.22, 0.75];
var currentShape = 0;
var currentPhase = -1;

var sine = [];
for (var sample = 0; sample <= 64; sample++) {
    var t = sample / 64;
    sine.push([t, Math.sin(t * 2 * Math.PI)]);
}

var shapes = [
    sine,
    [[0, -1], [0.5, 1], [1, -1]],
    [[0, -1], [1, 1], [1, -1]],
    [[0, 1], [0.5, 1], [0.5, -1], [1, -1], [1, 1]],
    // Four example holds. The actual values come from noise in the signal graph.
    [[0, 0.52], [0.25, 0.52], [0.25, -0.68], [0.5, -0.68],
     [0.5, 0.15], [0.75, 0.15], [0.75, 0.78], [1, 0.78]]
];

function shape(value) {
    if (value < 0 || value >= shapes.length || value !== Math.floor(value) || value === currentShape) return;
    currentShape = value;
    mgraphics.redraw();
}

function phase(value) {
    if (typeof value !== "number" || (value !== -1 && !(value >= 0 && value <= 1)) || value === currentPhase) return;
    currentPhase = value;
    if (currentShape < 4) mgraphics.redraw();
}

function colour(value) {
    mgraphics.set_source_rgba(value[0], value[1], value[2], value[3]);
}

function rule(x1, y1, x2, y2, ink) {
    colour(ink);
    mgraphics.set_line_width(1);
    mgraphics.move_to(x1, y1);
    mgraphics.line_to(x2, y2);
    mgraphics.stroke();
}

function paint() {
    var size = mgraphics.size;
    var width = size && size[0] ? size[0] : box.rect[2] - box.rect[0];
    var height = size && size[1] ? size[1] : box.rect[3] - box.rect[1];
    colour(background);
    mgraphics.rectangle(0, 0, width, height);
    mgraphics.fill();
    if (width < 24 || height < 24) return;

    var left = 8;
    var top = 8;
    var plotWidth = width - 16;
    var plotHeight = height - 16;
    var middle = top + plotHeight / 2;
    for (var i = 0; i <= 4; i++) {
        var x = left + plotWidth * i / 4;
        rule(x, top, x, top + plotHeight, grid);
    }
    rule(left, top, left + plotWidth, top, grid);
    rule(left, middle, left + plotWidth, middle, zeroLine);
    rule(left, top + plotHeight, left + plotWidth, top + plotHeight, grid);

    var points = shapes[currentShape];
    colour(waveform);
    mgraphics.set_line_width(1.5);
    mgraphics.move_to(left, middle - points[0][1] * plotHeight / 2);
    for (var point = 1; point < points.length; point++) {
        mgraphics.line_to(left + points[point][0] * plotWidth,
                          middle - points[point][1] * plotHeight / 2);
    }
    mgraphics.stroke();

    if (currentShape < 4 && currentPhase >= 0) {
        var cursorX = left + currentPhase * plotWidth;
        rule(cursorX, top, cursorX, top + plotHeight, cursor);
    }
}

function onresize() {
    mgraphics.redraw();
}

colour.local = rule.local = 1;
