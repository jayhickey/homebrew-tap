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

The cask installs `SimQueue.app` into `/Applications` and installs the CLI formula
if it is missing. Existing CLI users can add just the app with the same command.
Launch it through Spotlight or Applications; Launch at Login is opt-in in its menu.
The app connects to your existing daemon; installation does not start services.
For an existing older daemon, follow the planned upgrade guide before using the
app's daemon stop controls (requires v0.1.4+).

Quit the menu bar app before `brew upgrade --cask simqueue-app`. Upgrade the CLI
separately with `brew upgrade simqueue` after following the planned daemon upgrade
procedure. Keep both packages on the same release when available. Removing the app
with `brew uninstall --cask simqueue-app` leaves the CLI, running daemon, simulator
pool and queue data intact. No cask uninstall or zap hook removes shared data.

The app is ad-hoc signed, not notarized. Follow macOS security policy; do not disable
Gatekeeper or strip quarantine attributes. If you manually copied an earlier app
into Applications, quit it and move that copy aside before installing the cask.
See the [menu bar guide](https://github.com/jayhickey/SimQueue/blob/main/docs/MENU_BAR.md).

## Maintaining the app cask

Update formula and cask versions/checksums together from the actual public release.
Check that the staged app path matches the archive, the formula dependency is retained,
and cask uninstall never stops the daemon or removes shared state.
