const assert = require('node:assert/strict');
const { readFileSync } = require('node:fs');
const { join } = require('node:path');
const vm = require('node:vm');

const controls = {};
const messages = [];
const files = new Map();
let failTextRead = false;
const sourceState = {
    positions: [[4, 18], [19, 37], [45, 71], [75, 99]],
    playing: [true, false, true, false],
    normalPlaying: false,
    path: '/test/audio.wav',
};
const initialCurves = [[0, 1, 0.6, -0.8, 1, 1], [], [0, -0.5, 1, 0.5]];
const modState = {
    gains: Array(108).fill(0),
    curves: structuredClone(initialCurves),
    rates: [0.1, 0.5, 15],
    shapes: [5, 0, 5],
    currentLfo: 2,
    selected: 3,
    targetIndex: 7,
};
modState.gains[9] = 25;
modState.gains[106] = -100;

const router = {
    js: modState,
    message(selector, ...args) {
        switch (selector) {
        case 'select_lfo': modState.currentLfo = args[0]; break;
        case 'rate_state': modState.rates[args[0]] = args[1]; break;
        case 'shape_state': modState.shapes[args[0]] = args[1]; break;
        case 'curve_points': modState.curves[modState.currentLfo] = args; break;
        case 'view': modState.selected = args[0] - 1; break;
        case 'select_destination': modState.targetIndex = args[0]; break;
        case 'depth': modState.gains[((args[0] - 1) * 3 + args[1] - 1) * 9 + args[2] - 1] = args[3]; break;
        case 'bang': break;
        default: throw new Error('Unexpected route selector ' + selector);
        }
    },
};
const source = {
    js: sourceState,
    message(selector, ...args) {
        if (selector === 'exit_normal') sourceState.normalPlaying = false;
        if (selector === 'set_region') sourceState.positions[args[0] - 1] = args.slice(1);
        if (selector === 'stop_all') {
            sourceState.playing.fill(false);
            sourceState.normalPlaying = false;
        }
        if (selector === 'inspect_window') sourceState.inspector = args[0];
    },
};
function addControl(name, initial) {
    controls[name] = {
        value: initial,
        message(...args) {
            messages.push([name, ...args]);
            if (args[0] === 'set') this.value = args[1];
            if (typeof args[0] === 'number') this.value = args[0];
        },
        getvalueof() { return [this.value]; },
    };
}
for (let voice = 1; voice <= 4; voice++) {
    for (const [name, value] of Object.entries({ rate: 0.5, direction: 1, fade: 120, drive: 10, filter: -22, level: 55, pan: 5 })) {
        addControl(name + '_' + voice, value);
    }
}
for (const [name, value] of Object.entries({
    fx_enabled: 1, fx_tone: -8, fx_echo: 60, fx_time_ms: 500, fx_repeats: 77, fx_space: 12, fx_decay: 3.2, master: -5,
})) addControl(name, value);
for (let i = 1; i <= 8; i++) addControl('pattern_' + i, 0);
for (const name of ['pattern_store', 'pattern_status', 'pattern_save_dialog', 'pattern_load_dialog']) addControl(name, 0);
const named = name => {
    if (name === 'source_control') return source;
    if (name === 'patchbay') return { subpatcher: () => ({ getnamed: () => router }) };
    if (name === 'mix_fx') return { subpatcher: () => ({ getnamed: key => controls[key] }) };
    if (controls[name]) return controls[name];
    throw new Error('Unexpected control ' + name);
};
function File(path, mode) {
    this.position = 0;
    this.isopen = mode === 'write' || files.has(path);
    Object.defineProperty(this, 'eof', {
        get: () => files.get(path)?.length ?? 0,
        set: length => files.set(path, files.get(path).slice(0, length)),
    });
    this.writestring = text => { files.set(path, text); this.position = text.length; };
    this.readstring = size => {
        if (failTextRead) return null;
        const text = files.get(path).slice(this.position, this.position + size);
        this.position += text.length;
        return text;
    };
    this.readbytes = size => {
        const text = files.get(path).slice(this.position, this.position + size);
        this.position += text.length;
        return Array.from(text, char => char.charCodeAt(0));
    };
    this.close = () => { this.isopen = false; };
}

