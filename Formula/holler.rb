class Holler < Formula
  desc "Your agents are just a holler away — one binary, hub or body"
  homepage "https://github.com/Performant-Labs/holler"
  license "AGPL-3.0-or-later"

  # NOTE: no top-level `version` — `brew audit` flags it as redundant once
  # url/sha256 live inside on_* blocks (the version is scanned from the URL).
  #
  # url/sha256 cannot sit directly inside on_macos/on_linux (brew audit:
  # "on_macos cannot include url/sha256 directly ... only on_intel, on_arm,
  # ..., on_system ... are allowed as direct children") — they must nest one
  # level deeper, inside on_arm/on_intel/on_system.
  on_macos do
    on_arm do
      url "https://github.com/Performant-Labs/holler/releases/download/v0.4.0/holler-macos-latest"
      sha256 "69d0542c43fe0c5bb8596e284bd7f4a62104ba9e5b7da1c1d8df62cd270ef469"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Performant-Labs/holler/releases/download/v0.4.0/holler-ubuntu-arm64"
      sha256 "ccc8882656d23fc1188e8bb879daa144b46f80c4e9eb68de72c7080b3e33c337"
    end
    on_intel do
      url "https://github.com/Performant-Labs/holler/releases/download/v0.4.0/holler-ubuntu-latest"
      sha256 "ea72f1fdc0ef6aaaf979b52acf8c7ea3969fb7a0398c6ea1eb9cb7e1337e28a8"
    end
  end

  def install
    asset = if OS.mac?
      "holler-macos-latest"
    elsif Hardware::CPU.arm?
      "holler-ubuntu-arm64"
    else
      "holler-ubuntu-latest"
    end
    bin.install asset => "holler"
  end

  test do
    assert_match "holler #{version}", shell_output("#{bin}/holler --version")
  end
end
