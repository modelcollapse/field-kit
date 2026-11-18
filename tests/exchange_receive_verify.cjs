const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const script = fs.readFileSync(path.join(__dirname, '../max/fk_source.js'), 'utf8');
const results = [];

function fixture() {
    let now = 0;
    let failBind = false;
    const tasks = new Map();
    const messages = [];
    const named = new Map();
    const buffers = new Map();
    for (const key of [
        'buffer',
        'set_buffer',
        'empty_loop_buffer',
        ...Array.from({ length: 8 }, (_, i) => 'loop_buffer_' + i),
    ])
        buffers.set(key, { frames: 1, channels: 2, rate: 48000 });
    const files = new Map([
        ['/exchange/received.wav', { frames: 48000, channels: 2, rate: 48000 }],
        ['/exchange/next.wav', { frames: 22050, channels: 1, rate: 44100 }],
    ]);
    function object(target) {
        return {
            message(...args) {
                messages.push([target, ...args]);
                if (failBind && target === 'voice_2' && args[0] === 'source') {
                    failBind = false;
                    throw Error('Injected binding failure');
                }
                const audio = buffers.get(target);
                if (!audio) return;
                if (args[0] === 'name') named.set(args[1], audio);
                if (args[0] === 'sizeinsamps') audio.frames = args[1];
                if (args[0] === 'replace' && files.has(args[1]))
                    Object.assign(audio, files.get(args[1]));
                else if (args[0] === 'replace' && args[1].includes('fk_demo'))
                    Object.assign(audio, { frames: 384000, channels: 2, rate: 48000 });
            },
            getattr(name) {
                return name === 'sr' ? buffers.get(target)?.rate : undefined;
            },
            subpatcher() {
                return { getnamed: object };
            },
        };
    }
    const host = vm.createContext({
        patcher: { filepath: '/fixture/Field Kit.maxpat', getnamed: object },
        arrayfromargs: (value) => Array.from(value),
        outlet() {},
        Global: function () {},
        Buffer: function (name) {
            const audio = named.get(name);
            this.framecount = () => audio.frames;
            this.channelcount = () => audio.channels;
            this.length = () => (audio.frames * 1000) / audio.rate;
        },
        Task: function (fn) {
            this.schedule = (delay) => tasks.set(this, { fn, due: now + delay });
            this.cancel = () => tasks.delete(this);
        },
    });
    vm.runInContext(script, host);
    function advance(ms) {
        const end = now + ms;
        for (let count = 0; count < 100; count++) {
            const next = [...tasks].sort((a, b) => a[1].due - b[1].due)[0];
            if (!next || next[1].due > end) {
                now = end;
                return;
            }
            tasks.delete(next[0]);
            now = next[1].due;
            next[1].fn();
        }
        throw Error('Task loop');
    }
    host.initialize();
    advance(100);
    host.source_loaded(48000);
    host.inspect_window(1);
    messages.length = 0;
    return {
        host,
        messages,
        buffers,
        advance,
        set failBind(v) {
            failBind = v;
        },
        has: (...args) => messages.some((row) => JSON.stringify(row) === JSON.stringify(args)),
    };
}
function test(name, run) {
    try {
        run();
        results.push({ name, pass: true });
    } catch (error) {
        results.push({ name, pass: false, error: String(error.stack) });
    }
}

