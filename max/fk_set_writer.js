"use strict";

const fs = require("fs");
const path = require("path");
const os = require("os");
const maxApi = require("max-api");

const stagingName = /^\.field-kit-[^/\\]+\.tmp$/;

function nativePath(value) {
    if (typeof value !== "string" || !value || value.includes("\0")) {
        throw new Error("Expected an absolute file path");
    }

    if (process.platform === "win32") {
        if (!/^(?:[a-z]:[\\/]|[\\/]{2}[^\\/])/i.test(value)) {
            throw new Error("Expected a Windows drive or UNC file path");
        }
        return path.win32.normalize(value);
    }

    if (path.posix.isAbsolute(value)) {
        return path.posix.normalize(value);
    }

    if (process.platform === "darwin") {
        const volumePath = /^([^/:]+):(\/.*)$/.exec(value);
        if (volumePath && volumePath[1] !== "." && volumePath[1] !== "..") {
            // macOS links the named startup volume under /Volumes to /.
            const mount = fs.realpathSync(path.join("/Volumes", volumePath[1]));
            return path.join(mount, path.posix.resolve("/", volumePath[2]));
        }
    }

    throw new Error("Expected an absolute file path or a mounted Max volume path");
}

function sameFile(first, second) {
    return first.dev === second.dev && first.ino === second.ino;
}

function statIfPresent(file) {
    try {
        return fs.lstatSync(file, { bigint: true });
    } catch (error) {
        if (error.code !== "ENOENT") {
            throw error;
        }
    }
    return null;
}

function commitSet(stagedValue, destinationValue) {
    let stagedToRemove;
    try {
        const staged = nativePath(stagedValue);
        const destination = nativePath(destinationValue);
        const stagedBasename = path.basename(staged);
        const destinationBasename = path.basename(destination);
        if (!stagingName.test(stagedBasename)) {
            throw new Error("Invalid set staging filename");
        }

        const stagedParent = fs.realpathSync(path.dirname(staged));
        const destinationParent = fs.realpathSync(path.dirname(destination));
        const stagedPath = path.join(stagedParent, stagedBasename);
        const destinationPath = path.join(destinationParent, destinationBasename);
        if (!sameFile(
            fs.statSync(stagedParent, { bigint: true }),
            fs.statSync(destinationParent, { bigint: true }),
        )) {
            throw new Error("Set staging and destination must share a directory");
        }

        const stagedStat = statIfPresent(stagedPath);
        if (!stagedStat || !stagedStat.isFile()) {
            throw new Error("Missing or invalid staged set file");
        }

        const destinationStat = statIfPresent(destinationPath);
        if (stagedPath === destinationPath || (destinationStat && sameFile(stagedStat, destinationStat))) {
            throw new Error("Set staging and destination must be distinct files");
        }

        stagedToRemove = stagedPath;
        if (destinationStat && !destinationStat.isFile()) {
            throw new Error("Set destination is not a regular file");
        }

        fs.renameSync(stagedPath, destinationPath);
        return 1;
    } catch (error) {
        if (stagedToRemove) {
            try {
                fs.unlinkSync(stagedToRemove);
            } catch (_) {
                // The caller still receives the original commit failure.
            }
        }
        maxApi.post(`Field Kit set save failed: ${error.message}`);
        return 0;
    }
}

maxApi.addHandler("commit_set", (staged, destination) => {
    const result = commitSet(staged, destination);
    maxApi.outlet("set_written", result, typeof staged === "string" ? staged : "");
});

const home = os.homedir();
const workspace = path.join(home, "Documents", "Field Kit");
const appData = process.platform === "darwin"
    ? path.join(home, "Library", "Application Support")
    : process.env.APPDATA || path.join(home, "AppData", "Roaming");
const preferences = path.join(appData, "FieldKit", "working-folders.json");
const defaultFolders = {
    import: path.join(workspace, "Imports"),
    recording: path.join(workspace, "Recordings"),
    banks: path.join(workspace, "Banks"),
};

function readFolders() {
    try {
        const saved = JSON.parse(fs.readFileSync(preferences, "utf8"));
        return {
            import: typeof saved.import === "string" ? saved.import : "",
            recording: typeof saved.recording === "string" ? saved.recording : "",
            banks: typeof saved.banks === "string" ? saved.banks : "",
        };
    } catch (error) {
        if (error.code !== "ENOENT") maxApi.post(`Field Kit could not read working folders: ${error.message}`);
        return {};
    }
}

