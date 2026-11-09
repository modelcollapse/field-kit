// Appearance belongs to the window, independently of patterns, Sets and audio.
autowatch = 0;
inlets = 1;
outlets = 0;

var patch = this.patcher;
var fullScreen = false;
var activeWorkspace = 0;
var driftAdvanced = false;
var sourceDrawerOpen = false;
var sourceDrawerHeight = 0;
var windowLayout = [];
var frameWidth = 0;
var frameHeight = 0;
var fitTask = new Task(fit_full_screen, this);
var schemes = [
    {
        colors: ["141A23", "202936", "151E2A", "303F51", "F3F7FC", "B6C5D5", "8FB9F0", "365D88"],
        sections: {
            header: "202B3B", audio: "253345", transport: "202E40",
            source: "203244", source_files: "293448", input: "26384A", input_capture: "33384A",
            patterns: "2C2C42", mixer: "223141", playback: "192635",
            editor_playback: "293A4D", editor_fx: "34364C", editor_mix: "29384B",
            editor_sends: "294152", editor_fade: "2A3345",
            effects: "253145", capture: "34384B", master_output: "253A49", workspace: "222B3A",
            modulation: "253247", scenes: "28364B", visuals: "1C293A", mix: "243347",
            mix_scene_strip: "2C3A50",
            mix_drift: "333448", mix_drift_monitor: "262738", mix_drift_advanced: "2D374B", mix_sends: "203746",
            fx_tone: "2A394D", fx_echo: "2C344B", fx_room: "253B4C"
        }
    },
    {
        colors: ["131E1B", "1E2C27", "13231E", "2D4439", "F2F9F3", "B5CBC0", "99D4AE", "325E4B"],
        sections: {
            header: "20312A", audio: "29392F", transport: "24382F",
            source: "24372C", source_files: "333C31", input: "2C3D32", input_capture: "373D31",
            patterns: "343A2B", mixer: "24382E", playback: "192923",
            editor_playback: "304135", editor_fx: "3A4031", editor_mix: "2C3C32",
            editor_sends: "274438", editor_fade: "30392D",
            effects: "24352B", capture: "353E33", master_output: "284137", workspace: "1F2E27",
            modulation: "26372E", scenes: "2D3B2F", visuals: "1B2C26", mix: "24372C",
            mix_scene_strip: "314538",
            mix_drift: "384032", mix_drift_monitor: "283126", mix_drift_advanced: "293D33", mix_sends: "233931",
            fx_tone: "2A4035", fx_echo: "303C30", fx_room: "293C39"
        }
    },
    {
        colors: ["211915", "30231F", "231914", "46312A", "FCF5EE", "D5BFB1", "F1AB82", "6E4534"],
        sections: {
            header: "352720", audio: "413027", transport: "3B2E26",
            source: "392922", source_files: "3E3033", input: "44322A", input_capture: "4A3334",
            patterns: "422C2E", mixer: "382A24", playback: "2A201D",
            editor_playback: "49352C", editor_fx: "4B3036", editor_mix: "3E3029",
            editor_sends: "4A3C2D", editor_fade: "382824",
            effects: "392923", capture: "43322F", master_output: "493C2F", workspace: "2E2321",
            modulation: "3B2A26", scenes: "402E26", visuals: "2B211F", mix: "372921",
            mix_scene_strip: "48352C",
            mix_drift: "46302A", mix_drift_monitor: "33221F", mix_drift_advanced: "3D302B", mix_sends: "39302D",
            fx_tone: "432F29", fx_echo: "472F2F", fx_room: "41332B"
        }
    }
];

function loadbang() {
    remember_layout();
    patch.getnamed("theme_choice").message("set", 0);
    msg_int(0);
    workspace(0);
}

function workspace(view) {
    if (view < 0 || view > 4 || view !== Math.floor(view)) return;
    activeWorkspace = view;
    patch.getnamed("workspace_view").message("set", view);
    update_mix_panels();
    patch.getnamed("sequence_panel").hidden = view !== 1;
    patch.getnamed("patchbay").hidden = view !== 2;
    patch.getnamed("visuals_panel").hidden = view !== 3;
    patch.getnamed("surface_modulation").hidden = view === 4;
}

