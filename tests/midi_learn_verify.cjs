const assert = require("node:assert/strict");
const fs = require("node:fs");
const path = require("node:path");
const vm = require("node:vm");

const assets = path.join(__dirname, "..", "max");
const read = name => fs.readFileSync(path.join(assets, name), "utf8");
const messages = [];
const dictionaries = new Map();
let dictionaryId = 0;

class MockDict {
    constructor() {
        this.name = "test_midi_" + ++dictionaryId;
        dictionaries.set(this.name, this);
    }
    parse(data) { this.data = data; }
    stringify() { return this.data; }
    freepeer() { dictionaries.delete(this.name); }
}

function mockPatcher(document) {
    const objects = new Map();
    for (const { box } of document.boxes) {
        const { varname, saved_attribute_attributes: saved = {} } = box;
        const embedded = box.patcher || (box.maxclass === "bpatcher" && box.name &&
            JSON.parse(read(box.name)).patcher);
        const child = embedded ? mockPatcher(embedded) : null;
        const object = {
            valid: true,
            varname,
            value: saved.valueof?.parameter_initial?.[0] ?? 0,
            js: {},
            getvalueof() { return this.value; },
            getattr(attribute) { return box[attribute]; },
            setboxattr(attribute, value) { this[attribute] = value; },
            subpatcher() { return child; },
            message(...args) {
                messages.push([varname, ...args]);
                if (typeof args[0] === "number") this.value = args[0];
                if (args[0] === "set") this.value = args[1];
            }
        };
        objects.set(varname, object);
    }
    return {
        getnamed(name) { return objects.get(name); },
        applydeep(visit) {
            for (const object of objects.values()) {
                visit(object);
                object.subpatcher()?.applydeep(visit);
            }
        }
    };
}

const patcher = mockPatcher(JSON.parse(read("Field Kit.maxpat")).patcher);
const world = vm.createContext({
    patcher,
    Dict: MockDict,
    Task: class { schedule() {} repeat() {} cancel() {} },
    jsarguments: ["fk_io.js"],
    arrayfromargs: args => Array.from(args),
    include(name) { vm.runInContext(read(name), world, { filename: name }); }
});
vm.runInContext(read("fk_io.js"), world, { filename: "fk_io.js" });

for (const [id, target] of Object.entries(world.MIDI_TARGETS)) {
    const owner = target.owner.reduce((patch, name) => patch.getnamed(name)?.subpatcher(), patcher);
    assert.ok(owner?.getnamed(target.control), "Missing target " + id);
    for (const alternative of target.alternateIds || []) {
        assert.ok(world.MIDI_TARGETS[alternative], "Missing alternative " + alternative);
    }
}
for (const [owner, hits] of Object.entries(world.MIDI_HITS)) {
    const scope = owner ? owner.split(".").reduce((patch, name) => patch.getnamed(name)?.subpatcher(), patcher) : patcher;
    for (const hit of hits) {
        assert.ok(scope.getnamed(hit.control), "Missing overlay box " + hit.control);
        assert.ok(world.MIDI_TARGETS[hit.id], "Missing overlay target " + hit.id);
    }
}

function receive(port, kind, number, value, channel = 1) {
    world.midi_input(port, kind, number, value, channel);
}
function cc(port, number, value, channel = 1) { receive(port, "cc", number, value, channel); }
function press(port, number, channel = 1) { receive(port, "note", number, 127, channel); }
function release(port, number, channel = 1) { receive(port, "note", number, 0, channel); }

const named = (name, owner = patcher) => owner.getnamed(name);
const writes = name => messages.filter(message => message[0] === name);
const bound = (port, target) => world.bindings.find(entry => entry.port === port && entry.target === target);

world.load_profiles();
const load = writes("set_writer").at(-1);
dictionaries.get(load[3]).parse(JSON.stringify({ version: 1, mappings: [] }));
world.midi_profile_loaded(load[2], load[3]);
world.midi_devices("input", "Fader Bank", "Pad Controller");
world.midi_devices("output", "Pad Lights");

