# jayhickey/homebrew-tap

Install and manage tools by [Jay Hickey](https://github.com/jayhickey) with Homebrew.

[SimQueue](https://github.com/jayhickey/SimQueue) coordinates Xcode builds, tests and
reusable iOS Simulators on an Apple Silicon Mac. Each job runs its whole workload
on one simulator, or uses `--sims 0` for simulator-free work. It installs `simq`
(the client) and `simqd` (the daemon).

## Install

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
