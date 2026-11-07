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
    get_set_source() { return { kind: 'file', path: this.path }; },
};
const recorderState = { state: 'idle' };
let requestedSource;
const defaultCurve = [0, 0, 0.25, 1, 0.5, 0, 0.75, -1, 1, 0];
const defaultRates = [0.12, 0.31, 0.73, 0.18, 0.43, 0.67, 1.1, 1.7];
const defaultShapes = [0, 1, 2, 0, 1, 0, 1, 0];
const legacyCurves = [[0, 1, 0.6, -0.8, 1, 1], [], [0, -0.5, 1, 0.5]];
const lastCurve = [0, -0.25, 0.7, 0.75, 1, -0.25];
const initialCurves = [...legacyCurves, ...Array(4).fill(defaultCurve), lastCurve];
const modState = {
    DEFAULT_RATES: defaultRates,
    DEFAULT_SHAPES: defaultShapes,
    DEFAULT_CURVE: defaultCurve,
    gains: Array(288).fill(0),
    globalGains: Array(64).fill(0),
    curves: structuredClone(initialCurves),
    rates: [0.1, 0.5, 15, 0.2, 0.3, 0.4, 0.5, 19],
    shapes: [5, 0, 5, 0, 0, 0, 0, 5],
    currentLfo: 7,
    selected: 3,
    targetIndex: 7,
};
modState.gains[9] = 25;
modState.gains[241] = -100;
modState.gains[287] = 42;
modState.globalGains[63] = -35;

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
        case 'depth': {
            const [scope, lfo, destination, depth] = args;
            if (scope === 5) modState.globalGains[(lfo - 1) * 8 + destination - 1] = depth;
            else modState.gains[((scope - 1) * 8 + lfo - 1) * 9 + destination - 1] = depth;
            break;
        }
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
        if (selector === 'open_set_source') requestedSource = args[0];
    },
};
const mixerState = { mutes: [0, 1, 0, 1], solos: [0, 0, 1, 0] };
const mixer = {
    js: mixerState,
    message(selector, ...mutes) {
        assert.equal(selector, 'recall_mutes');
        mixerState.mutes = mutes;
        mixerState.solos.fill(0);
    },
};
function addControl(name, initial) {
    controls[name] = {
        value: initial,
        message(...args) {
            messages.push([name, ...args]);
            if (args[0] === 'set') this.value = args[1];
            if (typeof args[0] === 'number') this.value = args[0];
            if (args[0] === 'text') this.text = args[1];
            if (args[0] === 'activebgcolor') this.background = args.slice(1);
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
    fx_enabled: 1, fx_tone: -8, fx_echo: 60, fx_time_ms: 500, fx_repeats: 77, fx_space: 12, fx_decay: 3.2,
    pitch_scale: 5, master: -5,
})) addControl(name, value);
for (let i = 1; i <= 8; i++) addControl('pattern_' + i, 0);
for (const name of ['pattern_store', 'pattern_status', 'set_status', 'pattern_save_dialog', 'pattern_load_dialog',
                    'set_save_dialog', 'set_open_dialog', 'set_relink_dialog', 'set_writer',
                    'pattern_gain', 'pattern_gain_sample']) addControl(name, 0);
