# Formula audit — May 2026

Read-through review of `Formula/budi.rb` against current Homebrew style and best practices. Closes #13.

Audited revision: `Formula/budi.rb` at `budi v8.5.1`.

Reminder: `Formula/budi.rb` is auto-generated. Every fix below is a change request against the generator in `siropkin/budi/.github/workflows/release.yml`, **not** an edit to this file.

## Checklist results

### `desc` — pass

`"Local-first cost analytics for AI coding agents"`

- One line, no trailing period, 49 chars (under 80).
- Does not start with an article and does not repeat the formula name. Matches Homebrew style.

### `homepage` — pass

`https://github.com/siropkin/budi` resolves (HTTP 200) and points at the canonical product repo.

### URL pattern + sha256 — pass

GitHub release tarballs, version templated into the URL, one `sha256` per platform branch. Matches the standard tap layout for prebuilt cross-platform binaries.

### `livecheck` — **missing**

There is no `livecheck` block. For a GitHub-release-driven formula this should be:

```ruby
livecheck do
  url :stable
  strategy :github_latest
end
```

`:github_latest` is the right strategy here because the tap is only ever bumped from stable tags — prereleases (`vX.Y.Z-rc.N`) are excluded by `update-homebrew` gating in the generator (see SOUL.md §"Prereleases"). The `latest` release on GitHub already filters them out, so no regex is needed.

**Action:** add the block to the generator template.

### `test do` — pass (per SOUL.md)

```ruby
assert_match version.to_s, shell_output("#{bin}/budi --version")
```

SOUL.md explicitly says: *"`test do` in the formula should stay trivial — `budi --version` level. Anything deeper belongs in the main repo's CI, not here."* Current block honors that. No change.

Optional nit (do not act on): could additionally assert `budi-daemon --version` since both binaries ship from the same tarball and version skew is a stated risk. Leaving it out keeps the test trivial and matches SOUL.md guidance — flagging for awareness only.

### `depends_on` — pass

None listed. budi ships as a self-contained Rust binary per release target, so this is correct. Confirm at generator-template level that no runtime libraries (e.g. system OpenSSL) sneak in if the build switches off `rustls`/static linking.

## Minor / non-blocking findings

These do not block release and can be folded into the generator at the maintainer's discretion.

1. **Combine `bin.install` calls.** Two adjacent calls can be one:
   ```ruby
   bin.install "budi", "budi-daemon"
   ```
   Pure style — both forms pass `brew audit`.

2. **Explicit `Hardware::CPU.intel?` branches.** The current `if Hardware::CPU.arm? … else …` pattern implicitly maps the `else` arm to x86_64. Homebrew style guides accept this, but recent tap formulae increasingly use explicit `Hardware::CPU.intel?` for readability on the Intel arm. Optional.

3. **`# typed: false` sigil.** Fine for tap formulae; core formulae are moving to `true` but there is no requirement for taps. No change.

4. **License string.** `"MIT"` — confirm this matches the upstream `siropkin/budi` `Cargo.toml` / `LICENSE`. Not verified in this audit; flag for the generator owner to assert at template-build time.

## Summary

One real gap: **no `livecheck` block**. Everything else is either passing or stylistic. The fix lands in the generator template at `siropkin/budi/.github/workflows/release.yml`, not in this repo.
