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
const named = name => ({ message: (...args) => trace.push([name, ...args]) });
const host = vm.createContext({
    patcher: {
        filepath: `${home}/Field Kit.maxpat`,
        getnamed: name => name === 'sequence_panel' ? { subpatcher: () => ({ getnamed: named }) } : named(name),
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
host.wave_mouse(3, 0.8, 0, 1);
assert(sent('inspector_title', 'set', 'Editing Loop 3'));
assert(sent('loop_edit_3', 'set', 1));
host.track_wave(3, 0, 8000, 6400, 6400);
host.wave_mouse(3, 0.8, 0, 0);
runTask('commit_wave_edits');
assert.deepEqual(regions.at(-1), [2, 4000, 6000]);
assert(!sent('wave_edit_revision_3', 1));

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
assert(sent('wave_edit_revision_2', 2));
host.edit_end(2, -10);
assert(Math.abs(regions.at(-1)[2] - 801) < 1e-10);
assert(sent('wave_edit_revision_2', 3));

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
assert(!sent('run_1', 1));
frames = 192000;
channels = 1;
host.source_loaded(48000);
assert(sent('source_label', 'set', 'Stereo Test.wav   ·   4.00 s   ·   mono'));
assert(sent('normal_right_channel', 1));
assert.deepEqual(regions.at(-1), [3, 3000, 4000]);
for (let voice = 1; voice <= 4; voice++) assert(sent(`run_${voice}`, 1));
trace.length = 0;
host.dsp_enabled(0);
assert(sent('run_1', 0));

trace.length = 0;
host.open_source('/fixture/missing.wav');
runTask('read_source');
assert.deepEqual(trace.filter(([name]) => name === 'buffer'), [
    ['buffer', 'sizeinsamps', 1], ['buffer', 'replace', '/fixture/missing.wav'],
]);
frames = 1;
host.source_loaded(48000);
assert(sent('source_label', 'set', 'No source'));
assert(sent('wave_4', 'set'));
assert(sent('demo', 'ignoreclick', 0));
assert(!sent('dac', 'start'));

trace.length = 0;
host.open_source('/fixture/Stopped During Load.wav');
runTask('read_source');
host.stop_all();
frames = 192000;
host.source_loaded(48000);
assert.equal(host.get_set_source().path, '/fixture/Stopped During Load.wav');
assert(!sent('dac', 'start'));

trace.length = 0;
host.open_source('/fixture/Start With Audio Off.wav');
runTask('read_source');
assert(!sent('dac', 'start'));
host.source_loaded(48000);
assert(sent('dac', 'start'));
assert(!sent('run_1', 1));
settleAudio();
for (let voice = 1; voice <= 4; voice++) assert(sent(`run_${voice}`, 1));
host.set_audio(0);

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
const normalEnvelope = trace.find(([target]) => target === 'normal_blend');
assert.deepEqual(normalEnvelope, ['normal_blend', 'list', 1, 16, 1, host.duration - 32, 0, 16]);
assert(trace.indexOf(normalEnvelope) < trace.findIndex(([target, command]) =>
    target === 'normal_voice' && command === 'start'));
assert(sent('status', 'set', 'Playing original sample'));
assert.equal(host.normalPlaying, true);
trace.length = 0;
host.play_normal();
assert(!sent('normal_voice', 'start'));
host.edit_play(2, 1);
assert(!sent('normal_voice', 'stop'));
assert(sent('normal_blend', 'list', 0, 16));
assert(sent('run_2', 1));
assert.equal(host.normalPlaying, false);
trace.length = 0;
host.play_normal();
assert(sent('run_2', 0));
assert(!sent('normal_voice', 'start'));
host.normal_faded();
assert(sent('normal_voice', 'stop'));
assert(sent('normal_voice', 'start'));
trace.length = 0;
host.normal_finished();
host.normal_faded();
assert(!sent('normal_voice', 'stop'));
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

// Explicit demo selections play immediately after reading, without changing the mix.
trace.length = 0;
host.select_demo(NaN);
host.select_demo(4);
assert(!tasks.has('read_source'));
assert(sent('demo', 'set', 0));
for (const [item, id, file, name, tempo, sectionFrames] of [
    [2, 'glass-circuit', 'fk_demo_glass_circuit.wav', 'Glass Circuit', 120, 192000],
    [3, 'tidal-lanterns', 'fk_demo_tidal_lanterns.wav', 'Tidal Lanterns', 75, 307200],
]) {
    host.set_region(1, 7, 38);
    trace.length = 0;
    host.select_demo(item);
    assert(sent('sequence_control', 'stop'));
    assert(sent('demo', 'ignoreclick', 1));
    runTask('read_source');
    assert(sent('buffer', 'replace', `${home}/${file}`));
    assert(!sent('run_1', 1));
    frames = 4 * sectionFrames;
    host.source_loaded(48000);
    if (tasks.has('audio_timeout')) settleAudio();
    assert.equal(JSON.stringify(host.get_set_source()), JSON.stringify({kind: 'builtin', id}));
    assert.equal(JSON.stringify(host.positions), '[[0,25],[25,50],[50,75],[75,100]]');
    assert(sent('source_label', 'set', `${name}   ·   ${(frames / 48000).toFixed(2)} s   ·   stereo`));
    assert(sent('demo', 'ignoreclick', 0));
    assert(sent('seq_bpm', tempo));
    assert(sent('seq_beats', 4));
    for (let voice = 1; voice <= 4; voice++) {
        assert(sent(`run_${voice}`, 1));
        assert(sent(`rate_${voice}`, 1));
        assert(sent(`direction_${voice}`, 0));
        assert(sent(`fade_${voice}`, 0));
    }
    assert(!trace.some(([target]) => /^(pan_|level_|fx_|master$|mixer_control$|pattern_control$)/.test(target)));
}

trace.length = 0;
host.set_region(1, 7, 38);
host.open_set_demo('glass-circuit');
runTask('read_source');
assert(sent('set_buffer', 'replace', `${home}/fk_demo_glass_circuit.wav`));
frames = 768000;
host.set_source_read(48000);
runTask('commit_set_source');
assert.equal(host.get_set_source().id, 'glass-circuit');
assert.equal(host.positions[0][0], 7);
assert.equal(host.positions[0][1], 38);
assert(sent('pattern_control', 'set_source_loaded', 1));
assert(!sent('seq_bpm', 120));
assert(!sent('rate_1', 1));
assert(!sent('run_1', 1));

trace.length = 0;
host.open_set_demo('unknown');
assert(sent('pattern_control', 'set_source_loaded', 0));
assert(!tasks.has('read_source'));
assert.equal(host.get_set_source().id, 'glass-circuit');
host.select_demo(1);
runTask('read_source');
assert(sent('set_buffer', 'replace', `${home}/fk_demo.wav`));
frames = 352800;
host.set_source_read(44100);
assert.equal(host.get_set_source().kind, 'demo');
assert(sent('run_1', 1));
assert(!sent('rate_1', 1));

// A filter change in Max updates the voice control, then feeds the inspector sync route.
const filters = [0, 0, 0, 0];
const getnamed = host.patcher.getnamed;
host.patcher.getnamed = name => {
    const target = getnamed(name);
    const match = /^filter_([1-4])$/.exec(name);
    if (!match) return target;
    const voice = Number(match[1]);
    return {
        getvalueof: () => [filters[voice - 1]],
        message: value => {
            target.message(value);
            filters[voice - 1] = value;
            host.inspector_sync(voice, 'filter', value);
        },
    };
};
function filterEditorShows(value, type) {
    assert(sent('inspect_filter', 'set', value));
    assert(sent('inspect_filter_value', 'set', value));
    assert(sent('inspect_filter_type', 'set', type));
    trace.length = 0;
}

trace.length = 0;
host.inspect_window(0);
filterEditorShows(0, 1);
host.inspector_filter_type(0);
filterEditorShows(-40, 0);
host.inspector_edit('filter', -27.5);
filterEditorShows(-27.5, 0);
host.inspector_filter_type(2);
filterEditorShows(27.5, 2);

host.inspect_window(1);
filterEditorShows(0, 1);
host.inspector_filter_type(2);
filterEditorShows(40, 2);
host.inspector_filter_type(1);
filterEditorShows(0, 1);
assert.deepEqual(filters, [27.5, 0, 0, 0]);

// Scene recall writes each filter even when its loop is outside the editor.
host.patcher.getnamed('filter_1').message(-18);
assert(!trace.some(([target]) => target.startsWith('inspect_filter')));
trace.length = 0;
host.inspect_window(0);
filterEditorShows(-18, 0);
host.patcher.getnamed('filter_1').message(55);
filterEditorShows(55, 2);
host.inspector_edit('filter', 0);
filterEditorShows(0, 1);

console.log('PASS file and demo autoplay, layered demo timing, staged Set source commit/rollback, transport, and filter selection');