function drift_advanced(value) {
    if (value !== 0 && value !== 1) return;
    driftAdvanced = value === 1;
    if (driftAdvanced) workspace(0);
    else update_mix_panels();
}

function update_mix_panels() {
    var inMix = activeWorkspace === 0;
    var mix = patch.getnamed("performance_mix");
    mix.hidden = !inMix;
    patch.getnamed("performance_sends").hidden = !inMix || driftAdvanced;
    patch.getnamed("drifting_memory").hidden = !inMix || !driftAdvanced;
    mix.subpatcher().getnamed("drift_strip_advanced").message("set", driftAdvanced ? 1 : 0);
}
update_mix_panels.local = 1;

function drift_control_visible(name, visible) {
    var control = patch.getnamed("drifting_memory").subpatcher().getnamed(name);
    if (control && control.valid) control.hidden = visible !== 1;
}

function source_drawer(value) {
    if (value !== 0 && value !== 1) return;
    remember_layout();
    var toggle = patch.getnamed("source_drawer_toggle");
    if (toggle && toggle.valid) toggle.message("set", value);
    if (sourceDrawerOpen === (value === 1)) return;
    sourceDrawerOpen = value === 1;
    if (fullScreen) fit_full_screen();
    else resize_workspace(1, 1);
}

function full_screen() {
    remember_layout();
    fullScreen = !fullScreen;
    fitTask.cancel();
    if (fullScreen) {
        patch.fullscreen(1);
        fitTask.schedule(160);
    } else {
        resize_workspace(1, 1);
        patch.fullscreen(0);
    }
    label_full_screen();
}

function exit_full_screen() {
    if (fullScreen) full_screen();
}

function remember_layout() {
    if (windowLayout.length) return;
    var anchor = patch.getnamed("source_drawer_anchor");
    var drawer = anchor && anchor.valid ? anchor.getboxattr("presentation_rect") : null;
    if (drawer && drawer.length === 4) {
        sourceDrawerHeight = drawer[3];
        anchor.hidden = true;
    }
    remember_rects(patch, drawer);
    ["mix_fx", "recorder", "performance_mix", "performance_sends", "drifting_memory",
        "patchbay", "sequence_panel", "visuals_panel"].forEach(function (name) {
        remember_rects(patch.getnamed(name).subpatcher());
    });
}
remember_layout.local = 1;

function remember_rects(target, drawer) {
    target.apply(function (box) {
        if (!Number(box.getboxattr("presentation")) || box.varname === "source_drawer_anchor") return;
        var rect = box.getboxattr("presentation_rect");
        if (!rect || rect.length !== 4) return;
        var isDrawerControl = false;
        if (drawer && rect[1] >= drawer[1] && rect[1] < drawer[1] + sourceDrawerHeight && box.hidden) {
            var annotation = box.getboxattr("annotation") || box.getattr("annotation");
            isDrawerControl = String(annotation) === "source_drawer";
        }
        var shiftDown = drawer && !isDrawerControl && rect[1] >= drawer[1] + 2;
        windowLayout.push({ box: box, rect: rect.slice(), drawer: isDrawerControl, shiftDown: shiftDown });
        if (target === patch && !isDrawerControl) {
            frameWidth = Math.max(frameWidth, rect[0] + rect[2] + 8);
            frameHeight = Math.max(frameHeight, rect[1] + rect[3] + 8);
        }
    });
}
remember_rects.local = 1;

function fit_full_screen() {
    if (!fullScreen || !patch.wind) return;
    var size = patch.wind.size;
    if (!size[0] || !size[1]) return;
    var width = Math.min(1.8, size[0] / frameWidth);
    var height = Math.min(1.18, size[1] / (frameHeight + (sourceDrawerOpen ? sourceDrawerHeight : 0)));
    resize_workspace(width, height);
    label_full_screen();
    patch.wind.bringtofront();
}
fit_full_screen.local = 1;

