// Highlight presentation controls without modifying or triggering them during Learn.
autowatch = 0;
inlets = 1;
outlets = 0;

include(String(jsarguments[0]).replace(/[^/\\]+$/, "fk_midi_targets.js"));

mgraphics.init();
mgraphics.relative_coords = 0;
mgraphics.autofill = 0;

var patcherPath = jsarguments[1] === "root" ? "" : jsarguments[1];
var hitSpecs = MIDI_HITS[patcherPath] || [];
var regions = [];
var visible = false;
var size = [1, 1];
var clock = new Task(updateRegions, this);
clock.interval = 140;

function getController() {
    var root = patcher;
    while (root.box && root.box.valid) root = root.box.patcher;
    return root.getnamed("io_control");
}
getController.local = 1;

function availableRegions() {
    var result = hitSpecs.reduce(function (found, spec) {
        var control = patcher.getnamed(spec.control);
        if (!control || !control.valid || control.hidden) return found;
        var rect = control.getboxattr("presentation_rect");
        if (!rect || rect.length !== 4 || rect[2] <= 0 || rect[3] <= 0) return found;
        if (spec.region) {
            var ratio = spec.region;
            rect = [rect[0] + ratio[0] * rect[2], rect[1] + ratio[1] * rect[3],
                    (ratio[2] - ratio[0]) * rect[2], (ratio[3] - ratio[1]) * rect[3]];
        }
        found.push({ id: spec.id, rect: rect, caption: spec.caption, fixedId: spec.fixedId });
        return found;
    }, []);
    var canvasName = {
        "mix_fx.fx_pad_panel": "fx_pad_canvas",
        stereo_field_panel: "canvas"
    }[patcherPath];
    var canvas = canvasName && patcher.getnamed(canvasName);
    if (canvas && canvas.valid && !canvas.hidden) {
        var canvasRect = canvas.getboxattr("presentation_rect");
        canvas.js.midi_regions().forEach(function (spec) {
            var rect = spec.rect.slice();
            rect[0] += canvasRect[0];
            rect[1] += canvasRect[1];
            result.push({ id: patcherPath + "." + spec.id, rect: rect, fixedId: spec.fixedId });
        });
    }
    return result;
}
availableRegions.local = 1;

function updateRegions() {
    if (!visible) return;
    regions = availableRegions();
    var next = regions.reduce(function (bounds, region) {
        var rect = region.rect;
        return [Math.max(bounds[0], Math.ceil(rect[0] + rect[2] + 1)),
                Math.max(bounds[1], Math.ceil(rect[1] + rect[3] + 1))];
    }, [1, 1]);
    if (next[0] !== size[0] || next[1] !== size[1]) {
        var wind = patcher.wind;
        var dirty = wind && wind.dirty;
        size = next;
        var rect = [0, 0, size[0], size[1]];
        box.setboxattr("patching_rect", rect);
        box.setboxattr("presentation_rect", rect);
        if (wind) wind.dirty = dirty;
    }
    mgraphics.redraw();
}
updateRegions.local = 1;

function refresh() {
    var controller = getController();
    var midi = controller && controller.valid && controller.js;
    var next = !!(midi && midi.picking);
    if (next !== visible) {
        visible = next;
        var wind = patcher.wind;
        var dirty = wind && wind.dirty;
        box.hidden = !visible;
        if (visible) {
            patcher.bringtofront(box);
            clock.repeat();
        } else {
            clock.cancel();
            regions = [];
            // Preserve the patch's normal scrollbar bounds.
            size = [1, 1];
            box.setboxattr("patching_rect", [0, 0, 1, 1]);
            box.setboxattr("presentation_rect", [0, 0, 1, 1]);
        }
        if (wind) wind.dirty = dirty;
    }
    updateRegions();
}

function bang() {
    var controller = getController();
    var midi = controller && controller.valid && controller.js;
    if (midi && (midi.picking || midi.picked)) controller.message("midi_escape");
}

function mouseTarget(x, y) {
    if (!visible) return null;
    for (var i = regions.length - 1; i >= 0; i--) {
        var region = regions[i];
        var rect = region.rect;
        if (x >= rect[0] && y >= rect[1] && x < rect[0] + rect[2] && y < rect[1] + rect[3]) return region;
    }
    return null;
}
mouseTarget.local = 1;

function hittest(x, y) {
    return mouseTarget(x, y) !== null;
}

function onclick(x, y, button, mod1, shift, caps, opt) {
    var region = mouseTarget(x, y);
    var controller = getController();
    if (!region || !controller || !controller.valid) return;
    var target = MIDI_TARGETS[region.id];
    if (!target) return;
    if (target.navigation && !shift) {
        if (target.options) {
            var position = (x - region.rect[0]) / region.rect[2];
            controller.message("midi_navigate", region.id, Math.floor(position * target.options.length));
        } else {
            controller.message("midi_navigate", region.id);
        }
    } else if (opt && region.fixedId) {
        controller.message("midi_pick", region.fixedId);
    } else if (opt && target.alternateIds) {
        controller.message("midi_pick", region.id, "fixed");
    } else {
        controller.message("midi_pick", region.id);
    }
}

function paint() {
    if (!visible) return;
    var controller = getController();
    if (!controller || !controller.valid) return;
    var midi = controller.js;
    regions.forEach(function (region) {
        var rect = region.rect;
        var chosen = region.id === midi.picked;
        var mapped = typeof midi.isMapped === "function" && midi.isMapped(region.id);
        mgraphics.set_source_rgba(0.48, 0.25, 0.78, chosen ? 0.45 : mapped ? 0.31 : 0.16);
        mgraphics.rectangle(rect[0], rect[1], rect[2], rect[3]);
        mgraphics.fill();
        mgraphics.set_source_rgba(0.82, 0.68, 1, chosen || mapped ? 1 : 0.74);
        mgraphics.set_line_width(chosen ? 2 : 1);
        mgraphics.rectangle(rect[0] + 0.5, rect[1] + 0.5, rect[2] - 1, rect[3] - 1);
        mgraphics.stroke();
        if (region.caption) {
            mgraphics.select_font_face("Arial");
            mgraphics.set_font_size(12);
            mgraphics.move_to(rect[0] + 6, rect[1] + 15);
            mgraphics.show_text(region.caption);
        }
    });
}
