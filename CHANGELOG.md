# Field Kit changelog

## v0.8.25

- Add an input monitor in **Source, Input & Files**. It starts off and lets you hear the selected inputs at the Master level while recording.
- Save each loop WAV in a folder named after the take. Reusing a name creates a numbered folder.

## v0.8.24

- Crossfade into scenes and patterns as soon as their settings are ready, even when the outgoing loops have long ranges.
- Move each playhead into its new playback range at the start of the crossfade.
- Add a custom Field Kit icon to the macOS standalone.

## v0.8.23

- Save the main mix and four loop WAVs together in a folder named after the take. Reusing a name creates a numbered folder.
- Fix saving and reopening large pattern banks, including all eight occupied slots. Set saving uses the same chunked writer.

## v0.8.22

- Record the main mix and all four loops with one Record output / Stop recording button. Save five 24-bit stereo WAVs with identical sample counts.
- Capture channels synchronously, then split after stopping. Keep the original capture for recovery if file creation fails.
- Loop files capture individual mixer strips before shared effects; the main mix includes Main FX, Drifting Memory and Master processing.
- Refuse to replace existing take files or banks. Save edited banks under a new name; Load Bank and the saved Banks & patterns folder remain available.

## v0.8.21

- Add Loop actions… → Clear loop… with confirmation. Empty tracks stay silent and can receive new recordings, imports or copied audio.
- Preserve saved audio files when clearing a track. Sets with empty tracks use format version 3, while earlier Sets continue to open.
- Add a remembered Banks & patterns folder for Save Bank and Load Bank, defaulting to Documents/Field Kit/Banks.
- Switch each playing loop at its own end when recalling a pattern or scene.
- Crossfade the outgoing and incoming playback over 80 ms, with per-loop mute and send transitions.
- Show queued scene changes. Preserve stopped tracks and finish the current handoff before the newest queued scene.
- Apply shared effects and master level after all loops have switched. Keep the existing Play original transition.

## v0.8.20

- Remove the 60-second cutoff from Loop recording. Takes write to a temporary stereo WAV until you stop recording.
- Keep current loops playing through recording and confirmation. Save confirmed takes with **Save Loop WAV…**.

## v0.8.19

- Record and Import buttons show the destination from Send to.
- Loop recording shows the destination of a staged take or file while the header prompts you to confirm or discard.
- Match the recording and import button typography within the existing layout.

## v0.8.18

- Choose Selected loop, a specific loop, or All loops from the same Send to menu for recording and importing.
- Record or stage an import while the current loops keep playing. Confirm before swapping audio. All loops starts the four loops on different quarters of one take or file.

## v0.8.17

- Record a take for the selected loop while all current loops continue playing. Confirm or discard before swapping the audio.
- Copy audio and its range to another loop, or stage a replacement file for one loop. Sets can remember separate loop audio files.

## v0.8.16

- Drifting Memory starts with Advanced open in Mix.

## v0.8.15

- Working folders lets you choose and remember separate import and recording locations.

## v0.8.14

- Audio & MIDI Setup gives input and output devices separate menus.
- MIDI Learn maps a selected MIDI port to transport, global and loop controls.

## v0.8.13

- Record mix changes to Stop recording during a take.
- Global speed modes are now labeled Relative speed and Same speed.

## v0.8.12

- Echo and Room sends live in the four mixer strips. Main FX holds the routing mode and the Mix or Return levels. The FX routing panel now shows status, and the loop editor gives the Fade preview more room.
- Stereo Field labels its group gesture control Play paths / Stop paths.

## v0.8.11

- Stereo Field adds a Play all / Stop all button for recorded paths.

## v0.8.10

- Stereo Field adds Show all paths to display the recorded paths together, color-coded by loop.

## v0.8.9

- Stereo Field and FX Pad start looping a gesture as soon as you click Finish. The Play button becomes Stop while playback is running.

## v0.8.8

- The tuner now lives in Visuals alongside the spectrum and stereo scope. In wide full screen, the analyzers stay in the right column.

## v0.8.7

- The tuner is a docked workspace instead of a separate window.
- The scene sequencer opens from Patterns. The lower workspace selector no longer duplicates it.

## v0.8.6

- Transport adds Pitch Lock beside Tape. It keeps pitch steady while changing global speed in Scale or Match. Sets remember the pitch mode.
- The selected-loop tuner follows the pitch you hear in either mode.

## v0.8.5

