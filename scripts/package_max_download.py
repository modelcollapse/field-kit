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
SUPPORT_JSUI = {"fk_lfo_preview.js", "fk_loop_fade.js", "fk_stereo_field.js", "fk_fx_pad.js", "fk_tuner.js"}
EMBEDDED_SCRIPTS = {
    "js fk_io.js": f"js {SUPPORT_PATH}fk_io.js",
    "js fk_mod_routes.js": f"js {SUPPORT_PATH}fk_mod_routes.js",
    "js fk_recorder.js": f"js {SUPPORT_PATH}fk_recorder.js",
    "js fk_theme.js": f"js {SUPPORT_PATH}fk_theme.js",
}
START_HERE = """FIELD KIT for Max

1. Extract the ZIP and open the Field Kit folder.
2. Double-click Open FIELD KIT.maxpat. This download requires Max 9.
3. Click Play all to hear the original demo. In Source, Input & Files, open Demos… for Glass Circuit (120 BPM) or Tidal Lanterns (75 BPM), or choose a Send to destination and click Import audio… for your own sample.
4. Choose Slate, Moss, or Ember from Theme in the header.

In Transport, Speed changes all four loops from half to double speed.
Relative speed multiplies each loop’s own speed. Same speed plays every loop
at the displayed speed. Choose Tape to change pitch with speed, or Pitch Lock
to keep pitch steady. Relative speed holds each loop’s pitch at 1× global speed.
Same speed holds the source pitch. Save Set keeps the speed and modes.
Open Visuals and set the Tuner source to Live input L, Live input R, or Selected loop.
Enable audio and play one note at a time. The display shows the nearest note,
frequency and cents relative to A4 = 440 Hz.

Open Source, Input & Files → Working folders… to select the starting folders
for Import audio…, Replace audio…, Save Loop WAV…, and Record mix…. Field Kit remembers the two
choices across launches. The default folders, when present, are Imports and
Recordings under Documents/Field Kit.

Open Source, Input & Files → Audio & MIDI Setup… and choose your Input device
and Output device. Enable audio. In Input, choose the left and right channels. For mono, select the same channel twice.
Input gain adjusts both channels from −60 to +18 dB and starts at 0 dB.
The two post-gain peak meters show the recording levels with peak hold
and a red overload indicator.
Choose Selected loop, a loop number, or All loops in Send to. Click Record.
The current loops keep playing. Click Stop recording and confirm or discard. Takes are limited to
60 seconds. Select the recorded loop and choose Save Loop WAV… before saving a Set.
In the loop editor, Copy to Loop… shares the source and copies its range while
keeping the destination’s settings. Replace audio… stages a file for that loop.
Import audio… in the Source drawer uses the same Send to menu. All loops uses
one source, with each loop starting on a different quarter of the audio.

To use MIDI Learn, choose a port under MIDI In, pick a control and click Learn.
Move an absolute CC knob or fader, or use a note or momentary CC for buttons.
Clear removes the selected mapping. Mappings last for the current session.

Click a loop number or waveform to focus the editor beside the waveforms. Drag the waveform to set
the range. Fade preview shows how the outgoing and incoming audio overlap.
Choose Low-pass, Flat (off), or High-pass directly under Filter type. Drive is off at 0%. Switch between
Low-pass and High-pass to keep the same strength, or drag Filter sweep to move
continuously through all three.

Click Stereo field… beside FX pad… in the Main FX header. Each dot is one loop.
Resize the window by dragging an edge.
Drag left or right to pan, and up or down to set level.
Select a loop tab to see its pan and level above the pad.
Shift-click a Field preset slot or click Store preset and choose a slot to save all
four pan and level pairs. Click a filled slot to recall. Save Set keeps these presets.
Click Record and drag the dot. You can release and drag again during the same
take. Click Finish to save and start looping. At 30 seconds the take finishes
and loops automatically. Each loop keeps its own gesture. Use Play / Stop to
control playback or Clear to erase the selected loop’s gesture.
Click Play paths to start every recorded Stereo Field gesture. Paths already
running keep their place. Click Stop paths to stop the gestures while the audio
loops keep playing.
Click Show all paths to see the recorded paths together in each loop’s color.
Click Show selected path to focus on the selected loop again.

Field Kit starts dry. Main FX and Drifting Memory dials dim while the effects are
off and remain editable. In Main FX, choose Full mix for shared processing with
Mix % dials. Choose Loop sends and adjust Echo and Room on each mixer strip to
send those loops to the effects. The main dials then read Return % and set how
much comes back into the mix. FX routing shows the current mode and whether Main FX is on.
Distortion adds soft clipping to the stereo mix and is off at 0%.
Open FX pad and choose Tone tilt, Echo mix, Room mix, or Distortion for each axis.
X starts on Echo mix and Y starts on Room mix. Drag right or up to increase the value.
Tone tilt goes from dark through neutral to bright. Click Main FX · Off in the pad or the Main FX header to turn it on.
Click ● Record, drag across the pad as often as you like, then click Finish
to save and start looping. At 30 seconds the take finishes and loops automatically.
Play / Stop controls playback of the recorded effect pair.
The status below the buttons shows the capture time and the saved effect pair.
In Loop sends, the pad labels these axes Echo return and Room return.
Stop holds the current values. Clear erases the gesture. Stop all and recalling
a pattern stop gesture playback. Save Set keeps the recorded FX Pad gesture
and the Stereo Field gesture for each loop. After opening the Set, click Play
on a pad to replay its saved gesture.

In Mix, click Drift · Off to enable Drifting Memory, play your loops and choose All under Arm capture.
The default Two Delays / Small mode returns after about 2½ seconds. Memory shows
the signal in the delay. Wet return shows how much the delay adds to the mix.
Use Mix to blend it in and Off to stop writing. Advanced opens in Mix at startup and shows Time, Texture, and
I/O controls beside the delay. The mixer sends stay visible and the delay
keeps playing either way. The Main FX shortcut opens the same drawer.
Hold freezes the current memory. Cut Tail clears it and sets capture to Off while
the dry mix keeps playing. Release Hold and arm a bank to capture again.
Mix recording includes Drifting Memory. Click Record mix… beside Main FX to save
the final stereo output to a WAV. Click the same button when it reads Stop
recording to finish and save the take.
The L and R master meters show each output channel. A red CLIP light identifies
the channel that hit the output ceiling. Lower Master if either light comes on.

In the modulation patchbay, choose a loop for its playback, mixer, filter, Drive,
Echo send, and Room send controls. Choose Global for Master, Input gain, Main FX,
and Drifting Memory. Any of the eight LFOs can route to any of the 66 destinations.
Drifting Memory cutoff routes apply in Sweep; timing routes apply in Rhythmic.
Applied value shows what the destination receives while audio is on.
The lower left graph shows the selected LFO shape. Choose Breakpoint or click Use curve
to edit that LFO's own curve. The lower right graph shows the live signal while audio is on.

During playback, pattern and scene recalls crossfade a short buffer of the old mix
into the new mix over 100 ms. Fade ms separately controls the crossfade at the loop seam.
Pitch snap treats the sample at 1×
as the tonic and snaps Speed ×, including speed modulation, to the selected scale.

Click a filled pattern to recall it. Shift-click a square to store the current mix.
Click Scene sequencer beside Banks to show the eight steps below Patterns. Click
Hide sequencer in the same spot to close it while the sequence keeps playing. Set BPM and
Beats/bar once, then choose a scene and how many bars to hold it in each step.
Start plays the first available scene. Next bar advances at the next bar line.
Repeat starts the list again after the last step. Stop holds the current scene.
Stop all stops the sequencer and the loops. The tempo counts scene bars.
The scene strip between Transport and Master shows the current scene, next playable
scene, and bar count. Use Start, Stop, or Next bar while you stay in Mix.
Switch between Mix, Modulation, and Visuals in the lower workspace, or choose
Hide to collapse it. Visuals shows left and right frequency histories and a
stereo scope of the final mix. Click Stereo X/Y… above the scope for a larger
window. Switch Display to Spectrum for live frequency curves. Use Full screen to fit the workspace to the
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
        if box.get("text") == "pfft~ fk_pitch_fft 2048 8":
            box["text"] = f"pfft~ {SUPPORT_PATH}fk_pitch_fft.maxpat 2048 8"
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
