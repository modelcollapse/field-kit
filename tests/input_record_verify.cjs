// Exercise source input capture against Max buffer, task, and file fixtures.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');

const home = path.join(__dirname, '..', 'max');
const trace = [];
const regions = [];
const tasks = new Map();
const files = new Map();
const namedBuffers = new Map();
const buffers = new Map([
    ['buffer', { frames: 1, channels: 1, rate: 44100 }],
    ['set_buffer', { frames: 1, channels: 1, rate: 44100 }],
    ['empty_loop_buffer', { frames: 1, channels: 1, rate: 44100 }],
    ...Array.from({ length: 8 }, (_, slot) =>
        [`loop_buffer_${slot}`, { frames: 1, channels: 1, rate: 44100 }]),
]);
const sampleRate = 48000;
const fixturePath = '/fixture/Already Loaded.wav';
const takePath = '/fixture/Input Take.wav';
const stagingPath = '/scratch/Field Kit Take.wav';
let now = 0;

function message(target, ...args) {
    trace.push([target, ...args]);
    const buffer = buffers.get(target);
    if (!buffer) return;
    const [selector, first] = args;
    switch (selector) {
        case 'name':
            namedBuffers.set(first, buffer);
            break;
        case 'sizeinsamps':
            buffer.frames = first;
            break;
        case 'replace':
            const recorded = files.get(first);
            Object.assign(buffer, recorded ?
                { frames: recorded.readUInt32LE(40) / 6, channels: 2, rate: sampleRate } :
                { frames: 352800, channels: 2, rate: 44100 });
            break;
    }
}

function File(filename) {
    const contents = files.get(filename);
    this.isopen = Boolean(contents);
    this.eof = contents?.length ?? 0;
    this.position = 0;
    this.byteorder = 'little';
    this.close = () => { this.isopen = false; };
    this.readstring = count => {
        const value = contents.toString('ascii', this.position, this.position + count);
        this.position += count;
        return value;
    };
    this.readint32 = count => Array.from({ length: count }, () => {
        const value = contents.readInt32LE(this.position);
        this.position += 4;
        return value;
    });
}

function wav(frames) {
    const dataSize = frames * 6;
    const contents = Buffer.alloc(44 + dataSize);
    contents.write('RIFF', 0);
    contents.writeUInt32LE(contents.length - 8, 4);
    contents.write('WAVEfmt ', 8);
    contents.writeUInt32LE(16, 16);
    contents.writeUInt16LE(1, 20);
    contents.writeUInt16LE(2, 22);
    contents.writeUInt32LE(sampleRate, 24);
    contents.writeUInt32LE(sampleRate * 6, 28);
    contents.writeUInt16LE(6, 32);
    contents.writeUInt16LE(24, 34);
    contents.write('data', 36);
    contents.writeUInt32LE(dataSize, 40);
    return contents;
}

const host = vm.createContext({
    patcher: {
        filepath: path.join(home, 'Field Kit.maxpat'),
        getnamed: target => ({
            message: (...args) => message(target, ...args),
            getattr: attr => attr === 'sr' ? buffers.get(target)?.rate : undefined,
            subpatcher: () => ({
                getnamed: control => ({ message: (...args) => message(control, ...args) }),
            }),
        }),
    },
    arrayfromargs: value => Array.from(value),
    outlet: (index, values) => regions.push([index, ...values]),
    Global: function () {},
    Buffer: function (name) {
        const buffer = namedBuffers.get(name);
        this.framecount = () => buffer.frames;
        this.channelcount = () => buffer.channels;
        this.length = () => 1000 * buffer.frames / buffer.rate;
    },
    File,
    Date: { now: () => now },
    Task: function (fn) {
        this.schedule = delay => tasks.set(this, { fn, due: now + delay });
        this.cancel = () => tasks.delete(this);
    },
});
vm.runInContext(fs.readFileSync(path.join(home, 'fk_source.js'), 'utf8'), host);

function advance(ms) {
    const end = now + ms;
    while (tasks.size) {
        const [task, event] = [...tasks].sort((first, second) => first[1].due - second[1].due)[0];
        if (event.due > end) break;
        now = event.due;
        tasks.delete(task);
        event.fn();
    }
    now = end;
}

