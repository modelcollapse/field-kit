"""Staging removes app file associations without changing unrelated app metadata."""
from pathlib import Path
import plistlib
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'scripts'))
from standalone_metadata import strip_handlers, verify_handlers_absent

with tempfile.TemporaryDirectory(prefix='field-kit-metadata.') as folder:
    path = Path(folder) / 'Info.plist'
    retained = {'CFBundleIdentifier': 'audio.poeticstate.fieldkit',
                'CFBundleShortVersionString': '0.8.27', 'CFBundleIconFile': 'FieldKit.icns',
                'NSMicrophoneUsageDescription': 'Field Kit uses audio input to record samples.'}
    metadata = dict(retained, CFBundleDocumentTypes=[
        {'CFBundleTypeExtensions': ['maxpat', 'json', 'js', 'pdf', 'wav'], 'CFBundleTypeRole': 'Editor'}],
        CFBundleURLTypes=[{'CFBundleURLSchemes': ['max', 'file']}])
    path.write_bytes(plistlib.dumps(metadata))
    try:
        verify_handlers_absent(path)
        raise AssertionError('Unstripped handler claims were not rejected')
    except ValueError:
        pass
    assert set(strip_handlers(path)) == {'CFBundleDocumentTypes', 'CFBundleURLTypes'}
    assert plistlib.loads(path.read_bytes()) == retained
    verify_handlers_absent(path)
    assert strip_handlers(path) == []
    assert plistlib.loads(path.read_bytes()) == retained
print('Standalone metadata: 4 checks passed')
