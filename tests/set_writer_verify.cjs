"use strict";

const assert = require("node:assert/strict");
const fs = require("node:fs");
const os = require("node:os");
const path = require("node:path");
const vm = require("node:vm");

const source = fs.readFileSync(path.join(__dirname, "../max/fk_set_writer.js"), "utf8");

function loadWriter(platform = process.platform, fileApi = fs, pathApi = path) {
    const handlers = {};
    let response;
    const maxApi = {
        addHandler(name, callback) {
            handlers[name] = callback;
        },
        outlet(...args) {
            response = args;
        },
        post() {},
    };
    vm.runInNewContext(source, {
        require: name => ({fs: fileApi, path: pathApi, os: {homedir: () => dir, tmpdir: () => dir}, "max-api": maxApi})[name],
        process: {platform, env: {}}, Buffer,
    });
    function write(staged, destination, success) {
        response = null;
        handlers.commit_set(staged, destination);
        assert.deepEqual(response, ["set_written", success, staged]);
    }
    write.createTake = (request) => {
        handlers.create_input_temp(request);
        assert.deepEqual(response.slice(0, 2), ["input_temp_ready", request]);
        return response[2];
    };
    write.removeTake = handlers.remove_input_temp;
    write.folders = () => {
        handlers.folder_get();
        return response;
    };
    write.chooseFolder = (key, folder) => {
        handlers.folder_choose(key, folder);
        return response;
    };
    write.split = (capture, mix) => { handlers.split_output(capture, mix); return response; };
    write.prepareOutput = (id, file) => { handlers.prepare_output_folder(id, file); return response; };
    write.prepareLoop = (id, file) => { handlers.prepare_loop_folder(id, file); return response; };
    write.finishLoop = handlers.finish_loop_folder;
    return write;
}

