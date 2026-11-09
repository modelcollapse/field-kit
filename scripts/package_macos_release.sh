#!/bin/bash
set -euo pipefail

if [[ $# != 5 || ! $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    printf 'Usage: %s VERSION MAX_RUNTIME_ZIP COLLECTIVE FLAT_SOURCE OUTPUT_ZIP\n' "$0" >&2
    exit 2
fi

version=$1
runtime_zip=$2
collective=$3
source=$4
output=$5
max_plist="${FIELD_KIT_MAX_APP:-/Applications/Max.app}/Contents/Info.plist"
test -f "$runtime_zip"
test -s "$collective"
test -f "$max_plist"
test -d "$(dirname "$output")"
if [[ -e $output || -L $output ]]; then
    printf 'The output already exists: %s\n' "$output" >&2
    exit 1
fi

# Reject a stale or incomplete collective before expanding the large runtime ZIP.
python3 - "$collective" "$source" "$(dirname "$0")" <<'PY'
from collections import Counter
import json
from pathlib import Path
import sys


def graph(patcher):
    boxes = {}
    for entry in patcher['boxes']:
        box = entry['box']
        child = graph(box['patcher']) if 'patcher' in box else None
        boxes[box['id']] = (box['maxclass'], box.get('varname'), child)
    lines = (entry['patchline'] for entry in patcher.get('lines', ()))
    cords = Counter((tuple(line['source']), tuple(line['destination'])) for line in lines)
    return boxes, cords


collective, source, scripts = map(Path, sys.argv[1:])
sys.path.insert(0, str(scripts.resolve()))
from prepare_max_project import RUNTIME_ASSETS, TOP_LEVEL

data = collective.read_bytes()
main = json.loads((source / TOP_LEVEL).read_text())['patcher']
if not data.startswith(b'mx@c'):
    raise SystemExit('The input is not a Max collective')
# The compiled top-level patch is first. Max normalizes its JSON and live UI values.
offset = data.index(b'{', 16, 128)
compiled = json.JSONDecoder().raw_decode(data[offset:].decode(errors='replace'))[0]['patcher']
if graph(compiled) != graph(main) or not compiled.get('openinpresentation'):
    raise SystemExit('The compiled patch does not match the staged Field Kit graph')
for group, assets in RUNTIME_ASSETS.items():
    for name in assets.keys() - {TOP_LEVEL}:
        asset = source / name
        if not asset.is_file() or not asset.stat().st_size:
            raise SystemExit(f'The staged source is missing {name}')
        # Max moves media outside the collective when building an app.
        evidence = name.encode() if group == 'media' else asset.read_bytes()
        if evidence not in data:
            raise SystemExit(f'The compiled collective is missing the staged {name}')
print('Verified collective graph and dependencies.')
PY

stage=$(mktemp -d /private/tmp/field-kit-package.XXXXXX)
proof=
trap 'rm -rf "$stage"; if [[ -n $proof ]]; then rm -rf "$proof"; fi' EXIT
app="$stage/Field Kit.app"
ditto -x -k --norsrc --noextattr "$runtime_zip" "$stage"
resources="$app/Contents/Resources"
plist="$app/Contents/Info.plist"
node="$resources/C74/packages/Node for Max/source/bin/osx/node/node"
node_external="$resources/C74/packages/Node for Max/externals/node.script.mxo"

if [[ $(plutil -extract CFBundleIdentifier raw "$plist") != audio.poeticstate.fieldkit ||
      $(plutil -extract CFBundleLongVersionString raw "$plist") != $(plutil -extract CFBundleLongVersionString raw "$max_plist") ]]; then
    printf 'Use a Field Kit runtime from the same build of Max used to compile the collective.\n' >&2
    exit 1
fi
codesign --verify --deep --strict "$app"

plutil -replace CFBundleShortVersionString -string "$version" "$plist"
plutil -replace CFBundleVersion -string "$version" "$plist"
plutil -replace NSMicrophoneUsageDescription -string 'Field Kit uses audio input to record samples.' "$plist"
cp "$collective" "$resources/Field Kit.mxf"
cp "$source/fk_demo.wav" "$resources/C74/media/fk_demo.wav"
cp "$source/fk_set_writer.js" "$resources/fk_set_writer.js"

# Change only the app signature. The signed runtime libraries and Node keep their signatures.
codesign --force --sign - "$app"
codesign --verify --deep --strict "$app"

archive="$stage/field-kit-macos.zip"
ditto -c -k --norsrc --noextattr --keepParent "$app" "$archive"
proof=$(mktemp -d /private/tmp/field-kit-proof.XXXXXX)
ditto -x -k --norsrc --noextattr "$archive" "$proof"
proof_app="$proof/Field Kit.app"
proof_resources="$proof_app/Contents/Resources"
proof_plist="$proof_app/Contents/Info.plist"
codesign --verify --deep --strict "$proof_app"
codesign --verify --strict "$proof${node#"$stage"}"
codesign --verify --strict "$proof${node_external#"$stage"}"
"$proof${node#"$stage"}" --check "$proof_resources/fk_set_writer.js"
lipo "$proof_app/Contents/MacOS/Field Kit" -verify_arch arm64 x86_64
cmp "$collective" "$proof_resources/Field Kit.mxf"
cmp "$source/fk_demo.wav" "$proof_resources/C74/media/fk_demo.wav"
cmp "$source/fk_set_writer.js" "$proof_resources/fk_set_writer.js"
test "$(plutil -extract CFBundleShortVersionString raw "$proof_plist")" = "$version"
test "$(plutil -extract CFBundleVersion raw "$proof_plist")" = "$version"

mv -n "$archive" "$output"
test ! -e "$archive"
proof=
shasum -a 256 "$output"
printf 'Smoke test this extracted copy: %s\n' "$proof_app"