function indexOf(...expected) {
    return trace.findIndex(actual => actual.length === expected.length &&
        actual.every((value, index) => value === expected[index]));
}

const sent = (...args) => indexOf(...args) !== -1;
const displayed = name => trace.filter(([target, selector]) => target === name && selector === 'set').at(-1)?.[2];

host.initialize();
advance(100);
host.source_loaded(44100);
assert.equal(host.get_set_source().kind, 'demo');
assert.equal(displayed('input_record_state'), 'Enable audio to record');

host.input_sample_rate(sampleRate);
host.input_channel_count(8);
host.toggle_loop_record();
assert.equal(host.inputTake, null, 'recording requires the audio engine');
host.dsp_enabled(1);
host.input_channel_count(0);
host.toggle_loop_record();
assert.equal(host.inputTake, null, 'recording requires an input channel');
trace.length = 0;
host.input_channel_count(8);
for (const menu of ['input_left', 'input_right']) {
    assert(sent(menu, 'clear'));
    for (let channel = 1; channel <= 8; channel++) assert(sent(menu, 'append', channel));
}
host.set_input_channel(1, 4);
host.set_input_channel(2, 7);
assert(sent('input_adc', 'set', 1, 5));
assert(sent('input_adc', 'set', 2, 8));

host.play_all();
host.set_loop_destination(5);
host.toggle_loop_record();
assert.equal(host.inputTake.voice, 5);
assert.equal(host.inputTake.state, 'allocating');
const request = host.inputTake.request;
assert(sent('set_writer', 'create_input_temp', request));
host.input_temp_ready(request - 1, '/scratch/expired.wav');
assert(sent('set_writer', 'remove_input_temp', '/scratch/expired.wav'));
assert(!sent('input_recorder', 1), 'a stale reply cannot start the writer');
host.input_temp_ready(request, stagingPath);
assert(sent('input_recorder', 'samptype', 'int24'));
assert(sent('input_recorder', 'open', 'wave', stagingPath));
assert(indexOf('input_recorder', 'open', 'wave', stagingPath) < indexOf('input_recorder', 1));
host.set_loop_destination(2);
assert(sent('loop_destination', 'set', 5));
host.set_input_channel(1, 2);
assert(!sent('input_adc', 'set', 1, 3), 'the input stays pinned during recording');
host.stop_all();
host.play_all();
assert(host.playing.every(Boolean), 'transport can restart while the writer is active');
host.open_source(fixturePath);
assert.equal(host.get_set_source().kind, 'demo', 'another file cannot take over the recording');
host.input_elapsed(0);
for (let seconds = 1; seconds <= 75; seconds++) {
    advance(1000);
    host.input_elapsed(seconds * 1000);
}
assert.equal(displayed('input_record_state'), 'Recording to all loops');
assert.equal(displayed('input_record_time'), '01:15.0');
assert(!sent('input_recorder', 0), 'the writer continues beyond the former limit');
assert(host.playing.every(Boolean));
assert(host.loopSources.every(source => source === null));

const frames = sampleRate * 75;
host.toggle_loop_record();
assert(sent('input_recorder', 0));
assert.equal(displayed('input_record_state'), 'Preparing take…');
advance(300);
assert.equal(host.inputTake.state, 'stopping', 'wait for a complete WAV');
files.set(stagingPath, wav(frames));
advance(150);
const slot = host.loopPending.slot;
assert.equal(host.loopPending.state, 'reading');
assert(sent(`loop_buffer_${slot}`, 'replace', stagingPath));
assert(host.playing.every(Boolean));
host.loop_buffer_ready(slot, sampleRate);
assert.equal(displayed('input_record_state'), 'Take ready · all loops');
assert(sent('set_writer', 'remove_input_temp', stagingPath));
assert(host.loopSources.every(source => source === null), 'the take waits for confirmation');
host.confirm_loop_audio();
advance(40);
const shared = host.loopSources[0];
assert.equal(shared.frames, frames);
assert(host.loopSources.every(source => source === shared));
assert(host.playing.every(Boolean));
assert.deepEqual(JSON.parse(JSON.stringify(host.positions)), [[0, 25], [25, 50], [50, 75], [75, 100]]);
assert.equal(host.get_set_loops(), null);
host.choose_input_save();
assert(sent('input_save_dialog', 'bang'));
host.save_input_path(takePath);
assert(sent(`loop_buffer_${slot}`, 'writewave', takePath));
files.set(takePath, wav(frames));
host.loop_buffer_ready(slot, sampleRate);
assert.equal(shared.path, takePath);
assert(host.get_set_loops().every(filename => filename === takePath));

