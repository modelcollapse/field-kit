// Appearance belongs to the window, independently of patterns, Sets and audio.
autowatch = 0;
inlets = 1;
outlets = 0;

var patch = this.patcher;
var fullScreen = false;
var windowLayout = [];
var fitTask = new Task(fit_full_screen, this);
var schemes = [
    ["141A23", "202936", "151E2A", "303F51", "F3F7FC", "B6C5D5", "8FB9F0", "365D88"],
    ["131E1B", "1E2C27", "13231E", "2D4439", "F2F9F3", "B5CBC0", "99D4AE", "325E4B"],
    ["211915", "30231F", "231914", "46312A", "FCF5EE", "D5BFB1", "F1AB82", "6E4534"]
];

function loadbang() {
    patch.getnamed("theme_choice").message("set", 0);
    msg_int(0);
    workspace(1);
}

function workspace(view) {
    if (view < 0 || view > 3 || view !== Math.floor(view)) return;
    patch.getnamed("workspace_view").message("set", view);
    patch.getnamed("sequence_panel").hidden = view !== 0;
    patch.getnamed("patchbay").hidden = view !== 1;
    patch.getnamed("visuals_panel").hidden = view !== 2;
    patch.getnamed("surface_modulation").hidden = view === 3;
}

function full_screen() {
    fullScreen = !fullScreen;
    fitTask.cancel();
    if (fullScreen) {
        windowLayout = [];
        remember_rects(patch);
        ["mix_fx", "recorder", "patchbay", "sequence_panel", "visuals_panel"].forEach(function (name) {
            remember_rects(patch.getnamed(name).subpatcher());
        });
        patch.fullscreen(1);
        fitTask.schedule(160);
    } else {
        resize_workspace(1, 1);
        windowLayout = [];
        patch.fullscreen(0);
    }
    label_full_screen();
}

function exit_full_screen() {
    if (fullScreen) full_screen();
}

function remember_rects(target) {
    target.apply(function (box) {
        if (!Number(box.getboxattr("presentation"))) return;
        var rect = box.getboxattr("presentation_rect");
        if (rect && rect.length === 4) windowLayout.push({ box: box, rect: rect });
    });
}
remember_rects.local = 1;

function fit_full_screen() {
    if (!fullScreen || !patch.wind) return;
    var size = patch.wind.size;
    var width = Math.max(0.75, Math.min(1.8, size[0] / 1084));
    var height = Math.max(0.82, Math.min(1.18, size[1] / 958));
    resize_workspace(width, height);
    label_full_screen();
    patch.wind.bringtofront();
}
fit_full_screen.local = 1;

function resize_workspace(width, height) {
    var dirty = patch.wind.dirty;
    windowLayout.forEach(function (item) {
        var box = item.box;
        var rect = item.rect;
        var w = rect[2] * width;
        var h = rect[3] * height;
        var x = rect[0] * width;
        var y = rect[1] * height;
        // A jsui draws at its patching size. Center it inside its larger presentation cell.
        if (box.maxclass === "jsui") {
            x += (w - rect[2]) * 0.5;
            y += (h - rect[3]) * 0.5;
            w = rect[2];
            h = rect[3];
        } else if (box.varname === "visuals_stereo") {
            // Equal horizontal and vertical scale keeps the mono line at 45 degrees.
            var side = Math.min(w, h);
            x += (w - side) * 0.5;
            y += (h - side) * 0.5;
            w = h = side;
        }
        box.setboxattr("presentation_rect", [x, y, w, h]);
    });
    patch.wind.dirty = dirty;
}
resize_workspace.local = 1;

function label_full_screen() {
    var button = patch.getnamed("fullscreen_toggle");
    var label = fullScreen ? "Exit full screen" : "Full screen";
    button.message("text", label);
    button.message("texton", label);
}
label_full_screen.local = 1;

