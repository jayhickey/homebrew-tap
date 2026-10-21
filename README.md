# jayhickey/homebrew-tap

Install and manage tools by [Jay Hickey](https://github.com/jayhickey) with Homebrew.

This tap currently contains [SimQueue](https://github.com/jayhickey/SimQueue), a local job queue and reusable iOS Simulator pool for Apple Silicon Macs. It installs `simq`, the command-line client, and `simqd`, the background service. Use it to coordinate independent builds and tests sharing a Mac.

## Availability

**SimQueue installation is pending the first verified release.** The formula still has a placeholder checksum. Once its release asset and checksum are updated, install it using the steps below. Follow the project's [release checklist](https://github.com/jayhickey/SimQueue/blob/main/docs/RELEASE-CHECKLIST.md) for validation status.

SimQueue requires an Apple Silicon Mac (arm64), Xcode, and an iOS Simulator runtime. The [tested support matrix](https://github.com/jayhickey/SimQueue/blob/main/docs/RELEASE-CHECKLIST.md#initial-compatibility-target) records actual macOS/Xcode coverage.

## Installation

```sh
brew tap jayhickey/tap
brew install simqueue
```

You can also install a formula directly with `brew install jayhickey/tap/<formula>`.
For setup instructions and available services, run `brew info <formula>` or visit
the project's documentation.

## Formulae

| Formula | What it installs |
| --- | --- |
| [`simqueue`](https://github.com/jayhickey/SimQueue) | A per-Mac queue and simulator pool for Xcode builds and tests. Installs `simq` (CLI) and `simqd` (daemon). |

## Private beta access

The SimQueue beta repository is private. You need repository access and GitHub
authentication for release-asset downloads as well as for tapping this repository.
The formula uses Homebrew's GitHub credential discovery: an existing `gh auth login`
session, or `HOMEBREW_GITHUB_API_TOKEN` with repository contents read access. Store
credentials in your normal credential manager; do not put them in the formula, config
or shell history. Authentication errors should be fixed before retrying installation.
The tap-owned download strategy requests the exact versioned GitHub API asset and
Homebrew checks its SHA-256. Public anonymous release downloads are not yet supported.

Homebrew asks you to trust third-party taps before it loads their formulae. If `brew install`
refuses, trust the specific formula with `brew trust --formula jayhickey/tap/<formula>`.

## Setup and upgrades

After installation, follow SimQueue's [setup guide](https://github.com/jayhickey/SimQueue/blob/main/docs/INSTALL.md) to initialize the config, build and select a template, and choose on-demand startup or a Homebrew service. Drain running work before an upgrade and check the daemon version after restarting it.

The release archive is a Homebrew formula input named `simqueue-<version>-macos-arm64.tar.gz`. Use Homebrew for installation and upgrades.

## Maintaining a formula

After a verified release, update the corresponding file in `Formula/` with the
published download URL and SHA-256 checksum. Test the formula before merging the update.