function directory(value) {
    try {
        return fs.statSync(value).isDirectory();
    } catch (_) {
        return false;
    }
}

function showFolders(message) {
    const saved = readFolders();
    if (!directory(saved.banks) && !directory(defaultFolders.banks)) {
        try {
            fs.mkdirSync(defaultFolders.banks, { recursive: true });
        } catch (error) {
            maxApi.post(`Field Kit could not prepare the bank folder: ${error.message}`);
        }
    }
    const missing = Object.keys(defaultFolders).some(key => saved[key] && !directory(saved[key]));
    const active = key => saved[key] && directory(saved[key]) ? saved[key] :
        directory(defaultFolders[key]) ? defaultFolders[key] : "";
    maxApi.outlet("folder_paths", active("import"), active("recording"), active("banks"), message ||
        (missing ? "A saved folder is unavailable. Using the default location." :
            "Starting locations for audio and bank dialogs."));
}

function saveFolder(key, value) {
    let staging;
    try {
        if (!Object.prototype.hasOwnProperty.call(defaultFolders, key)) return;
        const folder = nativePath(value);
        if (!directory(folder)) {
            showFolders("That folder is unavailable. Choose an existing folder.");
            return;
        }
        const parent = path.dirname(preferences);
        fs.mkdirSync(parent, { recursive: true });
        const saved = readFolders();
        saved[key] = folder;
        staging = fs.mkdtempSync(path.join(parent, ".folders-"));
        const file = path.join(staging, "working-folders.json");
        fs.writeFileSync(file, JSON.stringify(saved) + "\n", { mode: 0o600 });
        fs.renameSync(file, preferences);
        showFolders("Working folder saved.");
    } catch (error) {
        maxApi.post(`Field Kit could not save the working folder: ${error.message}`);
        showFolders("Couldn’t save that folder. The previous setting is still in use.");
    } finally {
        if (staging) fs.rmSync(staging, { recursive: true, force: true });
    }
}

maxApi.addHandler("folder_get", () => showFolders());
maxApi.addHandler("folder_choose", saveFolder);

const inputTemps = new Set();
maxApi.addHandler("create_input_temp", (request) => {
    let filename = "";
    try {
        const folder = fs.mkdtempSync(path.join(os.tmpdir(), "field-kit-take-"));
        filename = path.join(folder, "Field Kit Take.wav");
        inputTemps.add(filename);
    } catch (error) {
        maxApi.post(`Field Kit could not prepare a loop recording: ${error.message}`);
    }
    maxApi.outlet("input_temp_ready", request, filename);
});
maxApi.addHandler("remove_input_temp", (filename) => {
    if (!inputTemps.has(filename)) return;
    try {
        fs.rmSync(filename, { force: true });
        fs.rmdirSync(path.dirname(filename));
        inputTemps.delete(filename);
    } catch (error) {
        maxApi.post(`Field Kit could not remove a temporary recording: ${error.message}`);
    }
});
showFolders();

