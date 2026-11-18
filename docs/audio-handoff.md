# Receive rendered audio from Looper

In Looper, choose **Send to Field Kit selected loop**. Field Kit loads the rendered WAV into the loop selected when it accepts the request. The received audio uses the full range of that loop; its other settings remain available in the loop editor. Other loops keep their sources and playback states. Receiving does not enable audio or start stopped loops.

Open **Source, Input & Files** to see receive status. Field Kit waits while recording, importing, saving a source, or opening a Set. A failed WAV load keeps the previous loop audio. The sender reports success only after Field Kit has committed the new source. Audio sent while Field Kit is closed remains queued until it is available.

The apps exchange local WAV files through the private `Max Audio Exchange/v1` folder under the user's Application Support folder. No network listener is used. Completed files are retained so loops and saved Sets keep valid source references; automatic cleanup is not included.

## Implementation and packaging

`fk_exchange_node.js` starts the shared Node receiver for role `field-kit`. `exchange_load` is routed to `source_control.receive_exchange`. The adapter claims a free loop buffer, pins the selected loop, validates Max's completed buffer read, then switches that loop's source. A playing loop uses the existing short source transition; stopped loops remain stopped. Failed binding restores the previous source before reporting failure.

The adapter replies `loaded` only after native commit, `failed` for a terminal error, and `busy` for a deferred request. Recent duplicate request IDs are acknowledged without replacing the source twice. The shared worker uses durable requests, audio hashes, a destination lease, and sender correlation tokens.

Keep `fk_exchange_node.js`, `handoff/exchange.js`, and `handoff/max-exchange.js` together. Both download packagers include these files; the standalone places the Node entry and its relative sidecars beside the collective. The ordinary Max download qualifies the entry through its `Support` folder. The standalone packager removes runtime-inherited document and URL handler declarations, so Field Kit does not register as a handler for Max patches, JSON, JavaScript, PDF or audio files.

## Verification for the 0.8.27 candidate

- All 13 Field Kit Node verification suites pass. The six receiver cases cover native-load validation and commit timing, preserving playback state, busy operation guards, invalid and timed-out reads, commit rollback, and duplicate delivery with the selected loop pinned.
- Four Node bootstrap checks cover the editable source, entry scripts extracted from a collective, missing modules, and dependency failures. The standalone entry locates external modules relative to the bundled Node executable when its extracted directory has no sidecars.
- Four Python packaging checks accept startup-generated MIDI port listeners only inside their existing runtime subpatcher and reject changed fixed objects or wiring.
- Four standalone-metadata checks verify inherited document and URL claims are removed while unrelated app metadata remains intact. The final signed, extracted candidate has neither handler declaration key.
- The shared exchange core passes its separate 18-test suite and is copied byte-for-byte from the Looper implementation.
- A native Max 9.2.1 pipeline used the actual Looper renderer, shared Node exchange, and Field Kit receiver. The receiver selected Loop 2 through its public API and verified the native tab before starting. Both sends committed to Loop 2 and produced durable loaded acknowledgments. Complete-frame PCM sums and squared sums matched the sender's rendered audio.

| Native send | Frames | Sample rate | Channels | Destination |
| --- | ---: | ---: | ---: | --- |
| Rendered loop, including seam and processing | 9,120 | 48,000 Hz | 2 | Loop 2 |
| Rendered slice | 8,640 | 48,000 Hz | 2 | Loop 2 |

The native fixtures removed physical audio, MIDI and DSP control endpoints. Loops 1, 3 and 4 retained their sources; playback remained stopped and audio remained off. This verifies file delivery and native buffer commit, not a physical audio-device test.

The editable ZIP was extracted and checked for its `Support` paths and current shared modules. The corrected native collective and macOS candidate passed structural, dependency, architecture and strict deep signature checks. The candidate's macOS ZIP SHA-256 is `a415e10707721fcdb1cd2a325e4710e3b37163a30bc6abb4a0280709e698023c`. Its signature is ad hoc, without Apple notarization.

An isolated packaged-app boot QA also passed with `max.isruntime` true: Max extracted the entry script into the standalone's own preference/temp directory, the entry found the external shared module beside the bundled Node executable, and the actual native Node outlet delivered `exchange_ready` for Field Kit's private test folder. A filesystem sentinel independently recorded those entry, executable and module paths. The QA app removed physical endpoints and other Node workers and quit itself after the result. The ordinary GUI preview showed the 0.8.27 workspace and demo with audio off.

Current screenshots, complete extracted-download UI checks, and the broader physical device checks in [the release checklist](releasing.md) remain required before an official release. This change is proposed through a draft PR; no official release is included.
