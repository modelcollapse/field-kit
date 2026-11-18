'use strict';
const fs = require('node:fs/promises');
const fsSync = require('node:fs');
const path = require('node:path');
const os = require('node:os');
const crypto = require('node:crypto');

const ROLES = new Set(['looper', 'field-kit', 'fx-patcher']);
const ID = /^mx-[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/;
const KINDS = new Set(['audio', 'slice', 'loop', 'chain']);
const TERMINAL = new Set(['loaded', 'error']);
const defaultRoot = () => path.join(os.homedir(), 'Library', 'Application Support', 'Max Audio Exchange', 'v1');
function validSlot(role, slot) { return role === 'field-kit' ? slot === 'selected' : role === 'fx-patcher' && (slot === 'a' || slot === 'b'); }
function text(value, max = 512) { return typeof value === 'string' && value.length > 0 && value.length <= max && !/[\x00-\x1f]/.test(value); }
function alive(pid) { if (!Number.isInteger(pid) || pid < 1) return false; try { process.kill(pid, 0); return true; } catch (e) { return e.code === 'EPERM'; } }
async function regular(file, max = Infinity) {
    const s = await fs.lstat(file);
    if (!s.isFile() || s.isSymbolicLink() || s.nlink !== 1 || s.size > max) throw Error('Expected a private regular file: ' + path.basename(file));
    return s;
}
async function directory(file) { const s = await fs.lstat(file); if (!s.isDirectory() || s.isSymbolicLink()) throw Error('Unsafe exchange directory'); return s; }
async function readJson(file) { await regular(file, 65536); return JSON.parse(await fs.readFile(file, 'utf8')); }
async function optionalJson(file) { try { return await readJson(file); } catch (e) { if (e.code === 'ENOENT') return null; throw e; } }
async function atomic(file, value, exclusive = false) {
    const temporary = file + '.tmp-' + crypto.randomUUID();
    const handle = await fs.open(temporary, 'wx', 0o600);
    try { await handle.writeFile(JSON.stringify(value)); await handle.sync(); } finally { await handle.close(); }
    try {
        if (exclusive) { await fs.link(temporary, file); await fs.unlink(temporary); }
        else await fs.rename(temporary, file);
    } catch (e) { await fs.unlink(temporary).catch(() => {}); throw e; }
}
async function validateWav(file) {
    const before = await regular(file, 0xffffffff + 8);
    if (before.size < 44) throw Error('WAV is empty or incomplete');
    const handle = await fs.open(file, fsSync.constants.O_RDONLY | (fsSync.constants.O_NOFOLLOW || 0));
    let format, data;
    try {
        const header = Buffer.alloc(12); await handle.read(header, 0, 12, 0);
        if (header.toString('ascii', 0, 4) !== 'RIFF' || header.toString('ascii', 8, 12) !== 'WAVE' || header.readUInt32LE(4) + 8 !== before.size) throw Error('WAV header or declared size is invalid');
        let offset = 12;
        while (offset + 8 <= before.size) {
            const chunk = Buffer.alloc(8); await handle.read(chunk, 0, 8, offset);
            const name = chunk.toString('ascii', 0, 4), length = chunk.readUInt32LE(4), start = offset + 8;
            if (start + length > before.size) throw Error('WAV contains an incomplete chunk');
            if (name === 'fmt ') {
                if (format || length < 16 || length > 4096) throw Error('WAV format chunk is invalid');
                const value = Buffer.alloc(Math.min(length, 40)); await handle.read(value, 0, value.length, start);
                let encoding = value.readUInt16LE(0);
                if (encoding === 0xfffe && length >= 40 && value.readUInt16LE(16) >= 22) {
                    const suffix = value.subarray(26, 40).toString('hex');
                    if (suffix !== '000000001000800000aa00389b71') throw Error('WAV extensible format is unsupported');
                    encoding = value.readUInt16LE(24);
                }
                const channels = value.readUInt16LE(2), sampleRate = value.readUInt32LE(4), byteRate = value.readUInt32LE(8), alignment = value.readUInt16LE(12), depth = value.readUInt16LE(14);
                if (![1, 3].includes(encoding) || ![1, 2].includes(channels) || sampleRate < 8000 || sampleRate > 384000 || !(encoding === 3 ? depth === 32 : [16, 24, 32].includes(depth)) || alignment !== channels * depth / 8 || byteRate !== sampleRate * alignment) throw Error('WAV sample format is unsupported or inconsistent');
                format = { channels, sampleRate, depth, encoding, alignment };
            }
            if (name === 'data') { if (data) throw Error('WAV has multiple audio data chunks'); data = { bytes: length }; }
            offset = start + length + (length & 1);
            if (offset > before.size) throw Error('WAV padding is incomplete');
        }
        if (offset !== before.size || !format || !data || data.bytes < format.alignment || data.bytes % format.alignment) throw Error('WAV audio data is missing or incomplete');
    } finally { await handle.close(); }
    const hash = crypto.createHash('sha256');
    const stream = fsSync.createReadStream(file, { flags: fsSync.constants.O_RDONLY | (fsSync.constants.O_NOFOLLOW || 0) });
    for await (const chunk of stream) hash.update(chunk);
    const after = await regular(file);
    if (before.ino !== after.ino || before.dev !== after.dev || before.size !== after.size || before.mtimeMs !== after.mtimeMs) throw Error('Audio is still changing; finish rendering before sending');
    return { frames: data.bytes / format.alignment, sampleRate: format.sampleRate, channels: format.channels, depth: format.depth, bytes: before.size, sha256: hash.digest('hex') };
}
function validManifest(m, id) {
    return m && m.version === 1 && m.id === id && ID.test(id) && ROLES.has(m.from) && validSlot(m.to, m.slot) && KINDS.has(m.kind) && text(m.label) && m.file === 'audio.wav' && Number.isFinite(m.createdAt) && Number.isInteger(m.frames) && m.frames > 0 && [1, 2].includes(m.channels) && Number.isInteger(m.sampleRate) && m.sampleRate >= 8000 && m.sampleRate <= 384000 && Number.isInteger(m.bytes) && m.bytes >= 44 && /^[a-f0-9]{64}$/.test(m.sha256);
}

function createExchange(options) {
    if (!options || !ROLES.has(options.role)) throw Error('Choose role looper, field-kit, or fx-patcher');
    const role = options.role, root = path.resolve(options.root || defaultRoot());
    const jobs = path.join(root, 'jobs'), locks = path.join(root, 'locks');
    const instanceId = options.instanceId || crypto.randomUUID(), emit = options.emit || (() => {});
    const sent = new Map(); let initialized, polling, timer, active = null, closed = false;
    const pollMs = Math.max(100, options.pollMs || 500), waitingMs = options.waitingMs || 15000;
    const lockPath = path.join(locks, role);
    const jobPath = id => { if (!ID.test(id)) throw Error('Invalid exchange request ID'); return path.join(jobs, id); };
    const signal = (selector, ...args) => emit(selector, ...args);
    async function init() {
        if (!initialized) initialized = (async () => {
            await fs.mkdir(root, { recursive: true, mode: 0o700 }); await directory(root);
            for (const folder of [jobs, locks]) { await fs.mkdir(folder, { mode: 0o700 }).catch(e => { if (e.code !== 'EEXIST') throw e; }); await directory(folder); }
        })();
        await initialized;
    }
    async function safeJob(id) { const folder = jobPath(id); await directory(folder); if (await fs.realpath(folder) !== path.join(await fs.realpath(jobs), id)) throw Error('Request path escapes exchange folder'); return folder; }
    async function prepare(to, slot, kind, label, clientToken) {
        await init();
        if (!validSlot(to, slot) || !KINDS.has(kind) || !text(label)) throw Error('Invalid destination, slot, kind, or label');
        if (clientToken !== undefined && !/^client-[A-Za-z0-9_-]{1,100}$/.test(clientToken)) throw Error('Invalid sender correlation token');
        const id = 'mx-' + crypto.randomUUID(), folder = jobPath(id);
        await fs.mkdir(folder, { mode: 0o700 });
        const draft = { version: 1, id, from: role, to, slot, kind, label, file: 'audio.wav', createdAt: Date.now() };
        await atomic(path.join(folder, 'draft.json'), draft, true);
        sent.set(id, { createdAt: draft.createdAt, last: '' });
        const audio = path.join(folder, 'audio.wav');
        signal('exchange_prepared', id, audio, ...(clientToken === undefined ? [] : [clientToken]));
        return { id, path: audio };
    }
    async function rendered(id) {
        const folder = await safeJob(id), draft = await readJson(path.join(folder, 'draft.json'));
        if (draft.id !== id || draft.from !== role || !validSlot(draft.to, draft.slot) || !KINDS.has(draft.kind) || !text(draft.label) || draft.file !== 'audio.wav') throw Error('Invalid or foreign prepared request');
        const metadata = await validateWav(path.join(folder, 'audio.wav'));
        const request = { ...draft, ...metadata };
        await fs.chmod(path.join(folder, 'audio.wav'), 0o444);
        await atomic(path.join(folder, 'request.json'), request, true).catch(async e => {
            if (e.code !== 'EEXIST') throw e;
            const existing = await readJson(path.join(folder, 'request.json'));
            if (existing.sha256 !== metadata.sha256) throw Error('Published audio cannot be replaced');
        });
        sent.set(id, { createdAt: draft.createdAt, last: '' });
        signal('exchange_queued', id); signal('exchange_status', id, 'queued', 'Waiting for ' + draft.to + ' to receive the audio.'); return request;
    }
    async function rendererfailed(id, reason) {
        const folder = await safeJob(id), draft = await readJson(path.join(folder, 'draft.json'));
        if (draft.from !== role) throw Error('Cannot fail another sender request');
        if (await optionalJson(path.join(folder, 'request.json'))) throw Error('Request is already queued');
        await atomic(path.join(folder, 'ack.json'), { version: 1, id, status: 'error', message: String(reason || 'Audio rendering failed').slice(0, 512), updatedAt: Date.now() });
        signal('exchange_status', id, 'error', String(reason || 'Audio rendering failed')); return true;
    }
    async function acquire(id) {
        const owner = { instanceId, pid: process.pid, token: crypto.randomUUID(), id, time: Date.now() };
        for (let tries = 0; tries < 2; tries++) {
            try { await fs.mkdir(lockPath, { mode: 0o700 }); await atomic(path.join(lockPath, 'owner.json'), owner, true); return owner; }
            catch (e) {
                if (e.code !== 'EEXIST') throw e;
                const previousDirectory = await directory(lockPath);
                const previous = await optionalJson(path.join(lockPath, 'owner.json'));
                if (previous ? alive(previous.pid) : Date.now() - previousDirectory.mtimeMs < 5000) return null;
                // Keep a nonempty tombstone for this exact dead owner. A second
                // contender that read the old owner cannot rename a newer live
                // lease over that same nonempty directory.
                const fingerprint = crypto.createHash('sha256').update(JSON.stringify(previous || { orphan: previousDirectory.mtimeMs })).digest('hex').slice(0, 32);
                const stale = lockPath + '.dead-' + fingerprint;
                try {
                    await fs.rename(lockPath, stale);
                    await atomic(path.join(stale, 'recovered.json'), { recoveredAt: Date.now() }, true);
                } catch (race) {
                    if (['ENOENT', 'EEXIST', 'ENOTEMPTY'].includes(race.code)) return null;
                    throw race;
                }
            }
        }
        return null;
    }
    async function release(owner) {
        const current = await optionalJson(path.join(lockPath, 'owner.json'));
        if (current && current.token === owner.token) { await fs.unlink(path.join(lockPath, 'owner.json')); await fs.rmdir(lockPath); }
    }
    async function reply(id, status, reason) {
        if (!active || active.id !== id) throw Error('No matching active exchange load');
        const current = await readJson(path.join(lockPath, 'owner.json'));
        if (current.token !== active.owner.token) throw Error('Exchange claim is no longer owned');
        const folder = await safeJob(id);
        const message = String(reason || (status === 'loaded' ? 'Audio loaded.' : status === 'waiting' ? 'Destination is busy; waiting to retry.' : 'Destination could not load audio.')).slice(0, 512);
        await atomic(path.join(folder, 'ack.json'), { version: 1, id, receiver: role, instanceId, status, message, updatedAt: Date.now(), ...(status === 'waiting' ? { retryAfter: Date.now() + Math.max(100, options.busyMs || 1000) } : {}) });
        const owner = active.owner; active = null; await release(owner); return true;
    }
    async function work() {
        await init(); if (closed) return;
        const names = (await fs.readdir(jobs)).filter(id => ID.test(id)).sort();
        const requests = [];
        for (const id of names) {
            try {
                const folder = await safeJob(id), request = await optionalJson(path.join(folder, 'request.json'));
                if (!request || !validManifest(request, id)) continue;
                const ack = await optionalJson(path.join(folder, 'ack.json'));
                const safeAck = ack && ack.version === 1 && ack.id === id && ack.receiver === request.to && text(ack.instanceId) && ['loading', 'waiting', 'loaded', 'error'].includes(ack.status) && text(ack.message);
                if (request.from === role) {
                    if (!sent.has(id)) sent.set(id, { createdAt: request.createdAt, last: '' });
                    const entry = sent.get(id), status = safeAck ? ack.status : Date.now() - entry.createdAt >= waitingMs ? 'waiting' : 'queued';
                    const message = safeAck ? ack.message : status === 'waiting' ? 'Still waiting for the destination app; the audio remains queued.' : 'Audio is queued.';
                    const key = status + ':' + message;
                    if (entry.last !== key) { entry.last = key; signal('exchange_status', id, status, message); }
                }
                if (request.to === role && !TERMINAL.has(safeAck && ack.status) && !(safeAck && ack.retryAfter > Date.now())) requests.push(request);
            } catch (e) { signal('exchange_warning', id, 'Skipped unsafe or unreadable request: ' + e.message); }
        }
        if (role === 'looper' || active || !requests.length) return;
        requests.sort((a, b) => a.createdAt - b.createdAt || a.id.localeCompare(b.id));
        for (const request of requests) {
            if (closed) return;
            const owner = await acquire(request.id); if (!owner) return;
            let loading = false;
            try {
                const folder = await safeJob(request.id), ack = await optionalJson(path.join(folder, 'ack.json'));
                if (ack && ack.id === request.id && ack.receiver === role && text(ack.instanceId) && TERMINAL.has(ack.status)) continue;
                const metadata = await validateWav(path.join(folder, 'audio.wav'));
                if (['frames', 'sampleRate', 'channels', 'bytes', 'sha256'].some(key => metadata[key] !== request[key])) throw Error('Audio does not match its published manifest');
                active = { id: request.id, owner };
                await atomic(path.join(folder, 'ack.json'), { version: 1, id: request.id, receiver: role, instanceId, status: 'loading', message: 'Destination is loading the audio.', updatedAt: Date.now() });
                loading = true;
                signal('exchange_load', request.id, path.join(folder, 'audio.wav'), request.label, request.kind, request.slot);
                return;
            } catch (e) {
                loading = false;
                active = null;
                const folder = await safeJob(request.id);
                await atomic(path.join(folder, 'ack.json'), { version: 1, id: request.id, receiver: role, instanceId, status: 'error', message: e.message.slice(0, 512), updatedAt: Date.now() });
                signal('exchange_warning', request.id, e.message);
            } finally { if (!loading) await release(owner); }
        }
    }
    function poll() { if (!polling) polling = work().finally(() => { polling = null; }); return polling; }
    async function start() { await init(); if (closed) throw Error('Exchange is closed'); if (!timer) { timer = setInterval(() => poll().catch(e => signal('exchange_error', e.message)), pollMs); if (timer.unref) timer.unref(); } signal('exchange_ready', role, root); await poll(); return api; }
    async function close() { closed = true; if (timer) clearInterval(timer); timer = null; if (polling) await polling.catch(() => {}); if (active) { const owner = active.owner; active = null; await release(owner); } }
    const api = { prepare, rendered, rendererfailed, loaded: id => reply(id, 'loaded'), failed: (id, reason) => reply(id, 'error', reason), busy: (id, reason) => reply(id, 'waiting', reason), poll, start, close, root, role, instanceId };
    return api;
}
module.exports = { createExchange, validateWav, validSlot, defaultRoot };
