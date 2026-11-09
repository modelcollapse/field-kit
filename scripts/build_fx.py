"""Build FIELD KIT's stock Max stereo mix effects."""

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "max"
VERSION = dict(major=9, minor=2, revision=0, architecture="arm64", modernui=1)
DIALS = (
    ("tone", "Tone tilt", "Tilt", 0, -100, 100, "Turn left to darken and right to brighten."),
    ("echo", "Echo mix", "Mix %", 20, 0, 100, "Amount of stereo echo."),
    ("time_ms", "Echo time", "Time ms", 310, 45, 850, "Delay time in milliseconds."),
    ("repeats", "Echo feedback", "Feedback %", 28, 0, 78, "How long the echo repeats."),
    ("space", "Room mix", "Mix %", 18, 0, 100, "Amount of room reverb."),
    ("decay", "Room decay", "Decay s", 1.7, 0.25, 5, "Reverb tail length in seconds."),
)
SEND_INPUTS = ("Echo send left", "Echo send right", "Room send left", "Room send right")

# Turn-on defaults match the parameters in the native controls. Gen handles
# smoothing so moving a dial or switching bypass does not jump the audio.
CODE = """Param enabled(0);
Param send_mode(0);
Param tone(0);
Param echo(20);
Param time_ms(310);
Param repeats(28);
Param space(18);
Param decay(1.7);

History fxMix(0);
History sendBlend(0);
History toneMix(0);
History echoMix(0.20);
History echoTime(310);
History echoNextTime(310);
History echoTimeBlend(1);
History echoTimeMod(0);
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
samplesPerMs = samplerate * 0.001;
bypassStep = 1 / (0.020 * samplerate);
fxMix = clamp(clamp(enabled, 0, 1), fxMix - bypassStep, fxMix + bypassStep);
sendBlend = clamp(clamp(send_mode, 0, 1), sendBlend - bypassStep, sendBlend + bypassStep);
fullMix = 1 - sendBlend;
toneMix = mix(toneMix, clamp(tone * 0.01 + in3, -1, 1), controlRamp);
echoMix = mix(echoMix, clamp(echo * 0.01 + in4, 0, 1), controlRamp);
// Changing the knob or recalling a pattern switches between two fixed taps.
requestedTime = clamp(time_ms, 45, 850);
if (echoTimeBlend >= 1 && requestedTime != echoNextTime) {
    echoTime = echoNextTime;
    echoNextTime = requestedTime;
    echoTimeBlend = 0;
}
echoTimeBlend = min(1, echoTimeBlend + 1 / (0.035 * samplerate));
echoWeight = echoTimeBlend * echoTimeBlend * (3 - 2 * echoTimeBlend);
// Cap the LFO offset and the delay-head motion per sample, including square waves.
delayStep = 0.25 / samplesPerMs;
echoTimeMod = clamp(mix(echoTimeMod, clamp(in5, -1, 1) * 30, timeRamp),
                    echoTimeMod - delayStep, echoTimeMod + delayStep);
oldDelayTime = clamp(echoTime + echoTimeMod, 45, 850);
newDelayTime = clamp(echoNextTime + echoTimeMod, 45, 850);
delayTime = mix(oldDelayTime, newDelayTime, echoWeight);
echoRepeats = mix(echoRepeats, clamp(repeats * 0.01 + in6 * 0.78, 0, 0.78), controlRamp);
spaceMix = mix(spaceMix, clamp(space * 0.01 + in7, 0, 1), controlRamp);
roomDecay = mix(roomDecay, clamp(decay + in8 * 2, 0.25, 5), controlRamp);

// Tone tilts around 1.2 kHz. At zero the direct signal passes through.
toneCutoff = 1 - exp(-7539.822369 / samplerate);
toneLowL = mix(toneLowL, in1, toneCutoff);
toneLowR = mix(toneLowR, in2, toneCutoff);
dark = max(-toneMix, 0) * 0.75;
bright = max(toneMix, 0) * 0.75;
toneL = in1 - dark * (in1 - toneLowL) - bright * toneLowL;
toneR = in2 - dark * (in2 - toneLowR) - bright * toneLowR;

// A slight difference in times and crossfeed opens up the repeats in stereo.
oldTapL = echoLineL.read(clamp(oldDelayTime * samplesPerMs, 1, 262141));
oldTapR = echoLineR.read(clamp(oldDelayTime * 1.17 * samplesPerMs, 1, 262141));
newTapL = echoLineL.read(clamp(newDelayTime * samplesPerMs, 1, 262141));
newTapR = echoLineR.read(clamp(newDelayTime * 1.17 * samplesPerMs, 1, 262141));
echoTapL = mix(oldTapL, newTapL, echoWeight);
echoTapR = mix(oldTapR, newTapR, echoWeight);
echoCutoff = 1 - exp(-28274.33388 / samplerate);
echoLowL = mix(echoLowL, echoTapL, echoCutoff);
echoLowR = mix(echoLowR, echoTapR, echoCutoff);
// Move the effect inputs between the serial mix and the independent sends.
// The existing delay histories keep ringing through a mode change.
echoInputL = mix(toneL, in9, sendBlend);
echoInputR = mix(toneR, in10, sendBlend);
echoLineL.write(echoInputL + echoRepeats * mix(echoLowL, echoLowR, 0.25));
echoLineR.write(echoInputR + echoRepeats * mix(echoLowR, echoLowL, 0.25));
echoWet = echoMix * 0.52;
echoTrim = 1 - echoRepeats * 0.75;
echoDry = 1 - 0.35 * echoWet * fullMix;
echoL = toneL * echoDry + echoTapL * echoWet * echoTrim;
echoR = toneR * echoDry + echoTapR * echoWet * echoTrim;

// Decorrelate the stereo input before it reaches the four-line room network.
roomInputL = mix(echoL, in11, sendBlend);
roomInputR = mix(echoR, in12, sendBlend);
diffTapL = roomDiffuserL.read(clamp(6.7 * samplesPerMs, 1, 4093));
diffTapR = roomDiffuserR.read(clamp(9.1 * samplesPerMs, 1, 4093));
diffL = diffTapL - 0.55 * roomInputL;
diffR = diffTapR - 0.55 * roomInputR;
roomDiffuserL.write(roomInputL + 0.55 * diffL);
roomDiffuserR.write(roomInputR + 0.55 * diffR);

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
// In Loop sends mode neither return attenuates the main signal.
roomDry = 1 - 0.18 * spaceMix * fullMix;
wetL = echoL * roomDry + roomL * spaceMix * 0.70;
wetR = echoR * roomDry + roomR * spaceMix * 0.70;

// The bypass branch has no filter, gain, or delay.
out1 = mix(in1, wetL, fxMix);
out2 = mix(in2, wetR, fxMix);
out3 = toneMix;
out4 = echoMix;
out5 = delayTime;
out6 = echoRepeats;
out7 = spaceMix;
out8 = roomDecay;
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
    channels = 2 + len(DIALS)
    inputs = channels + len(SEND_INPUTS)
    code = p.add("codebox", [40, 86, 600, 420], ins=inputs, outs=channels,
                 types=[""] * channels, code=CODE)
    for i in range(inputs):
        x = 40 + i * 70
        source = p.obj(f"in {i + 1}", x, 32, 48, ins=0, types=[""])
        p.cord(source, code, inlet=i)
    for i in range(channels):
        x = 40 + i * 70
        target = p.obj(f"out {i + 1}", x, 545, 48, outs=0)
        p.cord(code, target, outlet=i)
    return p.patcher(rect=[0, 0, 880, 600], namespace="dsp.gen",
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


def effects_pad(p, enabled, tone, echo, room):
    panel = Patch()
    source = panel.add("inlet", [16, 390, 26, 26], ins=0, outs=1, index=1)
    destination = panel.add("outlet", [16, 478, 26, 26], index=1)
    canvas = [0, 0, 440, 372]
    pad = panel.add("jsui", canvas, outs=1, types=[""], view=canvas, background=1,
                    filename="fk_fx_pad.js", varname="fx_pad_canvas", border=0, parameter_enable=0)
    menu_feedback = panel.obj("route xmenu ymenu", 16, 434, 127, outs=3, types=["", "", ""])
    panel.cord(source, pad)
    panel.cord(pad, menu_feedback)
    panel.cord(menu_feedback, destination, outlet=2)

    choices = ["Tone tilt", ",", "Echo mix", ",", "Room mix"]
    for axis, (label, view) in enumerate((("x", [50, 49, 152, 24]), ("y", [244, 49, 172, 24]))):
        x = 165 + axis * 128
        menu = panel.add("umenu", [x, 434, 112, 22], outs=3, types=["int", "", ""],
                         view=view, items=choices, varname=f"fx_pad_{label}", parameter_enable=0)
        assign = panel.obj(f"prepend assign {axis}", x, 478, 118, ins=2)
        select = panel.obj("prepend set", x, 516, 90, ins=2)
        default = panel.obj(f"loadmess {axis + 1}", x, 554, 85, types=["int"])
        panel.cord(menu, assign)
        panel.cord(assign, pad)
        panel.cord(menu_feedback, select, outlet=axis)
        panel.cord(default, select)
        panel.cord(select, menu)

    button_rect = [428, 0, 96, 20]
    button = p.add("live.text", button_rect, outs=2, types=["bang", ""], view=button_rect,
                   varname="fx_pad_open", mode=0, text="FX pad…", texton="FX pad…",
                   parameter_enable=0, hint="Blend two effects and record pad movements.")
    open_message = p.add("message", [0, 424, 52, 22], ins=2, outs=1, types=[""], text="open")
    window = p.obj("pcontrol", 0, 456, 62)
    subpatch = p.obj("p Effects pad", 0, 488, 102, types=[""], varname="fx_pad_panel",
                     patcher=panel.patcher(rect=[570, 152, 440, 372], title="Effects pad",
                                           openinpresentation=1, toolbarvisible=0))
    motion = p.add("inlet", [720, 172, 26, 26], ins=0, outs=1, types=[""],
                   index=3 + len(DIALS), comment="Stop pad motion")
    p.cord(button, open_message)
    p.cord(open_message, window)
    p.cord(window, subpatch)
    p.cord(motion, subpatch)

    edit = p.obj("route tone echo space", 0, 520, 144, outs=4, types=["", "", "", ""])
    state = p.obj("pak 0 20 18", 164, 424, 82, ins=3, types=["list"])
    state_message = p.obj("prepend source", 164, 456, 105, ins=2)
    bypass_message = p.obj("prepend enabled", 294, 456, 114, ins=2)
    p.cord(subpatch, edit)
    for index, dial in enumerate((tone, echo, room)):
        p.cord(edit, dial, outlet=index)
        p.cord(dial, state, inlet=index)
    p.cord(state, state_message)
    p.cord(state_message, subpatch)
    p.cord(enabled, bypass_message)
    p.cord(bypass_message, subpatch)


def build():
    p = Patch()
    dial_pitch = 112
    gutter = 4
    p.label("Main FX", 0, 0, 82, heading=True)
    p.label("Tone", 0, 24, dial_pitch - gutter)
    p.label("Stereo echo", dial_pitch, 24, 3 * dial_pitch - gutter)
    p.label("Room reverb", 4 * dial_pitch, 24, 2 * dial_pitch - gutter)

    left = p.add("inlet", [0, 172, 26, 26], ins=0, outs=1, types=["signal"], index=1,
                 comment="Mix left")
    right = p.add("inlet", [144, 172, 26, 26], ins=0, outs=1, types=["signal"], index=2,
                  comment="Mix right")
    channels = 2 + len(DIALS)
    gen = p.obj("gen~", 0, 320, 105, ins=channels + len(SEND_INPUTS), outs=channels, types=["signal"] * channels,
                patcher=gen_patcher(), varname="fk_fx_dsp")
    output_left = p.add("outlet", [0, 370, 26, 26], types=[], index=1, comment="Effects left")
    output_right = p.add("outlet", [144, 370, 26, 26], types=[], index=2, comment="Effects right")
    p.cord(left, gen)
    p.cord(right, gen, inlet=1)
    p.cord(gen, output_left)
    p.cord(gen, output_right, outlet=1)
    for offset, name in enumerate(SEND_INPUTS):
        send = p.add("inlet", [792 + 72 * offset, 172, 26, 26], ins=0, outs=1, types=["signal"],
                     index=channels + 2 + offset, comment=name)
        p.cord(send, gen, inlet=channels + offset)

    mode_rect = [86, 0, 94, 20]
    mode = p.add("umenu", mode_rect, view=mode_rect, outs=3, types=["int", "", ""],
                 varname="fx_mode", items=["Full mix", ",", "Loop sends"], parameter_enable=0,
                 hint="Feed Echo and Room from the full mix or the individual loop sends.")
    default_mode = p.obj("loadmess 0", 198, 210, 85, types=["int"])
    set_mode = p.obj("prepend send_mode", 198, 240, 134, ins=2)
    p.cord(default_mode, mode)
    p.cord(mode, set_mode)
    p.cord(set_mode, gen)

    switch = [532, 0, 136, 20]
    enabled = p.add("live.text", switch, view=switch, outs=2, types=["", ""],
                    mode=1, text="Enable FX", texton="FX on", varname="fx_enabled",
                    hint="Switch Tone, Echo and Room in or out. Drifting Memory has its own switch.",
                    **parameter("FX enabled", "FX", 0, 0, 1, options=("Off", "On")))
    prefix = p.obj("prepend enabled", 0, 265, 108, ins=2)
    p.cord(enabled, prefix)
    p.cord(prefix, gen)

    dials = {}
    for slot, (key, title, label, initial, low, high, hint) in enumerate(DIALS):
        index = slot + 3
        x = 288 + slot * 72
        modulation = p.add("inlet", [x, 172, 26, 26], ins=0, outs=1, types=["signal"],
                           index=index, comment=f"{title} modulation")
        effective = p.add("outlet", [x, 370, 26, 26], types=[], index=index,
                          comment=f"Applied {title.lower()}")
        p.cord(modulation, gen, inlet=index - 1)
        p.cord(gen, effective, outlet=index - 1)

        rect = [slot * dial_pitch, 48, dial_pitch - gutter, 68]
        dial = p.add("live.dial", rect, view=rect, outs=2, types=["float", "float"],
                     appearance=3, showname=1, shownumber=1, varname="fx_" + key, hint=hint,
                     # Max integer parameters support only 256 distinct values.
                     **parameter(title, label, initial, low, high, integer=key not in ("time_ms", "decay"),
                                 units={"time_ms": "%.0f", "decay": "%.2f"}.get(key)))
        prefix = p.obj("prepend " + key, slot * 118 + 122, 265, 108, ins=2)
        p.cord(dial, prefix)
        p.cord(prefix, gen)
        dials[key] = dial

    effects_pad(p, enabled, dials["tone"], dials["echo"], dials["space"])

    stereo_rect = [312, 0, 108, 20]
    stereo_button = p.add("live.text", stereo_rect, outs=2, types=["bang", ""], view=stereo_rect,
                          varname="stereo_field_open", mode=0, text="Stereo field…", texton="Stereo field…",
                          parameter_enable=0, hint="Place and record the pan and level of each loop.")
    stereo_open = p.add("outlet", [720, 370, 26, 26], index=channels + 1, comment="Open Stereo field")
    p.cord(stereo_button, stereo_open)

    drifting_rect = [188, 0, 116, 20]
    drifting = p.add("live.text", drifting_rect, outs=2, types=["bang", ""], view=drifting_rect,
                     varname="drifting_delay_open", mode=0, text="Drifting Memory…", texton="Drifting Memory…",
                     parameter_enable=0, hint="Open the Drifting Memory master effect.")
    drifting_open = p.add("outlet", [792, 370, 26, 26], index=channels + 2, comment="Open Drifting Memory")
    p.cord(drifting, drifting_open)

    patch = p.patcher(rect=[0, 0, 1040, 555], openinpresentation=1, gridsize=[8, 8],
                      description="Stereo mix effects for FIELD KIT")
    return {"patcher": patch}


if __name__ == "__main__":
    (ROOT / "fk_fx.maxpat").write_text(json.dumps(build(), ensure_ascii=False, indent=2) + "\n")
