const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const source = fs.readFileSync(path.join(__dirname, '../max/fk_exchange_node.js'), 'utf8');

function load(dirname, execPath, available, broken = false) {
    let selected;
    let role;
    const context = vm.createContext({
        __dirname: dirname,
        process: { execPath },
        require(name) {
            if (name === 'node:fs') return { existsSync: filename => available.includes(filename) };
            if (name === 'node:path') return path;
            selected = name;
            if (broken) throw Error('Module dependency failed');
            return { start(options) { role = options.role; } };
        },
    });
    vm.runInContext(source, context);
    return { selected, role };
}
const bundledNode = '/Applications/Field Kit.app/Contents/Resources/C74/packages/Node for Max/source/bin/osx/node/node';
const normal = load('/project/max', bundledNode, ['/project/max/handoff/max-exchange.js']);
assert.equal(normal.selected, '/project/max/handoff/max-exchange');
assert.equal(normal.role, 'field-kit');
const extracted = load('/temporary/collective-extraction', bundledNode, [
    '/Applications/Field Kit.app/Contents/Resources/handoff/max-exchange.js',
]);
assert.equal(extracted.selected, '/Applications/Field Kit.app/Contents/Resources/handoff/max-exchange');
assert.equal(extracted.role, 'field-kit');
assert.throws(() => load('/temporary/collective-extraction', bundledNode, []), /modules are missing/);
assert.throws(() => load('/project/max', bundledNode, ['/project/max/handoff/max-exchange.js'], true), /Module dependency failed/);
console.log('Node receiver bootstrap: 4 checks passed');
