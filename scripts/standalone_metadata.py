"""Remove inherited document and URL handler claims from a staged standalone."""
import argparse
from pathlib import Path
import plistlib

HANDLER_KEYS = ('CFBundleDocumentTypes', 'CFBundleURLTypes')


def strip_handlers(path):
    path = Path(path)
    metadata = plistlib.loads(path.read_bytes())
    removed = [key for key in HANDLER_KEYS if key in metadata]
    for key in HANDLER_KEYS:
        metadata.pop(key, None)
    path.write_bytes(plistlib.dumps(metadata, sort_keys=False))
    return removed


def verify_handlers_absent(path):
    metadata = plistlib.loads(Path(path).read_bytes())
    present = [key for key in HANDLER_KEYS if key in metadata]
    if present:
        raise ValueError('Unexpected standalone handler declarations: ' + ', '.join(present))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('plist', type=Path)
    parser.add_argument('--check', action='store_true')
    args = parser.parse_args()
    if args.check:
        verify_handlers_absent(args.plist)
        print('Verified no document or URL handler declarations')
    else:
        print('Removed handler declarations: ' + ', '.join(strip_handlers(args.plist)))
