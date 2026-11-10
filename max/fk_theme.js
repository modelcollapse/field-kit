// Appearance belongs to the window, independently of patterns, Sets and audio.
autowatch = 0;
inlets = 1;
outlets = 0;

var patch = this.patcher;
var fullScreen = false;
var wideLayout = false;
var activeWorkspace = 0;
var workspaceBeforeScenes = 0;
var workspaceTabs = [0, 2, 3, 4];
var driftAdvanced = true;
var sourceDrawerOpen = false;
var sourceDrawerHeight = 0;
var windowLayout = [];
var frameWidth = 0;
var frameHeight = 0;
var fitTask = new Task(fit_full_screen, this);
var scopeFitTask = new Task(fit_scope_popout, this);
var scopeOpenTask = new Task(show_scope_popout, this);
var foldersOpenTask = new Task(show_working_folders, this);
var ioOpenTask = new Task(show_io_setup, this);
var fieldOpenTask = new Task(show_stereo_field, this);
var scopeSize = [];
var interfacePalette = null;
var mainFxEnabled = false;
var mainFxUsesSends = false;
var driftEnabled = false;
var mainFxDialKeys = ["tone", "distortion", "echo", "time_ms", "repeats", "space", "decay"];
var sideColumnX = 1084;
var sideColumnWidth = 320;
var wideFrameWidth = sideColumnX + sideColumnWidth + 8;
var wideLayoutRects = {
    main: {
        surface_effects: [8, 496, 1068, 128],
        mix_fx: [16, 502, 1052, 116],
        surface_capture: [sideColumnX, 176, sideColumnWidth, 128],
        recorder: [sideColumnX + 8, 184, sideColumnWidth - 16, 112],
        surface_visuals: [sideColumnX, 312, sideColumnWidth, 582],
        visuals_panel: [sideColumnX + 8, 320, sideColumnWidth - 16, 566],
        tuner_panel: [16, 676, 328, 212]
    },
    recorder: {
        capture_title: [0, 0, 190, 20],
        record_time: [219, 0, 85, 20],
        record_format: [0, 24, 304, 17],
        record_button: [0, 46, 149, 22],
        record_status: [0, 71, 304, 18],
        record_file: [0, 91, 304, 17]
    },
    visuals_panel: {
        visuals_heading: [0, 0, 156, 23],
        visuals_mode_label: [161, 2, 54, 20],
        visuals_mode: [218, 0, 86, 22],
        visuals_mix_help: [0, 26, 304, 18]
    }
};
var schemes = [
    {
        colors: ["141A23", "202936", "151E2A", "303F51", "F3F7FC", "B6C5D5", "8FB9F0", "365D88"],
        sections: {
            header: "202B3B", audio: "253345", transport: "202E40",
            source: "203244", source_files: "293448", input: "26384A", input_capture: "33384A",
            patterns: "2C2C42", mixer: "223141", playback: "192635",
            editor_playback: "293A4D", editor_fx: "34364C", editor_mix: "29384B",
            editor_fade: "2A3345",
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
            editor_fade: "30392D",
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
            editor_fade: "382824",
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

function workspace_tab(index) {
    if (workspaceTabs[index] !== undefined) workspace(workspaceTabs[index]);
}

function workspace(view) {
    if (view < 0 || view > 4 || view !== Math.floor(view)) return;
    var sceneLayoutChanged = (activeWorkspace === 1) !== (view === 1);
    if (sceneLayoutChanged && view === 1) workspaceBeforeScenes = activeWorkspace;
    activeWorkspace = view;
    patch.getnamed("workspace_view").message("set", workspaceTabs.indexOf(view === 1 ? workspaceBeforeScenes : view));
    var sceneButton = patch.getnamed("sequence_open");
    var sceneLabel = view === 1 ? "Hide sequencer ▴" : "Scene sequencer ▾";
    sceneButton.message("text", sceneLabel);
    sceneButton.message("texton", sceneLabel);
    update_mix_panels();
    if (sceneLayoutChanged) {
        remember_layout();
        if (fullScreen) fit_full_screen();
        else resize_workspace(1, 1, false);
    }
    update_workspace_panels();
}

function toggle_scene_drawer() {
    workspace(activeWorkspace === 1 ? workspaceBeforeScenes : 1);
}

function update_workspace_panels() {
    patch.getnamed("sequence_panel").hidden = activeWorkspace !== 1;
    patch.getnamed("surface_scenes").hidden = activeWorkspace !== 1;
    patch.getnamed("patchbay").hidden = activeWorkspace !== 2;
    patch.getnamed("tuner_panel").hidden = activeWorkspace !== 3;
    patch.getnamed("visuals_panel").hidden = !wideLayout && activeWorkspace !== 3;
    patch.getnamed("surface_visuals").hidden = !wideLayout;
    patch.getnamed("surface_modulation").hidden = activeWorkspace === 1 || activeWorkspace === 4;
}
update_workspace_panels.local = 1;

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

function fx_power(value) {
    mainFxEnabled = value === 1;
    if (interfacePalette) paint_main_fx();
}

function fx_send_mode(value) {
    mainFxUsesSends = value === 1;
    if (interfacePalette) paint_main_fx();
}

function drift_power(value) {
    driftEnabled = value === 1;
    if (interfacePalette) paint_drift_fx();
}

function source_drawer(value) {
    if (value !== 0 && value !== 1) return;
    remember_layout();
    var toggle = patch.getnamed("source_drawer_toggle");
    if (toggle && toggle.valid) toggle.message("set", value);
    if (sourceDrawerOpen === (value === 1)) return;
    sourceDrawerOpen = value === 1;
    if (fullScreen) fit_full_screen();
    else resize_workspace(1, 1, false);
}

function full_screen() {
    remember_layout();
    fullScreen = !fullScreen;
    fitTask.cancel();
    if (fullScreen) {
        patch.fullscreen(1);
        fitTask.schedule(160);
    } else {
        resize_workspace(1, 1, false);
        patch.fullscreen(0);
    }
    label_full_screen();
}

function exit_full_screen() {
    if (fullScreen) full_screen();
}

function open_working_folders() {
    open_popout(foldersOpenTask);
}

function show_working_folders() {
    patch.getnamed("working_folders_window").message("open");
    patch.getnamed("set_writer").message("folder_get");
}
show_working_folders.local = 1;

function open_io_setup() {
    open_popout(ioOpenTask);
}

function show_io_setup() {
    patch.getnamed("io_setup_window").message("open");
    patch.getnamed("io_control").message("bang");
}
show_io_setup.local = 1;

function open_scope_popout() {
    open_popout(scopeOpenTask);
}

function open_stereo_field() {
    open_popout(fieldOpenTask);
}

function open_popout(task) {
    // Max opens subpatches full screen while the main patch is full screen.
    var delay = fullScreen ? 180 : 0;
    exit_full_screen();
    task.cancel();
    task.schedule(delay);
}
open_popout.local = 1;

function show_stereo_field() {
    patch.getnamed("stereo_field_window").message("open");
}
show_stereo_field.local = 1;

function show_scope_popout() {
    patch.getnamed("scope_popout_window").message("open");
    scopeFitTask.cancel();
    scopeSize = [];
    scopeFitTask.schedule(60);
}
show_scope_popout.local = 1;

function fit_scope_popout() {
    var child = patch.getnamed("scope_popout_panel").subpatcher();
    var wind = child.wind;
    if (!wind || !wind.visible) return;
    var size = wind.size;
    if (size[0] !== scopeSize[0] || size[1] !== scopeSize[1]) {
        var width = Math.max(320, size[0]);
        var height = Math.max(360, size[1]);
        if (width !== size[0] || height !== size[1]) wind.size = [width, height];
        var side = Math.min(width - 32, height - 86);
        var dirty = wind.dirty;
        child.getnamed("scope_popout_title").setboxattr("presentation_rect", [16, 12, width - 122, 27]);
        child.getnamed("scope_popout_close").setboxattr("presentation_rect", [width - 96, 12, 80, 26]);
        child.getnamed("scope_popout_plot").setboxattr("presentation_rect", [(width - side) / 2, 48, side, side]);
        child.getnamed("scope_popout_help").setboxattr("presentation_rect", [8, 58 + side, width - 16, 20]);
        wind.dirty = dirty;
        scopeSize = [width, height];
    }
    scopeFitTask.schedule(80);
}
fit_scope_popout.local = 1;

function remember_layout() {
    if (windowLayout.length) return;
    var anchor = patch.getnamed("source_drawer_anchor");
    var drawer = anchor && anchor.valid ? anchor.getboxattr("presentation_rect") : null;
    if (drawer && drawer.length === 4) {
        sourceDrawerHeight = drawer[3];
        anchor.hidden = true;
    }
    var scenes = patch.getnamed("surface_scenes").getboxattr("presentation_rect");
    var tabs = patch.getnamed("surface_workspace").getboxattr("presentation_rect");
    remember_rects(patch, "main", drawer, {
        top: scenes[1], bottom: tabs[1] + tabs[3], shift: scenes[3] + 8
    });
    ["mix_fx", "recorder", "performance_mix", "performance_sends", "drifting_memory",
        "patchbay", "sequence_panel", "visuals_panel", "tuner_panel"].forEach(function (name) {
        remember_rects(patch.getnamed(name).subpatcher(), name);
    });
}
remember_layout.local = 1;

function remember_rects(target, panel, drawer, sceneDock) {
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
        var alternate = wideLayoutRects[panel];
        var wideRect = alternate && alternate[box.varname];
        var sceneOffset = 0;
        if (sceneDock && !isDrawerControl && box.varname !== "sequence_panel" && box.varname !== "surface_scenes" &&
            rect[1] >= sceneDock.top && rect[1] < sceneDock.bottom) {
            sceneOffset = sceneDock.shift;
        }
        windowLayout.push({
            box: box, rect: rect.slice(), wideRect: wideRect,
            drawer: isDrawerControl, shiftDown: shiftDown, sceneOffset: sceneOffset,
            wideRail: panel === "main" && wideRect && wideRect[0] >= sideColumnX,
            wideTop: panel === "main" && (isDrawerControl || rect[1] < wideLayoutRects.main.surface_capture[1]),
            wideFx: panel === "mix_fx"
        });
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
    var wide = size[0] >= 1400;
    var width = Math.min(1.8, size[0] / (wide ? wideFrameWidth : frameWidth));
    var height = Math.min(1.18, size[1] / (frameHeight + (sourceDrawerOpen ? sourceDrawerHeight : 0)));
    resize_workspace(width, height, wide);
    label_full_screen();
    patch.wind.bringtofront();
}
fit_full_screen.local = 1;

function fit_wide_visuals(width, height) {
    var deck = wideLayoutRects.main.visuals_panel;
    var deckWidth = deck[2] * width;
    var leftTop = 68 * height;
    var labelBand = 24 * height;
    var footerBand = 26 * height;
    var plotHeight = deck[3] * height - leftTop - 2 * labelBand - footerBand;
    // Keep a square X/Y plot and leave usable history plots on shallow screens.
    var plotWidth = Math.min(deckWidth, plotHeight - 2 * 38 * height);
    var channelHeight = (plotHeight - plotWidth) * 0.5;
    var x = (deckWidth - plotWidth) * 0.5;
    var rightTop = leftTop + channelHeight + labelBand;
    var stereoTop = rightTop + channelHeight + labelBand;
    var labelOffset = 22 * height;
    var labelHeight = 20 * height;
    var frequencyWidth = plotWidth * 0.58;
    return {
        visuals_left_label: [x, leftTop - labelOffset, plotWidth - frequencyWidth, labelHeight],
        visuals_frequency_help: [x + plotWidth - frequencyWidth, leftTop - labelOffset, frequencyWidth, labelHeight],
        visuals_left: [x, leftTop, plotWidth, channelHeight],
        visuals_right_label: [x, rightTop - labelOffset, plotWidth, labelHeight],
        visuals_right: [x, rightTop, plotWidth, channelHeight],
        visuals_stereo_open: [x, stereoTop - labelOffset, plotWidth, labelHeight],
        visuals_stereo: [x, stereoTop, plotWidth, plotWidth],
        visuals_stereo_help: [x, stereoTop + plotWidth + 4 * height, plotWidth, labelHeight]
    };
}
fit_wide_visuals.local = 1;

function resize_workspace(width, height, wide) {
    var wind = patch.wind;
    var dirty = wind && wind.dirty;
    if (wideLayout !== wide) {
        wideLayout = wide;
        update_workspace_panels();
    }
    var wideFxScale = wideLayoutRects.main.mix_fx[2] / patch.getnamed("mix_fx").getboxattr("patching_rect")[2];
    var wideVisuals = wide ? fit_wide_visuals(width, height) : {};
    windowLayout.forEach(function (item) {
        var box = item.box;
        if (!box.valid) return;
        if (item.drawer) box.hidden = !sourceDrawerOpen;
        var plotRect = wideVisuals[box.varname];
        if (plotRect) {
            box.setboxattr("presentation_rect", plotRect);
            return;
        }
        var rect = wide && item.wideRect ? item.wideRect : item.rect;
        var horizontal = width;
        if (wide && item.wideTop) horizontal *= wideFrameWidth / frameWidth;
        if (wide && item.wideFx) horizontal *= wideFxScale;
        var w = rect[2] * horizontal;
        var h = rect[3] * height;
        var x = rect[0] * horizontal;
        var sourceOffset = item.shiftDown && sourceDrawerOpen ? sourceDrawerHeight : 0;
        var sceneOffset = activeWorkspace === 1 && !(wide && item.wideRail) ? item.sceneOffset : 0;
        var y = (rect[1] + sourceOffset + sceneOffset) * height;
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
    interfacePalette = palette;
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
    paint_patch(patch.getnamed("io_setup_panel").subpatcher(), sections.input, palette);
    paint_patch(patch.getnamed("working_folders_panel").subpatcher(), sections.source_files, palette);
    var tuner = patch.getnamed("tuner_panel").subpatcher();
    paint_patch(tuner, panel, palette);
    send_theme(tuner.getnamed("tuner_canvas"), inset.concat(ink, palette[5], accent, control));
    paint_patch(patch.getnamed("visuals_panel").subpatcher(), sections.visuals, palette);
    paint_patch(patch.getnamed("scope_popout_panel").subpatcher(), sections.visuals, palette);
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
    paint_main_fx();
    paint_drift_fx();
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

function paint_main_fx() {
    var effects = patch.getnamed("mix_fx").subpatcher();
    var pad = effects.getnamed("fx_pad_panel");
    if (pad && pad.valid) paint_controls(pad.subpatcher(), ["fx_pad_enabled"], false);
    var amountLabel = mainFxUsesSends ? "Return %" : "Mix %";
    effects.getnamed("fx_label_echo").message("set", amountLabel);
    effects.getnamed("fx_label_space").message("set", amountLabel);
    mainFxDialKeys.forEach(function (key) {
        paint_controls(effects, ["fx_" + key, "fx_label_" + key], !mainFxEnabled);
    });
    var sends = ["mixer_echo_sends_label", "mixer_room_sends_label"];
    for (var voice = 1; voice <= 4; voice++) sends.push("echo_send_" + voice, "room_send_" + voice);
    paint_controls(patch, sends, !mainFxEnabled || !mainFxUsesSends);
}
paint_main_fx.local = 1;

function paint_drift_fx() {
    var strip = patch.getnamed("performance_mix").subpatcher();
    paint_controls(strip, ["drift_strip_mix", "drift_strip_feedback", "drift_strip_drift"], !driftEnabled);
    var advanced = patch.getnamed("drifting_memory").subpatcher();
    paint_controls(advanced, ["blur", "width", "pitch", "drive", "dynamics"], !driftEnabled);
}
paint_drift_fx.local = 1;

function paint_controls(target, names, dim) {
    names.forEach(function (name) {
        var control = target.getnamed(name);
        if (control && control.valid) paint(control, interfacePalette, null, dim);
    });
}
paint_controls.local = 1;

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

function paint(obj, palette, sections, dim) {
    var canvas = palette[0], panel = palette[1], inset = palette[2], control = palette[3];
    var ink = palette[4], muted = palette[5], accent = palette[6], selection = palette[7];
    var name = obj.varname;
    var colors;
    switch (obj.maxclass) {
    case "comment":
        // The input recorder supplies its own white text for the red badge.
        if (name === "input_record_state") return;
        colors = { textcolor: name === "title" ? accent :
            (dim || /status$|_help$|^help$|wave_heading|source_label|record_file|record_format/.test(name) ? muted : ink) };
        break;
    case "panel":
        if (/^loop_row_/.test(name)) return;
        var surface = /^surface_(.+)$/.exec(name);
        colors = { bgcolor: surface ? (sections && sections[surface[1]]) || panel : control };
        break;
    case "live.text":
        if (/^pattern_([1-8]|store)$|^mixer_(mute|solo)_/.test(name)) return;
        if (name === "fx_pad_enabled") {
            var powerCaption = mainFxEnabled ? "Main FX · On" : "Main FX · Off";
            var powerFill = mainFxEnabled ? accent : inset;
            var powerText = mainFxEnabled ? canvas : ink;
            obj.message("text", powerCaption);
            obj.message("texton", powerCaption);
            colors = { activebgcolor: powerFill, activebgoncolor: powerFill,
                activetextcolor: powerText, activetextoncolor: powerText, bordercolor: accent };
            break;
        }
        if (name === "fx_enabled" || name === "drift_strip_enabled") {
            colors = { activebgcolor: inset, activetextcolor: ink,
                activebgoncolor: accent, activetextoncolor: canvas, bordercolor: accent };
            break;
        }
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
        colors = { activebgcolor: name === "input_gain" ? control : inset, textcolor: dim ? muted : ink };
        break;
    case "flonum":
        colors = { bgcolor: inset, textcolor: ink, trianglecolor: muted };
        break;
    case "live.slider":
        colors = { slidercolor: inset, tricolor: accent, trioncolor: ink };
        break;
    case "live.dial":
        var arc = dim ? control.map(function (channel, i) { return (channel + muted[i]) * 0.5; }) : accent;
        colors = { activedialcolor: arc, activefgdialcolor: control,
            activeneedlecolor: dim ? muted : ink, textcolor: dim ? muted : ink };
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
