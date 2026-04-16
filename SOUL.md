# SOUL.md

Homebrew tap for **budi**. Provides the formula that `brew install siropkin/budi/budi` resolves to.

This repo is **release metadata only**. The product itself lives in [`siropkin/budi`](https://github.com/siropkin/budi). Do not put source code, build tooling, or docs here — only the Ruby formula and the minimal scaffolding a tap needs.

## What's here

- `Formula/budi.rb` — the formula. **Auto-generated** by the release workflow in the main repo. Do not edit by hand; changes will be overwritten on the next release.
- `README.md` — short tap instructions for end users.

## Product boundaries

| Product | Repo | Role |
|---------|------|------|
| **budi-core** | [`siropkin/budi`](https://github.com/siropkin/budi) | Rust workspace: daemon, CLI, proxy. Source of all release artifacts. |
| **budi-cursor** | [`siropkin/budi-cursor`](https://github.com/siropkin/budi-cursor) | VS Code/Cursor extension |
| **budi-cloud** | [`siropkin/budi-cloud`](https://github.com/siropkin/budi-cloud) | Cloud dashboard at `app.getbudi.dev` |
| **homebrew-budi** | **this repo** (`siropkin/homebrew-budi`) | Homebrew tap that points `brew` at GitHub release tarballs |

## Install (for users)

```bash
brew install siropkin/budi/budi
```

The longer form:

```bash
brew tap siropkin/budi
brew install budi
```

Uninstall / untap:

```bash
brew uninstall budi
brew untap siropkin/budi
```

## Release flow

1. A version is tagged in the main repo (`siropkin/budi`) and GitHub Actions builds release tarballs for macOS (arm64, x86_64) and Linux (arm64, x86_64).
2. A workflow in the main repo computes the sha256 of each tarball and commits an updated `Formula/budi.rb` here with the new version, URLs, and checksums.
3. Once pushed, `brew update && brew upgrade budi` picks up the new version for everyone.

Because step 2 is automated, do not open manual PRs against `Formula/budi.rb`. If the formula is wrong, fix the release workflow in the main repo — not this file.

## Supported platforms

The formula builds for four targets:

| OS | Arch | Target triple |
|----|------|---------------|
| macOS | arm64 | `aarch64-apple-darwin` |
| macOS | x86_64 | `x86_64-apple-darwin` |
| Linux | arm64 | `aarch64-unknown-linux-gnu` |
| Linux | x86_64 | `x86_64-unknown-linux-gnu` |

Windows is not distributed via Homebrew. Windows users install via the tarball on the GitHub releases page of the main repo.

## Formula post-install

The formula installs two binaries on PATH: `budi` and `budi-daemon`. **Important**: the formula must ship both from the same release tarball. Version skew between `budi` and `budi-daemon` breaks the daemon auto-restart contract in the main repo. The release workflow bundles them in one tarball for exactly this reason.

After install, users run:

```bash
budi init
```

which patches shell / editor config for proxy routing and installs the platform-native autostart service (see main repo's SOUL.md for the details).

## Dev notes

- Do not add custom taps or formulae here beyond `budi.rb` unless there is a clear reason. This tap exists for one formula.
- `test do` in the formula should stay trivial — `budi --version` level. Anything deeper belongs in the main repo's CI, not here.
- If a user reports `brew install` breaking, check the release workflow first, then the formula URLs / sha256s, then Homebrew's bottle build logs.
- Keep the `README.md` minimal: install command, link to main repo, nothing else. Users coming here are confirming a URL, not reading docs.
