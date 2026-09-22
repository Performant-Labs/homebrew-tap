#!/bin/sh
# Bump Formula/holler.rb to a new holler release tag: downloads both
# platform assets, computes real sha256s, rewrites the formula, commits.
#
#   scripts/update-formula.sh v0.3.0
#
# Does not push — review the diff and push yourself.

set -eu

VERSION="${1:?usage: update-formula.sh vX.Y.Z}"
VERSION_NUM="${VERSION#v}"
REPO="Performant-Labs/holler"
FORMULA="$(dirname "$0")/../Formula/holler.rb"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

for asset in holler-macos-latest holler-ubuntu-latest; do
  echo "Downloading $asset ($VERSION)..." >&2
  curl -fsSL -o "$tmp/$asset" "https://github.com/$REPO/releases/download/$VERSION/$asset"
done

macos_sha="$(shasum -a 256 "$tmp/holler-macos-latest" | awk '{print $1}')"
linux_sha="$(shasum -a 256 "$tmp/holler-ubuntu-latest" | awk '{print $1}')"

cat > "$FORMULA" <<EOF
class Holler < Formula
  desc "Your agents are just a holler away — one binary, hub or body"
  homepage "https://github.com/$REPO"
  version "$VERSION_NUM"
  license "AGPL-3.0-or-later"

  on_macos do
    url "https://github.com/$REPO/releases/download/$VERSION/holler-macos-latest"
    sha256 "$macos_sha"
  end

  on_linux do
    url "https://github.com/$REPO/releases/download/$VERSION/holler-ubuntu-latest"
    sha256 "$linux_sha"
  end

  def install
    if OS.linux? && Hardware::CPU.arm?
      odie "holler has no arm64 Linux release yet — build from source instead: " \\
           "cargo build --release -p holler-cli " \\
           "(see https://github.com/$REPO#install)"
    end
    bin.install (OS.mac? ? "holler-macos-latest" : "holler-ubuntu-latest") => "holler"
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
