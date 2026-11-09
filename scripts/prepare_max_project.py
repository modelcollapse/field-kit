"""Stage a self-contained Max project for a native Application build."""

import argparse
import json
from pathlib import Path
from shutil import copy2


TOP_LEVEL = "Field Kit.maxpat"
PROJECT_NAME = "Field Kit"
RUNTIME_ASSETS = {
    "patchers": {
        TOP_LEVEL: "patcher",
        "fk_modulation.maxpat": "patcher",
        "fk_fx.maxpat": "patcher",
        "fk_record.maxpat": "patcher",
    },
    "code": {
        "fk_mixer.js": "javascript",
        "fk_mod_routes.js": "javascript",
        "fk_source.js": "javascript",
        "fk_stereo_field.js": "javascript",
        "fk_fx_pad.js": "javascript",
        "fk_theme.js": "javascript",
        "fk_lfo_preview.js": "javascript",
        "fk_loop_fade.js": "javascript",
        "fk_set_writer.js": "javascript",
        "fk_recorder.js": "javascript",
        "fk_patterns.js": "javascript",
        "fk_sequence.js": "javascript",
        "fk_voice.gendsp": "gendsp",
    },
    "media": {"fk_demo.wav": "audiofile"},
}
STANDALONE_OPTIONS = (
    "standalone @bundleidentifier audio.poeticstate.fieldkit @preffilename FieldKit "
    "@cefsupport 0 @copysupport 1 @gensupport 1 @usesearchpath 0 "
    "@searchformissingfiles 1 @statusvisible 0"
)


def write_json(path, data):
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n")


def set_app_window(path):
    document = json.loads(path.read_text())
    patcher = document["patcher"]
    patcher["openinpresentation"] = 1
    patcher["toolbarvisible"] = 0
    patcher["title"] = PROJECT_NAME
    standalone = next(
        (entry["box"] for entry in patcher["boxes"]
         if entry["box"].get("text", "").split(" ", 1)[0] == "standalone"),
        None,
    )
    if standalone is None:
        ids = {entry["box"]["id"] for entry in patcher["boxes"]}
        suffix = len(ids) + 1
        while f"obj-{suffix}" in ids:
            suffix += 1
        standalone = {
            "id": f"obj-{suffix}",
            "varname": "standalone_settings",
            "maxclass": "newobj",
            "numinlets": 1,
            "numoutlets": 0,
            "patching_rect": [16, 12, 780, 22],
        }
        patcher["boxes"].append({"box": standalone})
    standalone["text"] = STANDALONE_OPTIONS
    write_json(path, document)


def prepare_project(source, destination):
    if source.resolve() == destination.resolve():
        raise ValueError("Choose a separate folder for the standalone build.")
    missing = [name for files in RUNTIME_ASSETS.values() for name in files if not (source / name).is_file()]
    if missing:
        raise ValueError("Missing runtime files: " + ", ".join(missing))
    contents = {}
    for group, files in RUNTIME_ASSETS.items():
        group_dir = destination / group
        group_dir.mkdir(parents=True, exist_ok=True)
        contents[group] = {}
        for name, kind in files.items():
            copy2(source / name, group_dir / name)
            attributes = {"kind": kind, "local": 1}
            if name == TOP_LEVEL:
                attributes["toplevel"] = 1
            contents[group][name] = attributes
    set_app_window(destination / "patchers" / TOP_LEVEL)
    project_path = destination / (PROJECT_NAME + ".maxproj")
    write_json(project_path, {
        "name": PROJECT_NAME,
        "version": 1,
        "viewrect": [65, 85, 320, 440],
        "autoorganize": 1,
        "hideprojectwindow": 0,
        "showdependencies": 1,
        "autolocalize": 0,
        "contents": contents,
        "layout": {},
        "searchpath": {},
        "detailsvisible": 0,
        "amxdtype": 0,
        "readonly": 0,
        "devpathtype": 0,
        "devpath": ".",
        "sortmode": 0,
        "viewmode": 0,
    })
    return project_path


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path, help="Folder containing the built runtime files")
    parser.add_argument("destination", type=Path, help="Folder for the separate Max project")
    args = parser.parse_args()
    try:
        print(prepare_project(args.source, args.destination))
    except ValueError as error:
        parser.error(str(error))


if __name__ == "__main__":
    main()