- Transport adds global playback speed with Scale and Match modes. Sets save the setting and pattern changes preserve it.
- The tuner listens to either live input channel or the selected loop, with note, frequency and cents at A4 = 440 Hz.

## v0.8.4

- Stereo Field and FX Pad keep recording between drags. Stop saves the take. Both pads cap recording at 30 seconds.
- Main FX adds stereo distortion with a Drive control that can also be assigned to either FX Pad axis.

## v0.8.3

- The FX Pad uses Echo and Room return labels in Loop sends mode, including in its recorded gesture status.
- Sets save the FX Pad gesture and each loop's Stereo Field gesture. Reopening a Set restores the gestures ready to play.

## v0.8.2

- Pattern clicks and scene changes crossfade from a short buffer of the outgoing stereo mix into the new pattern. The loop editor's Fade ms still controls the loop seam.
- Echo and Room sends sit on each mixer strip and stay visible with Drifting Memory Advanced open. The main dials read Mix in Full mix and Return in Loop sends.
- Main FX and Drifting Memory start off. They have visible On and Off switches, and their editable dials dim while bypassed. The FX pad shares the Main FX switch.
- The shorter Scene Sequencer keeps all eight steps below Patterns. Its launcher opens and closes it without interrupting a running sequence.
- Store four pan and level arrangements in Stereo Field and keep them with a Set. The FX pad gives its Record button and capture status a dedicated row.

## v0.8.1

- Choose Glass Circuit, Tidal Lanterns, or the original demo in Source, Input & Files. The two new demos start four aligned loops and set Scenes to their tempo.
- Open a larger Stereo X/Y scope from Mix visuals. The Stereo Field also opens larger and resizes with its window.
- The scene sequencer opens directly below Patterns, with the mixer and loop editor below it.

## v0.8.0

- The loop editor sits beside the waveforms. Transport, scene cues, and Master stay at the top, and Source, Input & Files opens as a drawer. Slate, Moss, and Ember use distinct shades for each section.
- On wide displays, full screen moves the mix recorder, both channel visuals, and the square stereo scope to the right. Master shows independent left and right meters and clip lights.
- Drifting Memory sits in Mix with live Memory and Wet return meters, Hold, Cut Tail, and an Advanced drawer. Edit per-loop Echo and Room sends in the Mix matrix or the selected loop editor.
- Choose Low-pass, Flat, or High-pass in the loop editor. Loading a new audio file starts all four loops as soon as it is ready.
- Enable Main FX directly in the FX pad. Both gesture pads have a Close button and can continue playing gestures while closed.
- Eight LFOs reach 66 destinations, including eight per-loop sends and 14 Drifting Memory controls. Older Sets and Banks keep their saved assignments.

## v0.7.0

### What’s new

- **Performance workspace.** Switch between Scenes, Modulation, and Visuals, or choose Hide to collapse the lower panel. Use Full screen to fit the workspace to the display. Slate, Moss, and Ember are available from the Theme menu.
- **Scene sequencer.** Arrange up to eight stored patterns with a tempo, beats per bar, and a length for each step. Next bar advances at the next bar line, and Repeat loops the sequence.
- **Mix visuals.** Follow the final stereo mix with independent left and right scrolling frequency histories, live spectrum curves, and a stereo X/Y scope.
- **Loop editing.** Click a loop number or waveform to focus Editing Loop below the waveform lanes. Drag to set the range. Fade preview shows the incoming and outgoing curves and the effective overlap during playback.
- **Main FX.** Choose Full mix or give each loop its own Echo and Room send. Open Drifting Memory to capture the stereo mix into the 1.8 delay engine and blend its returns into the output.
- **Gesture pads.** Record and repeat pan and level movement for each loop in Stereo field. In FX pad, assign Tone tilt, Echo mix, or Room mix to the two axes and record the movement of that pair.
- **Source and mix recording.** Record source captures an input take for the four loops. Record mix writes the final stereo output as a 24-bit WAV.

### Get started

Unzip the Max download and open **Open FIELD KIT.maxpat** in Max 9. Keep the Support folder and companion patches beside the launcher. Click **Play all** to hear the demo.

Existing Sets and Banks open in this version. Sets save the source reference, pattern slots, current settings, and scene sequence with its tempo and meter. Use **Save source WAV…** before saving a Set that uses a newly recorded source. Pad gestures and captured Drifting Memory audio live in the current session.
