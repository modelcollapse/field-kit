# FIELD KIT

FIELD KIT is a Max instrument that turns an audio file or a live recording into four independent stereo loops. Set each loop's range, speed, direction, crossfade, drive, and filter. Blend the loops in the performance mixer, move them with eight LFOs, and capture the stereo mix with the built-in recorder.

## Start here

- **[Download the latest Max patch](https://github.com/modelcollapse/field-kit/releases/latest/download/field-kit-max.zip).** Unzip it and double-click **Open FIELD KIT.maxpat** in Max 9. **START HERE.txt** has the quick instructions. Keep **Support** and the companion Max patches beside the launcher.
- **[Download the latest standalone macOS app](https://github.com/modelcollapse/field-kit/releases/latest/download/field-kit-macos.zip).** Unzip it and open **Field Kit.app**.

The eight-second demo loads on startup. Click **Play all** to turn on audio and start the four loops, or click one window's play button to hear it on its own. Choose **Load audio…** to use your own sample. **Audio Setup…** lets you select your audio devices, and **Enable audio** starts the engine without starting playback.

![FIELD KIT playing four loops with wide blue volume faders, two soloed tracks, and stereo echo set to 575 ms](docs/screenshots/field-kit-overview.png)

## Record a source

1. Select your interface in **Audio Setup…** and click **Enable audio**. In the **Input recording** section, choose the left and right channels. Select the same channel on both sides for a mono source.
2. Set the linked input gain from −60 to +18 dB. It starts at 0 dB. The two peak meters show the levels after gain, with peak hold and a red overload indicator.
3. Click **Record input** to capture up to 60 seconds. The red **RECORDING** badge and timer show when audio is being captured. **Stop input** loads the take into all four loops. Use **Save input WAV…** before saving a Set that uses the take or replacing the source.

## Play and shape the loops

1. Drag across a waveform to preview a loop range, then release to apply it. If the window is playing, it fades briefly as it switches to the new range. The moving line shows playback position.
2. Use **Window 1–4** to pick the window you want to edit. **In %** and **Out %** let you enter the bounds precisely.
3. Choose **Forward**, **Reverse**, or **Ping-pong** and adjust the dials. **Fade ms** blends each pass into the next. **Filter** is flat at zero. Turn left to cut highs or right to cut lows. The filter works independently of the mix effects switch.

**Pitch snap** applies to all four windows. Choose a scale to snap the pitch reached by changing **Speed ×**, including speed modulation. The original sample at **1×** is the tonic. Speed and pitch stay linked, as on a tape deck.

**Play normal** plays the original sample once at its original speed, with the window mixer and effects bypassed. Switching between normal playback and the loop mix uses a short crossfade. **Stop all** stops playback. **Reset** also restores the default loop, mixer, modulation, and effects settings. It keeps the current sample and stored patterns.

## Mix the four windows

Each waveform has a mixer strip with playback, level, pan, mute, solo, and a peak meter. Click or drag the blue fader under a window’s playback button to set its volume, or edit the percentage box for a precise level. **Mute** removes a window from the mix while its loop keeps running. **Solo** lets you hear one or more windows together. Mute still takes precedence, and **Unsolo** brings back the current mute mix. The meters show what each window sends into the shared effects, and **Capture** records the resulting master mix.

Open **Stereo field…** in the **Mixer** header to place all four loops together. Drag a loop left or right to pan it, and up or down to change its level. If dots overlap, click the loop number to select one.

## Store patterns

Shift-click one of the eight squares to store the current pattern, or click **Store pattern** and pick a square. A dot marks a stored pattern, and the brightest square is the last one you stored or recalled. Click a dotted square to recall its loop settings, mixer levels, pans and mutes, pitch scale, LFO routes and curves, and effects on the current sample. During playback, the output briefly fades down and back up around the switch. Recall clears active solos. Click **Cancel store** to exit store mode.

Use **Save Set…** in **Set files** to save the source file location, all eight slots, and your current settings in one file. **Open Set…** restores the session with playback stopped. If the sample moved, choose its new location.

Open **Banks…** to load or save a bank of patterns.

Banks from the three-LFO version still open. Their settings are restored on LFOs 1–3. LFOs 4–8 start at their defaults with no routes.

## Patch modulation

Choose **LFO 1–8** from the dropdown and set its rate and shape. Choose a window, or select **Global** for master level, input gain, tone, echo, and room controls. Pick a destination, then turn **Depth** or click **Add route** to start at +25%. Negative depth inverts the LFO. The **active routes** menu jumps to a route for the selected LFO. **Applied value** shows what the destination receives.

The lower-left graph shows one cycle of the selected LFO’s shape. Choose **Breakpoint** or click **Use curve** to edit that LFO’s custom curve. Click to add a point, drag to move it, or Shift-click to delete it. Each LFO keeps its curve when you switch shapes. The graph on the right shows the live signal when audio is on.

![Close-up of LFO 8 modulating Window 4 pan at 55 percent, with its breakpoint curve and live feedback](docs/screenshots/field-kit-modulation.png)

## Process and capture

During loop playback, click **Enable FX** to turn on tone, stereo echo, and room reverb. Set an effect's **Mix %** to zero to remove it from the mix. Tone is neutral at zero, and echo time ranges from 45 to 850 ms.

With audio enabled, click **Record…** and choose where to save the take. The red **RECORDING** indicator and timer show when capture is active. Capture writes the final mix as a 24-bit stereo WAV at the audio device's current sample rate. **Stop all** lets the effects decay. Click **Stop** in Capture when the take is finished.

## Build and test

From a source checkout, open [Field Kit.maxpat](max/Field%20Kit.maxpat) in Max 9. The patch, its support files, and the demo live together in [`max/`](max/). Build and packaging tools are in [`scripts/`](scripts/).

Run `python3 scripts/build.py` to regenerate the patch, subpatchers, and demo. Run `python3 scripts/package_max_download.py build/field-kit-max.zip` to package the editable download.

To build the standalone app, run `python3 scripts/prepare_max_project.py max build/standalone`. Open the generated **Field Kit.maxproj** in Max and choose **File → Build Collective / Application… → Application**. [Cycling ’74 standalone build guide](https://docs.cycling74.com/userguide/standalones_and_collectives/)

Run the playback startup, input recording, pattern bank, curve editing, and Set writer tests with Node.js.

```sh
node tests/source_launch_verify.cjs
node tests/input_record_verify.cjs
node tests/pattern_bank_verify.cjs
node tests/curve_fade_verify.cjs
node tests/set_writer_verify.cjs
```

The playback and modulation brief was inspired by Field Tone Audio's FIELD KIT. [Original instrument](https://fieldtoneaudio.gumroad.com/l/field-kit)
