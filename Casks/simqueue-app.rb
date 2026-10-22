cask "simqueue-app" do
  version "0.1.14"
  sha256 "78e5d38c802850797b6949f5f2859008e8d77acae678c395259d4c8e0310062c"

  auto_updates true

  url "https://github.com/jayhickey/SimQueue/releases/download/v#{version}/simqueue-#{version}-macos-arm64.tar.gz"
  name "SimQueue"
  desc "Menu bar companion for the SimQueue job queue"
  homepage "https://github.com/jayhickey/SimQueue"

  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "simqueue-#{version}-macos-arm64/SimQueue.app"
  binary "#{appdir}/SimQueue.app/Contents/Helpers/simq"

  caveats <<~EOS
    Launch SimQueue from Applications, then click the square.stack menu bar icon
    to open the dashboard. Right-click for app and daemon quit options.
    Configure the CLI with simq init and start the configured daemon with
    simq status or your existing login service. Installing this cask does not
    start or restart the daemon, or enable Launch at Login.

    Quit the menu bar app before upgrading it. Follow the planned daemon upgrade
    instructions before upgrading the CLI or restarting a running daemon:
      https://github.com/jayhickey/SimQueue/blob/main/docs/INSTALL.md#planned-upgrade
    App shutdown controls require a daemon from v0.1.5 or later.

    This app is Developer ID signed and notarized by Apple.
    This cask links simq from the app, so Sparkle updates simq and simqd together.
    It replaces the simqueue formula: brew uninstall simqueue first.
    Removing the cask removes the app and its simq link; queue data stays intact.
  EOS
end
