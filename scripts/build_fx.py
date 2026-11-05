"""Build FIELD KIT's stock Max stereo mix effects."""

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "max"
VERSION = dict(major=9, minor=2, revision=0, architecture="arm64", modernui=1)

# Turn-on defaults match the parameters in the native controls. Gen handles
# smoothing so moving a dial or switching bypass does not jump the audio.
CODE = """Param enabled(0);
Param tone(0);
Param echo(20);
Param time_ms(310);
Param repeats(28);
Param space(18);
Param decay(1.7);

History fxMix(0);
History toneMix(0);
History echoMix(0.20);
History echoTime(310);
History echoRepeats(0.28);
History spaceMix(0.18);
History roomDecay(1.7);
History toneLowL(0);
History toneLowR(0);
History echoLowL(0);
History echoLowR(0);
History roomLowA(0);
History roomLowB(0);
History roomLowC(0);
History roomLowD(0);

Delay echoLineL(262144, interp="linear");
Delay echoLineR(262144, interp="linear");
Delay roomDiffuserL(4096);
Delay roomDiffuserR(4096);
Delay roomLineA(32768);
Delay roomLineB(32768);
Delay roomLineC(32768);
Delay roomLineD(32768);

controlRamp = 1 - exp(-1 / (0.020 * samplerate));
timeRamp = 1 - exp(-1 / (0.060 * samplerate));
bypassStep = 1 / (0.020 * samplerate);
fxMix = clamp(clamp(enabled, 0, 1), fxMix - bypassStep, fxMix + bypassStep);
toneMix = mix(toneMix, clamp(tone * 0.01, -1, 1), controlRamp);
echoMix = mix(echoMix, clamp(echo * 0.01, 0, 1), controlRamp);
echoTime = mix(echoTime, clamp(time_ms, 45, 850), timeRamp);
echoRepeats = mix(echoRepeats, clamp(repeats * 0.01, 0, 0.78), controlRamp);
spaceMix = mix(spaceMix, clamp(space * 0.01, 0, 1), controlRamp);
roomDecay = mix(roomDecay, clamp(decay, 0.25, 5), controlRamp);

// Tone tilts around 1.2 kHz. At zero the direct signal passes through.
toneCutoff = 1 - exp(-7539.822369 / samplerate);
toneLowL = mix(toneLowL, in1, toneCutoff);
toneLowR = mix(toneLowR, in2, toneCutoff);
dark = max(-toneMix, 0) * 0.75;
bright = max(toneMix, 0) * 0.75;
toneL = in1 - dark * (in1 - toneLowL) - bright * toneLowL;
toneR = in2 - dark * (in2 - toneLowR) - bright * toneLowR;

// A slight difference in times and crossfeed opens up the repeats in stereo.
samplesPerMs = samplerate * 0.001;
echoTapL = echoLineL.read(clamp(echoTime * samplesPerMs, 1, 262141));
echoTapR = echoLineR.read(clamp(echoTime * 1.17 * samplesPerMs, 1, 262141));
echoCutoff = 1 - exp(-28274.33388 / samplerate);
echoLowL = mix(echoLowL, echoTapL, echoCutoff);
echoLowR = mix(echoLowR, echoTapR, echoCutoff);
echoLineL.write(toneL + echoRepeats * mix(echoLowL, echoLowR, 0.25));
echoLineR.write(toneR + echoRepeats * mix(echoLowR, echoLowL, 0.25));
echoWet = echoMix * 0.52;
echoTrim = 1 - echoRepeats * 0.75;
echoL = toneL * (1 - 0.35 * echoWet) + echoTapL * echoWet * echoTrim;
echoR = toneR * (1 - 0.35 * echoWet) + echoTapR * echoWet * echoTrim;

// Decorrelate the stereo input before it reaches the four-line room network.
diffTapL = roomDiffuserL.read(clamp(6.7 * samplesPerMs, 1, 4093));
diffTapR = roomDiffuserR.read(clamp(9.1 * samplesPerMs, 1, 4093));
diffL = diffTapL - 0.55 * echoL;
diffR = diffTapR - 0.55 * echoR;
roomDiffuserL.write(echoL + 0.55 * diffL);
roomDiffuserR.write(echoR + 0.55 * diffR);

roomTapA = roomLineA.read(clamp(29.7 * samplesPerMs, 1, 32765));
roomTapB = roomLineB.read(clamp(37.1 * samplesPerMs, 1, 32765));
roomTapC = roomLineC.read(clamp(41.1 * samplesPerMs, 1, 32765));
roomTapD = roomLineD.read(clamp(53.9 * samplesPerMs, 1, 32765));
roomCutoff = 1 - exp(-17592.91886 / samplerate);
roomLowA = mix(roomLowA, roomTapA, roomCutoff);
roomLowB = mix(roomLowB, roomTapB, roomCutoff);
roomLowC = mix(roomLowC, roomTapC, roomCutoff);
roomLowD = mix(roomLowD, roomTapD, roomCutoff);

// The normalized Hadamard matrix preserves energy. Per-line attenuation
// follows the requested decay time, so the loop stays below unity gain.
roomLoss = -0.006907755279 / roomDecay;
feedA = (roomLowA + roomLowB + roomLowC + roomLowD) * 0.5;
feedB = (roomLowA - roomLowB + roomLowC - roomLowD) * 0.5;
feedC = (roomLowA + roomLowB - roomLowC - roomLowD) * 0.5;
feedD = (roomLowA - roomLowB - roomLowC + roomLowD) * 0.5;
roomLineA.write(diffL * 0.24 + feedA * exp(29.7 * roomLoss));
roomLineB.write(diffR * 0.24 + feedB * exp(37.1 * roomLoss));
roomLineC.write(diffL * 0.24 + feedC * exp(41.1 * roomLoss));
roomLineD.write(-diffR * 0.24 + feedD * exp(53.9 * roomLoss));
roomL = (roomTapA - roomTapB + roomTapC + roomTapD) * 0.5;
roomR = (roomTapA + roomTapB - roomTapC + roomTapD) * 0.5;
wetL = echoL * (1 - 0.18 * spaceMix) + roomL * spaceMix * 0.70;
wetR = echoR * (1 - 0.18 * spaceMix) + roomR * spaceMix * 0.70;

// The bypass branch has no filter, gain, or delay.
out1 = mix(in1, wetL, fxMix);
out2 = mix(in2, wetR, fxMix);
"""


