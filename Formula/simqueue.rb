# typed: false
# frozen_string_literal: true

# SimQueue: one queue per Mac for Xcode builds, tests and iOS simulators.
# The release workflow in jayhickey/SimQueue opens a PR here that bumps url and sha256 for
# each v* tag (scripts/bump-formula.sh). Until the first release, url/sha256 are placeholders.
class Simqueue < Formula
  desc "Per-Mac queue and simulator pool for Xcode builds, tests and UI tests"
  homepage "https://github.com/jayhickey/SimQueue"
  url "https://github.com/jayhickey/SimQueue/releases/download/v0.1.0/simqueue-0.1.0-macos-universal.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "Apache-2.0"

  depends_on macos: :sonoma # macOS only (implies depends_on :macos)
  # Slimmed simulator templates and clones. Lives in its maintainer's tap.
  depends_on "mobai-app/tap/simslim"

  def install
    bin.install "bin/simq", "bin/simqd"
  end

  # `brew services start simqueue` runs simqd as a per-user LaunchAgent. Without it, simq
  # starts simqd on demand. Pick one: with the service, set "autostart": false in the config
  # (`simq init --launchd` writes that).
  service do
    run [opt_bin/"simqd", "run", "--foreground"]
    keep_alive true
    log_path var/"log/simqd.log"
    error_log_path var/"log/simqd.log"
    # simqd runs xcrun/simctl (/usr/bin) and simslim (Homebrew's bin).
    environment_variables PATH: std_service_path_env
  end

  def caveats
    <<~EOS
      Set SimQueue up for this Mac (starter config, Xcode and simslim checks):
        simq init

      simq starts its daemon (simqd) on demand. To keep simqd running as a login
      service instead, set "autostart": false in the config, then:
        brew services start simqueue

      State (queue database, socket, logs, artifacts) lives in
        ~/Library/Application Support/SimQueue
      `simq uninstall --purge` removes it and the simq-* simulators SimQueue owns.
    EOS
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/simq --version").strip
    assert_equal version.to_s, shell_output("#{bin}/simqd --version").strip
    # A fake-backend daemon starts and exits cleanly in a scratch state dir.
    output = shell_output("#{bin}/simqd run --foreground --backend fake --probe fake " \
                          "--exit-after-startup --state-dir #{testpath}/state")
    assert_match "epoch=1", output
  end
end