const named = name => {
    if (name === 'source_control') return source;
    if (name === 'patchbay') return { subpatcher: () => ({ getnamed: () => router }) };
    if (name === 'mix_fx') return { subpatcher: () => ({ getnamed: key => controls[key] }) };
    if (name === 'mixer_control') return mixer;
    if (name === 'recorder') return { subpatcher: () => ({ getnamed: () => ({ js: recorderState }) }) };
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

const host = vm.createContext({ patcher: { getnamed: named }, File,
    Task: function () { this.schedule = () => {}; this.cancel = () => {}; } });
vm.runInContext(readFileSync(join(__dirname, '..', 'max', 'fk_patterns.js'), 'utf8'), host);

host.loadbang();
assert.equal(controls.pattern_2.text, '2');
assert.equal(controls.pattern_store.text, 'Store pattern');
assert.equal(host.bankDirty, false);
host.slot(2);
assert.match(controls.pattern_status.value, /empty/);
host.toggle_store();
assert.equal(controls.pattern_store.text, 'Cancel store');
host.toggle_store();
assert.equal(controls.pattern_store.text, 'Store pattern');
host.slot(2);
assert.equal(controls.pattern_2.text, '2');
host.toggle_store();
host.slot(2);
assert.equal(controls.pattern_2.text, '2 •');
assert.equal(controls.pattern_store.text, 'Store pattern');
assert.equal(host.bankDirty, true);
assert.equal(controls.pattern_status.value, 'Pattern 2 stored · bank unsaved');
const selectedBackground = controls.pattern_2.background;
assert.notDeepEqual(selectedBackground, controls.pattern_1.background);
mixerState.mutes.fill(1);
host.save_bank();
assert.deepEqual(messages.at(-1), ['pattern_save_dialog', 'bang']);
host.write_bank('/test/bank.json');
const bank = JSON.parse(files.get('/test/bank.json'));
assert.equal(bank.format, 'field-kit-patterns');
assert.equal(bank.version, 2);
assert.equal(bank.slots.length, 8);
assert.equal(bank.slots[1].windows[1].rate, 0.5);
assert.equal(bank.slots[1].pitchScale, 5);
assert.deepEqual(bank.slots[1].mixerMutes, [0, 1, 0, 1]);
assert.equal(bank.slots[1].mixerSolos, undefined);
assert.deepEqual(bank.slots[1].curves, initialCurves);
assert.equal(bank.slots[1].globalGains[63], -35);
assert.deepEqual(bank.slots[1].selection, { window: 3, lfo: 7, target: 7 });

sourceState.positions[1][0] = 26;
modState.curves[0][1] = 0;
modState.gains[0] = 100;
modState.gains[241] = 25;
modState.gains[287] = 0;
modState.globalGains[0] = 10;
modState.globalGains[63] = 0;
modState.rates[7] = 5;
modState.shapes[7] = 1;
modState.currentLfo = 0;
modState.selected = 0;
modState.targetIndex = 0;
controls.rate_2.value = 2;
controls.master.value = -40;
controls.fx_echo.value = 1;
controls.pitch_scale.value = 0;
sourceState.normalPlaying = true;
host.slot(2);
assert.deepEqual(sourceState.positions[1], [19, 37]);
assert.deepEqual(sourceState.playing, [true, false, true, false]);
assert.equal(sourceState.normalPlaying, false);
assert.equal(sourceState.path, '/test/audio.wav');
assert.deepEqual(modState.curves, initialCurves);
assert.equal(modState.gains[0], 0);
assert.equal(modState.gains[241], -100);
assert.equal(modState.gains[287], 42);
assert.equal(modState.globalGains[0], 0);
assert.equal(modState.globalGains[63], -35);
assert.equal(modState.rates[7], 19);
assert.equal(modState.shapes[7], 5);
assert.equal(modState.currentLfo, 7);
assert.equal(modState.selected, 3);
assert.equal(modState.targetIndex, 7);
assert.equal(controls.rate_2.value, 0.5);
assert.equal(controls.master.value, -5);
assert.equal(controls.fx_echo.value, 60);
assert.equal(controls.pitch_scale.value, 5);
assert.deepEqual(mixerState.mutes, [0, 1, 0, 1]);
assert.deepEqual(mixerState.solos, [0, 0, 0, 0]);
host.slot(2);
assert.equal(controls.pattern_2.text, '2 •');
assert.deepEqual(controls.pattern_2.background, selectedBackground);

mixerState.solos[0] = 1;
host.reset();
assert.deepEqual(sourceState.positions, [[0, 25], [25, 50], [50, 75], [75, 100]]);
assert.deepEqual(sourceState.playing, [false, false, false, false]);
assert.equal(sourceState.path, '/test/audio.wav');
assert.equal(controls.rate_2.value, 1);
assert.equal(controls.fx_enabled.value, 0);
assert.equal(controls.fx_echo.value, 20);
assert.equal(controls.master.value, -12);
assert.equal(controls.pitch_scale.value, 0);
assert.deepEqual(mixerState.mutes, [0, 0, 0, 0]);
assert.deepEqual(mixerState.solos, [0, 0, 0, 0]);
assert.equal(controls.pan_4.value, 45);
assert.equal(controls.pattern_2.text, '2 •');
assert.notDeepEqual(controls.pattern_2.background, selectedBackground);
assert.notDeepEqual(controls.pattern_2.background, controls.pattern_1.background);
assert.equal(modState.targetIndex, 0);
assert(modState.gains.every(value => value === 0));
assert(modState.globalGains.every(value => value === 0));
assert.deepEqual(modState.rates, defaultRates);
assert.deepEqual(modState.shapes, defaultShapes);
assert.deepEqual(modState.curves, Array(8).fill(defaultCurve));

host.slot(4, 1);
assert.equal(controls.pattern_4.text, '4 •');
assert.equal(controls.pattern_status.value, 'Pattern 4 stored · bank unsaved');
controls.rate_2.value = 0.75;
host.slot(4, 1);
assert.equal(controls.pattern_status.value, 'Pattern 4 replaced · bank unsaved');
controls.rate_2.value = 1;
host.slot(4, 0);
assert.equal(controls.rate_2.value, 0.75);
assert.equal(controls.pattern_status.value, 'Pattern 4 recalled · bank unsaved');
controls.rate_2.value = 1;
files.set('/test/invalid.json', JSON.stringify({ ...bank, version: 100 }));
host.read_bank('/test/invalid.json');
assert.match(controls.pattern_status.value, /Couldn’t open/);
assert.equal(controls.pattern_4.text, '4 •');
files.set('/test/wrong-width.json', JSON.stringify({ ...bank, version: 1 }));
host.read_bank('/test/wrong-width.json');
assert.match(controls.pattern_status.value, /Couldn’t open/);
assert.equal(controls.pattern_4.text, '4 •');
const invalidPitchSlots = bank.slots.slice();
invalidPitchSlots[1] = { ...bank.slots[1], pitchScale: 7 };
files.set('/test/invalid-pitch.json', JSON.stringify({ ...bank, slots: invalidPitchSlots }));
host.read_bank('/test/invalid-pitch.json');
assert.match(controls.pattern_status.value, /Couldn’t open/);
assert.equal(controls.pattern_4.text, '4 •');
for (const mixerMutes of [null, [0, 1, 0], [0, 0.5, 0, 1], [0, 2, 0, 1], [0, '1', 0, 1]]) {
    const invalidMuteSlots = bank.slots.slice();
    invalidMuteSlots[1] = { ...bank.slots[1], mixerMutes };
    files.set('/test/invalid-mutes.json', JSON.stringify({ ...bank, slots: invalidMuteSlots }));
    host.read_bank('/test/invalid-mutes.json');
    assert.match(controls.pattern_status.value, /Couldn’t open/);
    assert.equal(controls.pattern_4.text, '4 •');
}
host.load_bank();
assert.deepEqual(messages.at(-1), ['pattern_load_dialog', 'bang']);
failTextRead = true;
host.read_bank('/test/bank.json');
assert.equal(controls.pattern_4.text, '4');
assert.equal(controls.pattern_2.text, '2 •');
assert.equal(controls.rate_2.value, 1);
assert.deepEqual(mixerState.mutes, [0, 0, 0, 0]);
host.slot(2);
assert.equal(controls.rate_2.value, 0.5);
assert.equal(modState.gains[241], -100);
assert.equal(modState.gains[287], 42);
assert.deepEqual(modState.curves, initialCurves);
assert.equal(controls.pitch_scale.value, 5);
assert.deepEqual(mixerState.mutes, [0, 1, 0, 1]);

const oldV2Pattern = { ...bank.slots[1] };
delete oldV2Pattern.pitchScale;
delete oldV2Pattern.mixerMutes;
delete oldV2Pattern.globalGains;
const oldV2Slots = bank.slots.slice();
oldV2Slots[1] = oldV2Pattern;
files.set('/test/old-v2.json', JSON.stringify({ ...bank, slots: oldV2Slots }));
host.read_bank('/test/old-v2.json');
assert.match(controls.pattern_status.value, /Bank loaded/);
host.slot(2);
assert.equal(controls.pitch_scale.value, 0);
assert.deepEqual(mixerState.mutes, [0, 0, 0, 0]);
assert(modState.globalGains.every(value => value === 0));

// These are version 1 indices for W1 LFO 2 Start, W2 LFO 1 Speed,
// W3 LFO 2 Level, and W4 LFO 3 Level.
const legacyGains = Array(108).fill(0);
legacyGains[9] = 25;
legacyGains[29] = 31;
legacyGains[70] = -18;
legacyGains[106] = -100;
const legacyPattern = {
    ...oldV2Pattern,
    gains: legacyGains,
    rates: [0.1, 0.5, 15],
    shapes: [5, 0, 5],
    curves: legacyCurves,
    selection: { window: 3, lfo: 2, target: 7 },
};
const legacySlots = Array(8).fill(null);
legacySlots[7] = legacyPattern;
files.set('/test/legacy.json', JSON.stringify({ format: bank.format, version: 1, slots: legacySlots }));
host.read_bank('/test/legacy.json');
assert.match(controls.pattern_status.value, /Bank loaded/);
assert.equal(controls.pattern_2.text, '2');
assert.equal(controls.pattern_8.text, '8 •');
controls.pitch_scale.value = 6;
mixerState.mutes[0] = 1;
mixerState.solos[1] = 1;
host.slot(8);
assert.equal(controls.pitch_scale.value, 0);
assert.deepEqual(mixerState.mutes, [0, 0, 0, 0]);
assert.deepEqual(mixerState.solos, [0, 0, 0, 0]);
assert.equal(modState.currentLfo, 2);
assert.equal(modState.selected, 3);
assert.equal(modState.targetIndex, 7);
assert.deepEqual(modState.rates, [0.1, 0.5, 15, ...defaultRates.slice(3)]);
assert.deepEqual(modState.shapes, [5, 0, 5, ...defaultShapes.slice(3)]);
assert.deepEqual(modState.curves, [...legacyCurves, ...Array(5).fill(defaultCurve)]);
const migratedGains = Array(288).fill(0);
migratedGains[9] = 25;
migratedGains[74] = 31;
migratedGains[160] = -18;
migratedGains[241] = -100;
assert.deepEqual(modState.gains, migratedGains);
host.write_bank('/test/migrated.json');
const migratedBank = JSON.parse(files.get('/test/migrated.json'));
assert.equal(migratedBank.version, 2);
assert.deepEqual(migratedBank.slots[7].gains, migratedGains);

const denseCurve = [];
for (let point = 0; point <= 1024; point++) {
    denseCurve.push(point / 1024, Math.sin(point));
}
const densePattern = { ...bank.slots[1], curves: Array(8).fill(denseCurve) };
const denseBank = { ...bank, slots: Array(8).fill(densePattern) };
const denseBankText = JSON.stringify(denseBank, null, 2);
assert(denseBankText.length > 2 * 1024 * 1024);
failTextRead = false;
files.set('/test/dense-bank.json', denseBankText);
host.read_bank('/test/dense-bank.json');
assert.match(controls.pattern_status.value, /Bank loaded/);
host.slot(8);
assert.deepEqual(modState.curves[7], denseCurve);

console.log('PASS pattern store, cancel, overwrite, visible slots, pitch snap, mixer mutes, and v1/v2 bank round-trip');

host.read_bank('/test/bank.json');
modState.selected = 4;
modState.targetIndex = 7;
modState.globalGains[63] = -75;
sourceState.path = '/test/sets/Écho.wav';
controls.pan_1.value = -62;
host.slot(1, 1);
controls.pan_1.value = 37;
host.write_set('/test/sets/First.json');
const [, , stage, destination] = messages.at(-1);
assert.equal(controls.pattern_status.value, 'Pattern 1 stored · bank unsaved');
assert.equal(controls.set_status.value, 'Saving First.json…');
const set = JSON.parse(files.get(stage));
assert.equal(set.source.path, sourceState.path);
assert.equal(set.source.relative, 'Écho.wav');
assert.equal(set.slots[0].windows[0].pan, -62);
assert.equal(set.current.windows[0].pan, 37);
assert.equal(set.current.globalGains[63], -75);
assert.equal(set.current.selection.globalTarget, 7);
files.set(destination, files.get(stage));
host.set_written(1, stage);
assert.equal(controls.pattern_status.value, 'Pattern 1 stored.');
assert.equal(controls.set_status.value, 'Set saved · First.json');
assert.equal(host.bankDirty, false);
host.save_set();
assert.deepEqual(messages.slice(-3), [
    ['set_save_dialog', 'name', 'First.json'],
    ['set_save_dialog', 'setpath', '/test/sets/'],
    ['set_save_dialog', 'bang'],
]);

files.set('/relocated/First.json', files.get(destination));
files.set('/relocated/Écho.wav', 'sample');
host.write_set('/test/sets/Concurrent.json');
const [, , concurrentStage] = messages.at(-1);
controls.pan_1.value = 9;
host.slot(3, 1);
host.set_written(1, concurrentStage);
assert.equal(controls.pattern_status.value, 'Pattern 3 stored · bank unsaved');
assert.equal(controls.set_status.value, 'Set saved · Concurrent.json');
assert.equal(host.bankDirty, true);
host.read_set('/relocated/First.json');
assert.equal(requestedSource, '/relocated/Écho.wav');
assert.equal(controls.pan_1.value, 9);
assert.equal(controls.set_status.value, 'Opening First.json…');
host.set_source_loaded(0);
assert.equal(controls.pattern_3.text, '3 •');
assert.equal(controls.pan_1.value, 9);
assert.equal(controls.pattern_status.value, 'Pattern 3 stored · bank unsaved');
assert.match(controls.set_status.value, /Couldn’t load/);
host.read_set('/relocated/First.json');
host.set_source_loaded(1);
assert.equal(controls.pattern_3.text, '3');
assert.equal(controls.pan_1.value, 37);
assert.equal(controls.pattern_status.value, 'Click to recall. Shift-click to store.');
assert.equal(controls.set_status.value, 'Set opened · First.json');
host.slot(1);
assert.equal(controls.pan_1.value, -62);
assert.equal(controls.set_status.value, 'Set opened · First.json');

files.delete('/relocated/Écho.wav');
host.read_set('/relocated/First.json');
assert.deepEqual(messages.at(-1), ['set_relink_dialog', 'bang']);
host.cancel_relink();
assert.equal(controls.pan_1.value, -62);
assert.equal(controls.set_status.value, 'Open Set canceled.');
host.read_set('/relocated/First.json');
host.relink_set('/test/replacement.wav');
assert.equal(requestedSource, '/test/replacement.wav');
host.set_source_loaded(1);
assert.equal(controls.pan_1.value, 37);
recorderState.state = 'recording';
host.open_set();
assert.match(controls.set_status.value, /Stop recording/);
console.log('PASS set captures unslotted edits, restores after decode, and handles relocation, relink and cancel');

sourceState.audioOn = true;
controls.pan_1.value = 13;
host.slot(2, 1);
controls.pan_1.value = 37;
host.slot(1);
assert.equal(controls.pan_1.value, 37);
assert.deepEqual(messages.slice(-2), [
    ['pattern_gain', 'list', 0, 20],
    ['pattern_gain_sample', 'start'],
]);
host.slot(2);
assert.equal(controls.pan_1.value, 37);
host.recall_silent();
assert.equal(controls.pan_1.value, 13);
host.restore_recall_level();
assert.deepEqual(messages.at(-1), ['pattern_gain', 'list', 1, 30]);
host.slot(1);
sourceState.audioOn = false;
host.recall_dsp(0);
assert.equal(controls.pan_1.value, -62);
host.recall_silent();
assert.equal(controls.pan_1.value, -62);
console.log('PASS live recall waits for silence, coalesces rapid selection and recovers if DSP stops');