class Patch:
    def __init__(self):
        self.boxes = []
        self.lines = []

    def add(self, maxclass, rect, *, ins=1, outs=0, types=None, view=None, **attributes):
        ident = f"obj-{len(self.boxes) + 1}"
        box = dict(id=ident, maxclass=maxclass, patching_rect=rect,
                   numinlets=ins, numoutlets=outs, **attributes)
        if types is not None:
            box["outlettype"] = types
        if view is not None:
            box.update(presentation=1, presentation_rect=view)
        self.boxes.append({"box": box})
        return ident

    def obj(self, text, x, y, width, *, ins=1, outs=1, types=None, **attributes):
        return self.add("newobj", [x, y, width, 22], ins=ins, outs=outs, types=types,
                        text=text, **attributes)

    def cord(self, source, destination, outlet=0, inlet=0):
        self.lines.append({"patchline": dict(source=[source, outlet], destination=[destination, inlet])})

    def label(self, text, x, y, width, *, heading=False):
        rect = [x, y, width, 20]
        attrs = {"fontsize": 16, "fontface": 1} if heading else {}
        self.add("comment", rect, view=rect, text=text, **attrs)

    def patcher(self, *, rect, namespace="box", **attributes):
        return dict(fileversion=1, appversion=VERSION, classnamespace=namespace, rect=rect,
                    boxes=self.boxes, lines=self.lines, **attributes)


def gen_patcher():
    p = Patch()
    left = p.obj("in 1", 40, 32, 48, ins=0, types=[""])
    right = p.obj("in 2", 110, 32, 48, ins=0, types=[""])
    code = p.add("codebox", [40, 86, 600, 420], ins=2, outs=2, types=["", ""], code=CODE)
    output_left = p.obj("out 1", 40, 545, 48, outs=0)
    output_right = p.obj("out 2", 110, 545, 48, outs=0)
    p.cord(left, code)
    p.cord(right, code, inlet=1)
    p.cord(code, output_left)
    p.cord(code, output_right, outlet=1)
    return p.patcher(rect=[0, 0, 680, 600], namespace="dsp.gen",
                     description="Tone tilt, crossfed stereo echo, and a damped stereo room")


