# FIELD KIT

FIELD KIT is a Max instrument that turns one audio file into four independent stereo loops. Set each loop's range, speed, direction, crossfade, drive, filter, level, and pan. Eight LFOs can modulate the controls, and a built-in recorder captures the stereo mix.

## Start here

- **[Download the macOS app](https://github.com/modelcollapse/field-kit/releases/latest/download/field-kit-macos.zip).** Unzip it and open **Field Kit.app**. The app includes everything it needs to run.
- **[Download the editable Max patch](https://github.com/modelcollapse/field-kit/releases/latest/download/field-kit-max.zip).** Unzip it, open **FIELD KIT for Max**, and double-click **Open FIELD KIT.maxpat** in Max 9. **START HERE.txt** has the quick instructions. Keep **Support** beside the launcher so Max can load its files automatically.

The eight-second demo loads on startup. Click **Play all** to turn on audio and start the four loops, or click one window's play button to hear it on its own. Choose **Load audio…** to use your own sample. **Audio Setup…** lets you select an output device, and **Enable audio** starts the engine without starting playback.

![FIELD KIT playing the bundled demo through four loop windows, with Pitch Snap set to Natural Minor, one filled pattern square, and the red recording indicator](docs/screenshots/field-kit-overview.png)

## Play and shape the loops

1. Drag across a waveform to preview a loop range, then release to apply it. If the window is playing, it fades briefly as it switches to the new range. The moving line shows playback position.
2. Use **Window 1–4** to pick the window you want to edit. **In %** and **Out %** let you enter the bounds precisely.
3. Choose **Forward**, **Reverse**, or **Ping-pong** and adjust the dials. **Fade ms** blends each pass into the next. **LP / HP** is flat at zero. Turn left for a low-pass filter or right for a high-pass filter.

**Pitch snap** applies to all four windows. Choose a scale to snap the pitch reached by changing **Speed ×**, including speed modulation. The original sample at **1×** is the tonic. Speed and pitch stay linked, as on a tape deck.

**Play normal** plays the original sample once at its original speed, with effects bypassed. **Stop all** stops playback. **Reset** also restores the default loop, modulation, and effects settings. It keeps the current sample and stored patterns.

## Store patterns

Click **Store pattern**, then pick one of the eight squares. A dot marks a stored pattern, and the brightest square is the last one you stored or recalled. Click a dotted square to recall its loop settings, pitch scale, LFO routes and curves, and effects on the current sample. Click **Cancel store** to leave the bank alone.

Use **Save bank…** to keep your patterns between sessions. **Load bank…** opens a saved bank.

Banks from the three-LFO version still open. Their settings are restored on LFOs 1–3. LFOs 4–8 start at their defaults with no routes.

## Patch modulation

Choose **LFO 1–8** from the dropdown and set its rate and shape. Choose a window and destination, then turn **Depth** or click **Add route** to start at +25%. Negative depth inverts the LFO. The **active routes** menu jumps to a route for the selected LFO. **Applied value** shows what the playback control receives.

Click **Use curve** to use a custom breakpoint shape. The graph runs from the start to the end of one cycle. Click to add a point, drag to move it, or Shift-click to delete it. Each LFO has its own curve. Edits crossfade while playback runs.

![Close-up of LFO 8 modulating Window 4 pan at 55 percent, with its breakpoint curve and live feedback](docs/screenshots/field-kit-modulation.png)

## Process and capture

Click **Enable FX** to turn on tone, stereo echo, and room reverb. Set an effect's **Mix %** to zero to remove it from the mix. Tone is neutral at zero.

With audio enabled, click **Record…** and choose where to save the take. The red **RECORDING** indicator and timer show when capture is active. Capture writes the final mix as a 24-bit stereo WAV at the audio device's current sample rate. **Stop all** lets the effects decay. Click **Stop** in Capture when the take is finished.

## Build and test

From a source checkout, open [Field Kit.maxpat](max/Field%20Kit.maxpat) in Max 9. The patch, its support files, and the demo live together in [`max/`](max/). Build and packaging tools are in [`scripts/`](scripts/).

Run `python3 scripts/build.py` to regenerate the patch, subpatchers, and demo. Run `python3 scripts/package_max_download.py build/field-kit-max.zip` to package the editable download.

To build the standalone app, run `python3 scripts/prepare_max_project.py max build/standalone`. Open the generated **Field Kit.maxproj** in Max and choose **File → Build Collective / Application… → Application**. [Cycling ’74 standalone build guide](https://docs.cycling74.com/userguide/standalones_and_collectives/)

Run the playback startup, pattern bank, and curve editing tests with Node.js.

```sh
node tests/source_launch_verify.cjs
node tests/pattern_bank_verify.cjs
node tests/curve_fade_verify.cjs
```

The playback and modulation brief was inspired by Field Tone Audio's FIELD KIT. [Original instrument](https://fieldtoneaudio.gumroad.com/l/field-kit)
