"""Register Field Kit presentation controls and install click-to-learn overlays."""

import json
import re
from pathlib import Path


CONTINUOUS = {"live.dial", "live.numbox", "live.slider", "flonum", "number"}
MENUS = {"umenu", "live.menu", "live.tab"}
BUTTONS = {"live.text", "live.toggle", "textbutton", "button", "toggle"}
NAVIGATION = {
    "audio_setup", "drift_advanced_tabs", "drift_strip_advanced", "drifting_delay_open",
    "folders_close", "fullscreen_toggle", "fx_pad_close", "fx_pad_open", "scope_popout_close",
    "io_close", "io_open_mappings", "sequence_open", "source_drawer_toggle", "stereo_field_close", "stereo_field_open",
    "visuals_stereo_open", "working_folders", "workspace_view",
}
ACTION_MENUS = {"demo", "loop_copy", "pattern_banks", "set_menu"}
DYNAMIC_MENUS = {
    "fk_active_routes", "fk_mod_target", "fx_pad_x", "fx_pad_y", "input_left", "input_right",
    "io_audio_input", "io_audio_output",
}
POPOUTS = {"fx_pad_panel", "io_setup_panel", "loop_take_panel", "scope_popout_panel",
           "stereo_field_panel", "working_folders_panel"}
SECTIONS = {
    "drifting_memory": "Drifting Memory",
    "fx_pad_panel": "FX Pad",
    "io_setup_panel": "Audio Setup",
    "loop_take_panel": "Input Recording",
    "mix_fx": "Main FX",
    "patchbay": "Modulation",
    "performance_mix": "Drifting Memory",
    "recorder": "Output Recording",
    "scope_popout_panel": "Stereo X/Y",
    "sequence_panel": "Scene Sequencer",
    "stereo_field_panel": "Stereo Field",
    "tuner_panel": "Tuner",
    "visuals_panel": "Visuals",
    "working_folders_panel": "Working Folders",
}
LABELS = {
    "audio_setup": "Audio & MIDI Setup",
    "audio_switch": "Audio On/Off",
    "banks_choose": "Choose Banks Folder",
    "beats_per_bar": "Beats per Bar",
    "demo": "Demos",
    "drift_advanced_tabs": "Advanced Page",
    "drift_strip_advanced": "Advanced View",
    "drift_strip_drift": "Drift",
    "drift_strip_enabled": "On/Off",
    "drift_strip_feedback": "Feedback",
    "drift_strip_mix": "Mix",
    "drift_strip_mode": "Delay Mode",
    "drift_strip_record": "Arm Capture",
    "fk_action_add_route": "Add Route",
    "fk_action_clear_route": "Remove Route",
    "fk_action_use_curve": "Use Curve",
    "fk_active_routes": "Jump to Active Route",
    "fk_mod_lfo": "Select LFO",
    "fk_mod_rate": "Selected LFO Rate",
    "fk_mod_shape": "LFO Shape",
    "fk_mod_target": "Destination",
    "fk_mod_window": "Scope",
    "fx_enabled": "On/Off",
    "fx_mode": "Routing",
    "fx_pad_enabled": "Main FX On/Off",
    "fx_pad_x": "X Assignment",
    "fx_pad_y": "Y Assignment",
    "global_speed": "Global Speed",
    "import_choose": "Choose Imports Folder",
    "input_gain": "Input Gain",
    "input_left": "Left Input Channel",
    "input_monitor": "Input Monitor",
    "input_record_button": "Record/Stop Input",
    "input_right": "Right Input Channel",
    "input_save_button": "Save Loop WAV",
    "inspect_direction": "Direction",
    "inspect_drive": "Drive",
    "inspect_end": "Out Point",
    "inspect_fade": "Crossfade",
    "inspect_filter": "Filter Sweep",
    "inspect_filter_type": "Filter Type",
    "inspect_level": "Level",
    "inspect_pan": "Pan",
    "inspect_rate": "Speed",
    "inspect_start": "In Point",
    "io_audio_input": "Input Device",
    "io_audio_output": "Output Device",
    "load": "Import Audio",
    "loop_copy": "Loop Actions",
    "loop_destination": "Send Audio To",
    "master": "Master Level",
    "mix_scene_advance": "Scenes · Next Bar",
    "mix_scene_toggle": "Scenes · Start/Stop",
    "normal": "Play Original",
    "pattern_banks": "Pattern Banks",
    "pitch_lock": "Pitch Mode",
    "pitch_scale": "Pitch Snap Scale",
    "record_button": "Record/Stop Output",
    "recording_choose": "Choose Recordings Folder",
    "set_menu": "Set Files",
    "source_drawer_toggle": "Source, Input & Files",
    "speed_mode": "Speed Mode",
    "stereo_field_paths": "Show All/Selected Paths",
    "take_confirm": "Use Take",
    "take_discard": "Discard Take",
    "theme_choice": "Theme",
    "tuner_source": "Source",
    "visuals_mode": "Display",
    "workspace_view": "Workspace",
}


