const assert = require('node:assert/strict');
const { readFileSync } = require('node:fs');
const { join } = require('node:path');
const vm = require('node:vm');

let time = 10000;
let nextTick = null;
const slots = new Set();
const recalls = [];
const controls = new Map();

function control(name) {
    if (!controls.has(name)) {
        controls.set(name, { message(selector, value) { this[selector] = value; } });
    }
    return controls.get(name);
}

const source = {
    js: { ready: true, playing: [true] },
    message(selector) { assert.equal(selector, 'play_all'); },
};
const patterns = {
    js: { sequence_has_slot: slot => slots.has(slot) },
    message(selector, slot) {
        assert.equal(selector, 'sequence_recall');
        recalls.push([time, slot]);
    },
};
const host = vm.createContext({
    patcher: { getnamed(name) {
        if (name === 'source_control') return source;
        if (name === 'pattern_control') return patterns;
        if (name === 'sequence_panel') return { subpatcher: () => ({ getnamed: control }) };
        return control(name);
    } },
    Date: { now: () => time },
    Task: function (callback) {
        this.schedule = delay => { nextTick = { at: time + delay, callback }; };
        this.cancel = () => { nextTick = null; };
    },
});
vm.runInContext(readFileSync(join(__dirname, '..', 'max', 'fk_sequence.js'), 'utf8'), host);

function checkMix(current, next, bar, toggleActive, advanceActive, advanceLabel = 'Next bar') {
    assert.equal(control('mix_scene_current').set, current);
    assert.equal(control('mix_scene_next').set, next);
    assert.equal(control('mix_scene_bar').set, bar);
    assert.equal(control('mix_scene_toggle').active, toggleActive);
    assert.equal(control('mix_scene_advance').active, advanceActive);
    assert.equal(control('mix_scene_advance').text, advanceLabel);
}

function tickAt(at) {
    assert.equal(nextTick.at, at);
    const { callback } = nextTick;
    nextTick = null;
    time = at;
    callback();
}

host.loadbang();
checkMix('Now —', 'Next —', 'Bar —', 0, 0);
host.set_step(0, 2); // Empty pattern slot.
host.set_step(1, 4);
host.set_bars(1, 3);
host.set_step(3, 6);
host.set_bars(3, 2);
host.set_step(7, 8); // Empty pattern slot.
host.set_repeat(0);
checkMix('Now —', 'Next —', 'Bar —', 0, 0);

slots.add(4);
slots.add(6);
host.refresh_mix();
checkMix('Now —', 'Next 4', 'Bar —', 1, 0);
host.toggle();
assert.equal(control('mix_scene_toggle').text, 'Stop');
checkMix('Now 4', 'Next 6', 'Bar 1/3', 1, 1);
assert.match(control('seq_status').set, /Scene 4 · Bar 1\/3/);

tickAt(12000);
checkMix('Now 4', 'Next 6', 'Bar 2/3', 1, 1);
time = 12100;
host.next();
host.next();
checkMix('Now 4', 'Next 6', 'Bar 2/3', 1, 0, 'Queued');
assert.match(control('seq_status').set, /Next queued/);
assert.deepEqual(recalls, [[10000, 4]]);

tickAt(14000);
assert.deepEqual(recalls, [[10000, 4], [14000, 6]]);
checkMix('Now 6', 'End of set', 'Bar 1/2', 1, 0);
host.set_repeat(1);
checkMix('Now 6', 'Next 4', 'Bar 1/2', 1, 1);
host.set_repeat(0);
tickAt(16000);
tickAt(18000);
checkMix('Now —', 'Next 4', 'Bar —', 1, 0);
assert.equal(control('mix_scene_toggle').text, 'Start');
assert.equal(source.js.playing[0], true);
assert.match(control('seq_status').set, /Sequence complete/);
assert.equal(nextTick, null);

host.toggle();
checkMix('Now 4', 'Next 6', 'Bar 1/3', 1, 1);
host.toggle();
checkMix('Now —', 'Next 4', 'Bar —', 1, 0);
assert.match(control('seq_status').set, /Sequence stopped/);
slots.clear();
host.refresh_mix();
checkMix('Now —', 'Next —', 'Bar —', 0, 0);

console.log('PASS Mix and Scenes share scene eligibility, bar progress, and queued advance timing');
