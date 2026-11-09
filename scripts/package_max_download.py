"""Build the editable Max download with a single launcher and a Support folder."""

import argparse
import json
from pathlib import Path
from zipfile import ZIP_DEFLATED, ZipFile

from prepare_max_project import RUNTIME_ASSETS, TOP_LEVEL


ROOT = "Field Kit"
LAUNCHER = "Open FIELD KIT.maxpat"
SUPPORT = "Support"
SUPPORT_PATH = "Patcher:/Support/"
EMBEDDED_PATCHERS = {"fk_fx.maxpat", "fk_modulation.maxpat", "fk_record.maxpat"}
SUPPORT_JSUI = {"fk_lfo_preview.js", "fk_loop_fade.js", "fk_stereo_field.js", "fk_fx_pad.js"}
EMBEDDED_SCRIPTS = {
    "js fk_mod_routes.js": f"js {SUPPORT_PATH}fk_mod_routes.js",
    "js fk_recorder.js": f"js {SUPPORT_PATH}fk_recorder.js",
    "js fk_theme.js": f"js {SUPPORT_PATH}fk_theme.js",
}
START_HERE = """FIELD KIT for Max

1. Extract the ZIP and open the Field Kit folder.
2. Double-click Open FIELD KIT.maxpat. This download requires Max 9.
3. Click Play all to hear the demo, or Load audio... to choose a sample.
4. Choose Slate, Moss, or Ember from Theme in the header.

Open Source, Input & Files. Select your interface in Audio Setup and enable audio. In Input, choose the
left and right channels. For mono, select the same channel twice.
Input gain adjusts both channels from −60 to +18 dB and starts at 0 dB.
The two post-gain peak meters show the recording levels with peak hold
and a red overload indicator.
Click Record source and watch for the red RECORDING badge and timer.
Click Stop source to use the take in all four loops.
Recording stops automatically after 60 seconds. Click Save source WAV… before
saving a Set with the take or replacing it with a different source.

Click a loop number or waveform to focus the editor beside the waveforms. Drag the waveform to set
the range. Fade preview shows how the outgoing and incoming audio overlap.
Choose Low-pass, Flat, or High-pass directly under Filter type. Switch between
Low-pass and High-pass to keep the same strength, or drag Filter sweep to move
continuously through all three.

Click Stereo field… beside FX pad… in the Main FX header. Each dot is one loop.
Drag left or right to pan, and up or down to set level.
Select a loop tab to see its pan and level above the pad.
Click Record, drag and release the dot, then click Play to loop the gesture.
Each loop keeps its own gesture. Use Stop or Clear for the selected loop.

In Main FX, choose Full mix for shared processing, or Loop sends and adjust Echo
and Room sends in the Mix workspace. The four rows edit each loop; Return level
edits the same Echo and Room mix controls as the Main FX dials.
Open FX pad and choose Tone tilt, Echo mix, or Room mix for each axis.
X starts on Echo mix and Y starts on Room mix. Drag right or up to increase the value.
Tone tilt goes from dark through neutral to bright. Enable FX to hear the result.
Click Record, drag and release, then click Play to loop the recorded effect pair.
Stop holds the current values. Clear erases the gesture. Both pads keep gestures
while the patch is open. Stop all and recalling a pattern stop the gestures.
Sets and patterns save the control values, but do not store the gestures.

In Mix, enable Drifting Memory, play your loops and choose All under Arm capture.
The default Two Delays / Small mode returns after about 2½ seconds. Memory shows
the signal in the delay. Wet return shows how much the delay adds to the mix.
Use Mix to blend it in and Off to stop writing. Advanced shows Time, Texture, and
I/O controls beside the delay. Hide advanced brings back Loop sends. The delay
keeps playing either way. The Main FX shortcut opens the same drawer.
Hold freezes the current memory. Cut Tail clears it and sets capture to Off while
the dry mix keeps playing. Release Hold and arm a bank to capture again.
Mix recording includes Drifting Memory. Click Record mix… beside Main FX to save
the final stereo output to a WAV, and Stop mix when you finish.
The L and R master meters show each output channel. A red CLIP light identifies
the channel that hit the output ceiling. Lower Master if either light comes on.

In the modulation patchbay, choose a window for loop controls or Global for Master,
Input gain, Tone, Echo, and Room. Any LFO can route to any destination.
The lower left graph shows the selected LFO shape. Choose Breakpoint or click Use curve
to edit that LFO's own curve. The lower right graph shows the live signal while audio is on.

Playback, loop range edits, and pattern recalls use short fade-out and fade-in transitions.
Fade ms controls the crossfade at the loop seam. Pitch snap treats the sample at 1×
as the tonic and snaps Speed ×, including speed modulation, to the selected scale.

Click a filled pattern to recall it. Shift-click a square to store the current mix.
Open Scene sequencer… beside Banks to show Scenes and put stored patterns in order. Set BPM and
Beats/bar once, then choose a scene and how many bars to hold it in each step.
Start plays the first available scene. Next bar advances at the next bar line.
Repeat starts the list again after the last step. Stop holds the current scene.
Stop all stops the sequencer and the loops. The tempo counts scene bars.
The scene strip between Transport and Master shows the current scene, next playable
scene, and bar count. Use Start, Stop, or Next bar while you stay in Mix.
Switch between Mix, Scenes, Modulation, and Visuals in the lower workspace, or choose
Hide to collapse it. Visuals shows left and right frequency histories and a
stereo scope of the final mix. Switch Display to Spectrum for live frequency
curves. Use Full screen to fit the workspace to the
display. Click Exit full screen or press Escape to return to the window.
Open Source, Input & Files and use Set files… to open or save a Set. Save Set keeps the source
reference, all eight slots, the scene order and tempo, and current settings in
one file. Open Set restores them with playback stopped. If the source moved,
choose its new location.
Use Banks… → Save Bank or Load Bank to exchange patterns with earlier builds.

Keep the Support folder and companion patches beside Open FIELD KIT.maxpat.
Max loads the scripts and demo in Support automatically.
"""


