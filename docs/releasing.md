# Releasing Field Kit

Ship the Max 9 patch and the standalone macOS app on the same GitHub release. Build both from the same version of the source. Keep the previous complete release available while you verify the two new downloads and their screenshots.

## Build the two downloads

1. Regenerate the patches and demo, run the test suites, and review the generated changes.

   ```sh
   python3 scripts/build.py
   node tests/source_launch_verify.cjs
   node tests/input_record_verify.cjs
   node tests/pattern_bank_verify.cjs
   node tests/sequence_mix_verify.cjs
   node tests/curve_fade_verify.cjs
   node tests/set_writer_verify.cjs
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
   bash scripts/package_macos_release.sh 0.7.0 \
     "/path/to/verified-runtime.zip" "build/Field Kit.mxf" \
     build/standalone-runtime build/field-kit-macos.zip
   ```

   The packager reports the archive digest and the path to the extracted app for testing.
5. Finish signing after modifying the app bundle and verify it with `codesign --verify --deep --strict`. Record the signing and notarization status in the release notes. If packaging the app manually, create `field-kit-macos.zip` with `ditto -c -k --norsrc --keepParent`, extract it in a clean temporary folder, and verify the signature again. [Apple notarization guide](https://developer.apple.com/documentation/security/notarizing-macos-software-before-distribution)

## Check the extracted downloads

Open **Open FIELD KIT.maxpat** from a clean extraction in Max. Then quit Max and launch **Field Kit.app** from its own clean extraction. Use the bundled demo and a disposable folder for recordings, Sets, and Banks.

- [ ] Both builds launch to the presentation, load the demo, and run without missing files or startup errors. **Play all**, per-loop play/stop, **Play original**, and **Stop all** behave as expected. Verify both audio output channels on the available device, including headphones when present.
- [ ] Select a loop from its waveform and strip. Edit its bounds, direction, speed, and fade. Verify the fade preview, pitch snap, mixer level and pan, mute/unmute, and solo/unsolo.
- [ ] Use **Audio Setup…** to select a real input. Check channel selection, gain and meters, then record a source and save its WAV. Record a stereo mix WAV and check that the file plays and contains the final mix.
- [ ] Exercise both Main FX modes. Check that the **Mix** send matrix, loop editor, and Main FX controls agree. Verify that Drifting Memory's inline controls and **Details…** stay in sync and that **Memory** and **Wet return** respond to capture, Mix, and bypass. Open **Stereo field** and **FX pad** and verify manual movement, FX axis selection, and record/play/stop/clear on both pads.
- [ ] Store and recall patterns. Run a scene sequence with different bar lengths, **Next bar**, and **Repeat**. Confirm that the scene strip in Mix shows the same current scene, next scene, and bar count and can control the sequence. Save and reopen a Set and a Bank, and check an older fixture if available.
- [ ] Route an LFO and confirm the target responds. Check Mix, Scenes, Modulation, Visuals, Hide, the section shades in all three themes, and entering and exiting full screen. Check live signal in both History and Spectrum and on the stereo scope.
- [ ] Record which macOS version, chip, and audio devices were tested and any limits of the verification. Resolve regressions before publishing.

## Review screenshots and publish

1. Capture the release build using demo content. Include the full workspace in the standalone with audio running, Scenes in motion, Modulation with an active route, live Visuals, both gesture pads, and Drifting Memory. Show additional changed views if they help explain the update. Check each image for readable controls, current labels, and the absence of personal files, paths, or session data.
2. Commit the screenshots under [`docs/screenshots/`](screenshots/) and link them with descriptive alt text in the [README](../README.md). Update the [changelog](../CHANGELOG.md) and draft release notes with both install paths. Review the rendered screenshots and notes.
3. Tag the reviewed commit and push it. Create a draft for that tag and attach both `field-kit-max.zip` and `field-kit-macos.zip`. Verify both uploaded filenames, sizes, and SHA-256 digests against the tested archives.
4. Publish the draft as latest, then check the public release, both download links, and the screenshots. Keep the verified versioned downloads locally.
