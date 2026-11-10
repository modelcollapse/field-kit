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
        process: {platform, env: {}},
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
    return write;
}

const dir = fs.mkdtempSync(path.join(os.tmpdir(), "field-kit-writer-"));
try {
    const write = loadWriter();
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
