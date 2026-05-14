# SOUL.md

Homebrew tap for **budi**. Provides the formula that `brew install siropkin/budi/budi` resolves to.

This repo is **release metadata only**. The product itself lives in [`siropkin/budi`](https://github.com/siropkin/budi). Do not put source code, build tooling, or docs here — only the Ruby formula and the minimal scaffolding a tap needs.

## Doc layout

- `README.md` — end-user facing: what budi is, how to install/update/uninstall, supported platforms, links to sibling repos. Anything a user lands on from `brew search` or a release announcement reads here.
- `SOUL.md` — this file. Canonical guidance for AI agents and maintainers working in this repo: release flow, prerelease handling, target triples, formula contracts, dev notes. No end-user material; cross-link to `README.md` when needed.
- `CLAUDE.md`, `AGENTS.md` — tooling-discovery pointers (Claude Code reads `CLAUDE.md`, Codex / other agents read `AGENTS.md`). Both redirect here. Keep them as files rather than symlinks for portability across clones and Windows checkouts.
- `Formula/budi.rb` — the formula. **Auto-generated** by the release workflow in the main repo. Do not edit by hand; changes will be overwritten on the next release.
- `docs/` — one-off audit notes and ADR-style scratch (e.g. `formula-audit-2026-05.md`). Not a long-lived docs tree.

## Product boundaries

| Product | Repo | Role |
|---------|------|------|
| **budi-core** | [`siropkin/budi`](https://github.com/siropkin/budi) | Rust workspace: daemon, CLI, transcript tailer. Source of all release artifacts. |
| **budi-cursor** | [`siropkin/budi-cursor`](https://github.com/siropkin/budi-cursor) | VS Code / Cursor extension |
| **budi-jetbrains** | [`siropkin/budi-jetbrains`](https://github.com/siropkin/budi-jetbrains) | JetBrains IDE plugin (Kotlin) |
| **budi-cloud** | [`siropkin/budi-cloud`](https://github.com/siropkin/budi-cloud) | Cloud dashboard at `app.getbudi.dev` |
| **homebrew-budi** | **this repo** (`siropkin/homebrew-budi`) | Homebrew tap that points `brew` at GitHub release tarballs |
| **getbudi.dev** | [`siropkin/getbudi.dev`](https://github.com/siropkin/getbudi.dev) | Marketing site at `getbudi.dev` |

## Install (for users)

See `README.md`. The canonical install / update / uninstall steps live there so users landing on the tap from a release announcement don't have to read agent docs. Do not duplicate them here.

## Release flow

1. A version is tagged in the main repo (`siropkin/budi`) and GitHub Actions builds release tarballs for macOS (arm64, x86_64) and Linux (arm64, x86_64).
2. A workflow in the main repo computes the sha256 of each tarball and commits an updated `Formula/budi.rb` here with the new version, URLs, and checksums.
3. Once pushed, `brew update && brew upgrade budi` picks up the new version for everyone.

Because step 2 is automated, do not open manual PRs against `Formula/budi.rb`. If the formula is wrong, fix the release workflow in the main repo — not this file.

### Prereleases (`vX.Y.Z-rc.N`, `-beta.N`, …)

Any tag in the main repo with a `-` in the version (e.g. `v8.4.8-rc.1`) is a **prerelease**:

- The GitHub release is marked `prerelease: true` and excluded from the "Latest" badge on the main repo page.
- **The tap is NOT bumped** — `Formula/budi.rb` keeps pointing at the last stable. `brew upgrade siropkin/budi/budi` users never see the rc.
- The release workflow's `update-homebrew` job is gated on `IS_PRERELEASE != 'true'` (see `siropkin/budi/.github/workflows/release.yml`).

To test a prerelease locally, download the asset directly from the GitHub release page and swap the binary in `/opt/homebrew/Cellar/budi/<current-stable>/bin/` — or run it out of `/tmp`. When the rc passes smoke, the main repo re-tags the same SHA as `vX.Y.Z` and this tap auto-bumps on that stable tag.

## Supported target triples

The formula resolves to one of four prebuilt tarballs (the user-facing platform list lives in `README.md`):

| OS | Arch | Target triple |
|----|------|---------------|
| macOS | arm64 | `aarch64-apple-darwin` |
| macOS | x86_64 | `x86_64-apple-darwin` |
| Linux | arm64 | `aarch64-unknown-linux-gnu` |
| Linux | x86_64 | `x86_64-unknown-linux-gnu` |

Windows is not distributed via Homebrew. Windows users install via the `.zip` on the GitHub releases page of the main repo.

## Formula post-install

The formula installs two binaries on PATH: `budi` and `budi-daemon`. **Important**: the formula must ship both from the same release tarball. Version skew between `budi` and `budi-daemon` breaks the daemon auto-restart contract in the main repo. The release workflow bundles them in one tarball for exactly this reason.

After install, users run:

```bash
budi init
```

which creates the data dir, starts the daemon, installs the platform-native autostart service (launchd on macOS, systemd user unit on Linux), and wires recommended integrations (Claude Code statusline, Cursor / VS Code extension). Live capture is JSONL-tailing only — no shell or editor proxy patching ([ADR-0089](https://github.com/siropkin/budi/blob/main/docs/adr/0089-reverse-proxy-first-jsonl-tailing-as-sole-live-path.md)). See `siropkin/budi/SOUL.md` for the canonical contract.

## Dev notes

- Do not add custom taps or formulae here beyond `budi.rb` unless there is a clear reason. This tap exists for one formula.
- `test do` in the formula should stay trivial — `budi --version` level. Anything deeper belongs in the main repo's CI, not here.
- If a user reports `brew install` breaking, check the release workflow first, then the formula URLs / sha256s, then Homebrew's bottle build logs.
- `README.md` is the user-facing landing page (what budi is, install/update/uninstall, supported platforms, sibling-repo links). Keep it skimmable; if it grows beyond a quick read, push agent/maintainer detail back here rather than into the README.
