# typed: false
# frozen_string_literal: true

# SimQueue: one queue per Mac for Xcode builds, tests and iOS simulators.

class Simqueue < Formula
  desc "Per-Mac queue and simulator pool for Xcode builds, tests and UI tests"
  homepage "https://github.com/jayhickey/SimQueue"
  url "https://github.com/jayhickey/SimQueue/releases/download/v0.1.19/simqueue-0.1.19-macos-arm64.tar.gz"
  sha256 "cd5086f5b9de06a4afa4ab7c56fcddfb3a516185f1fbfeaffd447bf986985d0e"
  license "MIT"

  depends_on arch: :arm64
  depends_on macos: :sonoma # macOS only (implies depends_on :macos)
  # simslim is optional: users install it separately to opt in with template build --slim.

  def install
    bin.install "bin/simq", "bin/simqd"
    doc.install "README.md", "LICENSE", "NOTICE", "AGENTS.md", "docs", "skills"
  end

  # `brew services start simqueue` runs simqd as a per-user LaunchAgent. Without it, simq
  # starts simqd on demand. Pick one: with the service, set "autostart": false in the config
  # before starting the Homebrew service.
  service do
    run [opt_bin/"simqd", "run", "--foreground", "--log-file",
         "#{Dir.home}/Library/Application Support/SimQueue/simqd.log"]
    keep_alive true
    log_path File::NULL
    error_log_path File::NULL
    # simqd runs xcrun/simctl (/usr/bin) and simslim (Homebrew's bin).
    environment_variables PATH: std_service_path_env
  end

  def caveats
    <<~EOS
      SimQueue supports Apple Silicon Macs (arm64) only; Intel Macs are unsupported.

      This formula is the CLI-only setup: simq and simqd, no menu bar app.
      The menu bar app setup is the simqueue-app cask, which ships its own simq
      inside the app. Use one setup or the other. To switch to the app, drain,
      then uninstall this formula first:
        brew uninstall simqueue
        brew install --cask jayhickey/tap/simqueue-app
      Installed after the simqueue-app cask, this formula takes over its simq link.
      To go back to the app's simq: brew uninstall simqueue && brew link --cask simqueue-app

      Set SimQueue up for this Mac (starter config and Xcode checks):
        simq init

      Build a stock template (simslim is optional):
        simq template build host
      Select the returned UDID as simctl.template in config.json, then drain and
      restart the daemon. One explicit device/runtime/template serves this Mac.
      To opt into slimming, install simslim separately and use --slim. Keep it
      installed while the slimmed template is selected; new clones preserve its profile.

      simq starts its daemon (simqd) on demand. To use a login service instead,
      drain and stop that daemon, set "autostart": false in config.json, then:
        brew services start simqueue
      Choose one service method; do not run competing daemons.

      Planned upgrades:
        simq drain --timeout 30m
        # Continue only after successful drain and a consistent backup (see INSTALL.md).
        # Use SQLite online backup, or stop the drained daemon before copying its state.
        brew upgrade simqueue
        brew services restart simqueue
      For on-demand startup, stop the drained PID and run simq status instead.
      Verify simq --version, simq status and simq doctor after restarting.
      A drain timeout leaves the admission gate set: inspect it or simq resume.

      Offline instructions:
        simq agent-guide
        simq docs
      Optional agent skill: copy $(simq docs)/skills/simqueue into your agent's
      skill directory explicitly. Installation does not enable it automatically.

      State lives in ~/Library/Application Support/SimQueue.
      Inspect simq uninstall before using simq uninstall --yes. Simulator cleanup
      respects ownership and cleanup gates. Queue history, templates, config and
      artifacts are retained unless explicitly purged; --purge removes state.
      See https://github.com/jayhickey/SimQueue/blob/main/docs/INSTALL.md for
      legacy-state transitions, matching-backup rollback, and uninstall details.
    EOS
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/simq --version").strip
    assert_equal version.to_s, shell_output("#{bin}/simqd --version").strip
    assert_equal doc.to_s, shell_output("#{bin}/simq docs").strip
    assert_match "SimQueue #{version} agent guide", shell_output("#{bin}/simq agent-guide")
    assert_path_exists doc/"AGENTS.md"
    assert_path_exists doc/"docs/INSTALL.md"
    assert_path_exists doc/"skills/simqueue/SKILL.md"
    # A fake-backend daemon starts and exits cleanly in a scratch state dir.
    output = shell_output("#{bin}/simqd run --foreground --backend fake --probe fake " \
                          "--exit-after-startup --state-dir #{testpath}/state")
    assert_match "epoch=1", output
  end
end
