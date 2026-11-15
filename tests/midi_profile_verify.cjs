"use strict";

const assert = require("node:assert/strict");
const fs = require("node:fs");
const os = require("node:os");
const path = require("node:path");
const vm = require("node:vm");

const source = fs.readFileSync(path.join(__dirname, "../max/fk_set_writer.js"), "utf8");

function loadWriter(home, fileApi = fs) {
    const handlers = new Map();
    const dicts = new Map();
    const replies = new Map();
    const maxApi = {
        addHandler(name, handler) { handlers.set(name, handler); },
        async getDict(name) {
            if (name === "first save") await new Promise(resolve => setTimeout(resolve, 10));
            return structuredClone(dicts.get(name));
        },
        async setDict(name, data) { dicts.set(name, structuredClone(data)); },
        outlet(selector, request, ...args) { replies.set(request, [selector, ...args]); },
        post() {},
    };
    vm.runInNewContext(source, {
        require: name => ({fs: fileApi, path, os: {homedir: () => home}, "max-api": maxApi})[name],
        process: {platform: "darwin", env: {}},
    });
    return {
        dicts,
        async send(selector, request, ...args) {
            await handlers.get(selector)(request, ...args);
            return replies.get(request);
        },
    };
}

async function verify() {
    const home = fs.mkdtempSync(path.join(os.tmpdir(), "field-kit-midi-profile-"));
    try {
        const writer = loadWriter(home);
        const send = (action, ...args) => writer.send(`midi_profile_${action}`, ...args);
        assert.deepEqual(await send("get", 1, "initial"), ["midi_profile_loaded", "initial"]);
        assert.deepEqual(writer.dicts.get("initial"), {version: 1, mappings: []});

        const largeProfile = {version: 1, mappings: Array.from({length: 250}, (_, index) => ({
            target: `loop-editor-${index}`,
            port: index % 2 ? "Controller Ⅱ" : "Controlador 🎛",
            kind: "cc", number: index % 128, channel: index % 16 + 1,
            mode: "absolute", min: 0, max: 100, invert: false, pickup: true,
            feedback: index % 2 === 0, feedbackPort: "Controlador 🎛", enabled: true,
        }))};
        assert(Buffer.byteLength(JSON.stringify(largeProfile)) > 32767);
        writer.dicts.set("large", largeProfile);
        assert.deepEqual(await send("put", 2, "large"), ["midi_profile_saved"]);

        const restarted = loadWriter(home);
        assert.deepEqual(await restarted.send("midi_profile_get", 3, "restored"),
            ["midi_profile_loaded", "restored"]);
        assert.deepEqual(restarted.dicts.get("restored"), largeProfile);

        const exported = path.join(home, "Tour MIDI Ⅱ.json");
        const selection = {...largeProfile,
            mappings: largeProfile.mappings.filter(binding => binding.port === "Controller Ⅱ")};
        writer.dicts.set("controller", selection);
        assert.deepEqual(await send("export", 4, "controller", exported), ["midi_profile_exported"]);
        assert.deepEqual(JSON.parse(fs.readFileSync(exported, "utf8")), selection);
        assert.deepEqual(await send("import", 5, "portable", exported), ["midi_profile_imported", "portable"]);
        assert.deepEqual(writer.dicts.get("portable"), selection);

        fs.writeFileSync(exported, '{"version":99,"mappings":[]}');
        assert.equal((await send("import", 6, "invalid", exported))[0], "midi_profile_error");
        assert.equal(writer.dicts.has("invalid"), false);
        await send("get", 7, "after import");
        assert.deepEqual(writer.dicts.get("after import"), largeProfile);

        const blocked = loadWriter(home, {
            ...fs,
            renameSync() { throw Object.assign(new Error("Fixture rename failure"), {code: "EACCES"}); },
        });
        blocked.dicts.set("blocked", selection);
        const failed = await blocked.send("midi_profile_put", 8, "blocked");
        assert.equal(failed[0], "midi_profile_error");
        await send("get", 9, "after failure");
        assert.deepEqual(writer.dicts.get("after failure"), largeProfile);
        assert.deepEqual(fs.readdirSync(path.join(home, "Library", "Application Support", "FieldKit")),
            ["midi-mappings.json"]);

        writer.dicts.set("first save", selection);
        writer.dicts.set("clear", {version: 1, mappings: []});
        await Promise.all([send("put", 10, "first save"), send("put", 11, "clear")]);
        await restarted.send("midi_profile_get", 12, "after clearing");
        assert.deepEqual(restarted.dicts.get("after clearing"), {version: 1, mappings: []});
    } finally {
        fs.rmSync(home, {recursive: true, force: true});
    }
    console.log("MIDI mapping profiles passed large-layout round trip, JSON transfer, ordered saves, clearing, and atomic write failure.");
}

verify().catch(error => {
    console.error(error);
    process.exitCode = 1;
});
