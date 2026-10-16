cask "splix-macos" do
  version "2.0.1-macos4"
  sha256 "406f15baa03db5e5e76bbb31ba9eb4fc8407221b227a6abfcd93be5e741ed6ef"

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
