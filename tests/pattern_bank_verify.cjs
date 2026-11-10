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
    valid_builtin_demo(id) { return id === 'glass-circuit' || id === 'tidal-lanterns'; },
};
const recorderState = { state: 'idle' };
let requestedSource;
const blankSequence = { bpm: 120, beats: 4, repeat: 1, steps: Array.from({ length: 8 }, () => ({ slot: 0, bars: 1 })) };
const programmedSequence = structuredClone(blankSequence);
programmedSequence.bpm = 132.5;
programmedSequence.steps[0] = { slot: 1, bars: 2 };
programmedSequence.steps[1] = { slot: 2, bars: 3 };
const changedSequence = { ...programmedSequence, bpm: 150 };
const sequenceState = { data: structuredClone(blankSequence), running: false, validations: [], restores: [], refreshes: 0 };
const sequencer = {
    js: {
        sequence_snapshot() { return structuredClone(sequenceState.data); },
        sequence_valid(data) {
            sequenceState.validations.push(structuredClone(data));
            return !!data && data.bpm >= 20 && data.bpm <= 300;
        },
        restore_sequence(data) {
            sequenceState.restores.push({ data: structuredClone(data), pan: controls.pan_1.value,
                                          slot3: host.sequence_has_slot(3) });
            sequenceState.data = structuredClone(data ?? blankSequence);
            sequenceState.running = false;
        },
    },
    message(selector) {
        if (selector === 'refresh_mix') {
            sequenceState.refreshes++;
            return;
        }
        assert.equal(selector, 'stop');
        sequenceState.running = false;
    },
};
const defaultCurve = [0, 0, 0.25, 1, 0.5, 0, 0.75, -1, 1, 0];
const defaultRates = [0.12, 0.31, 0.73, 0.18, 0.43, 0.67, 1.1, 1.7];
const defaultShapes = [0, 1, 2, 0, 1, 0, 1, 0];
const legacyCurves = [[0, 1, 0.6, -0.8, 1, 1], [], [0, -0.5, 1, 0.5]];
const lastCurve = [0, -0.25, 0.7, 0.75, 1, -0.25];
const initialCurves = [...legacyCurves, ...Array(4).fill(defaultCurve), lastCurve];
const loopTargetCount = 11;
const globalTargetCount = 22;
const loopRoute = (window, lfo, destination) => ((window - 1) * 8 + lfo - 1) * loopTargetCount + destination - 1;
const globalRoute = (lfo, destination) => (lfo - 1) * globalTargetCount + destination - 1;
const secondLfoStart = loopRoute(1, 2, 1);
const fourthLoopLevel = loopRoute(4, 3, 8);
const lastLegacyLoopRoute = loopRoute(4, 8, 9);
const lastLegacyGlobalRoute = globalRoute(8, 8);
const roomSendRoute = loopRoute(2, 6, 11);
const lastDriftRoute = globalRoute(8, 22);
const modState = {
    DEFAULT_RATES: defaultRates,
    DEFAULT_SHAPES: defaultShapes,
    DEFAULT_CURVE: defaultCurve,
    gains: Array(4 * 8 * loopTargetCount).fill(0),
    globalGains: Array(8 * globalTargetCount).fill(0),
    curves: structuredClone(initialCurves),
    rates: [0.1, 0.5, 15, 0.2, 0.3, 0.4, 0.5, 19],
    shapes: [5, 0, 5, 0, 0, 0, 0, 5],
    currentLfo: 7,
    selected: 3,
    targetIndex: 7,
};
modState.gains[secondLfoStart] = 25;
modState.gains[fourthLoopLevel] = -100;
modState.gains[lastLegacyLoopRoute] = 42;
modState.gains[roomSendRoute] = -20;
modState.globalGains[lastLegacyGlobalRoute] = -35;
modState.globalGains[lastDriftRoute] = 60;

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
            if (scope === 5) modState.globalGains[globalRoute(lfo, destination)] = depth;
            else modState.gains[loopRoute(scope, lfo, destination)] = depth;
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
        if (selector === 'open_set_demo') messages.push(['source_control', selector, ...args]);
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
    for (const [name, value] of Object.entries({ rate: 0.5, direction: 1, fade: 120, drive: 10, filter: -22, level: 55, pan: 5,
                                                echo_send: voice * 10, room_send: voice * 5 })) {
        addControl(name + '_' + voice, value);
    }
}
for (const [name, value] of Object.entries({
    fx_enabled: 1, fx_mode: 1, fx_tone: -8, fx_distortion: 34, fx_echo: 60, fx_time_ms: 500, fx_repeats: 77, fx_space: 12, fx_decay: 3.2,
    pitch_scale: 5, master: -5, global_speed: 1, speed_mode: 0, pitch_lock: 0,
})) addControl(name, value);
for (let i = 1; i <= 8; i++) addControl('pattern_' + i, 0);
for (const name of ['pattern_store', 'pattern_status', 'set_status', 'pattern_save_dialog', 'pattern_load_dialog',
                    'set_save_dialog', 'set_open_dialog', 'set_relink_dialog', 'set_writer',
                    'pattern_transition_command', 'pattern_transition_sample', 'stereo_field_canvas']) addControl(name, 0);
