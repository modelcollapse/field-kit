# FIELD KIT

FIELD KIT is a Max instrument that turns an audio file or a live recording into four independent stereo loops. Set each loop's range, speed, direction, crossfade, drive, and filter. Blend the loops in the performance mixer, move them with eight LFOs, and capture the main mix and four separate loop WAVs with the built-in recorder.

## Start here

- **[Download the latest Max patch](https://github.com/modelcollapse/field-kit/releases/latest/download/field-kit-max.zip).** Unzip it and double-click **Open FIELD KIT.maxpat** in Max 9. **START HERE.txt** has the quick instructions. Keep **Support** and the companion Max patches beside the launcher.
- **[Download the latest standalone macOS app](https://github.com/modelcollapse/field-kit/releases/latest/download/field-kit-macos.zip).** Unzip it and open **Field Kit.app**. Max is not required.

For an organized installation, keep **Field Kit.app** and both versioned ZIPs in **Applications/Field Kit/Field Kit v0.8.22**. Keep the app bundle named **Field Kit.app** so its embedded runtime can find the collective.

The v0.8.22 standalone includes Apple silicon and Intel binaries. It is ad hoc signed and has no Apple notarization. macOS may show a first launch alert. [Apple’s explanation of first launch alerts](https://support.apple.com/en-us/102445).

[See what's new in v0.8.22](CHANGELOG.md).

![Field Kit v0.8.22 standalone with synchronized main-mix and four-loop output recording](docs/screenshots/field-kit-v0822-overview.png)

The original demo loads on startup. Click **Play all** to hear it. Open **Source, Input & Files → Demos…** to play **Glass Circuit** (120 BPM), **Tidal Lanterns** (75 BPM), or the original demo. Each new demo uses four equal loop regions and sets the scene tempo to match. Use **Send to** and the **Import to…** button to stage your own sample for a loop or all four. The same drawer holds audio setup, loop recording, and Set files.

Choose **Slate**, **Moss**, or **Ember** from the **Theme** menu in the header. Each theme uses related background shades to separate source setup, the mixer, loop controls, effects, and recording.

In the selected loop editor, choose **Low-pass** to cut highs, **High-pass** to cut lows, or **Flat (off)** to center the filter. Switch between Low-pass and High-pass to keep the same strength, or drag **Filter sweep** for a continuous move through all three. **Drive** is off at 0%. Patterns, Sets, and LFO routes still use each loop’s filter sweep.

## Working folders

Open **Source, Input & Files → Working folders…** to choose the starting locations for the **Import to…** button, **Replace audio…**, **Save Loop WAV…**, and **Record output…**. Use **Banks & patterns folder** for **Save Bank** and **Load Bank**. Patterns are stored together inside bank files. Field Kit remembers all three folder choices across launches. The default bank folder is **Documents/Field Kit/Banks**, which Field Kit creates when needed. When present, the default audio folders are **Documents/Field Kit/Imports** and **Documents/Field Kit/Recordings**. Choose a different destination in the save dialog whenever you need to.

![Working folders with a saved Banks & patterns location](docs/screenshots/field-kit-v0821-working-folders.png)

## Record a source

1. Open **Source, Input & Files**, open **Audio & MIDI Setup…**, and select your interface in **Input device** and **Output device**. Click **Enable audio**. In **Input**, choose the left and right channels. Select the same channel on both sides for a mono source.
2. Set the linked input gain from −60 to +18 dB. It starts at 0 dB. The two peak meters show the levels after gain, with peak hold and a red overload indicator.
3. In **Send to**, choose **Selected loop**, an explicit loop number, or **All loops**. Click **Record to** followed by the displayed destination. The current loops keep playing while you record. Recording continues until you stop it, subject to available storage. Click **Stop recording**, then check **Loop recording** for the destination awaiting confirmation. Choose **Use on** to confirm or **Discard** to keep the current loop audio.
4. With the new loop selected, click **Save Loop WAV…** before saving a Set. One saved WAV is enough for any copies that share the take.

![The take confirmation window with Use on all loops and Discard buttons](docs/screenshots/field-kit-take-ready.jpg)

## MIDI Learn

Open **Source, Input & Files → Audio & MIDI Setup…** and choose a controller under **MIDI In**. Pick a control and click **Learn**. Move an absolute MIDI CC knob or fader for a value, or press a note or momentary CC button for an action. You can learn global speed, master level, transport, Main FX, and each loop’s play, level, pan, and sends.

Select a mapped control and click **Clear** to remove its assignment. MIDI input starts off, and assignments are kept for the current session.

![Audio & MIDI Setup with independent input and output menus, MIDI In, and the Learn and Clear buttons](docs/screenshots/field-kit-audio-midi-setup.jpg)

## Play and shape the loops

1. Click a loop number or waveform to select it. **Editing Loop** sits beside the waveforms and shows the selected loop's settings. Drag across a waveform and release to change its range. The moving line shows playback position.
2. Use **In %** and **Out %** to enter the bounds precisely. Choose **Forward**, **Reverse**, or **Ping-pong** and adjust the dials.
3. **Fade ms** blends each pass into the next. **Fade preview** shows the two gain curves and the overlap duration. The live duration reflects short-loop limits, speed, and modulation. **Filter** is flat at zero. Turn left to cut highs or right to cut lows.

In the selected loop editor, choose **Loop actions… → Copy to Loop** to copy the audio and range to another loop while keeping the destination’s playback and mixer settings. **Replace audio…** lets you choose a file and confirm or discard it while your loops continue playing. Confirming a replacement starts the new audio with its full range. The **Import to…** button in the Source drawer uses the same **Send to** menu as the recorder. **All loops** starts each loop on a different quarter of the same audio. A single loop starts with the full range.

**Pitch snap** applies to all four windows. Choose a scale to snap the pitch reached by changing **Speed ×**, including speed modulation. The original sample at **1×** is the tonic. Speed and pitch stay linked, as on a tape deck.

Use **Speed** in Transport to slow down or speed up all four loops from **0.50×** to **2.00×**. **Relative speed** multiplies each loop’s speed after pitch snap. If two loops are set to 1× and 2×, setting global Speed to 0.50× plays them at 0.50× and 1×. **Same speed** would play both at 0.50×. Switching back to Relative speed uses each loop’s individual speed setting again.

**Tape** changes pitch with speed. Choose **Pitch Lock** to keep pitch steady while you turn the global Speed control. In Relative speed, this preserves each loop’s pitch at 1× global speed, including any local speed or Pitch Snap settings. In Same speed, it preserves the source pitch. **Save Set** stores the global speed and both modes. Pattern changes leave them in place.

Open **Visuals** and set the **Tuner** source to **Live input L**, **Live input R**, or **Selected loop**. With audio enabled, play one note at a time. The tuner shows the nearest note, frequency, and cents relative to **A4 = 440 Hz**.

**Play original** plays the original sample once at its original speed, with the window mixer and effects bypassed. Switching between original playback and the loop mix uses a short crossfade. **Stop all** stops playback. **Reset** also restores the default loop, mixer, modulation, and effects settings. It keeps the current sample and stored patterns.

## Mix the four windows

Each waveform has a mixer strip with playback, level, pan, mute, solo, a peak meter, and **Echo** and **Room** sends. Click or drag the blue fader under a window’s playback button to set its volume, or edit the percentage box for a precise level. **Mute** removes a window from the mix while its loop keeps running. **Solo** lets you hear one or more windows together. Mute still takes precedence, and **Unsolo** brings back the current mute mix. Mixer performance controls leave the edit selection in place. **Record output** captures the resulting master mix.

The **L** and **R** meters in the **Master** strip show each output channel. A red **Clip** light shows which channel hit the output ceiling. Lower **Master** if either light comes on. The **Output recording** panel below has the recording button, timer, status, and take name.

Open **Stereo field…** beside **FX pad…** in the **Main FX** header. Drag a window edge to resize the Stereo Field. The tabs select which loop's pan and level are shown above the pad. Drag its dot left or right to pan it, and up or down to change its level. If dots overlap, use the tabs to pick one.

Use **Field presets** to store four arrangements of all four loops' pan and level. Shift-click a slot, or click **Store preset** and pick a slot. Click a filled slot to recall it. Recall stops current Stereo Field movement so the positions stay where you set them. **Save Set…** keeps the presets with your session.

To record movement, select a loop, click **Record**, then drag its dot as many times as you like. Click **Finish** to save and start looping the take. It also starts looping when it reaches 30 seconds. The **Play / Stop** button controls playback and **Clear** erases the gesture. Each loop keeps one gesture and can play it alongside the others. Click **Play paths** to start every recorded Stereo Field gesture. Paths already running keep their place. Once all recorded paths are running, click **Stop paths** to stop the gestures while the audio loops keep playing. Click **Show all paths** to see the recorded paths together, color-coded to match the numbered loop markers. Click **Show selected path** to focus on one loop.

## Clear a track

Select the loop, open **Loop actions…** above its editor, then choose **Clear loop…**.
Confirm **Clear Loop** to stop and empty that track. Its playback button reads **Empty**.
Saved audio files stay on disk. Save an unsaved recorded take as a WAV first if you
want to keep it. **Cancel** keeps the existing loop. Record or import to that track
to fill it again, or copy another loop into it through **Loop actions…**.
**Play all** skips empty tracks. Saving a Set remembers them.
Sets containing empty tracks require v0.8.21 or later.

![The Clear Loop confirmation explains that saved audio files stay on disk](docs/screenshots/field-kit-v0821-clear-confirmation.png)

![Loop 1 is Empty while the other three tracks continue playing](docs/screenshots/field-kit-v0821-empty-track.png)

## Store patterns

Shift-click one of the eight squares to store the current pattern, or click **Store pattern** and pick a square. A dot marks a stored pattern, and the brightest square is the last one you stored or recalled. Click a dotted square to recall its loop settings, mixer levels, pans and mutes, pitch scale, LFO routes and curves, and effects on the current sample. In v0.8.21, each playing loop finishes its current pass and crossfades into the next pattern over 80 ms. Scene changes use the same transition. Reverse loops finish at the start of their range and ping-pong loops switch at the next turnaround. Different loop lengths reach the new scene at different times. The status shows a queued change. A newer request waits for the current handoff to finish. Shared Main FX, Drifting Memory and master level update after all loops have switched. Modulated loop controls hold their captured values while waiting. Stopped loops stay stopped. **Play original** keeps its existing short stereo-mix transition. **Fade ms** in the loop editor still controls only that loop's seam. Recall clears active solos. Click **Cancel store** to exit store mode.

Open **Source, Input & Files** and use **Save Set…** in the **Set files…** menu to save the shared source and any per-loop audio file locations, all eight slots, and your current settings in one file. **Open Set…** restores the session with playback stopped. If the sample moved, choose its new location.

Open **Banks…** to load or save a bank of patterns.

Banks from the three-LFO version still open. Their settings are restored on LFOs 1–3. LFOs 4–8 start at their defaults with no routes.

Click **Scene sequencer** beside **Banks…** to show the eight steps directly under Patterns. Click **Hide sequencer** in the same spot to return to your previous workspace while the sequence keeps playing. Set **BPM** and **Beats/bar**, then choose a scene and duration in bars for each step. **Start** starts with the first available scene, and **Next bar** advances early at the next bar line. **Repeat** loops the sequence. **Stop** holds the current scene and lets the loops continue. **Stop all** stops the sequencer and the loops. Selecting a pattern by hand stops the sequence and recalls that pattern.

The scene clock controls when patterns change. Set the tempo and meter before you start. Loop speed still follows each loop's **Speed ×** setting. **Save Set…** saves the sequence, tempo, and meter with the patterns. **Open Set…** restores them ready to start.

The scene strip at the top, between **Transport** and **Master**, shows the current scene, the next playable scene, and progress through the current scene’s bars. Use **Start** or **Stop** and **Next bar** directly from the strip.

![The compact Scene Sequencer running four programmed scenes directly below Patterns](docs/screenshots/field-kit-v0821-scenes.png)

Use the workspace selector to switch between **Mix**, **Modulation**, and **Visuals**, or **Hide** to collapse the lower panel. **Mix** opens by default. On wide displays, **Full screen** puts **Output recording** and **Mix visuals** in a right column that stays visible as you switch workspaces. Select **Visuals** there to show the tuner below the workspace tabs while the analyzers stay in the right column.

**Visuals** monitors the same final stereo signal as **Record output**. Choose **History** for a scrolling frequency history or **Spectrum** for a live frequency curve, with a separate view for each channel. Click **Stereo X/Y…** above the scope to open a larger, resizable window. The scope plots left against right. Matching left and right signals trace a rising diagonal. Opening Stereo X/Y or Stereo Field from full screen returns the workspace to a window so you can see both at once.

![The Visuals workspace with live stereo frequency history, Stereo X/Y, and the docked Tuner](docs/screenshots/field-kit-v0822-visuals.png)

![The resizable Stereo X/Y window showing the live left and right channels of the final mix](docs/screenshots/field-kit-stereo-scope.png)

## Patch modulation

Each of the eight LFOs can reach any of the 66 destinations. Choose a loop to modulate its range, speed, direction, crossfade, drive, filter, level, pan, or Echo and Room sends. Choose **Global** for master level, input gain, Main FX, and Drifting Memory. Pick a destination, then turn **Depth** or click **Add route** to start at +25%. Negative depth inverts the LFO. The **active routes** menu jumps to a route for the selected LFO. **Applied value** shows what the destination receives while audio is on.

In **Loop sends** mode, the per-loop send routes control which loops feed Echo and Room. In Drifting Memory, the HPF and LPF routes take effect in **Sweep**, and the timing routes take effect in **Rhythmic**. Older Sets and pattern banks keep their existing LFO assignments when opened.

The lower-left graph shows one cycle of the selected LFO’s shape. Choose **Breakpoint** or click **Use curve** to edit that LFO’s custom curve. Click to add a point, drag to move it, or Shift-click to delete it. Each LFO keeps its curve when you switch shapes. The graph on the right shows the live signal when audio is on.

![A sine LFO routed to Loop 1 Pan at +25% depth with an Applied value and live signal graph](docs/screenshots/field-kit-v0822-modulation.png)

## Process and capture

Field Kit starts dry with Main FX and Drifting Memory off. Their dimmed dials show the stored values and can still be edited. During loop playback, click **Main FX · Off** beside the Main FX heading to turn on tone, stereo echo, and room reverb. The button fills with the theme color and reads **Main FX · On**. Tone is neutral at zero, and echo time ranges from 45 to 850 ms.

**Full mix** applies Echo and Room to the combined loops. Their dials read **Mix %**. For per-loop routing, select **Loop sends** and turn up **Echo** or **Room** on the desired mixer strip. The main dials read **Return %** and set how much of each effect comes back into the mix. Start with a nonzero return, then raise the send for the loop you want to hear. The read-only **FX routing** panel shows the current mode and whether Main FX is on. Sets and patterns remember the mode, returns, and send amounts.

[See the mixer sends, Main FX returns, and read-only routing status together](docs/screenshots/field-kit-performance-sends.jpg).

Open **FX pad…** and use the **X** and **Y** menus to pair Tone tilt, Echo mix, Room mix, or Distortion. X starts on Echo mix and Y starts on Room mix. Picking the other axis’s effect swaps the pair. Drag right or up to increase the assigned value. Tone tilt moves from dark through neutral to bright. The pad and dials stay in sync.

Click **● Record** in the FX pad to arm it. Drag across the grid as many times as you like, then click **Finish** to save and start looping the take. It also starts looping when it reaches 30 seconds. The status below the buttons shows elapsed time while you record, then the saved duration and effect pair. **Play / Stop** starts or stops playback. Stopping holds the current values, and **Clear** erases the gesture. Turn on Main FX in the pad or the Main FX header to hear it. Both buttons control the same effects. **Distortion** adds soft clipping to the stereo mix and is off at 0%. **Close** hides either pad and lets its gestures keep playing. **Stop all**, resetting, or recalling a pattern stops gesture playback. In Loop sends, the FX pad calls the Echo and Room axes **Echo return** and **Room return**. **Save Set** keeps the FX pad gesture and all four Stereo Field gestures. Open the Set and click **Play** on either pad to replay a saved gesture.

| Stereo field | FX pad |
| --- | --- |
| ![The Stereo Field window with four loop positions, per-loop recording and Play paths controls](docs/screenshots/field-kit-v0822-stereo-field.png) | ![The FX pad with Echo and Room axes and Record, Play and Clear controls](docs/screenshots/field-kit-v0822-fx-pad.png) |

**Drifting Memory** runs at the end of Main FX. In **Mix**, click **Drift · Off** to turn it on, play the loops, then choose **All** under **Arm capture**. With **Two Delays** and **Small**, the first return takes about 2½ seconds. The **Memory** meter shows what’s circulating in the delay. **Wet return** shows what the delay adds to the final mix. Use **Mix** to blend it in. Choose **Off** under **Arm capture** to stop recording into memory while the tail plays. Sets and patterns save the effect settings. Captured memory is for the current session.

Drifting Memory starts with **Advanced** open in **Mix**, showing **Time**, **Texture**, and **I/O**. Click **Hide advanced** to collapse it. The **Drifting Memory** shortcut in Main FX opens Advanced again. The mixer sends stay visible and the delay and its capture continue while you switch views.

Use **Hold** to freeze what’s in memory. **Cut Tail** clears the captured audio and turns capture off while the dry mix keeps playing. To capture again, release **Hold** if it’s on and choose a capture bank.

![Drifting Memory enabled with Memory and Wet return meters, Hold, Cut Tail and the Advanced Time page](docs/screenshots/field-kit-v0821-drifting-memory.png)

With audio enabled, click **Record output…** and name the take. Field Kit creates a folder with that name inside the selected location, which starts in your Recordings folder. For example, `Evening Take.wav` creates `Recordings/Evening Take/` for the mix and four loop WAVs. If that folder already exists, the new take gets a numbered folder. The red **RECORDING** indicator and timer show when capture is active. The recorder writes five 24-bit stereo WAVs at the audio device's current sample rate: the chosen main-mix filename and four matching files ending in ` - Loop 1.wav` through ` - Loop 4.wav`. Loop files capture each mixer strip before shared Main FX and Drifting Memory; those shared effects and Master processing are captured in the main mix. All five files start and stop together. Field Kit captures the ten channels together, then separates them after **Stop recording**. Wait for **Saved mix + 4 loops**. The temporary synchronized capture is removed after successful saving and kept for recovery if saving fails. Existing take files are never replaced. **Stop all** lets the effects decay. Click the same button, now labeled **Stop recording**, to finish and save the take.

![Field Kit v0.8.22 recording the main mix and four loops together](docs/screenshots/field-kit-v0822-recording.png)

![Output recording confirms that the mix and four loop WAVs have been saved](docs/screenshots/field-kit-v0822-saved.png)

## Build and test

From a source checkout, open [Field Kit.maxpat](max/Field%20Kit.maxpat) in Max 9. The patch, its support files, and the demo live together in [`max/`](max/). Build and packaging tools are in [`scripts/`](scripts/).

Run `python3 scripts/build.py` to regenerate the patch, subpatchers, and demo. Run `python3 scripts/package_max_download.py build/field-kit-max.zip` to package the editable download.

To build the standalone app, run `python3 scripts/prepare_max_project.py max build/standalone`. Open the generated **Field Kit.maxproj** in Max and choose **File → Build Collective / Application… → Application**. [Cycling ’74 standalone build guide](https://docs.cycling74.com/userguide/standalones_and_collectives/)

See the [release checklist](docs/releasing.md) for building, testing, and publishing both downloads and their screenshots.

Run the playback startup, input recording, pattern bank, scene timing, curve editing, Set writer, and FX pad recording tests with Node.js.

```sh
node tests/output_record_verify.cjs
node tests/source_launch_verify.cjs
node tests/input_record_verify.cjs
node tests/pattern_bank_verify.cjs
node tests/sequence_mix_verify.cjs
node tests/curve_fade_verify.cjs
node tests/set_writer_verify.cjs
node tests/fx_pad_verify.cjs
```

The playback and modulation brief was inspired by Field Tone Audio's FIELD KIT. [Original instrument](https://fieldtoneaudio.gumroad.com/l/field-kit)

Save Bank preserves existing bank files. To save revised patterns, choose a new filename. Load Bank and the remembered Banks & patterns folder remain available; output recording never writes bank files.

![Field Kit v0.8.22 patterns with two stored demo snapshots](docs/screenshots/field-kit-v0822-scenes.png)

![Field Kit v0.8.22 Drifting Memory controls beside the output recorder](docs/screenshots/field-kit-v0822-drifting-memory.png)
