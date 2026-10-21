cask "simqueue-app" do
  version "0.1.4"
  sha256 "0480717ff305228d20119e733e0199c83965326dee9e7ea39284ae220bb12200"

  url "https://github.com/jayhickey/SimQueue/releases/download/v#{version}/simqueue-#{version}-macos-arm64.tar.gz"
  name "SimQueue"
  desc "Menu bar companion for the SimQueue job queue"
  homepage "https://github.com/jayhickey/SimQueue"

  depends_on arch: :arm64
  depends_on formula: "jayhickey/tap/simqueue"
  depends_on macos: :sonoma

  app "simqueue-#{version}-macos-arm64/SimQueue.app"

  caveats <<~EOS
    Launch SimQueue from Applications, then click the square.stack menu bar icon
    to open the dashboard. Right-click for app and daemon quit options.
    Configure the CLI with simq init and start the configured daemon with
    simq status or your existing login service. Installing this cask does not
    start or restart the daemon, or enable Launch at Login.

    Quit the menu bar app before upgrading it. Follow the planned daemon upgrade
    instructions before upgrading the CLI or restarting a running daemon:
      https://github.com/jayhickey/SimQueue/blob/main/docs/INSTALL.md#planned-upgrade
    App shutdown controls require a daemon from v0.1.4 or later.

    This app is ad-hoc signed and is not notarized. macOS may require explicit
    approval under its normal security policy. Do not disable Gatekeeper.
    Removing the cask leaves the CLI, daemon and queue data intact.
  EOS
end