test('Successful receive replaces selected loop after validation without autoplay, DSP or confirmation', () => {
    const f = fixture();
    const h = f.host;
    const old = h.loopSources.slice();
    h.receive_exchange('one', '/exchange/received.wav', 'Rendered loop', 'region', 'selected');
    assert.equal(h.loopPending.state, 'reading');
    assert(!f.has('exchange_worker', 'loaded', 'one'));
    const slot = h.loopPending.slot;
    h.loop_buffer_ready(slot, 48000);
    assert.equal(h.loopSources[1].path, '/exchange/received.wav');
    assert.equal(h.loopSources[1].name, 'Rendered loop');
    assert.deepEqual(Array.from(h.positions[1]), [0, 100]);
    for (const i of [0, 2, 3]) assert.equal(h.loopSources[i], old[i]);
    assert(f.has('exchange_worker', 'loaded', 'one'));
    assert.equal(h.audioOn, false);
    assert(h.playing.every((x) => !x));
    assert(!f.messages.some((row) => row[0] === 'theme_control' && row[1] === 'open_loop_take'));
    assert(!f.messages.some((row) => row[0] === 'dsp_control'));
});
test('Playing loop keeps its live play state and acknowledgment waits for the scheduled switch', () => {
    const f = fixture();
    const h = f.host;
    h.dsp_enabled(1);
    h.play_all();
    f.messages.length = 0;
    h.receive_exchange('two', '/exchange/received.wav', 'Rendered audio', 'whole', 'selected');
    h.loop_buffer_ready(h.loopPending.slot, 48000);
    assert.equal(h.loopPending.state, 'switching');
    assert.equal(h.loopSources[1], null);
    assert(!f.has('exchange_worker', 'loaded', 'two'));
    assert(f.has('run_2', 0));
    // A user Stop during the handoff is honored at commit.
    h.set_play(2, false);
    f.advance(40);
    assert.equal(h.loopSources[1].path, '/exchange/received.wav');
    assert(f.has('exchange_worker', 'loaded', 'two'));
    assert.equal(h.playing[1], false);
    assert(h.playing[0] && h.playing[2] && h.playing[3]);
});
test('Busy capture/manual import is retryable and does not overwrite an existing staged operation', () => {
    const f = fixture();
    const h = f.host;
    h.choose_loop_audio(3);
    const pending = h.loopPending;
    h.receive_exchange('busy', '/exchange/received.wav', 'Rendered', 'whole', 'selected');
    assert.equal(h.loopPending, pending);
    assert.equal(h.exchangeRequest, null);
    assert(
        f.messages.some(
            (row) => row[0] === 'exchange_worker' && row[1] === 'busy' && row[2] === 'busy',
        ),
    );
    assert(!f.has('exchange_worker', 'loaded', 'busy'));
});
test('Failed or timed-out native buffer read preserves old loop and sends failed rather than loaded', () => {
    for (const timeout of [false, true]) {
        const f = fixture();
        const h = f.host;
        h.receive_exchange('bad', '/exchange/missing.wav', 'Bad', 'whole', 'selected');
        if (timeout) f.advance(12000);
        else h.loop_buffer_ready(h.loopPending.slot, 48000);
        assert.equal(h.loopSources[1], null);
        assert.equal(h.exchangeRequest, null);
        assert(
            f.messages.some(
                (row) => row[0] === 'exchange_worker' && row[1] === 'failed' && row[2] === 'bad',
            ),
        );
        assert(!f.has('exchange_worker', 'loaded', 'bad'));
    }
});
test('A failed selected-loop commit restores its prior source and leaves other loops intact', () => {
    const f = fixture();
    const h = f.host;
    h.receive_exchange('initial', '/exchange/received.wav', 'First', 'whole', 'selected');
    h.loop_buffer_ready(h.loopPending.slot, 48000);
    const prior = h.loopSources[1];
    const range = h.positions[1].slice();
    f.messages.length = 0;
    h.receive_exchange('replace', '/exchange/next.wav', 'Second', 'region', 'selected');
    f.failBind = true;
    h.loop_buffer_ready(h.loopPending.slot, 44100);
    assert.equal(h.loopSources[1], prior);
    assert.deepEqual(h.positions[1].slice(), range);
    assert(
        f.messages.some(
            (row) => row[0] === 'exchange_worker' && row[1] === 'failed' && row[2] === 'replace',
        ),
    );
    assert(!f.has('exchange_worker', 'loaded', 'replace'));
    assert.equal(h.loopSources[0], null);
    assert.equal(h.loopSources[2], null);
    assert.equal(h.loopSources[3], null);
});
test('Duplicate delivery acknowledgments are idempotent and selected loop is pinned when accepted', () => {
    const f = fixture();
    const h = f.host;
    h.receive_exchange('dup', '/exchange/received.wav', 'First', 'whole', 'selected');
    const slot = h.loopPending.slot;
    h.inspect_window(3);
    h.receive_exchange('dup', '/exchange/received.wav', 'First', 'whole', 'selected');
    assert.equal(h.loopPending.slot, slot);
    h.loop_buffer_ready(slot, 48000);
    assert(h.loopSources[1]);
    assert.equal(h.loopSources[3], null);
    f.messages.length = 0;
    h.receive_exchange('dup', '/exchange/received.wav', 'First', 'whole', 'selected');
    assert(f.has('exchange_worker', 'loaded', 'dup'));
    assert.equal(h.loopPending, null);
    assert(!f.messages.some((row) => row[1] === 'replace'));
});
console.log(
    JSON.stringify(
        { passed: results.filter((x) => x.pass).length, total: results.length, results },
        null,
        2,
    ),
);
if (results.some((x) => !x.pass)) process.exitCode = 1;
