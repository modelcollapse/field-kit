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
};

function readFolders() {
    try {
        const saved = JSON.parse(fs.readFileSync(preferences, "utf8"));
        return {
            import: typeof saved.import === "string" ? saved.import : "",
            recording: typeof saved.recording === "string" ? saved.recording : "",
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
    const missing = Object.keys(defaultFolders).some(key => saved[key] && !directory(saved[key]));
    const active = key => saved[key] && directory(saved[key]) ? saved[key] :
        directory(defaultFolders[key]) ? defaultFolders[key] : "";
    maxApi.outlet("folder_paths", active("import"), active("recording"), message ||
        (missing ? "A saved folder is unavailable. Using the default location." :
            "These folders are the starting locations for audio dialogs."));
}

function saveFolder(key, value) {
    let staging;
    try {
        if (key !== "import" && key !== "recording") return;
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
showFolders();