const host = vm.createContext({ patcher: { getnamed: named }, File });
vm.runInContext(readFileSync(join(__dirname, '..', 'fk_patterns.js'), 'utf8'), host);

host.loadbang();
host.slot(2);
assert.match(controls.pattern_status.value, /empty/);
host.arm(1);
host.slot(2);
assert.equal(controls.pattern_2.value, 1);
assert.equal(controls.pattern_store.value, 0);
host.save_bank();
assert.deepEqual(messages.at(-1), ['pattern_save_dialog', 'bang']);
host.write_bank('/test/bank.json');
const bank = JSON.parse(files.get('/test/bank.json'));
assert.equal(bank.format, 'field-kit-patterns');
assert.equal(bank.version, 1);
assert.equal(bank.slots.length, 8);
assert.equal(bank.slots[1].windows[1].rate, 0.5);
assert.deepEqual(bank.slots[1].curves, initialCurves);
assert.deepEqual(bank.slots[1].selection, { window: 3, lfo: 2, target: 7 });

sourceState.positions[1][0] = 26;
modState.curves[0][1] = 0;
modState.gains[0] = 100;
modState.gains[106] = 25;
modState.currentLfo = 0;
modState.selected = 0;
modState.targetIndex = 0;
controls.rate_2.value = 2;
controls.master.value = -40;
controls.fx_echo.value = 1;
sourceState.normalPlaying = true;
host.slot(2);
assert.deepEqual(sourceState.positions[1], [19, 37]);
assert.deepEqual(sourceState.playing, [true, false, true, false]);
assert.equal(sourceState.normalPlaying, false);
assert.equal(sourceState.path, '/test/audio.wav');
assert.deepEqual(modState.curves, initialCurves);
assert.equal(modState.gains[0], 0);
assert.equal(modState.gains[106], -100);
assert.equal(modState.currentLfo, 2);
assert.equal(modState.selected, 3);
assert.equal(modState.targetIndex, 7);
assert.equal(controls.rate_2.value, 0.5);
assert.equal(controls.master.value, -5);
assert.equal(controls.fx_echo.value, 60);

host.reset();
assert.deepEqual(sourceState.positions, [[0, 25], [25, 50], [50, 75], [75, 100]]);
assert.deepEqual(sourceState.playing, [false, false, false, false]);
assert.equal(sourceState.path, '/test/audio.wav');
assert.equal(controls.rate_2.value, 1);
assert.equal(controls.fx_enabled.value, 0);
assert.equal(controls.fx_echo.value, 20);
assert.equal(controls.master.value, -12);
assert.equal(controls.pan_4.value, 45);
assert.equal(controls.pattern_2.value, 1);
assert.equal(modState.targetIndex, 0);
assert(modState.gains.every(value => value === 0));

host.arm(1);
host.slot(4);
assert.equal(controls.pattern_4.value, 1);
files.set('/test/invalid.json', JSON.stringify({ ...bank, version: 100 }));
host.read_bank('/test/invalid.json');
assert.match(controls.pattern_status.value, /Couldn’t open/);
assert.equal(controls.pattern_4.value, 1);
host.load_bank();
assert.deepEqual(messages.at(-1), ['pattern_load_dialog', 'bang']);
failTextRead = true;
host.read_bank('/test/bank.json');
assert.equal(controls.pattern_4.value, 0);
assert.equal(controls.pattern_2.value, 1);
assert.equal(controls.rate_2.value, 1);
host.slot(2);
assert.equal(controls.rate_2.value, 0.5);
assert.equal(modState.gains[106], -100);
assert.deepEqual(modState.curves, initialCurves);
console.log('PASS eight pattern slots, recall, selected route and curves, reset, bank round-trip, and invalid bank protection');
