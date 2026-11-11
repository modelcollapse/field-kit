# Releasing Field Kit

Ship the Max 9 patch and the standalone macOS app on the same GitHub release. Build both from the same version of the source. Keep the previous complete release available while you verify the two new downloads and their screenshots.

## Build the two downloads

1. Regenerate the patches and demo, run the test suites, and review the generated changes.

   ```sh
   python3 scripts/build.py
   node tests/output_record_verify.cjs
   node tests/source_launch_verify.cjs
   node tests/input_record_verify.cjs
   node tests/pattern_bank_verify.cjs
   node tests/sequence_mix_verify.cjs
   node tests/curve_fade_verify.cjs
   node tests/set_writer_verify.cjs
   node tests/fx_pad_verify.cjs
   git diff --check
   ```

2. Build the editable archive and stage a fresh standalone project.

   ```sh
   python3 scripts/package_max_download.py build/field-kit-max.zip
   python3 scripts/prepare_max_project.py max build/standalone
   ```

3. Open **Field Kit.maxproj** in Max 9 and choose **Build Collective / Application… → Application**. Verify the resulting app has the Field Kit bundle identifier `audio.poeticstate.fieldkit` and the intended release version in both `CFBundleShortVersionString` and `CFBundleVersion`. Confirm it includes the current collective, demo, Node for Max, and Set writer. Check the microphone usage description. [Cycling ’74 standalone build guide](https://docs.cycling74.com/userguide/standalones_and_collectives/)
4. If Max cannot export an Application, export a fresh **Collective** from the project and use the packager with a verified Field Kit runtime archive built by the same Max version and build. Use a fresh folder for the staged inputs and substitute the release version and file paths.

   ```sh
   mkdir -p build/standalone-runtime
   cp build/standalone/{patchers,code,media}/* build/standalone-runtime/
   bash scripts/package_macos_release.sh VERSION \
     "/path/to/verified-runtime.zip" "build/Field Kit.mxf" \
     build/standalone-runtime build/field-kit-macos.zip
   ```

   The packager reports the archive digest and the path to the extracted app for testing.
5. Finish signing after modifying the app bundle and verify it with `codesign --verify --deep --strict`. Record the signing and notarization status in the release notes. If packaging the app manually, create `field-kit-macos.zip` with `ditto -c -k --norsrc --keepParent`, extract it in a clean temporary folder, and verify the signature again. [Apple notarization guide](https://developer.apple.com/documentation/security/notarizing-macos-software-before-distribution)

## Check the extracted downloads

Open **Open FIELD KIT.maxpat** from a clean extraction in Max. Then quit Max and launch **Field Kit.app** from its own clean extraction. Use the bundled demo and a disposable folder for recordings, Sets, and Banks.

- [ ] Both builds launch to the presentation, load the demo, and run without missing files or startup errors. **Play all**, per-loop play/stop, **Play original**, and **Stop all** behave as expected. Stage a different WAV with **Import audio…**. Check that confirming updates the chosen destination while preserving each loop’s play or stop state. Verify both audio output channels on the available device, including headphones when present.
- [ ] Select a loop from its waveform and strip. Edit its bounds, direction, speed, and fade. Verify the fade preview, pitch snap, direct filter type selection and sweep, mixer level and pan, mute/unmute, and solo/unsolo. Recall a pattern to check that the selected loop shows its saved filter type and strength.
- [ ] Open and close **Source, Input & Files** in windowed and full screen. Check that Transport, Scenes, and Master stay at the top and the selected loop editor stays beside the waveforms. Use **Audio Setup…** to select a real input, check channel selection, gain and meters, then record a source and save its WAV. Record the main mix and all four loop WAVs. Verify distinct track content, stereo channels, 24-bit format, identical sample counts, and matching final output in the main mix. Check filename-collision protection and that failed splitting keeps the synchronized capture. Verify that clipping one channel lights only its indicator.
- [ ] While all four loops play, record a take longer than 60 seconds for one loop and verify audio past the one-minute mark in the saved WAV. Check playback while recording and while the take waits for confirmation. Confirm the take, copy it to another loop, and replace the first loop with a file. Check that the copy still plays the take, then save the take as WAV and verify both sources reopen in a Set. Check Discard with a staged take and a staged file. Exercise **Selected loop**, an explicit loop, and **All loops** with the Source drawer’s **Send to** menu. Confirm that **All loops** uses one source with four quarter ranges.
- [ ] Exercise both Main FX modes. Check that each mixer strip has its own Echo and Room sends, that the Main FX dials switch between **Mix %** and **Return %**, and that the FX routing status follows the mode and power. Confirm that bypassed dials dim but remain editable in each theme. Open Drifting Memory's **Advanced** drawer from Mix and from Main FX. Check that all four mixer sends stay visible, that its three pages work, and that delay audio continues while switching views. Check that **Hold** preserves memory and **Cut Tail** clears the wet signal and turns capture off while dry audio continues. Open **Stereo field** and **FX pad** and verify manual movement, FX axis selection, and record/play/stop/clear on both pads. Verify that **Play paths** and **Stop paths** control the Stereo Field gestures while audio playback continues. Enable FX in the pad and confirm Main FX stays in sync after closing and reopening it.
- [ ] Store contrasting patterns and check that manual and sequenced changes crossfade without a mute gap. Run a scene sequence with different bar lengths, **Next bar**, and **Repeat**. Open and close the sequencer from Patterns while it runs and confirm the scene strip still shows its progress. Store and recall two different Stereo Field presets, then save and reopen a Set to check both are restored. Save and reopen a Bank, and check an older fixture if available.
- [ ] Route LFOs to a loop, a loop send, Main FX, and Drifting Memory and confirm the effective value and audio respond. Check Mix, Scenes, Modulation, Visuals, Hide, the section shades in all three themes, and entering and exiting full screen. Confirm Master and Output recording have visibly separate backgrounds and the selected loop stands out across the mixer and waveform. Check live signal in both History and Spectrum and on the stereo scope.
- [ ] Record which macOS version, chip, and audio devices were tested and any limits of the verification. Resolve regressions before publishing.

## Review screenshots and publish

1. Capture the release build using demo content. Include the full workspace in the standalone with audio running, Scenes in motion, Modulation with an active route, live Visuals, both gesture pads, and Drifting Memory. Show additional changed views if they help explain the update. Check each image for readable controls, current labels, and the absence of personal files, paths, or session data.
2. Commit the screenshots under [`docs/screenshots/`](screenshots/) and link them with descriptive alt text in the [README](../README.md). Update the [changelog](../CHANGELOG.md) and draft release notes with both install paths. Review the rendered screenshots and notes.
3. Tag the reviewed commit and push it. Create a draft for that tag and attach both `field-kit-max.zip` and `field-kit-macos.zip`. Verify both uploaded filenames, sizes, and SHA-256 digests against the tested archives.
4. Publish the draft as latest, then check the public release, both download links, and the screenshots. Keep the verified versioned downloads locally.
