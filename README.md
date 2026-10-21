# jayhickey/homebrew-tap

Homebrew formulae for [SimQueue](https://github.com/jayhickey/SimQueue).

```sh
brew install jayhickey/tap/simqueue
simq init
```

| Formula | What it installs |
| --- | --- |
| `simqueue` | `simq` (CLI) and `simqd` (daemon), universal macOS binaries from the GitHub release. Template slimming with [`simslim`](https://github.com/mobai-app/simslim) is optional. |

Homebrew asks you to trust third-party taps before it loads their formulae. If `brew install`
refuses, trust the specific formula with `brew trust --formula jayhickey/tap/simqueue`.
If you separately install optional simslim, trust its formula when Homebrew requests it.

To run the daemon as a login service instead of on demand, see `brew info simqueue`
(`brew services start simqueue`).

## Updating

After a verified SimQueue release, update `url` and `sha256` in `Formula/simqueue.rb`
from its published tarball and checksum. Test the formula before merging the update.
The initial formula still has a placeholder checksum and cannot be installed from the
release URL until the first release is published.