host.set_loop_destination(3);
assert(sent('input_record_button', 'text', 'Record to Loop 3'));
assert(sent('load', 'text', 'Import to Loop 3…'));
host.import_loop_audio();
host.inspect_window(0);
host.stage_loop_file(fixturePath);
host.loop_buffer_ready(host.loopPending.slot, 44100);
assert.equal(displayed('input_record_state'), 'File ready · Loop 3');
assert(host.loopSources.every(source => source === shared));
host.confirm_loop_audio();
advance(40);
assert.equal(host.loopSources[2].path, fixturePath);
assert.equal(host.loopSources[0], shared);
assert.equal(host.loopSources[1], shared);
assert.equal(host.loopSources[3], shared);

host.set_loop_destination(5);
host.import_loop_audio();
host.stage_loop_file(fixturePath);
host.loop_buffer_ready(host.loopPending.slot, 44100);
host.discard_loop_audio();
assert.equal(host.loopSources[0], shared);
assert.equal(host.loopSources[2].path, fixturePath);
assert(host.playing.every(Boolean));

host.set_loop_destination(2);
host.inspect_window(3);
host.toggle_loop_record();
assert.equal(host.inputTake.voice, 2);
advance(5000);
assert.equal(host.inputTake, null, 'a missing temp response releases the recorder');
assert(host.playing.every(Boolean));
host.toggle_loop_record();
host.input_temp_ready(host.inputTake.request, '/scratch/failed.wav');
advance(4000);
assert.equal(host.inputTake, null, 'the recorder recovers if the file writer cannot start');
assert(sent('set_writer', 'remove_input_temp', '/scratch/failed.wav'));
assert.equal(host.loopSources[1], shared);
assert(host.playing.every(Boolean));

host.set_loop_destination(0);
assert(sent('input_record_button', 'text', 'Record to Loop 4'));
assert(sent('load', 'text', 'Import to Loop 4…'));
host.inspect_window(2);
host.clear_loop();
assert.equal(host.loopPending.state, 'clearing');
assert(host.playing.every(Boolean), 'clear waits for confirmation');
host.discard_loop_audio();
assert.equal(host.loopPending, null);
assert(host.playing.every(Boolean), 'cancel keeps the existing loop playing');
const fileCountBefore = files.size;
host.clear_loop();
host.confirm_loop_audio();
assert.equal(host.playing[2], false);
assert.equal(host.loopPending.state, 'switching');
advance(40);
assert.equal(host.loopSources[2], null);
assert.deepEqual([...host.get_set_cleared()], [false, false, true, false]);
assert(sent('voice_3', 'source', host.emptyBufferName));
assert.equal(files.size, fileCountBefore, 'clearing does not delete files');
assert.equal(host.loopSources[0], shared);
assert.equal(host.loopSources[1], shared);
assert.equal(host.loopSources[3], shared);
host.play_all();
assert.deepEqual([...host.playing], [true, true, false, true], 'Play all skips the empty track');
host.inspect_window(0);
host.copy_loop_to(3);
advance(40);
assert.equal(host.loopCleared[2], false, 'copying new audio fills an empty track');
assert.equal(host.loopSources[2], shared);
host.edit_play(3, 1);
assert(host.playing.every(Boolean));
host.inspect_window(3);
host.clear_loop();
host.loop_take_closed();
assert.equal(host.loopPending, null);
assert(host.playing.every(Boolean), 'closing the clear dialog cancels it');

console.log('Verified confirmed track clearing, cancellation, shared buffers, file preservation and refilling.');
console.log('Verified disk capture beyond 60 seconds, confirmation, transport, and WAV save.');
