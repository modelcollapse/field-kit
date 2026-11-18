"""The packager accepts generated MIDI listeners but rejects changed stable wiring."""
import copy
import json
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'scripts'))
from collective_graph import graph

source = json.loads((ROOT / 'max/Field Kit.maxpat').read_text())['patcher']
compiled = copy.deepcopy(source)
ports = next(entry['box']['patcher'] for entry in compiled['boxes']
             if entry['box'].get('varname') == 'io_midi_ports_control')
ports['boxes'].append({'box': {'id': 'generated-midi', 'maxclass': 'newobj',
                             'varname': 'midi_runtime_0_note_input', 'text': 'notein none @matchport 1'}})
ports['lines'].append({'patchline': {'source': ['generated-midi', 0], 'destination': ['obj-3', 0]}})
assert graph(source) == graph(compiled), 'Current-device MIDI listeners should not invalidate a collective'
changed = copy.deepcopy(compiled)
changed['lines'].pop()
assert graph(source) != graph(changed), 'A missing stable connection must be rejected'
changed = copy.deepcopy(compiled)
changed['boxes'].append({'box': {'id': 'generated-midi', 'maxclass': 'newobj',
                               'varname': 'midi_runtime_unexpected_top', 'text': 'dac~'}})
assert graph(source) != graph(changed), 'The transient exception must stay inside MIDI Ports'
changed = copy.deepcopy(compiled)
next(entry['box'] for entry in changed['boxes'] if entry['box'].get('varname') == 'source_control')['maxclass'] = 'message'
assert graph(source) != graph(changed), 'Changed fixed objects must be rejected'
print('Collective stable graph: 4 checks passed')
