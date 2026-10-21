# jayhickey/homebrew-tap

Homebrew formulae for tools by [Jay Hickey](https://github.com/jayhickey).

## Installation

```sh
brew tap jayhickey/tap
brew install <formula>
```

You can also install a formula directly with `brew install jayhickey/tap/<formula>`.
For setup instructions and available services, run `brew info <formula>` or visit
the project's documentation.

## Formulae

| Formula | What it installs |
| --- | --- |
| [`simqueue`](https://github.com/jayhickey/SimQueue) | A per-Mac queue and simulator pool for Xcode builds and tests. Installs `simq` (CLI) and `simqd` (daemon). |

**SimQueue availability:** its formula currently has a placeholder checksum and will
be installable once the first release is published and the formula is updated.
SimQueue supports Apple Silicon Macs (arm64) only; Intel Macs are unsupported.
The planned release archive is `simqueue-<version>-macos-arm64.tar.gz`.

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

## Updating

After a verified release, update the corresponding file in `Formula/` with the
published download URL and SHA-256 checksum. Test the formula before merging the update.
