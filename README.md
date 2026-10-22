# jayhickey/homebrew-tap

Install and manage tools by [Jay Hickey](https://github.com/jayhickey) with Homebrew.

[SimQueue](https://github.com/jayhickey/SimQueue) coordinates Xcode builds, tests and
reusable iOS Simulators on an Apple Silicon Mac. Each job runs its whole workload
on one simulator, or uses `--sims 0` for simulator-free work. It installs `simq`
(the client) and `simqd` (the daemon).

## CLI and daemon only

```sh
brew install jayhickey/tap/simqueue
simq init
```

SimQueue requires macOS Sonoma or later, Xcode and an installed iOS Simulator
runtime for simulator jobs. The public versioned ARM64 release downloads normally
through Homebrew and is checked by SHA-256. No GitHub account or token is required.
If Homebrew asks you to trust this third-party formula, review it and use
`brew trust --formula jayhickey/tap/simqueue`.

Follow the [installation guide](https://github.com/jayhickey/SimQueue/blob/main/docs/INSTALL.md)
to select a simulator template and choose on-demand startup or a login service.
One explicit template supplies the shared simulator pool on the Mac. Drain running
work before restarting or upgrading the daemon.

## Offline documentation and agents

```sh
simq agent-guide
simq docs
```

`simq agent-guide` prints version-matched coding-agent instructions without starting
a daemon. `simq docs` prints the full offline documentation directory installed in
the Cellar, including README.md, AGENTS.md, docs and an optional agent skill.
To enable the skill, explicitly copy `$(simq docs)/skills/simqueue` to your agent's
skill directory. Homebrew does not enable or copy skills automatically.

## Formulae

| Formula | What it installs |
| --- | --- |
| [`simqueue`](https://github.com/jayhickey/SimQueue) | A per-Mac queue and simulator pool for Xcode work. Installs `simq` and `simqd`. |

Run `brew info simqueue` for service and upgrade instructions. The
[setup guide](https://github.com/jayhickey/SimQueue/blob/main/docs/INSTALL.md)
covers consistent backups, recovery and uninstall behavior.

## Maintaining a formula

Update the formula only after verifying the actual published release archive and
its SHA-256. Keep downloads public and versioned, install the matching offline
documentation, and run the formula test before publishing an update.

## Optional menu bar app

```sh
brew install --cask jayhickey/tap/simqueue-app
```

The cask is the app setup: it installs `SimQueue.app` and links the app's own
`simq` (`SimQueue.app/Contents/Helpers/simq`), so Sparkle updates the CLI and the
bundled daemon together. It does not install or need the formula. Use one setup:
run `brew uninstall simqueue` before installing the cask. Launch the app through
Spotlight or Applications; Launch at Login is opt-in in its menu. Installation does
not start services. With `"autostart": false`, start the bundled daemon with
**Use Bundled Daemon…** or `SimQueueApp --register-daemon`.

The app installs into `/Applications`. For `~/Applications`, pass
`--appdir=~/Applications`, or set `HOMEBREW_CASK_OPTS="--appdir=~/Applications"` in
your shell profile. Keep the same appdir on every reinstall and upgrade so the
bundled daemon's path stays stable; a reinstall with a different appdir can leave an
empty `SimQueue.app` folder behind.

If both setups end up installed, `simq` follows the order:

- Cask, then formula: the formula overwrites the cask's link. Restore it with
  `brew uninstall simqueue && brew link --cask simqueue-app`.
- Formula, then cask: the cask skips its link. After `brew uninstall simqueue`,
  run `brew reinstall --cask jayhickey/tap/simqueue-app` (stop the bundled daemon
  first if it is registered).

Quit the menu bar app before `brew upgrade --cask simqueue-app`. Removing the app
with `brew uninstall --cask simqueue-app` removes the app and its `simq` link; the
simulator pool and queue data stay intact. No cask uninstall or zap hook removes
shared data. Stop the bundled daemon before uninstalling.

The app is Developer ID signed and notarized by Apple. Do not disable Gatekeeper or
strip quarantine attributes. If you manually copied an earlier app into
Applications, quit it and move that copy aside before installing the cask. See the
[menu bar guide](https://github.com/jayhickey/SimQueue/blob/main/docs/MENU_BAR.md)
and [switching setups](https://github.com/jayhickey/SimQueue/blob/main/docs/INSTALL.md#switching-between-the-formula-and-the-cask).

## Maintaining the app cask

Update formula and cask versions/checksums together from the actual public release.
Check that the staged app path matches the archive, the cask links the app's bundled
`simq` without depending on the formula, and cask uninstall never stops the daemon or
removes shared state. SimQueue's release workflow updates only versions and checksums;
edit caveats and this README here.
