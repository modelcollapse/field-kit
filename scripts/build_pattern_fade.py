"""Hold a short section of the outgoing stereo mix while a pattern changes."""


CODE = r"""
Data tail(131072, 2);
History writeHead(0);
History historyFrames(0);
History previousCommand(0);
History fadePhase(0);
History first(0);
History span(1);
History cursor(0);
History direction(1);

command = in3;
hold = command == 1;
flush = command == 2;
abort = command < 0;
head = writeHead;
frames = historyFrames;
start = first;
length = span;
position = cursor;
step = direction;

if (hold && previousCommand != 1) {
    // Freeze the last 150 ms. Enter it with a short fade to avoid a splice.
    length = min(historyFrames, max(1, floor(samplerate * 0.15)));
    start = (head - length + 131072) % 131072;
    position = 0;
    step = 1;
}

blend = fadePhase;
if (flush) {
    blend = 0;
    frames = 0;
} else if (hold) {
    blend = min(1, fadePhase + 1 / max(1, samplerate * 0.012));
} else {
    // Resume writing the new mix during the fade, ready for the next click.
    if (abort) {
        frames = 0;
    } else {
        poke(tail, in1, head, 0);
        poke(tail, in2, head, 1);
        head = (head + 1) % 131072;
        frames = min(frames + 1, 131072);
    }
    blend = max(0, fadePhase - 1 / max(1, samplerate * (abort ? 0.008 : 0.100)));
}

left = in1;
right = in2;
if (blend > 0 && length > 0) {
    readIndex = (start + position) % 131072;
    l = peek(tail, readIndex, 0);
    r = peek(tail, readIndex, 1);
    // If the scheduler is late, reflect at the ends rather than jumping.
    if (position >= length - 1) {
        step = -1;
    } else if (position <= 0) {
        step = 1;
    }
    position = clamp(position + step, 0, length - 1);
    weight = blend * blend * (3 - 2 * blend);
    left = mix(in1, l, weight);
    right = mix(in2, r, weight);
}

writeHead = head;
historyFrames = frames;
previousCommand = command;
first = start;
span = length;
cursor = position;
direction = step;
fadePhase = blend;
out1 = left;
out2 = right;
// 0 = live, 1 = safe to apply the snapshot, 2 = fading.
out3 = blend >= 1 && hold ? 1 : blend > 0 ? 2 : 0;
"""


def append_pattern_fade(p, patch_type):
    gen = patch_type()
    gen.add("crossfade", "codebox", [32, 80, 510, 360], ins=3, outs=3,
            types=["", "", ""], code=CODE)
    for index in range(3):
        x = 32 + 80 * index
        gen.obj(f"input_{index}", f"in {index + 1}", x, 32, ins=0)
        gen.connect(f"input_{index}", 0, "crossfade", index)
        gen.obj(f"output_{index}", f"out {index + 1}", x, 470, outs=0)
        gen.connect("crossfade", index, f"output_{index}")
    p.add("pattern_transition", "newobj", [550, 1860, 63, 22], text="gen~", ins=3,
          outs=3, types=["signal"] * 3,
          patcher=dict(fileversion=1, classnamespace="dsp.gen", rect=[0, 0, 580, 530],
                       boxes=gen.boxes, lines=gen.lines))
    p.obj("pattern_transition_command", "sig~ 0.", 1550, 2120, types=["signal"])
    p.obj("pattern_transition_sample", "snapshot~ 5 @active 0", 1550, 2155,
          ins=2, types=["float"])
    p.obj("pattern_transition_defer", "deferlow", 1550, 2190)
    p.obj("pattern_transition_phase", "prepend recall_phase", 1550, 2225, ins=2)
    p.connect("pattern_transition_command", 0, "pattern_transition", 2)
    p.connect("pattern_transition", 2, "pattern_transition_sample")
    p.connect("pattern_transition_sample", 0, "pattern_transition_defer")
    p.connect("pattern_transition_defer", 0, "pattern_transition_phase")
    p.connect("pattern_transition_phase", 0, "pattern_control")
