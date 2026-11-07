// Stereo field for Field Kit's four existing mixer strips.
inlets = 1;
outlets = 1;

mgraphics.init();
mgraphics.relative_coords = 0;
mgraphics.autofill = 0;

var ink = {
    background: [0.16, 0.16, 0.16, 1],
    button: [0.23, 0.23, 0.23, 1],
    field: [0.125, 0.125, 0.125, 1],
    grid: [0.23, 0.23, 0.23, 1],
    axis: [0.34, 0.34, 0.34, 1],
    text: [0.78, 0.78, 0.78, 1],
    blue: [0.64, 0.78, 1, 1]
};
var loops = [
    { pan: -45, level: 70 },
    { pan: -15, level: 70 },
    { pan: 15, level: 70 },
    { pan: 45, level: 70 }
];
var selected = 1;
var drag = null;

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
    point.pan = pan;
    point.level = level;
    mgraphics.redraw();
}

function select(loop) {
    if (!validLoop(loop) || loop === selected) return;
    selected = loop;
    mgraphics.redraw();
}

function bounds() {
    var size = mgraphics.size;
    var width = size && size[0] ? size[0] : box.rect[2] - box.rect[0];
    var height = size && size[1] ? size[1] : box.rect[3] - box.rect[1];
    return {
        width: width, height: height,
        left: 52, right: Math.max(53, width - 23),
        top: 55, bottom: Math.max(56, height - 30),
        tabLeft: 14, tabWidth: (width - 28) / loops.length
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
    var point = trackPosition(loops[loop - 1], grid);
    var active = loop === selected;
    var radius = active ? 11 : 9;
    mgraphics.ellipse(point[0] - radius, point[1] - radius, radius * 2, radius * 2);
    colour(active ? ink.blue : ink.field);
    mgraphics.fill_preserve();
    colour(ink.blue);
    mgraphics.set_line_width(1);
    mgraphics.stroke();
    label(String(loop), point[0], point[1] + 3.5, active ? ink.field : ink.blue, true);
}

function paint() {
    var grid = bounds();
    rectangle(0, 0, grid.width, grid.height, ink.background);
    mgraphics.select_font_face("Arial");
    mgraphics.set_font_size(11);

    for (var loop = 1; loop <= loops.length; loop++) {
        var x = grid.tabLeft + grid.tabWidth * (loop - 1);
        var active = loop === selected;
        rectangle(x + 1, 10, grid.tabWidth - 2, 25, active ? ink.blue : ink.button);
        label("Loop " + loop, x + grid.tabWidth / 2, 26, active ? ink.field : ink.text, true);
    }

    rectangle(grid.left, grid.top, grid.right - grid.left, grid.bottom - grid.top, ink.field);
    for (var step = 0; step <= 4; step++) {
        var xLine = grid.left + (grid.right - grid.left) * step / 4;
        var yLine = grid.top + (grid.bottom - grid.top) * step / 4;
        rule(xLine, grid.top, xLine, grid.bottom, step === 2 ? ink.axis : ink.grid);
        rule(grid.left, yLine, grid.right, yLine, ink.grid);
    }
    label("100%", 14, grid.top + 4, ink.text);
    label("Level", 14, (grid.top + grid.bottom) / 2 + 4, ink.text);
    label("0%", 14, grid.bottom + 4, ink.text);
    label("Left", grid.left, grid.bottom + 20, ink.text, true);
    label("Center", (grid.left + grid.right) / 2, grid.bottom + 20, ink.text, true);
    label("Right", grid.right, grid.bottom + 20, ink.text, true);

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

function onclick(x, y) {
    var grid = bounds();
    drag = null;
    if (y >= 10 && y <= 35 && x >= grid.tabLeft && x < grid.width - grid.tabLeft) {
        select(1 + Math.floor((x - grid.tabLeft) / grid.tabWidth));
        outlet(0, "select", selected);
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
    drag = {
        loop: loop, x: x, y: y, last: 0,
        pan: loops[loop - 1].pan, level: loops[loop - 1].level
    };
    outlet(0, "select", loop);
}

function moveLoop(x, y, force) {
    if (!drag) return;
    var now = Date.now();
    if (!force && now - drag.last < 20) return;
    var grid = bounds();
    var pan = clamp(drag.pan + 200 * (x - drag.x) / (grid.right - grid.left), -100, 100);
    var level = clamp(drag.level - 100 * (y - drag.y) / (grid.bottom - grid.top), 0, 100);
    pan = Math.round(pan * 10) / 10;
    level = Math.round(level * 10) / 10;
    var point = loops[drag.loop - 1];
    if (point.pan === pan && point.level === level) return;
    drag.last = now;
    source(drag.loop, pan, level);
    outlet(0, "position", drag.loop, pan, level);
}

function ondrag(x, y, button) {
    moveLoop(x, y, !button);
    if (!button) drag = null;
}

function onmouseup(x, y) {
    moveLoop(x, y, true);
    drag = null;
}

function onresize() {
    mgraphics.redraw();
}

validLoop.local = clamp.local = bounds.local = trackPosition.local = 1;
colour.local = label.local = rectangle.local = rule.local = marker.local = 1;
nearLoop.local = moveLoop.local = 1;
