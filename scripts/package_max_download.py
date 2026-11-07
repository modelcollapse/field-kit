"""Build the editable Max download with a single launcher and a Support folder."""

import argparse
import json
from pathlib import Path
from zipfile import ZIP_DEFLATED, ZipFile

from prepare_max_project import RUNTIME_ASSETS, TOP_LEVEL


ROOT = "Field Kit - Live Input"
LAUNCHER = "Open FIELD KIT.maxpat"
SUPPORT = "Support"
SUPPORT_PATH = "Patcher:/Support/"
START_HERE = """FIELD KIT for Max

1. Extract the ZIP and open the Field Kit - Live Input folder.
2. Double-click Open FIELD KIT.maxpat. This download requires Max 9.
3. Click Play all to hear the demo, or Load audio... to choose a sample.

Select your interface in Audio Setup and enable audio. In Input recording,
choose the left and right channels. For mono, select the same channel twice.
Input gain adjusts both channels from −60 to +18 dB and starts at 0 dB.
The two post-gain peak meters show the recording levels with peak hold
and a red overload indicator.
Click Record input and watch for the red RECORDING badge and timer.
Click Stop input to use the take in all four loops.
Recording stops automatically after 60 seconds. Click Save input WAV… before
saving a Set with the take or replacing it with a different source.

Click Stereo field in the Mixer. Each dot is one loop.
Drag left or right to pan, and up or down to set level.
Click a loop number to select it if dots overlap. Store a pattern to save the positions.

The lower left graph shows the selected LFO shape. Choose Breakpoint or click Use curve
to edit that LFO's own curve. The lower right graph shows the live signal while audio is on.

Click a filled pattern to recall it. Shift-click a square to store the current mix.
Save Set keeps the source reference, all eight slots and the current settings in one file.
Open Set restores them with playback stopped. If the source moved, choose its new location.
Use Banks… → Save Bank or Load Bank to exchange patterns with earlier builds.

Keep the Support folder beside Open FIELD KIT.maxpat.
Max loads the scripts, patchers, and demo in Support automatically.
"""


def qualify_stereo_script(patcher):
    for entry in patcher["boxes"]:
        box = entry["box"]
        if box.get("filename") == "fk_stereo_field.js":
            box["filename"] = SUPPORT_PATH + box["filename"]
        if "patcher" in box:
            qualify_stereo_script(box["patcher"])


def make_download(source, archive):
    assets = [name for files in RUNTIME_ASSETS.values() for name in files]
    for name in assets:
        if not (source / name).is_file():
            raise FileNotFoundError(source / name)

    document = json.loads((source / TOP_LEVEL).read_text(encoding="utf-8"))
    document["patcher"]["title"] = "Field Kit — Live Input"
    replacements = {
        "js fk_mixer.js": f"js {SUPPORT_PATH}fk_mixer.js",
        "js fk_source.js": f"js {SUPPORT_PATH}fk_source.js",
        "js fk_patterns.js": f"js {SUPPORT_PATH}fk_patterns.js",
        "node.script fk_set_writer.js @autostart 1":
            f"node.script {SUPPORT_PATH}fk_set_writer.js @autostart 1",
        "gen~ fk_voice": f"gen~ @gen {SUPPORT_PATH}fk_voice.gendsp",
    }
    for entry in document["patcher"]["boxes"]:
        box = entry["box"]
        if box.get("text") in replacements:
            box["text"] = replacements[box["text"]]
        if box.get("maxclass") == "bpatcher" and box.get("name") in assets:
            box["name"] = SUPPORT_PATH + box["name"]

    qualify_stereo_script(document["patcher"])
    archive.parent.mkdir(parents=True, exist_ok=True)
    with ZipFile(archive, "w", compression=ZIP_DEFLATED) as bundle:
        bundle.writestr(f"{ROOT}/{LAUNCHER}", json.dumps(document, ensure_ascii=False, indent=2) + "\n")
        bundle.writestr(f"{ROOT}/START HERE.txt", START_HERE)
        for name in assets:
            if name != TOP_LEVEL:
                bundle.write(source / name, f"{ROOT}/{SUPPORT}/{name}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("archive", type=Path, help="Path of the output ZIP")
    args = parser.parse_args()
    make_download(Path(__file__).resolve().parents[1] / "max", args.archive)
