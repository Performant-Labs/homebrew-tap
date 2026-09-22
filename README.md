# Performant-Labs/homebrew-tap

Self-hosted Homebrew tap for Performant Labs tools.

## Install

```bash
brew tap Performant-Labs/tap
brew install holler
```

## Formulae

- `holler` — [Performant-Labs/holler](https://github.com/Performant-Labs/holler). Fetches the
  platform release binary directly (no source build); arm64 Linux isn't published yet and
  fails closed with a pointer to building from source.

## Bumping a formula for a new release

```bash
scripts/update-formula.sh v0.3.0   # downloads both assets, computes real sha256s, commits
git push
```

Run this as part of `holler`'s own release checklist (see its
[`docs/release-checklist-template.md`](https://github.com/Performant-Labs/holler/blob/main/docs/release-checklist-template.md)),
after the release's binaries are published — the script downloads the real uploaded assets,
it doesn't guess checksums.
