cask "simqueue-app" do
  version "0.1.20"
  sha256 "54f66f65ea5ac3a78ca3a40975732eb9d3a737a782f2810f7b69c068e61dc143"

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
    Configure SimQueue with simq init. Installing this cask does not start or
    restart the daemon, or enable Launch at Login. With "autostart": false, start
    the app's bundled daemon with Use Bundled Daemon… in the menu, or run:
      "#{appdir}/SimQueue.app/Contents/MacOS/SimQueueApp" --register-daemon

    Quit the menu bar app before upgrading it. Follow the planned daemon upgrade
    instructions before upgrading the app or restarting a running daemon:
      https://github.com/jayhickey/SimQueue/blob/main/docs/INSTALL.md#planned-upgrade
    App shutdown controls require a daemon from v0.1.5 or later.

    The app installs into /Applications. For ~/Applications, pass
    --appdir=~/Applications or set HOMEBREW_CASK_OPTS="--appdir=~/Applications".
    Keep the same appdir on every reinstall and upgrade so the bundled daemon's
    path stays stable.

    This app is Developer ID signed and notarized by Apple.
    This cask links simq from the app, so Sparkle updates simq and simqd together.
    It replaces the simqueue formula: brew uninstall simqueue first.
    Installing the formula later takes over the simq link. To restore it:
      brew uninstall simqueue && brew link --cask simqueue-app
    Removing the cask removes the app and its simq link; queue data stays intact.
  EOS
end
