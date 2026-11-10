"""Build the resizable presentation for the Stereo Field pop-out."""


def stereo_field_window(field, version):
    width, height = 780, 638
    canvas = [12, 44, width - 24, height - 80]
    help_rect = [12, 12, 282, 22]
    paths_rect = [width - 234, 11, 136, 23]
    close_rect = [width - 90, 11, 78, 23]
    field.add("input", "inlet", [20, 616, 30, 30], ins=0, index=1)
    field.add("output", "outlet", [20, 662, 30, 30], outs=0, index=1)
    field.add("canvas", "jsui", canvas, view=canvas,
              filename="fk_stereo_field.js", border=0, parameter_enable=0, types=[""])
    field.add("help", "comment", help_rect, outs=0, view=help_rect, fontsize=12,
              text="Drag a loop’s dot · X Pan · Y Level")
    field.add("stereo_field_paths", "textbutton", paths_rect, view=paths_rect, outs=3,
              types=["bang", "", "int"], mode=0, outputmode=1, rounded=6,
              text="Show all paths", texton="Show all paths",
              hint="Show every recorded loop path together, or focus on the selected loop.")
    field.add("stereo_field_paths_command", "message", [218, 692, 102, 22], ins=2, text="toggle_paths")
    field.add("stereo_field_close", "textbutton", [310, 616, 78, 22],
              view=close_rect, outs=3, types=["bang", "", "int"],
              mode=0, outputmode=1, text="Close", texton="Close")
    field.add("stereo_field_close_message", "message", [310, 648, 62, 22], ins=2, text="wclose")
    field.obj("stereo_field_thispatcher", "thispatcher", 310, 680, outs=2, types=["", ""])
    field.obj("stereo_field_active", "active", 104, 616, types=["int"])
    field.obj("stereo_field_window_active", "prepend window_active", 104, 648, ins=2)

    field.connect("input", 0, "canvas")
    field.connect("stereo_field_paths", 0, "stereo_field_paths_command")
    field.connect("stereo_field_paths_command", 0, "canvas")
    field.connect("canvas", 0, "output")
    field.connect("stereo_field_close", 0, "stereo_field_close_message")
    field.connect("stereo_field_close_message", 0, "stereo_field_thispatcher")
    field.connect("stereo_field_active", 0, "stereo_field_window_active")
    field.connect("stereo_field_window_active", 0, "canvas")

    return dict(fileversion=1, appversion=version, classnamespace="box",
                rect=[240, 120, width, height], title="Stereo field", openinpresentation=1,
                toolbarvisible=0, enablehscroll=0, enablevscroll=0,
                boxes=field.boxes, lines=field.lines)
