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
      url "https://github.com/Performant-Labs/holler/releases/download/v0.5.0/holler-macos-latest"
      sha256 "641415ae2c17b642c1b212e8f728adab5d2dd57d0ec041e7f32ab3ccd081e3c8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Performant-Labs/holler/releases/download/v0.5.0/holler-ubuntu-arm64"
      sha256 "035199c95449551577cbe17550462ac45356f7f2912d34ccf9fe27aba7c5c59c"
    end
    on_intel do
      url "https://github.com/Performant-Labs/holler/releases/download/v0.5.0/holler-ubuntu-latest"
      sha256 "0d82d914f6076a3e08b1393d24636581a874360bb180c1af1cb5156bd443fa43"
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
