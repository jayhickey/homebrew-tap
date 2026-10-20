# jayhickey/homebrew-tap

Homebrew formulae for [SimQueue](https://github.com/jayhickey/SimQueue).

```sh
brew install jayhickey/tap/simqueue
simq init
```

| Formula | What it installs |
| --- | --- |
| `simqueue` | `simq` (CLI) and `simqd` (daemon), universal macOS binaries from the GitHub release. Depends on [`simslim`](https://github.com/mobai-app/simslim) from `mobai-app/tap`. |

Homebrew asks you to trust third-party taps before it loads their formulae. If `brew install`
refuses, run `brew trust --tap jayhickey/tap` and `brew trust --formula mobai-app/tap/simslim`
(or `brew trust --tap mobai-app/tap`).

To run the daemon as a login service instead of on demand, see `brew info simqueue`
(`brew services start simqueue`).

## Updating

Each `v*` tag in jayhickey/SimQueue runs its release workflow, which publishes the tarball and
opens a PR here bumping `url` and `sha256` in `Formula/simqueue.rb`. Review it, check that
`brew install --build-from-source ./Formula/simqueue.rb` (or the PR's test run) passes, and
merge.
