"use strict";

const assert = require("node:assert/strict");
const fs = require("node:fs");
const os = require("node:os");
const path = require("node:path");
const vm = require("node:vm");

const source = fs.readFileSync(path.join(__dirname, "../max/fk_set_writer.js"), "utf8");

function loadWriter(platform = process.platform, fileApi = fs, pathApi = path) {
    let handler;
    let response;
    const maxApi = {
        addHandler(name, callback) {
            assert.equal(name, "commit_set");
            handler = callback;
        },
        outlet(...args) {
            response = args;
        },
        post() {},
    };
    vm.runInNewContext(source, {
        require: name => ({fs: fileApi, path: pathApi, "max-api": maxApi})[name],
        process: {platform},
    });
    return (staged, destination, success) => {
        response = null;
        handler(staged, destination);
        assert.deepEqual(response, ["set_written", success, staged]);
    };
}

const dir = fs.mkdtempSync(path.join(os.tmpdir(), "field-kit-writer-"));
try {
    const write = loadWriter();
    const staging = path.join(dir, ".field-kit-épreuve.tmp");
    const destination = path.join(dir, "My set ✨.json");
    fs.writeFileSync(destination, "original");
    fs.writeFileSync(staging, "next");
    write(staging, destination, 1);
    assert.equal(fs.readFileSync(destination, "utf8"), "next");
    assert.equal(fs.existsSync(staging), false);

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
