// Exercise the delivered message-rate adapter against a small Max API fixture.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');

const home = path.join(__dirname, '..', 'max');
const trace = [];
const regions = [];
const tasks = new Map();
let frames = 352800;
let channels = 2;
const host = vm.createContext({
    patcher: {
        filepath: `${home}/Field Kit.maxpat`,
        getnamed: name => ({ message: (...args) => trace.push([name, ...args]) }),
    },
    arrayfromargs: value => Array.from(value),
    outlet: (index, values) => regions.push([index, ...values]),
    Global: function () {},
    Buffer: function () {
        this.framecount = () => frames;
        this.channelcount = () => channels;
    },
    Task: function (fn) {
        this.schedule = ms => tasks.set(fn.name, { fn, ms });
        this.cancel = () => tasks.delete(fn.name);
    },
});
vm.runInContext(fs.readFileSync(path.join(home, 'fk_source.js'), 'utf8'), host);

function runTask(name) {
    const { fn } = tasks.get(name);
    tasks.delete(name);
    fn();
}
function settleAudio() {
    host.dsp_enabled(1);
    runTask('audio_settled');
}
function sent(name, ...args) {
    return trace.some(([target, ...actual]) => target === name &&
        actual.length === args.length && actual.every((value, index) => value === args[index]));
}

host.initialize();
runTask('boot_source');
runTask('read_source');
assert(sent('buffer', 'replace', `${home}/fk_demo.wav`));
assert(sent('buffer', 'name', 'field-kit-source-1'));
assert(sent('set_buffer', 'name', 'field-kit-set-source-1'));
assert(sent('set_source_info', 'set', 'field-kit-set-source-1'));
assert(sent('source_info', 'set', 'field-kit-source-1'));
assert(sent('normal_voice', 'set', 'field-kit-source-1'));
assert(sent('voice_1', 'source', 'field-kit-source-1'));
assert(sent('voice_4', 'source', 'field-kit-source-1'));
host.source_loaded(44100);
assert.deepEqual(regions, [[0, 0, 2000], [1, 2000, 4000], [2, 4000, 6000], [3, 6000, 8000]]);
assert(sent('source_label', 'set', 'Demo   ·   8.00 s   ·   stereo'));
assert(sent('normal_right_channel', 2));
assert(sent('source_rate', 44100));
assert.equal(host.get_set_source().kind, 'demo');
assert(sent('status', 'set', 'Click Play all to hear the demo.'));
assert(!sent('dac', 'start'));
assert(!tasks.has('read_timeout'));

host.play_all();
assert(!sent('run_1', 1));
assert(sent('dac', 'start'));
assert(sent('status', 'set', 'Starting audio…'));
assert(tasks.has('audio_timeout'));
host.dsp_enabled(1);
assert(tasks.has('audio_settled'));
assert(!sent('run_1', 1));
// Max can briefly turn DSP off again while rebuilding its signal graph.
host.dsp_enabled(0);
assert(!tasks.has('audio_settled'));
assert(tasks.has('audio_timeout'));
assert(!sent('run_1', 1));
settleAudio();
assert(!tasks.has('audio_timeout'));
for (let voice = 1; voice <= 4; voice++) {
    assert(sent(`run_${voice}`, 1));
    assert(sent(`playhead_gate_${voice}`, 1));
}
assert(sent('status', 'set', '4 of 4 windows playing'));
host.edit_play(3, 0);
assert(sent('run_3', 0));
assert(sent('status', 'set', '3 of 4 windows playing'));

trace.length = 0;
host.wave_mouse(2, 0.2, 0, 1);
host.track_wave(2, 0, 8000, 2000, 2000);
host.wave_mouse(2, 0.5, 0, 2);
host.track_wave(2, 0, 8000, 2000, 4000);
assert(!tasks.has('commit_wave_edits'));
assert(!trace.some(([name]) => /^(base_start_2|base_end_2|wave_edit_revision_2)$/.test(name)));
host.wave_mouse(2, 0.6, 0, 0);
host.track_wave(2, 0, 8000, 3200, 4800);
runTask('commit_wave_edits');
assert(sent('wave_edit_revision_2', 1));
assert(sent('start_2', 'set', 40));
assert(sent('end_2', 'set', 60));
assert.deepEqual(trace.filter(([name]) => /^(base_start_2|base_end_2|wave_edit_revision_2)$/.test(name)), [
    ['wave_edit_revision_2', 1], ['base_start_2', 40], ['base_end_2', 60],
]);
trace.length = 0;
host.wave_mouse(2, 0.6, 0, 0);
runTask('commit_wave_edits');
assert(!trace.some(([name]) => name === 'wave_edit_revision_2'));
host.edit_start(2, 10);
assert.deepEqual(regions.at(-1), [1, 800, 4800]);
host.edit_end(2, -10);
assert(Math.abs(regions.at(-1)[2] - 801) < 1e-10);

