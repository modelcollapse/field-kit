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
    ...Array.from({ length: 8 }, (_, slot) =>
        [`loop_buffer_${slot}`, { frames: 1, channels: 1, rate: 44100 }]),
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
const displayed = name => trace.filter(([target, selector]) => target === name && selector === 'set').at(-1)?.[2];

host.initialize();
advance(100);
host.source_loaded(44100);
assert.equal(host.get_set_source().kind, 'demo');
assert.equal(displayed('input_record_state'), 'Enable audio to record');

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
assert.equal(displayed('input_record_state'), 'Ready to record');

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
assert.equal(displayed('input_record_state'), 'Starting…');
assert.equal(displayed('input_record_time'), '00:00.0');
assert(sent('input_clock', 'start'));

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
assert.equal(displayed('input_record_state'), 'Preparing take…');
assert(sent('input_progress', 'bang'));
assert(indexOf('input_recorder', 0) < indexOf('input_progress', 'bang'));
host.input_record_progress(0);
advance(100);
assert(!bound(), 'an empty recording leaves the current source bound');
assert.equal(host.get_set_source().path, fixturePath);
assert.equal(displayed('input_record_state'), 'Ready to record');

trace.length = 0;
host.toggle_input_record();
host.toggle_input_record();
advance(1000);
assert(!bound(), 'a missing progress reply leaves the current source bound');
assert.equal(host.get_set_source().path, fixturePath);
assert.equal(displayed('input_record_state'), 'Ready to record');

trace.length = 0;
host.toggle_input_record();
assert(sent('input_recorder', 1), 'a missing progress reply allows another take');
assert.equal(displayed('input_record_time'), '00:00.0');
host.input_elapsed_phase(0);
assert.equal(displayed('input_record_state'), 'Starting…');
host.input_elapsed_phase(0.05);
assert.equal(displayed('input_record_state'), '● RECORDING');
assert.equal(displayed('input_record_time'), '00:03.0');
host.input_elapsed_phase(0.025);
assert.equal(displayed('input_record_time'), '00:03.0', 'the elapsed clock never runs backward');

host.stop_all();
assert(sent('run_1', 0), 'Stop all stops the loops during capture');
assert.equal(displayed('input_record_state'), '● RECORDING');
host.play_all();
assert(sent('run_1', 1), 'Play all starts the loops during capture');
host.play_normal();
assert(sent('normal_voice', 'start'), 'Play normal starts the current sample during capture');
assert(!sent('input_recorder', 0), 'loop transport does not stop recording');
assert.equal(displayed('input_record_state'), '● RECORDING');

host.toggle_input_record();
host.input_elapsed_phase(0.1);
assert.equal(displayed('input_record_time'), '00:03.0', 'stopped capture ignores further clock samples');
assert.deepEqual(trace.filter(([target]) => target === 'input_clock'), [
    ['input_clock', 'start'], ['input_clock', 'stop'],
]);
const capturedSeconds = 3.125;
host.input_record_progress(capturedSeconds / 60);
const trim = trace.find(([target, selector]) => target === 'set_buffer' && selector === 'crop_samples');
assert(trim, 'recorded audio is cropped before becoming the source');
assert.equal(trim[2], 0);
assert(Math.abs(trim[3] - capturedSeconds * sampleRate) <= 1, 'trim tracks the recorded frame count');
assert(!bound(), 'playing voices are released before switching buffers');
assert.equal(host.get_set_source().path, fixturePath);
assert.equal(displayed('input_record_state'), 'Preparing take…');
advance(100);
assert(sent('normal_voice', 'set', 'field-kit-set-source-1'));
for (let voice = 1; voice <= 4; voice++) {
    assert(sent(`voice_${voice}`, 'source', 'field-kit-set-source-1'));
    assert(sent(`wave_${voice}`, 'set', 'field-kit-set-source-1'));
}
assert(sent('source_rate_1', sampleRate));
assert(sent('normal_right_channel', 2));
assert(Math.abs(regions.at(-1)[2] - trim[3] * 1000 / sampleRate) < 1e-9);
assert.equal(host.get_set_source(), null, 'an unsaved recording has no Set file path');
assert.equal(displayed('input_record_state'), 'Ready to record');
const stoppedTime = displayed('input_record_time');
host.input_elapsed_phase(0.15);
assert.equal(displayed('input_record_state'), 'Ready to record', 'a late clock sample cannot restart the marker');
assert.equal(displayed('input_record_time'), stoppedTime, 'a late clock sample cannot change a finished take time');

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
host.dsp_enabled(0);
assert(sent('input_recorder', 0), 'turning off DSP stops capture');
assert.equal(displayed('input_record_state'), 'Preparing take…');
host.input_record_progress(0);
assert.equal(displayed('input_record_state'), 'Enable audio to record');

host.dsp_enabled(1);
host.play_all();
host.set_loop_destination(5);
trace.length = 0;
host.toggle_loop_record();
host.set_loop_destination(2);
assert(sent('loop_destination', 'set', 5), 'a take keeps the destination chosen at record start');
host.toggle_loop_record();
host.input_record_progress(0.05);
advance(100);
assert(host.playing.every(Boolean));
assert(host.loopSources.every(source => source === null), 'recorded audio waits for confirmation');
assert(sent('take_confirm', 'text', 'Use on all loops'));
host.confirm_loop_audio();
advance(40);
const shared = host.loopSources[0];
assert(shared && host.loopSources.every(source => source === shared));
assert.deepEqual(JSON.parse(JSON.stringify(host.positions)), [[0, 25], [25, 50], [50, 75], [75, 100]]);
assert(host.playing.every(Boolean));

host.set_loop_destination(3);
host.import_loop_audio();
host.inspect_window(0);
host.stage_loop_file(fixturePath);
host.loop_buffer_ready(host.loopPending.slot, 44100);
assert(sent('take_confirm', 'text', 'Use on Loop 3'));
assert(host.loopSources.every(source => source === shared), 'an import leaves the old audio in place');
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
assert.equal(host.inputTake.voice, 2, 'the explicit record target is independent of the editor');
host.toggle_loop_record();
host.input_record_progress(0.05);
advance(100);
assert(sent('take_confirm', 'text', 'Use on Loop 2'));
host.discard_loop_audio();
assert.equal(host.loopSources[1], shared);
assert(host.playing.every(Boolean));

console.log('Verified Field Kit input routing, recording indicator, playback independence, and saved Set paths.');
