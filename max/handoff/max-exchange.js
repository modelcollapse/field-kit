'use strict';
const { createExchange } = require('./exchange');
function start(options) {
    const max = options.max || require('max-api');
    const exchange = createExchange({ ...options, emit: (selector, ...args) => max.outlet(selector, ...args) });
    const handler = (name, fn) => max.addHandler(name, async (...args) => {
        try { return await fn(...args); }
        catch (error) {
            if (name !== 'prepare' && typeof args[0] === 'string') max.outlet('exchange_status', args[0], 'error', error.message);
            max.outlet('exchange_error', name, error.message);
        }
    });
    handler('prepare', (to, slot, kind, label, clientToken) => exchange.prepare(to, slot, kind, label, clientToken));
    for (const name of ['rendered', 'rendererfailed', 'loaded', 'failed', 'busy']) handler(name, (id, ...reason) => exchange[name](id, reason.join(' ')));
    exchange.start().catch(error => max.outlet('exchange_error', 'start', error.message));
    return exchange;
}
module.exports = { start };
