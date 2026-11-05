# FIELD KIT

FIELD KIT is a Max instrument that turns one audio file into four independent stereo loops. Set each loop's range, speed, direction, crossfade, drive, filter, level, and pan. Three LFOs can modulate the controls, and a built-in recorder captures the stereo mix.

## Start playing

- **macOS app.** Download the standalone ZIP from the repository's Releases tab, unzip it, and open **Field Kit.app**.
- **Max patch.** Download or clone this repository and open **Field Kit.maxpat** in Max 9. Keep the supporting files beside the patch.

The eight-second demo loads on startup. Click **Play all** to turn on audio and start the four loops, or click one window's play button to hear it on its own. Choose **Load audio…** to use your own sample. **Audio Setup…** lets you select an output device, and **Enable audio** starts the engine without starting playback.

## Play and shape the loops

1. Drag across a waveform to set its loop. The shaded region marks the bounds, and the moving line shows playback position.
2. Use **Window 1–4** to pick the window you want to edit. **In %** and **Out %** let you enter the bounds precisely.
3. Choose **Forward**, **Reverse**, or **Ping-pong** and adjust the dials. **Fade ms** blends each pass into the next. **LP / HP** is flat at zero. Turn left for a low-pass filter or right for a high-pass filter.

**Play normal** plays the original sample once at its original speed, with effects bypassed. **Stop all** stops playback. **Reset** also restores the default loop, modulation, and effects settings. It keeps the current sample and stored patterns.

## Store patterns

Click **Store pattern**, then pick one of the eight squares. Click a filled square to recall its loop settings, LFO routes and curves, and effects on the current sample. **Save bank…** writes all eight slots to a file you can reopen with **Load bank…**.

## Patch modulation

Select **LFO 1–3** and set its rate and shape. Choose a window and destination, then turn **Depth** or click **Add route** to start at +25%. Negative depth inverts the LFO. The **active routes** menu jumps to a route for the selected LFO. **Applied value** shows what the playback control receives.

Click **Use curve** to use a custom breakpoint shape. The graph runs from the start to the end of one cycle. Click to add a point, drag to move it, or Shift-click to delete it. Each LFO has its own curve.

## Process and capture

Click **FX Off** to turn on tone, stereo echo, and room reverb. Set an effect's **Mix %** to zero to remove it from the mix. Tone is neutral at zero.

With audio enabled, click **Record…** and choose where to save the take. Capture writes the final mix as a 24-bit stereo WAV at the audio device's current sample rate. **Stop all** lets the effects decay. Click **Stop** in Capture when the take is finished.

## Build and test

Run `python3 build.py` to regenerate the patch, subpatchers, and original demo. Run `python3 prepare_max_project.py . build/standalone` to stage a Max project. Open the generated **Field Kit.maxproj** in Max and choose **File → Build Collective / Application… → Application**. [Cycling ’74 standalone build guide](https://docs.cycling74.com/userguide/standalones_and_collectives/)

Run the playback startup and pattern bank controller tests with Node.js.

```sh
node tests/source_launch_verify.cjs
node tests/pattern_bank_verify.cjs
```

The playback and modulation brief was inspired by Field Tone Audio's FIELD KIT. [Original instrument](https://fieldtoneaudio.gumroad.com/l/field-kit)
