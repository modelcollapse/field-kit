const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');

const tasks = new Set();
const received = [];
const sent = [];
const errors = [];
const objects = [];
const connections = [];
const restored = { varname: 'midi_runtime_saved', valid: true };
let failedPort = '';

const named = {
    query_inputs: { message: (...atoms) => sent.push(['query_inputs', ...atoms]) },
    query_outputs: { message: (...atoms) => sent.push(['query_outputs', ...atoms]) },
    port_controller: {},
    port_feedback: { message: (...atoms) => sent.push(['port_feedback', ...atoms]) },
};
const host = vm.createContext({
    inlet: 0,
    arrayfromargs: args => Array.from(args),
    outlet: (index, ...atoms) => {
        assert.equal(index, 0);
        received.push(Array.from(atoms.flat()));
    },
    post: (...atoms) => errors.push(atoms.join('')),
    Task: function (fn) {
        this.schedule = () => tasks.add(fn);
        this.cancel = () => tasks.delete(fn);
    },
    patcher: {
        firstobject: restored,
        getnamed: name => named[name],
        newdefault(x, y, kind, ...args) {
            if (kind === 'prepend' && failedPort && args[1] === failedPort) return null;
            const object = {
                kind, args, valid: true, values: [],
                message(command, port) {
                    assert.equal(command, 'port');
                    this.port = port;
                },
            };
            objects.push(object);
            return object;
        },
        hiddenconnect: (source, outlet, destination, inlet) => connections.push({ source, outlet, destination, inlet }),
        remove(object) { object.valid = false; },
    },
});
vm.runInContext(fs.readFileSync(path.join(__dirname, '..', 'max', 'fk_midi_ports.js'), 'utf8'), host);

function scan(direction, ports, explicit = true) {
    host.inlet = direction;
    host.clear();
    ports.forEach(name => host.append(name));
    if (explicit) host.set(0);
}

function flush() {
    const scheduled = [...tasks];
    tasks.clear();
    scheduled.forEach(run => run());
}

function sendOutlet(object, outlet, atoms) {
    for (const { source, outlet: from, destination, inlet } of connections) {
        if (source !== object || from !== outlet) continue;
        if (destination.kind === 'pack' && destination.valid) {
            destination.values[inlet] = atoms[0];
            if (inlet === 0) sendOutlet(destination, 0, destination.values);
        } else if (destination.kind === 'prepend' && destination.valid) {
            sendOutlet(destination, 0, [...destination.args, ...atoms]);
        } else if (destination === named.port_controller) {
            const [selector, ...values] = atoms;
            host[selector](...values);
        }
    }
}

function hardware(port, kind, number, value, channel) {
    const receiver = objects.find(object => object.valid && object.port === port && object.kind === kind);
    assert(receiver);
    sendOutlet(receiver, 2, [channel]);
    sendOutlet(receiver, 1, [kind === 'ctlin' ? number : value]);
    sendOutlet(receiver, 0, [kind === 'ctlin' ? value : number]);
}

const firstPort = 'Launchkey MIDI 1';
const secondPort = 'Fader Port';
host.refresh_devices();
assert.deepEqual(sent, [['query_inputs', 'bang'], ['query_outputs', 'bang']]);
scan(1, ['Disconnected Before Publishing'], false);
scan(1, [firstPort, secondPort, firstPort]);
flush();
assert(!restored.valid);
assert.deepEqual(received.at(-1), ['midi_devices', 'input', firstPort, secondPort]);
assert.equal(objects.filter(object => object.valid).length, 12);
const firstStream = host.streams[firstPort].id;
const secondStream = host.streams[secondPort].id;

hardware(firstPort, 'ctlin', 14, 111, 2);
assert.deepEqual(received.at(-1), ['midi_input', firstPort, 'cc', 14, 111, 2]);
hardware(secondPort, 'ctlin', 14, 73, 2);
assert.deepEqual(received.at(-1), ['midi_input', secondPort, 'cc', 14, 73, 2]);
hardware(firstPort, 'notein', 63, 100, 2);
hardware(secondPort, 'notein', 63, 0, 2);
assert.deepEqual(received.slice(-2), [
    ['midi_input', firstPort, 'note', 63, 100, 2],
    ['midi_input', secondPort, 'note', 63, 0, 2],
]);

scan(1, [secondPort, firstPort]);
flush();
assert.deepEqual(received.at(-1), ['midi_devices', 'input', secondPort, firstPort]);
assert.equal(host.streams[firstPort].id, firstStream);
assert.equal(host.streams[secondPort].id, secondStream);

scan(1, [secondPort], false);
flush();
assert.equal(objects.filter(object => object.valid).length, 6);
assert.equal(host.streams[secondPort].id, secondStream);
let previousEvents = received.length;
host.receive_note(firstPort, firstStream, 9, 10, 11);
assert.equal(received.length, previousEvents);
scan(1, [secondPort, firstPort]);
flush();
assert.notEqual(host.streams[firstPort].id, firstStream);
previousEvents = received.length;
host.receive_cc(firstPort, firstStream, 10, 9, 11);
assert.equal(received.length, previousEvents);

failedPort = 'Broken Port';
scan(1, [failedPort]);
flush();
assert.match(errors.at(-1), /Broken Port/);
assert.equal(objects.filter(object => object.valid).length, 0);
assert.deepEqual(received.at(-1), ['midi_devices', 'input']);
scan(1, [], false);
flush();
assert.deepEqual(received.at(-1), ['midi_devices', 'input']);

const outputPort = 'Launchkey MIDI Out';
scan(2, [outputPort]);
flush();
assert.deepEqual(received.at(-1), ['midi_devices', 'output', outputPort]);
host.send_feedback(outputPort, 176, 14, 23);
assert.deepEqual(sent.slice(-4), [
    ['port_feedback', 'port', outputPort], ['port_feedback', 176], ['port_feedback', 14], ['port_feedback', 23],
]);
const previousSends = sent.length;
scan(2, []);
flush();
assert.deepEqual(received.at(-1), ['midi_devices', 'output']);
host.send_feedback(outputPort, 176, 14, 23);
assert.equal(sent.length, previousSends);

console.log('Verified concurrent MIDI devices, port refresh and reconnect, and feedback routing');
