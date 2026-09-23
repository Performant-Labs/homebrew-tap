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
      url "https://github.com/Performant-Labs/holler/releases/download/v0.3.0/holler-macos-latest"
      sha256 "027c9bb9c85c6ccfe6e2f6f750b195b1f126b6e81b47e60ae2d9280fd72aec2c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Performant-Labs/holler/releases/download/v0.3.0/holler-ubuntu-arm64"
      sha256 "362a9bf47ebb268e39e3230ac30ee40d43fa5e1debb9f451760ea6bced23f9f4"
    end
    on_intel do
      url "https://github.com/Performant-Labs/holler/releases/download/v0.3.0/holler-ubuntu-latest"
      sha256 "039b14551c9f49efdb68f9fa46a0ef8129b0e1dd12cce26ad956655c8e3f2638"
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
