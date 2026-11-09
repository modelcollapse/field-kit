"""Build the native stereo analysis deck for Field Kit's final mix."""

WIDTH = 1052
HEIGHT = 212
INSET = [21 / 255, 30 / 255, 42 / 255, 1.0]
GRID = [48 / 255, 63 / 255, 81 / 255, 1.0]
MID = [54 / 255, 93 / 255, 136 / 255, 1.0]
ACCENT = [143 / 255, 185 / 255, 240 / 255, 1.0]
INK = [243 / 255, 247 / 255, 252 / 255, 1.0]
MUTED = [182 / 255, 197 / 255, 213 / 255, 1.0]


def build():
    boxes = []
    lines = []

    def box(name, cls, rect, ins=1, outputs=(), visible=False, **attrs):
        ident = f"obj-{len(boxes) + 1}"
        value = dict(id=ident, varname=name, maxclass=cls, patching_rect=rect,
                     numinlets=ins, numoutlets=len(outputs), **attrs)
        if outputs:
            value["outlettype"] = list(outputs)
        if visible:
            value.update(presentation=1, presentation_rect=rect)
        boxes.append({"box": value})
        return ident

    def connect(source, target, inlet=0):
        lines.append({"patchline": {"source": [source, 0], "destination": [target, inlet]}})

    box("visuals_heading", "comment", [0, 0, 132, 23], visible=True,
        text="Mix visuals", fontsize=16, fontface=1, textcolor=INK)
    box("visuals_mix_help", "comment", [140, 3, 650, 20], visible=True,
        text="Final mix · same signal as Record mix", textcolor=MUTED)
    box("visuals_mode_label", "comment", [811, 3, 59, 20], visible=True, text="Display", textcolor=INK)
    mode = box("visuals_mode", "umenu", [874, 0, 178, 22], outputs=("int", "", ""), visible=True,
               items=["History", ",", "Spectrum"], allowdrag=0, parameter_enable=0,
               hint="Choose scrolling frequency history or the live spectrum for both channels.")
    history = box("visuals_history_flag", "newobj", [874, 250, 48, 22], ins=2,
                  outputs=("int",), text="!- 1")
    set_history = box("visuals_history_command", "newobj", [874, 282, 96, 22], ins=2,
                      outputs=("",), text="prepend sono")
    connect(mode, history)
    connect(history, set_history)

    stereo = box("visuals_stereo", "scope~", [888, 47, 140, 140], ins=2, visible=True,
                 range=[-1.0, 1.0], calccount=8, bufsize=256, bgcolor=INSET,
                 gridcolor=GRID, fgcolor=ACCENT, bordercolor=GRID,
                 hint="The stereo trace plots left on X and right on Y. Hold to freeze the trace.")
    for index, (side, label, x) in enumerate((("left", "Left channel", 0), ("right", "Right channel", 432))):
        box(f"visuals_{side}_label", "comment", [x, 26, 420, 20], visible=True,
            text=label, fontsize=13, fontface=1, textcolor=INK)
        analyzer = box(f"visuals_{side}", "spectroscope~", [x, 47, 420, 140], ins=2, outputs=("",),
                       visible=True, sono=1, scroll=2, orientation=0, monochrome=0, logfreq=1, logamp=1,
                       interval=32, domain=[20.0, 20000.0], range=[0.0, 1.0],
                       bgcolor=INSET, fgcolor=ACCENT, markercolor=GRID, sonolocolor=INSET,
                       sonomedlocolor=GRID, sonomedcolor=MID, sonomedhicolor=ACCENT, sonohicolor=INK)
        source = box(f"visuals_input_{side}", "inlet", [x, 250, 26, 26], ins=0,
                     outputs=("signal",), index=index + 1, comment=f"{label} of the final mix")
        connect(source, analyzer)
        connect(source, stereo, index)
        connect(set_history, analyzer)

    box("visuals_stereo_label", "comment", [864, 26, 188, 20], visible=True,
        text="Stereo X/Y", fontsize=13, fontface=1, textjustification=1, textcolor=INK)
    box("visuals_frequency_help", "comment", [0, 190, 852, 20], visible=True,
        text="20 Hz–20 kHz · Log frequency", textjustification=1, textcolor=MUTED)
    box("visuals_stereo_help", "comment", [864, 190, 188, 20], visible=True,
        text="X Left · Y Right · Mono ↗", textjustification=1, textcolor=MUTED)

    return dict(fileversion=1, appversion=dict(major=9, minor=2, revision=0, architecture="arm64", modernui=1),
                classnamespace="box", rect=[0, 0, WIDTH, HEIGHT], openinpresentation=1,
                description="Frequency and stereo analysis of the final Field Kit mix",
                boxes=boxes, lines=lines)