function msg_int(index) {
    if (index < 0 || index >= schemes.length) return;
    var palette = schemes[index].map(rgba);
    var canvas = palette[0], panel = palette[1], inset = palette[2], control = palette[3];
    var ink = palette[4], accent = palette[6], selection = palette[7];

    paint_patch(patch, canvas, palette);
    send_theme(patch.getnamed("pattern_control"), control.concat(selection, accent, ink, canvas));
    send_theme(patch.getnamed("mixer_control"), control.concat(ink));
    paint_patch(patch.getnamed("sequence_panel").subpatcher(), panel, palette);
    paint_patch(patch.getnamed("visuals_panel").subpatcher(), panel, palette);
    var source = patch.getnamed("source_control");
    source.message.apply(source, ["wave_theme"].concat(inset, control, accent, ink));
    send_theme(patch.getnamed("loop_fade_preview"), inset.concat(control, ink, palette[5], accent));

    var stereo = patch.getnamed("stereo_field_panel").subpatcher();
    stereo.getnamed("canvas").message("theme", index);
    paint_patch(stereo, panel, palette);
    var effects = patch.getnamed("mix_fx").subpatcher();
    paint_patch(effects, panel, palette);
    var fxPad = effects.getnamed("fx_pad_panel");
    if (fxPad && fxPad.valid) {
        var fxWindow = fxPad.subpatcher();
        fxWindow.getnamed("fx_pad_canvas").message("theme", index);
        paint_patch(fxWindow, panel, palette);
    }
    paint_patch(patch.getnamed("recorder").subpatcher(), panel, palette);
    paint_patch(patch.getnamed("drifting_memory").subpatcher(), panel, palette);
    var modulation = patch.getnamed("patchbay").subpatcher();
    paint_patch(modulation, panel, palette);
    send_theme(modulation.getnamed("fk_lfo_preview"), inset.concat(control, selection, accent));
}

function send_theme(obj, colors) {
    obj.message.apply(obj, ["theme"].concat(colors));
}
send_theme.local = 1;

function rgba(hex) {
    var color = parseInt(hex, 16);
    return [(color >> 16) / 255, ((color >> 8) & 255) / 255, (color & 255) / 255, 1];
}
rgba.local = 1;

function paint_patch(target, background, palette) {
    target.message.apply(target, ["locked_bgcolor"].concat(background));
    target.apply(function (obj) {
        var cls = obj.maxclass;
        if (cls === "comment" || cls === "panel" || cls === "live.text" || cls === "textbutton" || cls === "umenu" ||
            cls === "live.numbox" || cls === "live.slider" || cls === "live.dial" || cls === "live.tab" ||
            cls === "waveform~" || cls === "scope~" || cls === "spectroscope~" || cls === "function") {
            if (Number(obj.getboxattr("presentation"))) paint(obj, palette);
        }
    });
}
paint_patch.local = 1;

function paint(obj, palette) {
    var canvas = palette[0], panel = palette[1], inset = palette[2], control = palette[3];
    var ink = palette[4], muted = palette[5], accent = palette[6], selection = palette[7];
    var name = obj.varname;
    var colors;
    switch (obj.maxclass) {
    case "comment":
        // The input recorder supplies its own white text for the red badge.
        if (name === "input_record_state") return;
        colors = { textcolor: name === "title" ? accent :
            (/status$|_help$|^help$|wave_heading|source_label/.test(name) ? muted : ink) };
        break;
    case "panel":
        if (/^loop_row_/.test(name)) return;
        colors = { bgcolor: /^surface_/.test(name) ? panel : control };
        break;
    case "live.text":
        if (/^pattern_([1-8]|store)$|^mixer_(mute|solo)_/.test(name)) return;
        colors = { activebgcolor: name === "play" ? accent : control,
            activetextcolor: name === "play" ? canvas : ink,
            activebgoncolor: accent, activetextoncolor: canvas,
            bgcolor: inset, bgoncolor: control, textoffcolor: muted };
        break;
    case "textbutton":
        colors = { bgcolor: control, bgoncolor: selection, textcolor: ink, textoncolor: ink };
        break;
    case "umenu":
        colors = { bgcolor: control, arrowbgcolor: control, arrowcolor: muted, textcolor: ink };
        break;
    case "live.numbox":
        colors = { activebgcolor: name === "input_gain" ? control : inset, textcolor: ink };
        break;
    case "live.slider":
        colors = { slidercolor: inset, tricolor: accent, trioncolor: ink };
        break;
    case "live.dial":
        colors = { activedialcolor: control, activefgdialcolor: accent,
            activeneedlecolor: ink, textcolor: ink };
        break;
    case "live.tab":
        colors = { activebgcolor: control, activebgoncolor: accent, textcolor: ink, textoncolor: canvas };
        break;
    case "waveform~":
        colors = { bgcolor: inset, gridcolor: control, waveformcolor: accent,
            selectioncolor: selection, linecolor: ink, labeltextcolor: muted };
        break;
    case "scope~":
        colors = { bgcolor: inset, gridcolor: control, fgcolor: accent };
        break;
    case "spectroscope~":
        colors = { bgcolor: inset, fgcolor: accent, markercolor: control,
            sonolocolor: inset, sonomedlocolor: control, sonomedcolor: selection,
            sonomedhicolor: accent, sonohicolor: ink };
        break;
    case "function":
        colors = { bgcolor: inset, gridcolor: control, linecolor: accent, pointcolor: accent };
        break;
    }
    for (var key in colors) obj.message.apply(obj, [key].concat(colors[key]));
}
paint.local = 1;
