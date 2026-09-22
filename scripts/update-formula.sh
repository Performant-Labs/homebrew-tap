#!/bin/sh
# Bump Formula/holler.rb to a new holler release tag: downloads all three
# platform assets, computes real sha256s, rewrites the formula, commits.
#
#   scripts/update-formula.sh v0.3.0
#
# Does not push — review the diff and push yourself.

set -eu

VERSION="${1:?usage: update-formula.sh vX.Y.Z}"
REPO="Performant-Labs/holler"
FORMULA="$(dirname "$0")/../Formula/holler.rb"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

for asset in holler-macos-latest holler-ubuntu-latest holler-ubuntu-arm64; do
  echo "Downloading $asset ($VERSION)..." >&2
  curl -fsSL -o "$tmp/$asset" "https://github.com/$REPO/releases/download/$VERSION/$asset"
done

macos_sha="$(shasum -a 256 "$tmp/holler-macos-latest" | awk '{print $1}')"
linux_x86_64_sha="$(shasum -a 256 "$tmp/holler-ubuntu-latest" | awk '{print $1}')"
linux_arm64_sha="$(shasum -a 256 "$tmp/holler-ubuntu-arm64" | awk '{print $1}')"

cat > "$FORMULA" <<EOF
class Holler < Formula
  desc "Your agents are just a holler away — one binary, hub or body"
  homepage "https://github.com/$REPO"
  license "AGPL-3.0-or-later"

  # NOTE: no top-level \`version\` — \`brew audit\` flags it as redundant once
  # url/sha256 live inside on_* blocks (the version is scanned from the URL).
  #
  # url/sha256 cannot sit directly inside on_macos/on_linux (brew audit:
  # "on_macos cannot include url/sha256 directly ... only on_intel, on_arm,
  # ..., on_system ... are allowed as direct children") — they must nest one
  # level deeper, inside on_arm/on_intel/on_system.
  on_macos do
    on_arm do
      url "https://github.com/$REPO/releases/download/$VERSION/holler-macos-latest"
      sha256 "$macos_sha"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/$REPO/releases/download/$VERSION/holler-ubuntu-arm64"
      sha256 "$linux_arm64_sha"
    end
    on_intel do
      url "https://github.com/$REPO/releases/download/$VERSION/holler-ubuntu-latest"
      sha256 "$linux_x86_64_sha"
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
EOF

echo "Wrote $FORMULA for $VERSION" >&2
git -C "$(dirname "$FORMULA")/.." add Formula/holler.rb
git -C "$(dirname "$FORMULA")/.." commit -m "chore: bump holler to $VERSION"
echo "Committed. Review with 'git show' and push when ready." >&2