world.learn();
world.midi_pick("global_speed");
assert.equal(writes("global_speed").length, 0, "Selecting a target must never move it");
cc("Fader Bank", 12, 120);
assert.equal(world.picking, true, "Learn stays on for the next control");
assert.equal(bound("Fader Bank", "global_speed").number, 12);
assert.equal(writes("global_speed").length, 0, "Learning a MIDI message must never change a control");
world.midi_pick("master");
cc("Fader Bank", 12, 85);
assert.ok(world.pending, "Reusing an input requires a conflict choice");
world.conflict_share();
assert.ok(bound("Fader Bank", "master"));
assert.ok(bound("Fader Bank", "global_speed"));
world.undo();
assert.equal(bound("Fader Bank", "master"), undefined, "Undo restores the previous complete mapping");
world.midi_escape();

const speed = named("global_speed");
cc("Fader Bank", 12, 127);
assert.equal(speed.value, 1, "Pickup keeps the recalled value until the knob crosses it");
cc("Fader Bank", 12, 40);
assert.equal(speed.value, 0.5 + 1.5 * 40 / 127, "Crossing the stored speed engages the fader");
speed.value = 1.1; // A pattern or a human changed this value.
cc("Fader Bank", 12, 42);
assert.equal(speed.value, 1.1, "External changes reset pickup");
cc("Fader Bank", 12, 55);
assert.equal(speed.value, 0.5 + 1.5 * 55 / 127);

named("source_control").js.inspectedWindow = 3;
world.learn();
world.midi_pick("inspect_rate", "fixed");
cc("Pad Controller", 12, 32, 2);
assert.ok(bound("Pad Controller", "rate_3"), "Option+click resolves the current loop as a fixed target");
world.midi_pick("workspace_view:choice:2");
press("Pad Controller", 5);
release("Pad Controller", 5);
world.midi_pick("mixer_mute_1");
press("Pad Controller", 8);
release("Pad Controller", 8);
world.midi_escape();
assert.equal(writes("workspace_view").length, 0, "MIDI Learn did not open the workspace");
press("Pad Controller", 5);
assert.deepEqual(writes("workspace_view").at(-1), ["workspace_view", 2]);

world.show_mappings();
const entries = world.rows;
assert.ok(entries.some(row => row.port === "Fader Bank"));
assert.ok(entries.some(row => row.port === "Pad Controller"));
world.find_hardware();
cc("Fader Bank", 12, 78);
assert.equal(world.rows.length, 1);
assert.equal(world.rows[0].target, "global_speed");
world.find_hardware();
world.mapping_search("mute");
assert.equal(world.rows.length, 1);
world.mapping_row(0, 1);
world.mapping_option("button", 2);
world.mapping_option("feedback", 1);
world.apply_options();
assert.equal(bound("Pad Controller", "mixer_mute_1").mode, "hold");

const mixer = named("mixer_control");
mixer.js.mutes = [0, 0, 0, 0];
mixer.message = (...args) => {
    messages.push(["mixer_control", ...args]);
    mixer.js.mutes[args[1] - 1] = args[2];
};
press("Pad Controller", 8);
assert.equal(mixer.js.mutes[0], 1);
world.refresh_feedback();
assert.deepEqual(writes("io_midi_ports_control").at(-1),
    ["io_midi_ports_control", "send_feedback", "Pad Lights", 144, 8, 127]);
world.midi_devices("input", "Fader Bank");
assert.equal(mixer.js.mutes[0], 0, "Disconnecting a held pad releases its control");
assert.equal(world.rows[0].state, "Offline");
assert.deepEqual(writes("io_midi_ports_control").at(-1),
    ["io_midi_ports_control", "send_feedback", "Pad Lights", 144, 8, 0]);

world.mapping_import_port(1);
world.import_mappings("/tmp/layout.json");
const request = writes("set_writer").at(-1);
dictionaries.get(request[3]).parse(JSON.stringify({
    version: 1,
    mappings: [{...bound("Pad Controller", "mixer_mute_1"), enabled: false }]
}));
world.midi_profile_imported(request[2], request[3]);
assert.equal(bound("Fader Bank", "mixer_mute_1").enabled, false);
assert.equal(bound("Fader Bank", "mixer_mute_1").feedbackPort, "");

world.export_mappings("/tmp/export.json");
const exported = writes("set_writer").at(-1);
assert.equal(exported[1], "midi_profile_export");
assert.ok(JSON.parse(dictionaries.get(exported[3]).stringify()).mappings.length > 0);
world.midi_profile_exported(exported[2]);
assert.equal(dictionaries.has(exported[3]), false, "Completed operations release their dictionaries");

console.log("MIDI Learn targets, multiport assignments, undo, pickup, lookup, release, feedback and layouts verified.");