def target_id(owner, control):
    return ".".join((*owner, control))


def parameter(box):
    return box.get("saved_attribute_attributes", {}).get("valueof", {})


def control_label(owner, box):
    name = box["varname"]
    loop_control = re.fullmatch(
        r"(play|loop_edit|mixer_mute|mixer_solo|mixer_pan|mixer_level|echo_send|room_send)_(\d)", name
    )
    if loop_control:
        key, voice = loop_control.groups()
        suffix = {
            "play": "Play/Stop", "loop_edit": "Focus", "mixer_mute": "Mute", "mixer_solo": "Solo",
            "mixer_pan": "Pan", "mixer_level": "Level", "echo_send": "Echo Send", "room_send": "Room Send",
        }[key]
        return f"Loop {voice} · {suffix}"
    if re.fullmatch(r"pattern_[1-8]", name):
        return f"Pattern {name[-1]} · Recall"
    if re.fullmatch(r"seq_slot_[0-7]", name):
        return f"Scene Sequencer · Step {int(name[-1]) + 1} Scene"
    label = LABELS.get(name) or parameter(box).get("parameter_longname") or box.get("text")
    label = (label or name.replace("_", " ").title()).strip("▶■● …▴▾")
    if name.startswith("inspect_"):
        return f"Selected Loop · {label}"
    return f"{SECTIONS[owner[-1]]} · {label}" if owner and owner[-1] in SECTIONS else label


def add_box(document, name, maxclass, rect, **attributes):
    index = len(document["boxes"]) + 1
    identifiers = {entry["box"]["id"] for entry in document["boxes"]}
    while f"obj-{index}" in identifiers:
        index += 1
    identifier = f"obj-{index}"
    document["boxes"].append({
        "box": dict(id=identifier, varname=name, maxclass=maxclass, patching_rect=rect, **attributes)
    })
    return identifier


def add_trigger(document, box, destinations):
    """Deliver the same bang a momentary mouse click sends to the patch graph."""
    name = "midi_action_" + box["varname"]
    x, y = box["patching_rect"][:2]
    identifier = add_box(document, name, "button", [x, y + 25, 18, 18],
                         numinlets=1, numoutlets=1, outlettype=["bang"])
    for destination in destinations:
        document["lines"].append({"patchline": {**destination, "source": [identifier, 0]}})
    return name


def entry(owner, name, label, kind, **attributes):
    return dict(label=label, owner=list(owner), control=name, kind=kind, **attributes)


def visible_control(document, owner, box, destinations):
    name = box["varname"]
    maxclass = box["maxclass"]
    value = parameter(box)
    label = control_label(owner, box)
    extras = {"navigation": True} if name in NAVIGATION or name.startswith("loop_edit_") else {}
    if maxclass in CONTINUOUS:
        low = value.get("parameter_mmin", box.get("minimum"))
        high = value.get("parameter_mmax", box.get("maximum"))
        if low is None or high is None:
            raise ValueError(f"Missing MIDI range for {target_id(owner, name)}")
        return entry(owner, name, label, "continuous", min=low, max=high,
                     integer=maxclass == "number" or value.get("parameter_type") == 1, **extras)
    if maxclass in MENUS:
        options = value.get("parameter_enum") or [str(item) for item in box.get("items", []) if item != ","]
        return entry(owner, name, label, "step", options=options, min=0, max=len(options) - 1,
                     **extras, **({"actionMenu": True} if name in ACTION_MENUS else {}),
                     **({"dynamicOptions": True} if name in DYNAMIC_MENUS else {}))
    if re.fullmatch(r"pattern_[1-8]", name):
        return entry(owner, "pattern_control", label, "trigger", message=["slot", int(name[-1]), 0])
    if name.startswith("loop_edit_"):
        return entry(owner, "source_control", label, "trigger",
                     message=["inspect_window", int(name[-1]) - 1], **extras)
    if re.fullmatch(r"mixer_(mute|solo)_\d", name):
        command = name.split("_")[1]
        voice = int(name[-1])
        return entry(owner, "mixer_control", label, "toggle", message=[command, voice],
                     state=dict(control="mixer_control", property=command + "s", index=voice - 1))
    if re.fullmatch(r"play_[1-4]", name):
        voice = int(name[-1])
        return entry(owner, "source_control", label, "toggle", message=["edit_play", voice],
                     state=dict(control="source_control", property="playing", index=voice - 1,
                                bitmask="queuedWindows"))
    if box.get("mode", 1 if maxclass == "live.text" else 0) == 1 or maxclass in {"live.toggle", "toggle"}:
        return entry(owner, name, label, "toggle", **extras)
    relay = add_trigger(document, box, destinations)
    return entry(owner, relay, label, "trigger", read=name,
                 active=maxclass in {"live.text", "textbutton"}, **extras)