trace.length = 0;
host.wave_mouse(2, 0.6, 0, 0);
assert(tasks.has('commit_wave_edits'));
host.open_source('/fixture/Stereo Test.wav');
assert(!tasks.has('commit_wave_edits'));
assert(sent('run_1', 0));
assert(sent('run_2', 0));
assert(sent('run_4', 0));
assert(!sent('buffer', 'replace', '/fixture/Stereo Test.wav'));
runTask('read_source');
assert(sent('buffer', 'replace', '/fixture/Stereo Test.wav'));
frames = 192000;
channels = 1;
host.source_loaded(48000);
assert(sent('source_label', 'set', 'Stereo Test.wav   ·   4.00 s   ·   mono'));
assert(sent('normal_right_channel', 1));
assert.deepEqual(regions.at(-1), [3, 3000, 4000]);
host.edit_play(1, 1);
host.dsp_enabled(0);
assert(sent('run_1', 0));

host.open_source('/fixture/missing.wav');
runTask('read_source');
runTask('read_timeout');
assert(sent('source_label', 'set', 'No source'));
assert(sent('wave_4', 'set'));
trace.length = 0;
host.load_demo();
host.edit_play(2, 1);
assert(sent('status', 'set', 'Loading audio… Playback queued.'));
host.dsp_enabled(0);
assert(!sent('dac', 'start'));
runTask('read_source');
host.source_loaded(44100);
assert(sent('dac', 'start'));
assert(!sent('run_2', 1));
settleAudio();
assert(sent('run_2', 1));
assert(!sent('run_1', 1));

trace.length = 0;
host.set_audio(0);
assert(sent('run_2', 0));
assert(sent('dac', 'stop'));
host.play_all();
assert(sent('dac', 'start'));
host.dsp_enabled(1);
host.stop_all();
runTask('audio_settled');
assert(!sent('run_1', 1));
assert(!sent('run_2', 1));

trace.length = 0;
host.set_audio(0);
host.play_all();
runTask('audio_timeout');
assert(sent('status', 'set', 'Audio didn’t start. Open Audio Setup…'));
host.dsp_enabled(1);
assert(!sent('run_1', 1));
host.play_all();
assert(sent('run_1', 1));

trace.length = 0;
host.set_audio(0);
host.set_audio(1);
settleAudio();
assert(sent('dac', 'start'));
assert(!sent('run_1', 1));

trace.length = 0;
host.set_audio(0);
host.play_normal();
assert(sent('dac', 'start'));
assert(!sent('normal_voice', 'start'));
assert.equal(host.normalPlaying, false);
settleAudio();
assert(sent('normal_voice', 'start'));
assert(sent('normal_mix_l', 2));
assert(sent('normal_mix_r', 2));
assert(sent('status', 'set', 'Playing original sample'));
assert.equal(host.normalPlaying, true);
trace.length = 0;
host.play_normal();
assert(!sent('normal_voice', 'start'));
host.edit_play(2, 1);
assert(sent('normal_voice', 'stop'));
assert(sent('normal_mix_l', 1));
assert(sent('run_2', 1));
assert.equal(host.normalPlaying, false);
trace.length = 0;
host.normal_finished();
assert(!sent('normal_mix_l', 0));
host.play_normal();
assert(sent('run_2', 0));
assert(sent('normal_voice', 'start'));
host.normal_finished();
assert(sent('normal_mix_l', 0));
assert.equal(host.normalPlaying, false);

trace.length = 0;
host.load_demo();
host.play_normal();
assert(!sent('normal_voice', 'start'));
assert(sent('status', 'set', 'Loading audio… Playback queued.'));
host.exit_normal();
runTask('read_source');
host.source_loaded(44100);
assert(!sent('normal_voice', 'start'));

