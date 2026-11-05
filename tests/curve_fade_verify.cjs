const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const { join } = require('node:path');

const root = join(__dirname, '..', 'max');
const writes = [];
const messages = [];
let curveDump = null;

const router = {
    Global: function () {},
    Buffer: function (name) {
        this.framecount = () => 1025;
        this.poke = (channel, start, data) => writes.push({ name, channel, start, data: [...data] });
    },
    arrayfromargs: (args) => Array.from(args),
    outlet: () => {},
    patcher: {
        getnamed: (name) => ({
            valid: true,
            message: (...args) => {
                messages.push([name, ...args]);
                if (name === 'fk_curve' && args[0] === 'listdump' && curveDump) {
                    router.curve_points(...curveDump);
                }
            }
        })
    }
};

vm.createContext(router);
vm.runInContext(fs.readFileSync(join(root, 'fk_mod_routes.js'), 'utf8'), router);
router.bang();
assert.equal(writes.length, 8);
assert.deepEqual(writes.map(({ name }) => name), Array.from({ length: 8 }, (_, i) => 'field-kit-curve-' + (2 * i + 1)));

router.select_lfo(7);
const table = router.tables[7];
const firstEdit = [0, -1, 1, 1];
const middleEdit = [0, -1, 0.5, -0.75, 1, 1];
const finalEdit = [0, 1, 0.5, -0.5, 1, 1];
router.curve_points(...firstEdit);
assert.deepEqual([...router.curves[7]], firstEdit);
assert.equal(writes.length, 8);
assert.equal(table.dirty, true);

router.running(1);
assert.equal(writes.at(-1).name, 'field-kit-curve-16');
assert.equal(writes.at(-1).data[0], -1);
assert.equal(writes.at(-1).data[512], 0);
assert.equal(writes.at(-1).data[1024], 1);
assert.deepEqual(messages.findLast(([name]) => name === 'fk_curve_fade_8'), ['fk_curve_fade_8', 1, 24]);

router.curve_points(...middleEdit);
router.curve_points(...finalEdit);
assert.deepEqual([...router.curves[7]], finalEdit);
assert.equal(writes.length, 9);
assert.equal(table.active, 0);
router.curve_ready(7);
assert.equal(table.active, 1);
assert.equal(writes.length, 10);
assert.equal(writes.at(-1).name, 'field-kit-curve-15');
assert.equal(writes.at(-1).data[512], -0.5);
assert.deepEqual(messages.findLast(([name]) => name === 'fk_curve_fade_8'), ['fk_curve_fade_8', 0, 24]);

router.running(0);
router.running(1);
assert.deepEqual(messages.findLast(([name]) => name === 'fk_curve_fade_8'), ['fk_curve_fade_8', 0, 24]);
assert.equal(writes.length, 10);
router.curve_ready(7);
assert.equal(table.active, 0);
assert.equal(table.fading, false);

curveDump = finalEdit;
router.curve_edited();
assert.equal(writes.length, 10, 'unchanged function dumps must not write audio buffers');
curveDump = null;
router.curve_edited();
assert.equal(router.curves[7].length, 0);
assert.equal(writes.at(-1).name, 'field-kit-curve-16');
assert.ok(writes.at(-1).data.every((sample) => sample === 0));

console.log('PASS inactive-buffer edits, latest-edit coalescing, DSP restart, and empty/unchanged dumps');
