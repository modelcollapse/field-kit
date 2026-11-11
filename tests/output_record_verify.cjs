const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const path = require('node:path');
const root = path.join(__dirname, '..');
const messages = [];
const context = vm.createContext({
    patcher: { getnamed(name) { return {
        message(...args) { messages.push([name, ...args]); },
        getattr() { return [1, 1, 1, 1]; },
    }; } },
    arrayfromargs: args => Array.from(args),
    outlet: (...args) => messages.push(['outlet', ...args]),
    Task: function() { this.repeat = this.cancel = this.schedule = () => {}; },
});
vm.runInContext(fs.readFileSync(path.join(root, 'max/fk_recorder.js'), 'utf8'), context);
context.dsp_enabled(1);
context.start_path('/takes/session.wav');
assert(messages.some(m => m[0] === 'outlet' && m[2] === 'prepare_output_folder'));
assert(!messages.some(m => m[1] === 'open'), 'wait for the folder before recording');
context.output_folder_ready(0, '/takes/stale.wav');
assert.equal(context.state, 'preparing');
context.output_folder_ready(1, '/takes/session/session.wav');
const opens = messages.filter(m => m[1] === 'open');
assert.equal(opens.length, 1);
assert.equal(opens[0][3], '/takes/session/session - synchronized capture.wav');
context.elapsed(0); context.elapsed(100);
assert.equal(context.state, 'recording');
context.toggle_record();
assert.equal(messages.filter(m => m[0] === 'writer' && m[1] === 0).length, 1);
context.hasAudio = () => true;
context.finish();
assert.equal(context.state, 'splitting');
assert(messages.some(m => m[0] === 'outlet' && m[2] === 'split_output'));
context.split_done(0, 'Disk full');
assert.match(context.status, /capture kept/, 'failed saves retain the original capture');
const main = JSON.parse(fs.readFileSync(path.join(root, 'max/Field Kit.maxpat'))).patcher;
const byName = new Map(main.boxes.map(b => [b.box.varname, b.box.id]));
const connected = (s, so, t, ti) => main.lines.some(l => l.patchline.source[0] === byName.get(s) && l.patchline.source[1] === so && l.patchline.destination[0] === byName.get(t) && l.patchline.destination[1] === ti);
for (let i = 1; i <= 4; i++) for (const [channel, suffix] of ['left', 'right'].entries()) {
    assert(connected(`mixer_${suffix}_${i}`, 0, 'recorder', 2 + (i - 1) * 2 + channel));
}
for (const [channel, suffix] of ['left', 'right'].entries()) assert(connected(`output_${suffix}`, 0, 'recorder', channel));
const recorder = JSON.parse(fs.readFileSync(path.join(root, 'max/fk_record.maxpat'))).patcher;
const inlets = recorder.boxes.map(b => b.box).filter(b => b.maxclass === 'inlet').sort((a,b) => a.patching_rect[0] - b.patching_rect[0]);
assert.deepEqual(inlets.map(b => b.index), [1,2,3,4,5,6,7,8,9,10], 'Max inlet order follows physical horizontal placement');
console.log('PASS synchronized capture, collision protection, stop, failure recovery, and stereo routing');
