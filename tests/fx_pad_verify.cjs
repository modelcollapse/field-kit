const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');

let now = 1000;
let tick = null;
const labels = [];
const values = { tone: 0, echo: 20, space: 18, distortion: 0 };
const menuChanges = [];
const noop = () => {};
const menuItems = {};
const patcher = {
    getnamed(name) {
        return { message(selector, item) {
            if (selector === 'clear') menuItems[name] = [];
            else if (selector === 'append') menuItems[name].push(item);
        } };
    },
};
const canvas = {
    size: [440, 372], init: noop, redraw: noop, fill: noop, stroke: noop,
    set_source_rgba: noop, set_line_width: noop, rectangle: noop, ellipse: noop,
    move_to: noop, line_to: noop, select_font_face: noop, set_font_size: noop,
    text_measure: (text) => [text.length * 6, 12], show_text: (text) => labels.push(text)
};
const pad = vm.createContext({
    mgraphics: canvas, patcher,
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
        pad.source(values.tone, values.echo, values.space, values.distortion);
    }
});
vm.runInContext(fs.readFileSync(path.join(__dirname, '../max/fk_fx_pad.js'), 'utf8'), pad);

function statusStartsWith(prefix) {
    labels.length = 0;
    pad.paint();
    assert(labels.some((text) => text.startsWith(prefix)), labels.join('\n'));
}

const rowY = 96;
const recordX = 70, playX = 215, clearX = 350;
const left = 62, right = 416, middle = (left + right) / 2;
const top = 134, bottom = 298, centerY = (top + bottom) / 2;

pad.assign(0, 0); // Tone on X, Room on Y.
pad.onclick(recordX, rowY);
statusStartsWith('Ready · Drag the pad');
pad.onclick(recordX, rowY);
statusStartsWith('No gesture recorded');
pad.onclick(recordX, rowY);
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
statusStartsWith('Recording · 0.1 s');
assert.equal(pad.gesture_snapshot(), null);
now = 1150;
tick();
now = 1200;
pad.onclick(left, bottom);
now = 1250;
pad.ondrag(right, top, 1);
now = 1280;
pad.onmouseup(left, bottom);
assert.equal(pad.gesture_snapshot(), null);
pad.onclick(recordX, rowY);
statusStartsWith('Playing · 0.3 s · Tone tilt + Room mix');
assert.equal(typeof tick, 'function');
pad.onclick(playX, rowY);
statusStartsWith('Gesture saved · 0.3 s · Tone tilt + Room mix');
assert.equal(tick, null);
const clip = structuredClone(pad.gesture_snapshot());
pad.gesture_restore(null);
statusStartsWith('No gesture recorded');
pad.gesture_restore(clip);
assert.equal(tick, null);
pad.send_mode(1);
assert.deepEqual(menuItems, {
    fx_pad_x: ['Tone tilt', 'Echo return', 'Room return', 'Distortion'],
    fx_pad_y: ['Tone tilt', 'Echo return', 'Room return', 'Distortion'],
});
statusStartsWith('Gesture saved · 0.3 s · Tone tilt + Room return');
pad.send_mode(0);
statusStartsWith('Gesture saved · 0.3 s · Tone tilt + Room mix');

pad.assign(0, 1);
menuChanges.length = 0;
now = 1500;
pad.onclick(playX, rowY);
assert.deepEqual(menuChanges, [['xmenu', 0], ['ymenu', 2]]);
statusStartsWith('Playing · ');
for (const [time, tone, space] of [[1610, 100, 100], [1680, 0, 50], [1720, -100, 0], [1770, -100, 0], [1850, 100, 100]]) {
    now = time;
    assert.equal(typeof tick, 'function');
    tick();
    assert.deepEqual(values, { tone, echo: 20, space, distortion: 0 });
}

pad.onclick(playX, rowY);
assert.equal(tick, null);
assert.deepEqual(values, { tone: 100, echo: 20, space: 100, distortion: 0 });
statusStartsWith('Gesture saved · ');
pad.onclick(clearX, rowY);
statusStartsWith('No gesture recorded');
pad.onclick(playX, rowY);
assert.equal(tick, null);

pad.assign(0, 3);
pad.onclick(left, bottom);
pad.onmouseup(right, top);
assert.equal(values.distortion, 100);
pad.source(100, 20, 100, 23);
assert.equal(pad.targets[3].value, 23);

// A completed take starts playback at the recording limit, too.
now = 2000;
pad.onclick(recordX, rowY);
pad.onclick(left, bottom);
now = 2020;
pad.onmouseup(right, top);
now = 32000;
tick();
assert.equal(pad.gesture_snapshot().duration, 30000);
statusStartsWith('Playing · 30.0 s');
pad.onclick(playX, rowY);
assert.equal(tick, null);
const finished = pad.gesture_snapshot();
pad.onclick(recordX, rowY);
pad.onclick(right, top);
now = 32100;
pad.onclick(recordX, rowY);
assert.equal(pad.gesture_snapshot(), finished);
assert.equal(tick, null);

console.log('FX pad recording, dial feedback, loop playback and transport verified.');
