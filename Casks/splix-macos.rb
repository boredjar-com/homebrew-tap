cask "splix-macos" do
  version "2.0.1-macos3"
  sha256 "a9ace162fca5a4175b5bdc57bfc4ac97bdf34e1ebd6732ec6e1e31af32270e74"

  url "https://github.com/boredjar-com/splix-macos/releases/download/v#{version}/SpliX-macOS-#{version}.pkg"
  name "SpliX for macOS"
  desc "Samsung, Xerox and Dell SPL/QPDL laser printer driver (SpliX)"
  homepage "https://github.com/boredjar-com/splix-macos"

  livecheck do
    url :url
    strategy :github_latest
    regex(/^v?(\d+(?:\.\d+)+-macos\d+)$/i)
  end

  depends_on macos: :monterey

  pkg "SpliX-macOS-#{version}.pkg"

  uninstall script:  {
              executable: "/bin/bash",
              args:       [
                "-c",
                "for p in /etc/cups/ppd/*.ppd; do grep -qs Printers/SpliX/rastertoqpdl \"$p\" && " \
                "lpadmin -x \"$(basename \"$p\" .ppd)\"; done; true",
              ],
              sudo:       true,
            },
            pkgutil: "com.boredjar.splix-macos",
            delete:  [
              "/Library/Printers/PPDs/Contents/Resources/SpliX-*.ppd.gz",
              "/Library/Printers/SpliX",
            ]

  caveats <<~EOS
    The installer adds any connected Samsung SPL printer automatically. If yours was
    off, run later:  sudo /Library/Printers/SpliX/splix-autosetup.sh
  EOS
end
