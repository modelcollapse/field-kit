# Field Kit releases

When publishing a Field Kit version, follow [the release checklist](docs/releasing.md). Ship the editable Max patch and the standalone macOS app together on the same GitHub release. Test both extracted downloads and review the updated screenshots before publishing. Record any platform or audio device checks that could not be run.

When testing a build, close its scratch Max windows and any superseded standalone previews as soon as they are no longer needed. Keep the current preview available and leave documents with unsaved work open.

When the user approves a Field Kit version, install the approved standalone as `Field Kit.app` alongside both versioned ZIPs in `/Applications/Field Kit/Field Kit v<VERSION>`, then publish both tested builds to GitHub with updated instructions and screenshots. Keep the standalone bundle name `Field Kit.app` so Max can find its embedded collective. Verify the installed app launches, then verify the public downloads and their checksums. Then move only the verified superseded installed pair and redundant build artifacts to Trash. Preserve working folders, source audio, recordings, Sets, and any active sessions. Permanent deletion requires a separate explicit request.
