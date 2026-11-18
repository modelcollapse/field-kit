'use strict';
const fs = require('node:fs');
const path = require('node:path');
let location = path.join(__dirname, 'handoff', 'max-exchange');
if (!fs.existsSync(location + '.js')) {
    // node.script can extract this entry from a collective. Its shared CommonJS
    // modules remain external beside the application Resources directory.
    let directory = path.dirname(process.execPath);
    for (;;) {
        const candidate = path.join(directory, 'handoff', 'max-exchange');
        if (fs.existsSync(candidate + '.js')) { location = candidate; break; }
        const parent = path.dirname(directory);
        if (parent === directory) throw new Error('Audio exchange modules are missing from the application Resources directory.');
        directory = parent;
    }
}
require(location).start({ role: 'field-kit' });