def install_midi_targets(patch, root):
    """Generate runtime metadata from the same widgets and ranges used in the UI."""
    targets = {}
    hits = {}
    document = {"boxes": patch.boxes, "lines": patch.lines}
    visit_patcher(document, (), root, targets, hits)
    add_fixed_loop_targets(document, targets, hits)
    add_canvas_targets(targets, hits)
    contents = "// Generated by scripts/build_midi_targets.py.\n"
    contents += f"var MIDI_TARGETS = {json.dumps(targets, ensure_ascii=False, indent=2)};\n"
    contents += f"var MIDI_HITS = {json.dumps(hits, ensure_ascii=False, indent=2)};\n"
    (root / "fk_midi_targets.js").write_text(contents, encoding="utf-8")


def visit_patcher(document, owner, root, targets, hits):
    # Regeneration also works if the support patchers already contain the MIDI overlays.
    generated = {"midi_learn_overlay", "midi_learn_key", "midi_learn_escape"}
    removed = {item["box"]["id"] for item in document["boxes"]
               if item["box"].get("varname", "").startswith("midi_action_")
               or item["box"].get("varname") in generated}
    if removed:
        document["boxes"][:] = [item for item in document["boxes"] if item["box"]["id"] not in removed]
        document["lines"][:] = [item for item in document["lines"]
                                if item["patchline"]["source"][0] not in removed]
    boxes = [item["box"] for item in document["boxes"]]
    branches = {}
    for connection in document["lines"]:
        line = connection["patchline"]
        source, outlet = line["source"]
        if outlet == 0:
            branches.setdefault(source, []).append(line)

    for box in boxes:
        name = box.get("varname", "")
        if name.startswith("midi_") or name == "io_midi_input":
            continue
        child = box.get("patcher")
        if child and name:
            visit_patcher(child, (*owner, name), root, targets, hits)
        elif box["maxclass"] == "bpatcher" and name and box.get("name"):
            source = root / Path(box["name"]).name
            if source.is_file():
                external = json.loads(source.read_text(encoding="utf-8"))
                visit_patcher(external["patcher"], (*owner, name), root, targets, hits)
                source.write_text(json.dumps(external, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

        destinations = branches.get(box["id"], [])
        if not (name and box.get("presentation") and not box.get("ignoreclick") and destinations):
            continue
        if box["maxclass"] not in CONTINUOUS | MENUS | BUTTONS:
            continue
        group = hits.setdefault(".".join(owner), [])
        alias = re.fullmatch(r"mixer_level_value_(\d)", name)
        if alias or name == "inspect_filter_value":
            canonical = f"mixer_level_{alias[1]}" if alias else "inspect_filter"
            group.append(dict(id=target_id(owner, canonical), control=name))
            continue
        identifier = target_id(owner, name)
        targets[identifier] = visible_control(document, owner, box, destinations)
        hit = dict(id=identifier, control=name)
        if re.fullmatch(r"pattern_[1-8]", name):
            slot = int(name[-1])
            hit["fixedId"] = f"pattern_store_{slot}"
            targets[hit["fixedId"]] = entry(owner, "pattern_control", f"Pattern {slot} · Store", "trigger",
                                           message=["slot", slot, 1])
        group.append(hit)

    if ".".join(owner) in hits:
        rect = [0, 0, 1, 1]
        overlay = add_box(document, "midi_learn_overlay", "jsui", rect, numinlets=1, numoutlets=0,
                          presentation=1, presentation_rect=rect, hidden=1,
                          border=0, parameter_enable=0, filename="fk_midi_overlay.js",
                          jsarguments=[".".join(owner) or "root"])
        if owner and owner[-1] in POPOUTS:
            key = add_box(document, "midi_learn_key", "newobj", [180, 732, 50, 22],
                          text="key", numinlets=0, numoutlets=4, outlettype=["int"] * 4)
            escape = add_box(document, "midi_learn_escape", "newobj", [180, 766, 60, 22],
                             text="sel 27", numinlets=2, numoutlets=2, outlettype=["bang", ""])
            for before, after in ((key, escape), (escape, overlay)):
                document["lines"].append({"patchline": {"source": [before, 0], "destination": [after, 0]}})


def add_fixed_loop_targets(document, targets, hits):
    boxes = {item["box"].get("varname"): item["box"] for item in document["boxes"]}
    for name in ("start", "end", "rate", "direction", "fade", "drive", "filter", "level", "pan"):
        alias = "inspect_" + name
        template = targets[alias]
        alternatives = []
        for voice in range(1, 5):
            identifier = f"{name}_{voice}"
            if name in {"level", "pan"}:
                identifier = f"mixer_{name}_{voice}"
            else:
                options = dict(template)
                options["control"] = identifier
                options["label"] = template["label"].replace("Selected Loop", f"Loop {voice}")
                targets[identifier] = options
            alternatives.append(identifier)
        template["alternateIds"] = alternatives

    selected_filter_type = targets["inspect_filter_type"]
    selected_filter_type["alternateIds"] = []
    for voice in range(1, 5):
        identifier = f"filter_type_{voice}"
        targets[identifier] = entry(
            (), "source_control", f"Loop {voice} · Filter Type", "step",
            min=0, max=2, options=selected_filter_type["options"], message=["edit_filter_type", voice],
            state=dict(control="source_control", method="filter_type", args=[voice])
        )
        selected_filter_type["alternateIds"].append(identifier)

    for voice in range(1, 5):
        waveform = f"wave_{voice}"
        if waveform not in boxes:
            continue
        for name, left, right, caption in (
            ("start", 0, 0.5, "In point"), ("end", 0.5, 1, "Out point")
        ):
            hits[""].append(dict(id=f"{name}_{voice}", control=waveform,
                                 region=[left, 0, right, 1], caption=caption))


def add_canvas_targets(targets, hits):
    fx = ("mix_fx", "fx_pad_panel")
    stereo = ("stereo_field_panel",)
    for axis in range(2):
        key = f"axis_{axis}"
        targets[target_id(fx, key)] = entry(
            fx, "fx_pad_canvas", f"FX Pad · {'XY'[axis]} Position", "continuous",
            min=0, max=1, message=["midi_axis", axis],
            state=dict(control="fx_pad_canvas", method="midi_axis_value", args=[axis])
        )
    for index, label in enumerate(("Record/Finish", "Play/Stop Gesture", "Clear Gesture")):
        key = f"motion_{index}"
        targets[target_id(fx, key)] = entry(
            fx, "fx_pad_canvas", f"FX Pad · {label}", "trigger", message=["midi_motion", index]
        )

    for axis, low, label in ((0, -100, "Pan"), (1, 0, "Level")):
        key = f"axis_{axis}"
        targets[target_id(stereo, key)] = entry(
            stereo, "canvas", f"Stereo Field · Selected Loop {label}", "continuous",
            min=low, max=100, message=["midi_axis", axis],
            alternateIds=[f"mixer_{label.lower()}_{voice}" for voice in range(1, 5)],
            state=dict(control="canvas", method="midi_axis_value", args=[axis])
        )
    for voice in range(1, 5):
        targets[target_id(stereo, f"select_{voice}")] = entry(
            stereo, "canvas", f"Stereo Field · Focus Loop {voice}", "trigger",
            message=["midi_select", voice], navigation=True
        )
    for index, label in enumerate(("Record/Finish", "Play/Stop Selected Gesture", "Clear Selected Gesture",
                                   "Play/Stop All Gestures")):
        targets[target_id(stereo, f"motion_{index}")] = entry(
            stereo, "canvas", f"Stereo Field · {label}", "trigger", message=["midi_motion", index]
        )
    for slot in range(1, 5):
        targets[target_id(stereo, f"preset_{slot}")] = entry(
            stereo, "canvas", f"Stereo Field · Recall Preset {slot}", "trigger",
            message=["midi_preset", slot, 0]
        )
        targets[target_id(stereo, f"store_{slot}")] = entry(
            stereo, "canvas", f"Stereo Field · Store Preset {slot}", "trigger",
            message=["midi_preset", slot, 1]
        )
    targets[target_id(stereo, "preset_arm")] = entry(
        stereo, "canvas", "Stereo Field · Arm Preset Store", "trigger", message=["midi_preset_arm"]
    )

    mod = ("patchbay",)
    curve_controls = (
        ("select", "Select Point"), ("time", "Point Time"), ("level", "Point Level"), ("add", "Add Point"),
        ("first", "First Point"), ("previous", "Previous Point"), ("next", "Next Point"), ("remove", "Remove Point"),
    )
    for position, (action, label) in enumerate(curve_controls):
        identifier = target_id(mod, "curve_" + action)
        if action in {"select", "time", "level"}:
            targets[identifier] = entry(
                mod, "fk_router", f"Breakpoint Curve · {label}", "continuous",
                min=-1 if action == "level" else 0, max=1, message=["midi_curve", action],
                state=dict(control="fk_router", method="midi_curve_value", args=[action])
            )
        else:
            targets[identifier] = entry(mod, "fk_router", f"Breakpoint Curve · {label}",
                                        "trigger", message=["midi_curve_action", action])
        row, column = divmod(position, 4)
        hits["patchbay"].append(dict(
            id=identifier, control="fk_curve", region=[column / 4, row / 2, (column + 1) / 4, (row + 1) / 2],
            caption=label
        ))
