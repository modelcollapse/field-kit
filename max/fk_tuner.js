// Read-only pitch display for monophonic input. Reference: A4 = 440 Hz.
inlets = 1;
outlets = 0;

mgraphics.init();
mgraphics.relative_coords = 0;
mgraphics.autofill = 0;

var names = ["C", "C♯", "D", "E♭", "E", "F", "F♯", "G", "A♭", "A", "B♭", "B"];
var hz = 0;
var note = "";
var cents = 0;
var timeout = new Task(bang, this);

function frequency(value) {
    if (typeof value !== "number" || !isFinite(value) || value < 40 || value > 1800) return;
    var midi = 69 + 12 * Math.log(value / 440) / Math.LN2;
    var nearest = Math.round(midi);
    hz = value;
    note = names[nearest % 12] + (Math.floor(nearest / 12) - 1);
    cents = Math.round(100 * (midi - nearest));
    timeout.cancel();
    timeout.schedule(350);
    mgraphics.redraw();
}

function bang() {
    timeout.cancel();
    hz = 0;
    mgraphics.redraw();
}

function fill(x, y, width, height, color) {
    mgraphics.set_source_rgba(color);
    mgraphics.rectangle(x, y, width, height);
    mgraphics.fill();
}
fill.local = 1;

function label(text, x, y, color) {
    mgraphics.set_source_rgba(color);
    mgraphics.move_to(x, y);
    mgraphics.show_text(text);
}
label.local = 1;

var palette = [
    [0.08, 0.11, 0.15, 1], [0.94, 0.97, 1, 1], [0.68, 0.74, 0.82, 1],
    [0.56, 0.73, 0.94, 1], [0.18, 0.24, 0.32, 1]
];
var tuned = [0.55, 0.84, 0.66, 1];

function theme() {
    var colors = arrayfromargs(arguments);
    for (var index = 0; index < palette.length; index++) {
        palette[index] = colors.slice(4 * index, 4 * index + 4);
    }
    mgraphics.redraw();
}

function paint() {
    var background = palette[0], ink = palette[1], muted = palette[2];
    var accent = palette[3], track = palette[4];
    var centered = Math.abs(cents) <= 3;
    var active = centered ? tuned : accent;
    fill(0, 0, mgraphics.size[0], mgraphics.size[1], background);
    mgraphics.select_font_face("Arial");
    mgraphics.set_font_size(36);
    label(hz ? note : "—", 18, 61, ink);
    mgraphics.set_font_size(14);
    if (hz) {
        var sign = cents > 0 ? "+" : "";
        label(hz.toFixed(1) + " Hz", 116, 43, muted);
        label(sign + cents + " cents", 116, 63, centered ? tuned : ink);
    } else {
        label("Waiting for a note", 116, 53, muted);
    }
    fill(20, 85, 256, 10, track);
    fill(147, 81, 2, 18, muted);
    if (hz) fill(145 + 2.48 * cents, 81, 6, 18, active);
    mgraphics.set_font_size(11);
    label("−50", 18, 115, muted);
    label("0", 145, 115, muted);
    label("+50", 254, 115, muted);
    label("Enable audio and play one note at a time.", 18, 139, muted);
}
