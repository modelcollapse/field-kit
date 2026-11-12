"""Build the Mix master meters and their independent clip indicators."""

CLIP_HOLD_MS = 1500


def append_master_meter(p, left, top, ceiling):
    for index, side in enumerate(("left", "right")):
        y = top + 1 + index * 15
        channel_label = [left, y, 14, 14]
        meter_rect = [left + 15, y + 2, 163, 11]
        light_rect = [left + 184, y + 2, 10, 10]
        clip_label = [left + 197, y, 34, 14]
        meter = f"master_meter_{side}"
        light = f"master_clip_{side}"
        clip_hint = (f"Lights when the {side} master clips and stays lit for "
                     f"{CLIP_HOLD_MS / 1000:g} seconds after the last overload.")
        p.add(f"master_channel_label_{side}", "comment", channel_label, view=channel_label,
              outs=0, text=side[0].upper(), fontsize=10, fontface=1)
        p.add(meter, "live.meter~", meter_rect, view=meter_rect, outs=2, types=["float", "int"],
              orientation=1, clip_size=2, hint=f"{side.title()} channel level in the recorded mix.")
        p.add(light, "led", light_rect, view=light_rect, types=["int"], ignoreclick=1,
              parameter_enable=0, bgcolor=[0.0, 0.0, 0.0, 0.0], offcolor=[0.27, 0.22, 0.25, 1.0],
              oncolor=[1.0, 0.26, 0.33, 1.0], useoffcolor=1, hint=clip_hint)
        p.add(f"master_clip_label_{side}", "comment", clip_label, view=clip_label,
              outs=0, text="Clip", fontsize=10, hint=clip_hint)
        p.connect(f"output_{side}", 0, meter)

        # Peak detection taps the signal before the output protection. Each
        # overload retriggers the timeout, so sustained peaks keep the light on.
        x = 640 + index * 180
        peak = f"master_clip_peak_{side}"
        compare = f"master_clip_threshold_{side}"
        overload = f"master_clip_overload_{side}"
        trigger = f"master_clip_trigger_{side}"
        hold = f"master_clip_hold_{side}"
        clear = f"master_clip_clear_{side}"
        state = f"master_clip_state_{side}"
        p.obj(peak, "peakamp~ 40", x, 1990, ins=2, types=["float"])
        p.obj(compare, f"> {ceiling}", x, 2020, ins=2, types=["int"])
        p.obj(overload, "sel 1", x, 2050, ins=2, outs=2, types=["bang", ""])
        p.obj(trigger, "t b 1", x, 2080, outs=2, types=["bang", "int"])
        p.obj(hold, f"delay {CLIP_HOLD_MS}", x, 2110, ins=2, types=["bang"])
        p.obj(clear, "t 0", x, 2140, types=["int"])
        p.obj(state, "change 0", x + 90, 2170, outs=3, types=["", "int", "int"])
        p.connect("pattern_transition", index, peak)
        p.connect(peak, 0, compare)
        p.connect(compare, 0, overload)
        p.connect(overload, 0, trigger)
        p.connect(trigger, 1, state)
        p.connect(trigger, 0, hold)
        p.connect(hold, 0, clear)
        p.connect(clear, 0, state)
        p.connect(state, 0, light)