host.set_region(1, 90, 99);
assert.equal(host.positions[0][0], 90);
assert.equal(host.positions[0][1], 99);
host.reset_regions();
assert.equal(host.positions[0][0], 0);
assert.equal(host.positions[0][1], 25);

trace.length = 0;
host.play_all();
host.open_set_source('/fixture/New Set.wav');
assert.equal(host.get_set_source().kind, 'demo');
assert.equal(host.playing[0], true);
host.play_all();
host.edit_play(1, 1);
host.play_normal();
host.open_source('/fixture/Concurrent.wav');
runTask('read_source');
assert(sent('set_buffer', 'sizeinsamps', 1));
assert(sent('set_buffer', 'replace', '/fixture/New Set.wav'));
assert(!sent('buffer', 'replace', '/fixture/New Set.wav'));
assert(!trace.some(([, ...args]) => args.includes('/fixture/Concurrent.wav')));
host.source_loaded(96000);
assert(!sent('source_rate', 96000));
assert(!sent('pattern_control', 'set_source_loaded', 1));
trace.length = 0;
frames = 192000;
channels = 1;
host.set_source_read(48000);
assert(sent('run_1', 0));
assert(!sent('source_rate', 48000));
assert.equal(host.get_set_source().kind, 'demo');
assert(!sent('pattern_control', 'set_source_loaded', 1));
host.play_all();
host.edit_play(2, 1);
host.play_normal();
runTask('commit_set_source');
assert.equal(host.get_set_source().kind, 'file');
assert.equal(host.get_set_source().path, '/fixture/New Set.wav');
assert(sent('normal_voice', 'set', 'field-kit-set-source-1'));
assert(sent('voice_4', 'source', 'field-kit-set-source-1'));
assert(sent('wave_4', 'set', 'field-kit-set-source-1'));
assert(sent('source_rate', 48000));
assert(sent('pattern_control', 'set_source_loaded', 1));
assert(!sent('run_1', 1));
assert(!sent('run_2', 1));
assert(!sent('normal_voice', 'start'));

trace.length = 0;
host.play_all();
host.open_set_source('/fixture/Invalid Set.wav');
runTask('read_source');
assert(sent('buffer', 'replace', '/fixture/Invalid Set.wav'));
frames = 1;
host.source_loaded(44100);
assert(sent('pattern_control', 'set_source_loaded', 0));
assert(sent('source_label', 'set', 'New Set.wav   ·   4.00 s   ·   mono'));
assert.equal(host.get_set_source().path, '/fixture/New Set.wav');
assert.equal(host.playing[0], true);
assert(!sent('source_rate', 44100));
assert(!sent('voice_4', 'source', 'field-kit-source-1'));

trace.length = 0;
host.open_set_demo();
runTask('read_source');
assert(sent('buffer', 'replace', `${home}/fk_demo.wav`));
runTask('read_timeout');
host.source_loaded(44100);
assert(sent('pattern_control', 'set_source_loaded', 0));
assert(!sent('pattern_control', 'set_source_loaded', 1));
assert.equal(host.get_set_source().path, '/fixture/New Set.wav');
assert.equal(host.playing[0], true);

trace.length = 0;
host.open_source('/fixture/Regular.wav');
assert.equal(host.get_set_source(), null);
host.open_set_demo();
assert(sent('pattern_control', 'set_source_loaded', 0));
runTask('read_source');
assert(sent('set_buffer', 'replace', '/fixture/Regular.wav'));
frames = 88200;
channels = 2;
host.set_source_read(44100);
assert.equal(host.get_set_source().path, '/fixture/Regular.wav');
assert(!sent('pattern_control', 'set_source_loaded', 1));

trace.length = 0;
host.open_set_demo();
runTask('read_source');
host.source_loaded(44100);
runTask('commit_set_source');
assert.equal(host.get_set_source().kind, 'demo');
assert(sent('voice_4', 'source', 'field-kit-source-1'));
assert(sent('pattern_control', 'set_source_loaded', 1));

console.log('PASS normal transport, staged Set source commit/rollback, descriptor tracking, and concurrent loads');