const dir = fs.mkdtempSync(path.join(os.tmpdir(), "field-kit-writer-"));
try {
    const write = loadWriter();
    const selected = path.join(dir, "Output.wav");
    const mix = path.join(dir, "Output", "Output.wav");
    assert.deepEqual(write.prepareOutput(1, selected), ["output_folder_ready", 1, mix]);
    const capture = mix.replace('.wav', ' - synchronized capture.wav');
    const frames = 20000, pcm = Buffer.alloc(frames * 30), header = Buffer.alloc(44);
    header.write('RIFF'); header.writeUInt32LE(pcm.length + 36, 4); header.write('WAVEfmt ', 8);
    header.writeUInt32LE(16, 16); header.writeUInt16LE(1, 20); header.writeUInt16LE(10, 22);
    header.writeUInt32LE(48000, 24); header.writeUInt32LE(48000 * 30, 28); header.writeUInt16LE(30, 32); header.writeUInt16LE(24, 34);
    header.write('data', 36); header.writeUInt32LE(pcm.length, 40);
    for (let frame = 0; frame < frames; frame++) for (let ch = 0; ch < 10; ch++) pcm.writeIntLE(frame * 10 + ch, frame * 30 + ch * 3, 3);
    fs.writeFileSync(capture, Buffer.concat([header, pcm]));
    assert.equal(write.split(capture, mix)[1], 1);
    assert(!fs.existsSync(capture));
    assert.deepEqual(write.prepareOutput(2, selected), ["output_folder_ready", 2, path.join(dir, "Output 2", "Output.wav")]);
    assert.equal(fs.readdirSync(path.dirname(mix)).length, 5);
    for (let stem = 0; stem < 5; stem++) {
        const file = stem ? mix.replace('.wav', ` - Loop ${stem}.wav`) : mix;
        const wav = fs.readFileSync(file); assert.equal(wav.length, 44 + frames * 6);
        for (const frame of [0, 8191, 8192, 19999]) for (let channel = 0; channel < 2; channel++)
            assert.equal(wav.readIntLE(44 + frame * 6 + channel * 3, 3), frame * 10 + stem * 2 + channel);
    }
    // A collision in the final stem must preserve it and roll back only this attempt's outputs.
    const otherMix = path.join(dir, 'Collision.wav'), otherCapture = otherMix.replace('.wav', ' - synchronized capture.wav');
    fs.writeFileSync(otherCapture, Buffer.concat([header, pcm]));
    const occupied = otherMix.replace('.wav', ' - Loop 4.wav'); fs.writeFileSync(occupied, 'KEEP');
    assert.equal(write.split(otherCapture, otherMix)[1], 0);
    assert.equal(fs.readFileSync(occupied, 'utf8'), 'KEEP'); assert(fs.existsSync(otherCapture)); assert(!fs.existsSync(otherMix));

    const occupiedFolder = path.join(dir, "Output 3");
    fs.writeFileSync(occupiedFolder, "KEEP");
    const loop = path.join(dir, "Output 4", "Output.wav");
    assert.deepEqual(write.prepareLoop(1, selected), ["loop_folder_ready", 1, loop]);
    assert.equal(fs.readFileSync(occupiedFolder, "utf8"), "KEEP");
    write.finishLoop(999, 0);
    assert(fs.existsSync(path.dirname(loop)));
    write.finishLoop(1, 0);
    assert(!fs.existsSync(path.dirname(loop)), "a failed save removes its empty folder");
    assert.deepEqual(write.prepareLoop(2, selected), ["loop_folder_ready", 2, loop]);
    fs.writeFileSync(loop, "KEEP");
    write.finishLoop(2, 0);
    assert.equal(fs.readFileSync(loop, "utf8"), "KEEP", "a failed save preserves any audio on disk");
    assert.deepEqual(write.prepareLoop(3, path.join(dir, "missing", "Loop.wav")), ["loop_folder_ready", 3, ""]);

    const bankDefault = path.join(dir, "Documents", "Field Kit", "Banks");
    assert.equal(write.folders()[3], bankDefault);
    assert(fs.statSync(bankDefault).isDirectory());
    const importFolder = path.join(dir, "Imported loops");
    const recordingFolder = path.join(dir, "Recorded loops");
    const bankFolder = path.join(dir, "Saved banks ✨");
    for (const folder of [importFolder, recordingFolder, bankFolder]) fs.mkdirSync(folder);
    write.chooseFolder("import", importFolder);
    write.chooseFolder("recording", recordingFolder);
    const chosen = write.chooseFolder("banks", bankFolder);
    assert.deepEqual(chosen.slice(0, 4), ["folder_paths", importFolder, recordingFolder, bankFolder]);
    assert.deepEqual(loadWriter().folders().slice(1, 4), [importFolder, recordingFolder, bankFolder]);
    fs.rmdirSync(bankFolder);
    assert.equal(write.folders()[3], bankDefault);
    assert.match(write.folders()[4], /unavailable/);
    assert.equal(write.chooseFolder("banks", path.join(dir, "missing"))[3], bankDefault);
    assert.deepEqual(write.folders().slice(1, 3), [importFolder, recordingFolder]);
    const staging = path.join(dir, ".field-kit-épreuve.tmp");
    const destination = path.join(dir, "My set ✨.json");
    fs.writeFileSync(destination, "original");
    fs.writeFileSync(staging, "next");
    write(staging, destination, 1);
    assert.equal(fs.readFileSync(destination, "utf8"), "next");
    assert.equal(fs.existsSync(staging), false);
    const firstTake = write.createTake(1);
    const secondTake = write.createTake(2);
    assert.notEqual(firstTake, secondTake);
    fs.writeFileSync(firstTake, "take");
    write.removeTake(destination);
    assert.equal(fs.readFileSync(destination, "utf8"), "next");
    write.removeTake(firstTake);
    assert.equal(fs.existsSync(path.dirname(firstTake)), false);
    assert.equal(fs.existsSync(path.dirname(secondTake)), true);
    write.removeTake(secondTake);

    fs.writeFileSync(staging, "pending");
    write(staging, staging, 0);
    assert.equal(fs.readFileSync(staging, "utf8"), "pending");
    const other = path.join(dir, "other");
    fs.mkdirSync(other);
    write(staging, path.join(other, "file.json"), 0);
    assert.equal(fs.existsSync(staging), true);

    const hardlink = path.join(dir, "set-link.json");
    fs.linkSync(staging, hardlink);
    write(staging, hardlink, 0);
    assert.equal(fs.existsSync(staging), true);

    const symlink = path.join(dir, "symlink.json");
    fs.symlinkSync(destination, symlink);
    write(staging, symlink, 0);
    assert.equal(fs.existsSync(staging), false);
    assert.equal(fs.lstatSync(symlink).isSymbolicLink(), true);
    assert.equal(fs.readFileSync(destination, "utf8"), "next");

    const denied = loadWriter(process.platform, {
        ...fs,
        renameSync() {
            throw Object.assign(new Error("fixture rename failure"), {code: "EACCES"});
        },
    });
    fs.writeFileSync(staging, "uncommitted");
    denied(staging, destination, 0);
    assert.equal(fs.existsSync(staging), false);
    assert.equal(fs.readFileSync(destination, "utf8"), "next");

    if (process.platform === "darwin") {
        const bootVolume = fs.readdirSync("/Volumes").find(name =>
            fs.realpathSync(path.join("/Volumes", name)) === "/"
        );
        if (bootVolume) {
            fs.writeFileSync(staging, "volume path");
            write(bootVolume + ":" + staging, destination, 1);
            assert.equal(fs.readFileSync(destination, "utf8"), "volume path");
            const volumePrefix = bootVolume + ":";
            const nativeLoop = path.join(dir, "Volume Take", "Volume Take.wav");
            assert.deepEqual(write.prepareLoop(4, volumePrefix + path.join(dir, "Volume Take.wav")),
                ["loop_folder_ready", 4, volumePrefix + nativeLoop]);
            write.finishLoop(4, 1);
            assert(fs.existsSync(path.dirname(nativeLoop)));
        }
    }
} finally {
    fs.rmSync(dir, {recursive: true, force: true});
}

const winStage = "C:\\Users\\Bryan\\.field-kit-win.tmp";
const winTarget = "C:\\Users\\Bryan\\Live set.json";
const renamed = [];
loadWriter("win32", {
    realpathSync: value => value,
    statSync: () => ({dev: 8n, ino: 1n}),
    lstatSync: value => ({dev: 8n, ino: value === winStage ? 2n : 3n, isFile: () => true}),
    renameSync: (staged, target) => renamed.push([staged, target]),
}, path.win32)("C:/Users/Bryan/.field-kit-win.tmp", winTarget, 1);
assert.deepEqual(renamed, [[winStage, winTarget]]);
console.log("Set writer passed replacement, cleanup, correlation, same-file and same-parent guards, macOS boot path, and simulated Windows drive handling.");