const fxGesture = { axes: [0, 3], duration: 100, samples: [{ time: 0, x: -100, y: 0 }, { time: 100, x: 100, y: 100 }] };
const fieldGesture = { duration: 300, samples: [{ time: 0, pan: -90, level: 12 }, { time: 150, pan: 90, level: 90 }] };
function gesturePad(initial, empty) {
    let gesture = initial;
    return {
        gesture_snapshot: () => structuredClone(gesture),
        gesture_restore: saved => { gesture = structuredClone(saved ?? empty); },
    };
}
const fxPad = gesturePad(fxGesture, null);
const fieldPad = gesturePad([fieldGesture, null, null, fieldGesture], [null, null, null, null]);
controls.stereo_field_canvas.js = fieldPad;
controls.fx_pad_panel = { subpatcher: () => ({ getnamed: () => ({ js: fxPad }) }) };

const named = name => {
    if (name === 'source_control') return source;
    if (name === 'sequence_control') return sequencer;
    if (name === 'patchbay') return { subpatcher: () => ({ getnamed: () => router }) };
    if (name === 'mix_fx') return { subpatcher: () => ({ getnamed: key => controls[key] }) };
    if (name === 'drifting_memory') return { subpatcher: () => ({ getnamed: key => controls['drifting.' + key] }) };
    if (name === 'mixer_control') return mixer;
    if (name === 'stereo_field_panel') return { subpatcher: () => ({ getnamed: () => controls.stereo_field_canvas }) };
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
const field = vm.createContext({ patcher: { getnamed: named }, Global: function () {},
    Task: function () {}, arrayfromargs: args => Array.from(args) });
vm.runInContext(readFileSync(join(__dirname, '..', 'max', 'fk_source.js'), 'utf8'), field);
for (const fn of ['field_presets_snapshot', 'field_presets_valid', 'field_presets_restore']) sourceState[fn] = field[fn];
for (const [key, , , initial] of host.DRIFT_CONTROLS) addControl('drifting.' + key, initial);
controls['drifting.drift_enabled'].value = 1;
controls['drifting.drift_mix'].value = 48;
controls['drifting.feedback'].value = 91;

host.loadbang();
assert.equal(controls.pattern_2.text, '2');
assert.equal(controls.pattern_store.text, 'Store pattern');
assert.equal(host.bankDirty, false);
assert.equal(host.sequence_has_slot(2), false);
sequenceState.running = true;
host.slot(2);
assert.match(controls.pattern_status.value, /empty/);
assert.equal(sequenceState.running, true);
host.toggle_store();
assert.equal(controls.pattern_store.text, 'Cancel store');
host.toggle_store();
assert.equal(controls.pattern_store.text, 'Store pattern');
host.slot(2);
assert.equal(controls.pattern_2.text, '2');
host.toggle_store();
host.slot(2);
assert.equal(controls.pattern_2.text, '2 •');
assert.equal(sequenceState.refreshes, 1);
assert.equal(host.sequence_has_slot(2), true);
assert.equal(host.sequence_has_slot('2'), false);
assert.equal(host.sequence_has_slot(2.5), false);
assert.equal(host.sequence_has_slot(0), false);
assert.equal(sequenceState.running, true);
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
assert.equal(Object.hasOwn(bank, 'sequence'), false);
assert.equal(bank.slots[1].windows[1].rate, 0.5);
assert.equal(bank.slots[1].windows[1].echo_send, 20);
assert.equal(bank.slots[1].windows[1].room_send, 10);
assert.equal(bank.slots[1].effects.fx_mode, 1);
assert.equal(bank.slots[1].drifting.feedback, 91);
assert.equal(bank.slots[1].pitchScale, 5);
assert.deepEqual(bank.slots[1].mixerMutes, [0, 1, 0, 1]);
assert.equal(bank.slots[1].mixerSolos, undefined);
assert.deepEqual(bank.slots[1].curves, initialCurves);
assert.equal(bank.slots[1].gains[roomSendRoute], -20);
assert.equal(bank.slots[1].globalGains[lastLegacyGlobalRoute], -35);
assert.equal(bank.slots[1].globalGains[lastDriftRoute], 60);
assert.deepEqual(bank.slots[1].selection, { window: 3, lfo: 7, target: 7 });

sourceState.positions[1][0] = 26;
modState.curves[0][1] = 0;
modState.gains[0] = 100;
modState.gains[fourthLoopLevel] = 25;
modState.gains[lastLegacyLoopRoute] = 0;
modState.gains[roomSendRoute] = 0;
modState.globalGains[0] = 10;
modState.globalGains[lastLegacyGlobalRoute] = 0;
modState.globalGains[lastDriftRoute] = 0;
modState.rates[7] = 5;
modState.shapes[7] = 1;
modState.currentLfo = 0;
modState.selected = 0;
modState.targetIndex = 0;
controls.rate_2.value = 2;
controls.master.value = -40;
controls.fx_echo.value = 1;
controls.fx_mode.value = 0;
controls.echo_send_2.value = 1;
controls.room_send_2.value = 3;
controls['drifting.feedback'].value = 20;
controls['drifting.drift_enabled'].value = 0;
controls.pitch_scale.value = 0;
sourceState.normalPlaying = true;
host.slot(2);
assert.equal(sequenceState.running, false);
assert.deepEqual(sourceState.positions[1], [19, 37]);
assert.deepEqual(sourceState.playing, [true, false, true, false]);
assert.equal(sourceState.normalPlaying, false);
assert.equal(sourceState.path, '/test/audio.wav');
assert.deepEqual(modState.curves, initialCurves);
assert.equal(modState.gains[0], 0);
assert.equal(modState.gains[fourthLoopLevel], -100);
assert.equal(modState.gains[lastLegacyLoopRoute], 42);
assert.equal(modState.gains[roomSendRoute], -20);
assert.equal(modState.globalGains[0], 0);
assert.equal(modState.globalGains[lastLegacyGlobalRoute], -35);
assert.equal(modState.globalGains[lastDriftRoute], 60);
assert.equal(modState.rates[7], 19);
assert.equal(modState.shapes[7], 5);
assert.equal(modState.currentLfo, 7);
assert.equal(modState.selected, 3);
assert.equal(modState.targetIndex, 7);
assert.equal(controls.rate_2.value, 0.5);
assert.equal(controls.master.value, -5);
assert.equal(controls.fx_echo.value, 60);
assert.equal(controls.fx_mode.value, 1);
assert.equal(controls.echo_send_2.value, 20);
assert.equal(controls.room_send_2.value, 10);
assert.equal(controls['drifting.drift_enabled'].value, 1);
assert.equal(controls['drifting.feedback'].value, 91);
assert.equal(controls.pitch_scale.value, 5);
assert.deepEqual(mixerState.mutes, [0, 1, 0, 1]);
assert.deepEqual(mixerState.solos, [0, 0, 0, 0]);
host.slot(2);
assert.equal(controls.pattern_2.text, '2 •');
assert.deepEqual(controls.pattern_2.background, selectedBackground);
sequenceState.running = true;
controls.rate_2.value = 2;
host.sequence_recall(1);
assert.equal(controls.rate_2.value, 2);
host.sequence_recall(2);
assert.equal(controls.rate_2.value, 0.5);
assert.equal(sequenceState.running, true);

mixerState.solos[0] = 1;
sequenceState.data = structuredClone(programmedSequence);
host.reset();
assert.equal(sequenceState.running, false);
assert.deepEqual(sequenceState.data, programmedSequence);
assert.deepEqual(sourceState.positions, [[0, 25], [25, 50], [50, 75], [75, 100]]);
assert.deepEqual(sourceState.playing, [false, false, false, false]);
assert.equal(sourceState.path, '/test/audio.wav');
assert.equal(controls.rate_2.value, 1);
assert.equal(controls.fx_enabled.value, 0);
assert.equal(controls.fx_mode.value, 0);
assert.equal(controls.echo_send_2.value, 0);
assert.equal(controls.room_send_2.value, 0);
assert.equal(controls['drifting.drift_enabled'].value, 0);
assert.equal(controls['drifting.drift_mix'].value, 35);
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
const refreshesAfterStore = sequenceState.refreshes;
controls.rate_2.value = 0.75;
host.slot(4, 1);
assert.equal(controls.pattern_status.value, 'Pattern 4 replaced · bank unsaved');
assert.equal(sequenceState.refreshes, refreshesAfterStore);
controls.rate_2.value = 1;
host.slot(4, 0);
assert.equal(controls.rate_2.value, 0.75);
assert.equal(controls.pattern_status.value, 'Pattern 4 recalled · bank unsaved');
controls.rate_2.value = 1;
sequenceState.running = true;
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
assert.equal(sequenceState.running, true);
failTextRead = true;
host.read_bank('/test/bank.json');
assert.equal(sequenceState.running, false);
assert.equal(sequenceState.refreshes, refreshesAfterStore + 1);
assert.deepEqual(sequenceState.data, programmedSequence);
assert.equal(controls.pattern_4.text, '4');
assert.equal(controls.pattern_2.text, '2 •');
assert.equal(controls.rate_2.value, 1);
assert.deepEqual(mixerState.mutes, [0, 0, 0, 0]);
host.slot(2);
assert.equal(controls.rate_2.value, 0.5);
assert.equal(modState.gains[fourthLoopLevel], -100);
assert.equal(modState.gains[lastLegacyLoopRoute], 42);
assert.deepEqual(modState.curves, initialCurves);
assert.equal(controls.pitch_scale.value, 5);
assert.deepEqual(mixerState.mutes, [0, 1, 0, 1]);

const oldLoopGains = bank.slots[1].gains.filter((_, index) => index % loopTargetCount < 9);
const oldGlobalGains = bank.slots[1].globalGains.filter((_, index) => index % globalTargetCount < 8);
const oldV2Pattern = { ...bank.slots[1], gains: oldLoopGains };
delete oldV2Pattern.pitchScale;
delete oldV2Pattern.mixerMutes;
delete oldV2Pattern.globalGains;
delete oldV2Pattern.drifting;
oldV2Pattern.effects = { ...oldV2Pattern.effects };
delete oldV2Pattern.effects.fx_mode;
oldV2Pattern.windows = oldV2Pattern.windows.map(({ echo_send, room_send, ...window }) => window);
const oldV2Slots = bank.slots.slice();
oldV2Slots[1] = oldV2Pattern;
oldV2Slots[2] = { ...oldV2Pattern, globalGains: oldGlobalGains };
files.set('/test/old-v2.json', JSON.stringify({ ...bank, slots: oldV2Slots }));
host.read_bank('/test/old-v2.json');
assert.match(controls.pattern_status.value, /Bank loaded/);
host.slot(2);
assert.equal(controls.pitch_scale.value, 0);
assert.equal(controls.fx_mode.value, 0);
assert.equal(controls.echo_send_2.value, 0);
assert.equal(controls.room_send_2.value, 0);
assert.equal(controls['drifting.drift_enabled'].value, 0);
assert.equal(controls['drifting.drift_mix'].value, 35);
assert.deepEqual(mixerState.mutes, [0, 0, 0, 0]);
assert.equal(modState.gains[secondLfoStart], 25);
assert.equal(modState.gains[fourthLoopLevel], -100);
assert.equal(modState.gains[lastLegacyLoopRoute], 42);
assert.equal(modState.gains[roomSendRoute], 0);
assert(modState.globalGains.every(value => value === 0));
host.slot(3);
assert.equal(modState.globalGains[lastLegacyGlobalRoute], -35);
assert.equal(modState.globalGains[lastDriftRoute], 0);

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
    globalGains: [...Array(23).fill(0), 47],
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
const migratedGains = Array(4 * 8 * loopTargetCount).fill(0);
migratedGains[secondLfoStart] = 25;
migratedGains[loopRoute(2, 1, 3)] = 31;
migratedGains[loopRoute(3, 2, 8)] = -18;
migratedGains[fourthLoopLevel] = -100;
assert.deepEqual(modState.gains, migratedGains);
const migratedGlobals = Array(8 * globalTargetCount).fill(0);
migratedGlobals[globalRoute(3, 8)] = 47;
assert.deepEqual(modState.globalGains, migratedGlobals);
host.write_bank('/test/migrated.json');
const migratedBank = JSON.parse(files.get('/test/migrated.json'));
assert.equal(migratedBank.version, 2);
assert.deepEqual(migratedBank.slots[7].gains, migratedGains);
assert.deepEqual(migratedBank.slots[7].globalGains, migratedGlobals);

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

console.log('PASS pattern store, pitch snap, mixer mutes, and route migration for v1 and v2 banks');

host.read_bank('/test/bank.json');
modState.selected = 4;
modState.targetIndex = 21;
modState.globalGains[lastDriftRoute] = -75;
modState.gains[roomSendRoute] = -22;
sourceState.path = '/test/sets/Écho.wav';
controls.pan_1.value = -62;
host.slot(1, 1);
field.field_preset_slot(1, 1);
controls.pan_1.value = 37;
field.field_preset_arm();
field.field_preset_slot(4, 0);
field.field_preset_slot(1, 0);
assert.equal(controls.pan_1.value, -62);
assert(messages.some(message => message[0] === 'stereo_field_canvas' && message[1] === 'stop_motion'));
field.field_preset_slot(4, 0);
assert.equal(controls.pan_1.value, 37);
sequenceState.running = true;
controls.global_speed.value = 0.75;
controls.speed_mode.value = 1;
controls.pitch_lock.value = 1;
host.write_set('/test/sets/First.json');
assert.equal(sequenceState.running, true);
const [, , stage, destination] = messages.at(-1);
assert.equal(controls.pattern_status.value, 'Pattern 1 stored · bank unsaved');
assert.equal(controls.set_status.value, 'Saving First.json…');
const set = JSON.parse(files.get(stage));
assert.equal(set.source.path, sourceState.path);
assert.equal(set.source.relative, 'Écho.wav');
assert.equal(set.slots[0].windows[0].pan, -62);
assert.equal(set.current.windows[0].pan, 37);
assert.deepEqual(set.sequence, programmedSequence);
assert.deepEqual(set.globalSpeed, [0.75, 1]);
assert.equal(set.pitchLock, 1);
assert.deepEqual(set.fieldPresets, [
    [-62, ...set.current.windows.flatMap(w => [w.pan, w.level]).slice(1)],
    null, null, set.current.windows.flatMap(w => [w.pan, w.level]),
]);
assert.equal(set.current.effects.fx_distortion, 34);
assert.deepEqual(set.gestures, { fx: fxGesture, field: [fieldGesture, null, null, fieldGesture] });
assert.equal(set.current.gains[roomSendRoute], -22);
assert.equal(set.current.globalGains[lastDriftRoute], -75);
assert.equal(set.current.selection.globalTarget, 21);
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
field.field_preset_slot(1, 1);
host.set_written(1, concurrentStage);
assert.equal(controls.pattern_status.value, 'Pattern 3 stored · bank unsaved');
assert.equal(controls.set_status.value, 'Set saved · Concurrent.json');
assert.equal(host.bankDirty, true);
sequenceState.data = structuredClone(changedSequence);
sequenceState.running = true;
for (const invalid of [null, { ...programmedSequence, bpm: 0 }]) {
    const previousSource = requestedSource;
    files.set('/relocated/Invalid.json', JSON.stringify({ ...set, sequence: invalid }));
    host.read_set('/relocated/Invalid.json');
    assert.equal(requestedSource, previousSource);
    assert.deepEqual(sequenceState.validations.at(-1), invalid);
    assert.match(controls.set_status.value, /Couldn’t open/);
    assert.equal(sequenceState.running, true);
}
for (const invalid of [null, [null], [[0, 900, 0, 40, 0, 40, 0, 40], null, null, null]]) {
    const previousSource = requestedSource;
    files.set('/relocated/Invalid.json', JSON.stringify({ ...set, fieldPresets: invalid }));
    host.read_set('/relocated/Invalid.json');
    assert.equal(requestedSource, previousSource);
    assert.match(controls.set_status.value, /Couldn’t open/);
}
controls.fx_distortion.value = 0;
fxPad.gesture_restore(null);
fieldPad.gesture_restore(null);
for (const invalid of [
    null,
    { ...set.gestures, fx: { ...fxGesture, axes: [0, 0] } },
    { ...set.gestures, fx: { ...fxGesture, samples: [{ time: 0, x: 0, y: -1 }] } },
    { ...set.gestures, field: [{ ...fieldGesture, duration: 149 }, null, null, null] },
]) {
    files.set('/relocated/Invalid.json', JSON.stringify({ ...set, gestures: invalid }));
    host.read_set('/relocated/Invalid.json');
    assert.match(controls.set_status.value, /Couldn’t open/);
}
host.read_set('/relocated/First.json');
assert.equal(requestedSource, '/relocated/Écho.wav');
assert.deepEqual(sequenceState.validations.at(-1), programmedSequence);
assert.deepEqual(sequenceState.data, changedSequence);
assert.equal(sequenceState.restores.length, 0);
assert.equal(controls.pan_1.value, 9);
assert.equal(controls.set_status.value, 'Opening First.json…');
controls.global_speed.value = 1.25;
controls.speed_mode.value = 0;
controls.pitch_lock.value = 0;
host.set_source_loaded(0);
assert.equal(controls.global_speed.value, 1.25);
assert.equal(controls.pitch_lock.value, 0);
assert.equal(controls.speed_mode.value, 0);
assert.equal(fxPad.gesture_snapshot(), null);
assert.deepEqual(fieldPad.gesture_snapshot(), [null, null, null, null]);
assert.equal(field.field_presets_snapshot()[0][0], 9);
assert.equal(controls.pattern_3.text, '3 •');
assert.equal(controls.pan_1.value, 9);
assert.equal(controls.pattern_status.value, 'Pattern 3 stored · bank unsaved');
assert.match(controls.set_status.value, /Couldn’t load/);
assert.deepEqual(sequenceState.data, changedSequence);
assert.equal(sequenceState.running, true);
assert.equal(sequenceState.restores.length, 0);
host.read_set('/relocated/First.json');
host.set_source_loaded(1);
assert.deepEqual(JSON.parse(JSON.stringify(field.field_presets_snapshot())), set.fieldPresets);
assert.equal(controls.fx_distortion.value, 34);
assert.deepEqual(fxPad.gesture_snapshot(), set.gestures.fx);
assert.equal(controls.global_speed.value, 0.75);
assert.equal(controls.speed_mode.value, 1);
assert.equal(controls.pitch_lock.value, 1);
assert.deepEqual(fieldPad.gesture_snapshot(), set.gestures.field);
assert.deepEqual(sequenceState.restores, [{ data: programmedSequence, pan: 37, slot3: false }]);
assert.deepEqual(sequenceState.data, programmedSequence);
assert.equal(sequenceState.running, false);
assert.equal(controls.pattern_3.text, '3');
assert.equal(controls.pan_1.value, 37);
assert.equal(controls.pattern_status.value, 'Click to recall. Shift-click to store.');
assert.equal(controls.set_status.value, 'Set opened · First.json');
assert.equal(modState.gains[roomSendRoute], -22);
assert.equal(modState.globalGains[lastDriftRoute], -75);
assert.equal(modState.targetIndex, 21);
host.slot(1);
assert.equal(controls.pan_1.value, -62);
assert.equal(controls.set_status.value, 'Set opened · First.json');
assert.equal(controls.global_speed.value, 0.75);
assert.equal(controls.speed_mode.value, 1);
assert.equal(controls.pitch_lock.value, 1);

files.delete('/relocated/Écho.wav');
sequenceState.data = structuredClone(changedSequence);
sequenceState.running = true;
host.read_set('/relocated/First.json');
assert.deepEqual(messages.at(-1), ['set_relink_dialog', 'bang']);
host.cancel_relink();
assert.equal(controls.pan_1.value, -62);
assert.equal(controls.set_status.value, 'Open Set canceled.');
assert.deepEqual(sequenceState.data, changedSequence);
assert.equal(sequenceState.running, true);
host.read_set('/relocated/First.json');
host.relink_set('/test/replacement.wav');
assert.equal(requestedSource, '/test/replacement.wav');
host.set_source_loaded(1);
assert.equal(controls.pan_1.value, 37);
assert.deepEqual(sequenceState.data, programmedSequence);
assert.equal(sequenceState.running, false);
const { sequence: ignoredSequence, fieldPresets: ignoredFieldPresets, gestures: ignoredGestures, globalSpeed: ignoredSpeed, pitchLock: ignoredPitchLock, ...olderSet } = set;
const { fx_distortion: ignoredDistortion, ...olderEffects } = olderSet.current.effects;
olderSet.current = { ...olderSet.current, effects: olderEffects, gains: oldLoopGains, globalGains: oldGlobalGains,
                     selection: { window: 0, lfo: 7, target: 0, globalTarget: 7 } };
olderSet.slots = olderSet.slots.slice();
olderSet.slots[0] = { ...olderSet.slots[0], gains: oldLoopGains, globalGains: oldGlobalGains,
                      selection: { window: 0, lfo: 7, target: 0, globalTarget: 7 } };
files.set('/test/sets/Older.json', JSON.stringify(olderSet));
files.set('/test/sets/Écho.wav', 'sample');
const validatedSequences = sequenceState.validations.length;
host.read_set('/test/sets/Older.json');
assert.equal(sequenceState.validations.length, validatedSequences);
assert.deepEqual(sequenceState.data, programmedSequence);
host.set_source_loaded(1);
assert.equal(controls.fx_distortion.value, 0);
assert.equal(controls.global_speed.value, 1);
assert.equal(controls.pitch_lock.value, 0);
assert.equal(controls.speed_mode.value, 0);
assert.deepEqual(Array.from(field.field_presets_snapshot()), [null, null, null, null]);
assert.equal(fxPad.gesture_snapshot(), null);
assert.deepEqual(fieldPad.gesture_snapshot(), [null, null, null, null]);
assert.equal(sequenceState.restores.at(-1).data, undefined);
assert.deepEqual(sequenceState.data, blankSequence);
assert.equal(sequenceState.running, false);
assert.equal(modState.gains[fourthLoopLevel], -100);
assert.equal(modState.gains[lastLegacyLoopRoute], 42);
assert.equal(modState.gains[roomSendRoute], 0);
assert.equal(modState.globalGains[lastLegacyGlobalRoute], -35);
assert.equal(modState.globalGains[lastDriftRoute], 0);
assert.equal(modState.targetIndex, 7);
modState.gains[fourthLoopLevel] = 0;
modState.gains[roomSendRoute] = 19;
modState.globalGains[lastLegacyGlobalRoute] = 0;
modState.globalGains[lastDriftRoute] = 15;
host.slot(1);
assert.equal(modState.gains[fourthLoopLevel], -100);
assert.equal(modState.gains[roomSendRoute], 0);
assert.equal(modState.globalGains[lastLegacyGlobalRoute], -35);
assert.equal(modState.globalGains[lastDriftRoute], 0);
recorderState.state = 'recording';
host.open_set();
assert.match(controls.set_status.value, /Stop recording/);
console.log('PASS Set round-trip, Stereo Field presets, transactional sequence restore, older Sets, relocation, relink and cancel');

sourceState.audioOn = true;
sourceState.playing[0] = true;
controls.pan_1.value = 13;
host.slot(2, 1);
controls.pan_1.value = 37;
host.slot(1);
assert.equal(controls.pan_1.value, 37);
assert.deepEqual(messages.slice(-2), [
    ['pattern_transition_command', 1],
    ['pattern_transition_sample', 'start'],
]);
sequenceState.running = true;
host.sequence_recall(2);
assert.equal(sequenceState.running, true);
assert.equal(controls.pan_1.value, 37);
host.recall_phase(2);
assert.equal(controls.pan_1.value, 37);
host.recall_phase(1);
assert.equal(controls.pan_1.value, 13);
host.release_recall_tail();
assert.deepEqual(messages.at(-1), ['pattern_transition_command', 0]);
host.slot(2);
host.slot(1);
assert.equal(controls.pan_1.value, 13);
host.recall_phase(0);
assert.deepEqual(messages.slice(-2), [
    ['pattern_transition_command', 1],
    ['pattern_transition_sample', 'start'],
]);
host.recall_phase(1);
assert.equal(controls.pan_1.value, -62);
sourceState.playing.fill(false);
host.transport_stopped();
assert.deepEqual(messages.at(-1), ['pattern_transition_command', -1]);
host.release_recall_tail();
assert.deepEqual(messages.at(-1), ['pattern_transition_command', -1]);
host.recall_phase(0);
host.slot(2);
assert.equal(controls.pan_1.value, 13);
assert.equal(host.recallStage, 'idle');
sourceState.playing[0] = true;
host.slot(1);
sourceState.audioOn = false;
host.recall_dsp(0);
assert.equal(controls.pan_1.value, -62);
assert.deepEqual(messages.at(-1), ['pattern_transition_command', 2]);
host.recall_phase(1);
assert.equal(controls.pan_1.value, -62);
console.log('PASS buffered recall waits for DSP, queues the latest click and recovers on transport and DSP stops');

// Built-in references are portable; older Sets keep the original demo reference.
recorderState.state = 'idle';
for (const id of ['glass-circuit', 'tidal-lanterns']) {
    const reference = { kind: 'builtin', id };
    sourceState.get_set_source = () => reference;
    const destination = '/test/sets/' + id + '.json';
    host.write_set(destination);
    const stage = messages.at(-1)[2];
    assert.deepEqual(JSON.parse(files.get(stage)).source, reference);
    files.set(destination, files.get(stage));
    host.set_written(1, stage);
    host.read_set(destination);
    assert.deepEqual(messages.at(-1), ['source_control', 'open_set_demo', id]);
    host.set_source_loaded(1);
    assert.equal(controls.set_status.value, 'Set opened · ' + id + '.json');
}
files.set('/test/sets/Invalid demo.json', JSON.stringify({ ...set, source: { kind: 'builtin', id: 'unknown' } }));
host.read_set('/test/sets/Invalid demo.json');
assert.match(controls.set_status.value, /Couldn’t open/);
assert.equal(host.pendingSet, null);
files.set('/test/sets/Original demo.json', JSON.stringify({ ...set, source: { kind: 'demo' } }));
host.read_set('/test/sets/Original demo.json');
assert.deepEqual(messages.at(-1), ['source_control', 'open_set_demo']);
host.set_source_loaded(1);
assert.equal(controls.set_status.value, 'Set opened · Original demo.json');
console.log('PASS portable built-in and original demo Set references');