function resize_workspace(width, height) {
    var wind = patch.wind;
    var dirty = wind && wind.dirty;
    windowLayout.forEach(function (item) {
        var box = item.box;
        if (!box.valid) return;
        if (item.drawer) box.hidden = !sourceDrawerOpen;
        var rect = item.rect;
        var w = rect[2] * width;
        var h = rect[3] * height;
        var x = rect[0] * width;
        var y = (rect[1] + (item.shiftDown && sourceDrawerOpen ? sourceDrawerHeight : 0)) * height;
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
    if (wind) wind.dirty = dirty;
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
    var scheme = schemes[index];
    var palette = scheme.colors.map(rgba);
    var sections = {};
    Object.keys(scheme.sections).forEach(function (name) {
        sections[name] = rgba(scheme.sections[name]);
    });
    var canvas = palette[0], panel = palette[1], inset = palette[2], control = palette[3];
    var ink = palette[4], accent = palette[6], selection = palette[7];

    paint_patch(patch, canvas, palette, sections);
    send_theme(patch.getnamed("pattern_control"), control.concat(selection, accent, ink, canvas));
    send_theme(patch.getnamed("mixer_control"), control.concat(ink));
    paint_patch(patch.getnamed("sequence_panel").subpatcher(), sections.scenes, palette);
    paint_patch(patch.getnamed("visuals_panel").subpatcher(), sections.visuals, palette);
    var performanceMix = patch.getnamed("performance_mix");
    if (performanceMix && performanceMix.valid) {
        paint_patch(performanceMix.subpatcher(), sections.mix, palette, sections);
    }
    paint_patch(patch.getnamed("performance_sends").subpatcher(), sections.mix, palette, sections);
    var source = patch.getnamed("source_control");
    source.message.apply(source, ["wave_theme"].concat(inset, control, accent, ink));
    send_theme(patch.getnamed("loop_fade_preview"), inset.concat(control, ink, palette[5], accent));

    var stereo = patch.getnamed("stereo_field_panel").subpatcher();
    stereo.getnamed("canvas").message("theme", index);
    paint_patch(stereo, panel, palette);
    var effects = patch.getnamed("mix_fx").subpatcher();
    paint_patch(effects, sections.effects, palette, sections);
    var fxPad = effects.getnamed("fx_pad_panel");
    if (fxPad && fxPad.valid) {
        var fxWindow = fxPad.subpatcher();
        fxWindow.getnamed("fx_pad_canvas").message("theme", index);
        paint_patch(fxWindow, panel, palette);
    }
    paint_patch(patch.getnamed("recorder").subpatcher(), sections.capture, palette);
    paint_patch(patch.getnamed("drifting_memory").subpatcher(), sections.mix, palette, sections);
    var modulation = patch.getnamed("patchbay").subpatcher();
    paint_patch(modulation, sections.modulation, palette);
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

function paint_patch(target, background, palette, sections) {
    target.message.apply(target, ["locked_bgcolor"].concat(background));
    target.apply(function (obj) {
        var cls = obj.maxclass;
        if (cls === "comment" || cls === "panel" || cls === "live.text" || cls === "textbutton" || cls === "umenu" ||
            cls === "live.numbox" || cls === "flonum" || cls === "live.slider" || cls === "live.dial" || cls === "live.tab" ||
            cls === "waveform~" || cls === "scope~" || cls === "spectroscope~" || cls === "function") {
            if (Number(obj.getboxattr("presentation"))) paint(obj, palette, sections);
        }
    });
}
paint_patch.local = 1;

function paint(obj, palette, sections) {
    var canvas = palette[0], panel = palette[1], inset = palette[2], control = palette[3];
    var ink = palette[4], muted = palette[5], accent = palette[6], selection = palette[7];
    var name = obj.varname;
    var colors;
    switch (obj.maxclass) {
    case "comment":
        // The input recorder supplies its own white text for the red badge.
        if (name === "input_record_state") return;
        colors = { textcolor: name === "title" ? accent :
            (/status$|_help$|^help$|wave_heading|source_label|record_file|record_format/.test(name) ? muted : ink) };
        break;
    case "panel":
        if (/^loop_row_/.test(name)) return;
        var surface = /^surface_(.+)$/.exec(name);
        colors = { bgcolor: surface ? (sections && sections[surface[1]]) || panel : control };
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
    case "flonum":
        colors = { bgcolor: inset, textcolor: ink, trianglecolor: muted };
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
