class Holler < Formula
  desc "Your agents are just a holler away — one binary, hub or body"
  homepage "https://github.com/Performant-Labs/holler"
  version "0.2.0"
  license "AGPL-3.0-or-later"

  on_macos do
    url "https://github.com/Performant-Labs/holler/releases/download/v0.2.0/holler-macos-latest"
    sha256 "8c2f978e598ec62fca325a81e5a0ded32b63291cbcc9fa93029e6a94c8eb93e7"
  end

  on_linux do
    url "https://github.com/Performant-Labs/holler/releases/download/v0.2.0/holler-ubuntu-latest"
    sha256 "1bd47c9b6f16ff37fa96550d60ba8befb5cd1f632de4560a267961b2df11d687"
  end

  def install
    if OS.linux? && Hardware::CPU.arm?
      odie "holler has no arm64 Linux release yet — build from source instead: " \
           "cargo build --release -p holler-cli " \
           "(see https://github.com/Performant-Labs/holler#install)"
    end
    bin.install (OS.mac? ? "holler-macos-latest" : "holler-ubuntu-latest") => "holler"
  end

  test do
    assert_match "holler #{version}", shell_output("#{bin}/holler --version")
  end
end
