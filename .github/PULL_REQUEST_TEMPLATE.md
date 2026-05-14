<!--
Tap-PR reviewer cheat-sheet. Most PRs here are auto-generated formula bumps
from siropkin/budi's release workflow — those need almost no review.
Manual PRs (docs, workflows, scaffolding) get the checklist below.
See SOUL.md for repo philosophy.
-->

## What kind of PR is this?

- [ ] **Auto-bump** of `Formula/budi.rb` from the release workflow in `siropkin/budi` → merge with minimal review.
- [ ] **Manual change** (docs / workflows / scaffolding) → use the checklist below.

> A manual edit to `Formula/budi.rb` is a red flag. The formula is auto-generated; fix the generator in `siropkin/budi/.github/workflows/release.yml` instead.

## Summary

<!-- One or two sentences. What changes and why. -->

## Reviewer checklist (manual PRs)

**Formula or anything that runs in CI**
- [ ] `brew audit --strict --online Formula/budi.rb` passes in `tests.yml`
- [ ] `brew style Formula/budi.rb` passes in `tests.yml`

**Docs (`README.md`, `SOUL.md`, `CLAUDE.md`, `AGENTS.md`)**
- [ ] End-user content stays in `README.md`; AI-agent / contributor guidance stays in `SOUL.md` (see #15)
- [ ] No duplication between the two
- [ ] No stale references to shell/editor proxy patching — live capture is JSONL-tailing only ([ADR-0089](https://github.com/siropkin/budi/blob/main/docs/adr/0089-reverse-proxy-first-jsonl-tailing-as-sole-live-path.md))

**Workflows (`.github/workflows/*.yml`)**
- [ ] Third-party actions pinned to a full commit SHA (not a floating tag)
- [ ] Job-level `permissions:` set to the minimum needed (usually `contents: read`)
- [ ] Concurrency group set if the workflow can be superseded

**Always**
- [ ] Sibling-repo links resolve: `siropkin/budi`, `siropkin/budi-cursor`, `siropkin/budi-jetbrains`, `siropkin/budi-cloud`, `siropkin/getbudi.dev`
- [ ] No source code, build tooling, or product docs added — this repo is release metadata only
