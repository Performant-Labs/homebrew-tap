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
      url "https://github.com/Performant-Labs/holler/releases/download/v0.2.0/holler-macos-latest"
      sha256 "8c2f978e598ec62fca325a81e5a0ded32b63291cbcc9fa93029e6a94c8eb93e7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Performant-Labs/holler/releases/download/v0.2.0/holler-ubuntu-arm64"
      sha256 "271d3a13b62fdf6312377b223b1a4f0631839066190ba107e9e5efed9c7eb588"
    end
    on_intel do
      url "https://github.com/Performant-Labs/holler/releases/download/v0.2.0/holler-ubuntu-latest"
      sha256 "1bd47c9b6f16ff37fa96550d60ba8befb5cd1f632de4560a267961b2df11d687"
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