// One ten-channel disk capture keeps the mix and four stereo stems sample-aligned.
// Split in bounded blocks after recording; exclusive output creation protects old takes.
maxApi.addHandler("split_output", (captureValue, mixValue) => {
    const opened = [], created = [];
    let input;
    try {
        const capture = nativePath(captureValue), mix = nativePath(mixValue);
        if (!/\.wav$/i.test(mix) || capture !== mix.replace(/\.wav$/i, " - synchronized capture.wav")) {
            throw new Error("Unexpected capture path");
        }
        input = fs.openSync(capture, "r");
        const size = fs.fstatSync(input).size, head = Buffer.alloc(12);
        fs.readSync(input, head, 0, 12, 0);
        const rf64 = head.toString("ascii", 0, 4) === "RF64";
        if ((!rf64 && head.toString("ascii", 0, 4) !== "RIFF") || head.toString("ascii", 8, 12) !== "WAVE") throw new Error("Not a WAV");
        let at = 12, format, dataAt, dataSize, extended;
        while (at + 8 <= size) {
            const chunk = Buffer.alloc(8); fs.readSync(input, chunk, 0, 8, at);
            const tag = chunk.toString("ascii", 0, 4), length = chunk.readUInt32LE(4); at += 8;
            if (tag === "ds64") { const ds = Buffer.alloc(16); fs.readSync(input, ds, 0, 16, at); extended = Number(ds.readBigUInt64LE(8)); }
            if (tag === "fmt ") { format = Buffer.alloc(Math.min(length, 40)); fs.readSync(input, format, 0, format.length, at); }
            if (tag === "data") { dataAt = at; dataSize = rf64 && length === 0xffffffff ? extended : length; break; }
            at += length + length % 2;
        }
        if (!format || format.length < 16 || !Number.isSafeInteger(dataSize) || !dataSize || dataAt + dataSize > size || dataSize % 30 ||
            ![1, 0xfffe].includes(format.readUInt16LE(0)) || format.readUInt16LE(2) !== 10 || format.readUInt16LE(14) !== 24 || format.readUInt16LE(12) !== 30) throw new Error("Invalid ten-channel PCM capture");
        const rate = format.readUInt32LE(4), frames = dataSize / 30, stereoBytes = frames * 6;
        const outputs = [mix, ...[1,2,3,4].map(i => mix.replace(/\.wav$/i, ` - Loop ${i}.wav`))];
        for (const output of outputs) {
            const fd = fs.openSync(output, "wx"); opened.push(fd); created.push(output);
            const large = stereoBytes + 36 > 0xffffffff, header = Buffer.alloc(large ? 80 : 44);
            header.write(large ? "RF64" : "RIFF", 0); header.writeUInt32LE(large ? 0xffffffff : stereoBytes + 36, 4); header.write("WAVE", 8);
            let offset = 12;
            if (large) {
                header.write("ds64", offset); header.writeUInt32LE(28, offset + 4);
                header.writeBigUInt64LE(BigInt(stereoBytes + 72), offset + 8); header.writeBigUInt64LE(BigInt(stereoBytes), offset + 16); header.writeBigUInt64LE(BigInt(frames), offset + 24); offset += 36;
            }
            header.write("fmt ", offset); header.writeUInt32LE(16, offset + 4); header.writeUInt16LE(1, offset + 8); header.writeUInt16LE(2, offset + 10);
            header.writeUInt32LE(rate, offset + 12); header.writeUInt32LE(rate * 6, offset + 16); header.writeUInt16LE(6, offset + 20); header.writeUInt16LE(24, offset + 22);
            header.write("data", offset + 24); header.writeUInt32LE(large ? 0xffffffff : stereoBytes, offset + 28); fs.writeSync(fd, header);
        }
        const blockFrames = 8192, block = Buffer.alloc(blockFrames * 30);
        for (let frame = 0; frame < frames; frame += blockFrames) {
            const count = Math.min(blockFrames, frames - frame), bytes = count * 30;
            if (fs.readSync(input, block, 0, bytes, dataAt + frame * 30) !== bytes) throw new Error("Short capture read");
            for (let stem = 0; stem < 5; stem++) {
                const output = Buffer.alloc(count * 6);
                for (let n = 0; n < count; n++) block.copy(output, n * 6, n * 30 + stem * 6, n * 30 + stem * 6 + 6);
                let written = 0;
                while (written < output.length) { const amount = fs.writeSync(opened[stem], output, written, output.length - written); if (!amount) throw new Error("Short disk write"); written += amount; }
            }
        }
        for (const fd of opened) { fs.fsyncSync(fd); fs.closeSync(fd); } opened.length = 0;
        fs.closeSync(input); input = undefined;
        fs.unlinkSync(capture);
        maxApi.outlet("output_split_done", 1, "Saved mix + 4 loops");
    } catch (error) {
        for (const fd of opened) { try { fs.closeSync(fd); } catch (_) {} }
        if (input !== undefined) { try { fs.closeSync(input); } catch (_) {} }
        for (const filename of created) { try { fs.unlinkSync(filename); } catch (_) {} }
        maxApi.post(`Output recording retained its synchronized capture: ${error.message}`);
        maxApi.outlet("output_split_done", 0, "Synchronized capture kept for recovery");
    }
});
