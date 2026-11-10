const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');

let now = 1000;
let tick = null;
const labels = [];
const values = { tone: 0, echo: 20, space: 18 };
const menuChanges = [];
const noop = () => {};
const canvas = {
    size: [440, 372], init: noop, redraw: noop, fill: noop, stroke: noop,
    set_source_rgba: noop, set_line_width: noop, rectangle: noop, ellipse: noop,
    move_to: noop, line_to: noop, select_font_face: noop, set_font_size: noop,
    text_measure: (text) => [text.length * 6, 12], show_text: (text) => labels.push(text)
};
const pad = vm.createContext({
    mgraphics: canvas,
    Date: { now: () => now },
    Task: function (callback) {
        this.repeat = () => { tick = callback; };
        this.cancel = () => { tick = null; };
    },
    outlet: (index, selector, value) => {
        assert.equal(index, 0);
        if (selector === 'xmenu' || selector === 'ymenu') {
            menuChanges.push([selector, value]);
            return;
        }
        assert(Object.hasOwn(values, selector), selector);
        values[selector] = value;
        pad.source(values.tone, values.echo, values.space);
    }
});
vm.runInContext(fs.readFileSync(path.join(__dirname, '../max/fk_fx_pad.js'), 'utf8'), pad);

function statusStartsWith(prefix) {
    labels.length = 0;
    pad.paint();
    assert(labels.some((text) => text.startsWith(prefix)), labels.join('\n'));
}

const rowY = 96;
const recordX = 70, playX = 170, stopX = 270, clearX = 370;
const left = 62, right = 416, middle = (left + right) / 2;
const top = 134, bottom = 298, centerY = (top + bottom) / 2;

pad.assign(0, 0); // Tone on X, Room on Y.
pad.onclick(recordX, rowY);
statusStartsWith('Armed · Drag the pad');
pad.onclick(left, bottom);
statusStartsWith('Recording · 0.0 s');

// Max can deliver pointer moves before the Task runs. A gesture that goes
// back to its starting point still has to retain its intervening movement.
now = 1010;
pad.ondrag(right, top, 1);
now = 1080;
pad.ondrag(middle, centerY, 1);
now = 1120;
pad.onmouseup(left, bottom);
statusStartsWith('Gesture saved · 0.1 s · Tone tilt + Room mix');
assert.equal(tick, null);

pad.assign(0, 1);
menuChanges.length = 0;
now = 1500;
pad.onclick(playX, rowY);
assert.deepEqual(menuChanges, [['xmenu', 0], ['ymenu', 2]]);
statusStartsWith('Playing · ');
for (const [time, tone, space] of [[1610, 100, 100], [1680, 0, 50], [1720, -100, 0], [1830, 100, 100]]) {
    now = time;
    assert.equal(typeof tick, 'function');
    tick();
    assert.deepEqual(values, { tone, echo: 20, space });
}

pad.onclick(stopX, rowY);
assert.equal(tick, null);
assert.deepEqual(values, { tone: 100, echo: 20, space: 100 });
statusStartsWith('Gesture saved · ');
pad.onclick(clearX, rowY);
statusStartsWith('No gesture recorded');
pad.onclick(playX, rowY);
assert.equal(tick, null);

console.log('FX pad recording, dial feedback, loop playback and transport verified.');
