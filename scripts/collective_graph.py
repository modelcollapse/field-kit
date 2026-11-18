"""Compare stable Max wiring while excluding rebuilt MIDI port listeners."""
from collections import Counter


def graph(patcher, dynamic_midi=False):
    # fk_midi_ports.js removes and recreates these listeners at startup. Max may
    # serialize them while exporting a collective, unlike the generated source.
    transient = {
        entry['box']['id'] for entry in patcher['boxes']
        if dynamic_midi and entry['box'].get('varname', '').startswith('midi_runtime_')
    }
    boxes = {}
    for entry in patcher['boxes']:
        box = entry['box']
        if box['id'] in transient:
            continue
        child = graph(box['patcher'], box.get('varname') == 'io_midi_ports_control') if 'patcher' in box else None
        boxes[box['id']] = (box['maxclass'], box.get('varname'), child)
    cords = Counter(
        (tuple(line['source']), tuple(line['destination']))
        for entry in patcher.get('lines', ())
        for line in [entry['patchline']]
        if line['source'][0] not in transient and line['destination'][0] not in transient
    )
    return boxes, cords
