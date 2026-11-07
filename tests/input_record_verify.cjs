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
]);
const sampleRate = 48000;
const capacity = sampleRate * 60;
const fixturePath = '/fixture/Already Loaded.wav';
const takePath = '/fixture/Input Take.wav';
let now = 0;

function message(target, ...args) {
    trace.push([target, ...args]);
    const buffer = buffers.get(target);
    if (!buffer) return;
    const [selector, first, second] = args;
    switch (selector) {
        case 'name':
            namedBuffers.set(first, buffer);
            break;
        case 'sr':
            buffer.rate = first;
            break;
        case 'sizeinsamps':
            buffer.frames = first;
            buffer.channels = second ?? buffer.channels;
            break;
        case 'crop_samples':
            buffer.frames = second - first;
            break;
        case 'replace':
            Object.assign(buffer, { frames: 352800, channels: 2, rate: 44100 });
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
const bound = () => trace.some(([target, selector]) => target === 'normal_voice' && selector === 'set');

host.initialize();
advance(100);
host.source_loaded(44100);
assert.equal(host.get_set_source().kind, 'demo');

trace.length = 0;
host.input_sample_rate(sampleRate);
host.input_channel_count(8);
host.toggle_input_record();
assert(!sent('input_recorder', 1), 'recording requires the audio engine');
host.dsp_enabled(1);

host.input_channel_count(0);
host.toggle_input_record();
assert(!sent('input_recorder', 1), 'recording requires an available input channel');
trace.length = 0;
host.input_channel_count(8);
for (const menu of ['input_left', 'input_right']) {
    assert(sent(menu, 'clear'));
    for (let channel = 1; channel <= 8; channel++) assert(sent(menu, 'append', channel));
}

host.open_source(fixturePath);
host.toggle_input_record();
assert(!sent('input_recorder', 1), 'recording must wait for the pending file load');
advance(40);
assert(sent('buffer', 'replace', fixturePath));
host.source_loaded(44100);
assert.equal(host.get_set_source().path, fixturePath);

trace.length = 0;
host.set_input_channel(1, 4);
host.set_input_channel(2, 7);
assert(sent('input_adc', 'set', 1, 5), 'left outlet records interface channel 5');
assert(sent('input_adc', 'set', 2, 8), 'right outlet records interface channel 8');

host.play_all();
host.toggle_input_record();
assert(sent('set_buffer', 'sr', sampleRate));
assert(sent('set_buffer', 'sizeinsamps', capacity, 2));
assert(sent('set_buffer', 'clear'));
assert(sent('input_recorder', 'set', 'field-kit-set-source-1'));
assert(sent('input_recorder', 'reset'));
assert(sent('input_progress', 'bang'));
assert(sent('input_recorder', 1));
assert(indexOf('set_buffer', 'clear') < indexOf('input_recorder', 1));
assert(indexOf('input_progress', 'bang') < indexOf('input_recorder', 1));
assert(!bound(), 'the previous source remains active during capture');
assert.equal(host.get_set_source().path, fixturePath);

const beforeChannelEdits = trace.length;
host.set_input_channel(1, 2);
host.set_input_channel(2, 3);
const rejectedChannelEdits = trace.slice(beforeChannelEdits);
assert(!rejectedChannelEdits.some(([target]) => target === 'input_adc'),
    'channel selections cannot change while recording');
assert.deepEqual(rejectedChannelEdits.filter(([target]) => /^input_(left|right)$/.test(target)), [
    ['input_left', 'set', 4], ['input_right', 'set', 7],
]);

host.open_source('/fixture/Concurrent.wav');
host.open_set_source('/fixture/Concurrent Set.wav');
advance(40);
assert(!trace.some(([, selector]) => selector === 'replace'), 'file loads cannot take over a recording buffer');

trace.length = 0;
host.toggle_input_record();
assert(sent('input_recorder', 0));
assert(sent('input_progress', 'bang'));
assert(indexOf('input_recorder', 0) < indexOf('input_progress', 'bang'));
host.input_record_progress(0);
advance(100);
assert(!bound(), 'an empty recording leaves the current source bound');
assert.equal(host.get_set_source().path, fixturePath);

trace.length = 0;
host.toggle_input_record();
host.toggle_input_record();
advance(1000);
assert(!bound(), 'a missing progress reply leaves the current source bound');
assert.equal(host.get_set_source().path, fixturePath);

trace.length = 0;
host.toggle_input_record();
assert(sent('input_recorder', 1), 'a missing progress reply allows another take');
host.toggle_input_record();
host.input_record_progress(2 / 60);
const trim = trace.find(([target, selector]) => target === 'set_buffer' && selector === 'crop_samples');
assert(trim, 'recorded audio is cropped before becoming the source');
assert.equal(trim[2], 0);
assert(Math.abs(trim[3] - 2 * sampleRate) <= 1, 'trim tracks the recorded frame count');
assert(!bound(), 'playing voices are released before switching buffers');
assert.equal(host.get_set_source().path, fixturePath);
advance(100);
assert(sent('normal_voice', 'set', 'field-kit-set-source-1'));
for (let voice = 1; voice <= 4; voice++) {
    assert(sent(`voice_${voice}`, 'source', 'field-kit-set-source-1'));
    assert(sent(`wave_${voice}`, 'set', 'field-kit-set-source-1'));
}
assert(sent('source_rate', sampleRate));
assert(sent('normal_right_channel', 2));
assert(Math.abs(regions.at(-1)[2] - 2000) <= 1000 / sampleRate);
assert.equal(host.get_set_source(), null, 'an unsaved recording has no Set file path');

trace.length = 0;
host.choose_input_save();
assert(sent('input_save_dialog', 'bang'));
host.save_input_path(takePath);
assert(sent('set_buffer', 'writewave', takePath));
assert.equal(host.get_set_source(), null, 'a write request is not a saved take');
files.set(takePath, wav(0));
host.set_source_read(sampleRate);
assert.equal(host.get_set_source(), null, 'an empty WAV does not become a Set source');
host.save_input_path(takePath);
files.set(takePath, wav(trim[3]));
host.source_loaded(sampleRate);
assert.equal(host.get_set_source(), null, 'the wrong buffer cannot confirm a save');
host.set_source_read(sampleRate);
advance(1000);
assert.equal(host.get_set_source().kind, 'file');
assert.equal(host.get_set_source().path, takePath);

trace.length = 0;
host.load_demo();
advance(40);
assert(trace.some(([target, selector, filename]) =>
    target === 'set_buffer' && selector === 'replace' && filename.endsWith('fk_demo.wav')));
host.set_source_read(44100);
assert.equal(host.get_set_source().kind, 'demo');

trace.length = 0;
host.input_channel_count(1);
host.set_input_channel(1, 0);
host.set_input_channel(2, 0);
assert(sent('input_adc', 'set', 1, 1), 'a one-input device uses channel 1 on the left');
assert(sent('input_adc', 'set', 2, 1), 'the same input can feed the right channel');
host.toggle_input_record();
assert(sent('input_recorder', 1), 'recording works with a single hardware input');
host.toggle_input_record();
host.input_record_progress(0);

console.log('Verified Field Kit input routing, recording, source switching, and saved Set paths.');
