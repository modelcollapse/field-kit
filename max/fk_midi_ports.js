autowatch = 0;
inlets = 3;
outlets = 1;

var patch = this.patcher;
var outputs = [];
var inputScan = [];
var outputScan = [];
var streams = Object.create(null);
var streamId = 0;
var restoredStreamsRemoved = false;
var inputTask = new Task(publishInputs, this);
var outputTask = new Task(publishOutputs, this);

function refresh_devices() {
    patch.getnamed("query_inputs").message("bang");
    patch.getnamed("query_outputs").message("bang");
}

// midiinfo starts each list with clear and one append per device. An explicit
// query ends with set; automatic polling can finish without that message.
function clear() {
    if (inlet === 1) {
        inputScan = [];
        reschedule(inputTask, 35);
    } else if (inlet === 2) {
        outputScan = [];
        reschedule(outputTask, 35);
    }
}

function append() {
    if (inlet === 0) return;
    var name = arrayfromargs(arguments).join(" ");
    var scan = inlet === 1 ? inputScan : outputScan;
    if (name && scan.indexOf(name) === -1) scan.push(name);
}

function set() {
    if (inlet === 1) reschedule(inputTask, 0);
    if (inlet === 2) reschedule(outputTask, 0);
}

function reschedule(task, delay) {
    task.cancel();
    task.schedule(delay);
}
reschedule.local = 1;

function publishInputs() {
    if (!restoredStreamsRemoved) {
        removeRestoredStreams();
        restoredStreamsRemoved = true;
    }
    var found = inputScan.slice();
    Object.keys(streams).forEach(function (port) {
        if (found.indexOf(port) === -1) {
            var disconnected = streams[port].objects;
            delete streams[port];
            removeObjects(disconnected);
        }
    });
    found.forEach(function (port) {
        if (!streams[port]) addStream(port);
    });
    // A string in the first array slot is a Max message selector. The
    // direction remains an argument even when the device list is empty.
    outlet(0, ["midi_devices", "input"].concat(found.filter(function (port) { return !!streams[port]; })));
}
publishInputs.local = 1;

function publishOutputs() {
    outputs = outputScan.slice();
    outlet(0, ["midi_devices", "output"].concat(outputs));
}
publishOutputs.local = 1;

function removeRestoredStreams() {
    var restored = [];
    for (var object = patch.firstobject; object; object = object.nextobject) {
        if (String(object.varname).indexOf("midi_runtime_") === 0) restored.push(object);
    }
    removeObjects(restored);
}
removeRestoredStreams.local = 1;

function removeObjects(objects) {
    objects.forEach(function (object) {
        if (object && object.valid) patch.remove(object);
    });
}
removeObjects.local = 1;

function addStream(port) {
    var id = streamId++;
    var objects = [];
    var controller = patch.getnamed("port_controller");
    function create(type, x, y, args) {
        var object = patch.newdefault.apply(patch, [x, y].concat(args));
        if (!object || !object.valid) throw new Error("MIDI receiver could not be created");
        object.varname = "midi_runtime_" + id + "_" + type;
        objects.push(object);
        return object;
    }
    try {
        ["note", "cc"].forEach(function (kind, index) {
            var x = 16 + index * 330;
            var y = 330 + id * 100;
            // The port name travels as an atom even when it contains spaces.
            var receiver = create(kind + "_input", x, y, [kind === "note" ? "notein" : "ctlin", "none", "@matchport", 1]);
            var pack = create(kind + "_pack", x, y + 28, ["pack", 0, 0, 0]);
            var event = create(kind + "_event", x, y + 56, ["prepend", "receive_" + kind, port, id]);
            for (var i = 0; i < 3; i++) patch.hiddenconnect(receiver, i, pack, i);
            patch.hiddenconnect(pack, 0, event, 0);
            patch.hiddenconnect(event, 0, controller, 0);
            receiver.message("port", port);
        });
        streams[port] = { id: id, objects: objects };
    } catch (error) {
        removeObjects(objects);
        errorMessage(port, error);
    }
}
addStream.local = 1;

function errorMessage(port, error) {
    post("Field Kit could not open MIDI input ", port, ": ", String(error), "\n");
}
errorMessage.local = 1;

function receive_note(port, id, number, value, channel) {
    if (streams[port] && streams[port].id === id) outlet(0, "midi_input", port, "note", number, value, channel);
}

function receive_cc(port, id, value, number, channel) {
    if (streams[port] && streams[port].id === id) outlet(0, "midi_input", port, "cc", number, value, channel);
}

function send_feedback(port, status, number, value) {
    if (outputs.indexOf(port) === -1 || status < 128 || status > 191 ||
        number < 0 || number > 127 || value < 0 || value > 127) return;
    var sender = patch.getnamed("port_feedback");
    sender.message("port", port);
    sender.message(status);
    sender.message(number);
    sender.message(value);
}