def qualify_support_scripts(patcher):
    for entry in patcher["boxes"]:
        box = entry["box"]
        if box.get("text") in EMBEDDED_SCRIPTS:
            box["text"] = EMBEDDED_SCRIPTS[box["text"]]
        if box.get("filename") in SUPPORT_JSUI:
            box["filename"] = SUPPORT_PATH + box["filename"]
        if "patcher" in box:
            qualify_support_scripts(box["patcher"])


def embed_support_patchers(patcher, source):
    """Embed the three panels so Max can reopen the launcher after saving it."""
    for entry in patcher["boxes"]:
        box = entry["box"]
        if box.get("maxclass") != "bpatcher":
            continue
        name = box.get("name", "").removeprefix(SUPPORT_PATH)
        if name not in EMBEDDED_PATCHERS:
            continue
        if not box.get("embed") or "patcher" not in box:
            box["patcher"] = json.loads((source / name).read_text(encoding="utf-8"))["patcher"]
        box.update(name=name, embed=1)
    qualify_support_scripts(patcher)


def make_download(source, archive):
    assets = [name for files in RUNTIME_ASSETS.values() for name in files]
    for name in assets:
        if not (source / name).is_file():
            raise FileNotFoundError(source / name)

    document = json.loads((source / TOP_LEVEL).read_text(encoding="utf-8"))
    document["patcher"]["title"] = "Field Kit"
    replacements = {
        "js fk_mixer.js": f"js {SUPPORT_PATH}fk_mixer.js",
        "js fk_source.js": f"js {SUPPORT_PATH}fk_source.js",
        "js fk_patterns.js": f"js {SUPPORT_PATH}fk_patterns.js",
        "js fk_sequence.js": f"js {SUPPORT_PATH}fk_sequence.js",
        "node.script fk_set_writer.js @autostart 1":
            f"node.script {SUPPORT_PATH}fk_set_writer.js @autostart 1",
        "gen~ fk_voice": f"gen~ @gen {SUPPORT_PATH}fk_voice.gendsp",
    }
    for entry in document["patcher"]["boxes"]:
        box = entry["box"]
        if box.get("text") in replacements:
            box["text"] = replacements[box["text"]]

    embed_support_patchers(document["patcher"], source)
    archive.parent.mkdir(parents=True, exist_ok=True)
    with ZipFile(archive, "w", compression=ZIP_DEFLATED) as bundle:
        bundle.writestr(f"{ROOT}/{LAUNCHER}", json.dumps(document, ensure_ascii=False, indent=2) + "\n")
        bundle.writestr(f"{ROOT}/START HERE.txt", START_HERE)
        for name in sorted(EMBEDDED_PATCHERS):
            panel = json.loads((source / name).read_text(encoding="utf-8"))
            qualify_support_scripts(panel["patcher"])
            bundle.writestr(f"{ROOT}/{name}", json.dumps(panel, ensure_ascii=False, indent=2) + "\n")
        for name in assets:
            if name != TOP_LEVEL:
                bundle.write(source / name, f"{ROOT}/{SUPPORT}/{name}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("archive", type=Path, help="Path of the output ZIP")
    args = parser.parse_args()
    make_download(Path(__file__).resolve().parents[1] / "max", args.archive)