def parameter(name, label, initial, low, high, *, options=None, units=None, integer=False):
    value = dict(parameter_longname=name, parameter_shortname=label,
                 parameter_type=1 if integer else 0, parameter_mmin=low, parameter_mmax=high,
                 parameter_initial=[initial], parameter_initial_enable=1, parameter_invisible=1)
    if options is not None:
        value.update(parameter_type=2, parameter_enum=list(options))
    if units is not None:
        value.update(parameter_unitstyle=9, parameter_units=units)
    return dict(parameter_enable=1, saved_attribute_attributes={"valueof": value})


def build():
    p = Patch()
    dial_pitch = 112
    gutter = 4
    p.label("Mix effects", 0, 0, 188, heading=True)
    p.label("Tone", 0, 24, dial_pitch - gutter)
    p.label("Stereo echo", dial_pitch, 24, 3 * dial_pitch - gutter)
    p.label("Room reverb", 4 * dial_pitch, 24, 2 * dial_pitch - gutter)

    left = p.add("inlet", [0, 172, 26, 26], ins=0, outs=1, types=["signal"], index=1,
                 comment="Mix left")
    right = p.add("inlet", [144, 172, 26, 26], ins=0, outs=1, types=["signal"], index=2,
                  comment="Mix right")
    gen = p.obj("gen~", 0, 320, 105, ins=2, outs=2, types=["signal", "signal"],
                patcher=gen_patcher(), varname="fk_fx_dsp")
    output_left = p.add("outlet", [0, 370, 26, 26], types=[], index=1, comment="Effects left")
    output_right = p.add("outlet", [144, 370, 26, 26], types=[], index=2, comment="Effects right")
    p.cord(left, gen)
    p.cord(right, gen, inlet=1)
    p.cord(gen, output_left)
    p.cord(gen, output_right, outlet=1)

    switch = [528, 0, 140, 20]
    enabled = p.add("live.text", switch, view=switch, outs=2, types=["", ""],
                    mode=1, text="Enable FX", texton="FX on", varname="fx_enabled",
                    hint="Switch the entire mix effects chain in or out.",
                    **parameter("FX enabled", "FX", 0, 0, 1, options=("Off", "On")))
    prefix = p.obj("prepend enabled", 0, 265, 108, ins=2)
    p.cord(enabled, prefix)
    p.cord(prefix, gen)

    for slot, key, title, label, initial, low, high, hint in (
        (0, "tone", "Tone tilt", "Tilt", 0, -100, 100, "Turn left to darken and right to brighten."),
        (1, "echo", "Echo mix", "Mix %", 20, 0, 100, "Amount of stereo echo."),
        (2, "time_ms", "Echo time", "Time ms", 310, 45, 850, "Delay time in milliseconds."),
        (3, "repeats", "Echo feedback", "Feedback %", 28, 0, 78, "How long the echo repeats."),
        (4, "space", "Room mix", "Mix %", 18, 0, 100, "Amount of room reverb."),
        (5, "decay", "Room decay", "Decay s", 1.7, 0.25, 5, "Reverb tail length in seconds."),
    ):
        rect = [slot * dial_pitch, 48, dial_pitch - gutter, 68]
        dial = p.add("live.dial", rect, view=rect, outs=2, types=["float", "float"],
                     appearance=3, showname=1, shownumber=1, varname="fx_" + key, hint=hint,
                     **parameter(title, label, initial, low, high, integer=key != "decay",
                                 units="%.2f" if key == "decay" else None))
        prefix = p.obj("prepend " + key, slot * 118 + 122, 265, 108, ins=2)
        p.cord(dial, prefix)
        p.cord(prefix, gen)

    patch = p.patcher(rect=[0, 0, 740, 425], openinpresentation=1, gridsize=[8, 8],
                      description="Stereo mix effects for FIELD KIT")
    return {"patcher": patch}


if __name__ == "__main__":
    (ROOT / "fk_fx.maxpat").write_text(json.dumps(build(), ensure_ascii=False, indent=2) + "\n")
