# Homebrew Tap for Budi

[Budi](https://github.com/siropkin/budi) is a local-first cost analytics layer for AI coding agents. It sits as a transparent proxy between your editor (Claude Code, Codex, Cursor, Copilot CLI) and the upstream provider, capturing every request in real time so you can see session cost, today's spend, and historical trends — without any prompts, code, or responses leaving your machine.

This repository is the [Homebrew](https://brew.sh/) tap for distributing Budi on macOS and Linux.

## Install

```bash
brew install siropkin/budi/budi
budi init
```

`budi init` starts the daemon, registers a platform autostart service (launchd on macOS, systemd user unit on Linux), patches your shell profile so CLI agents route through the Budi proxy, and offers to install the Cursor / VS Code extension.

Restart your terminal (or `source ~/.zshrc` / `source ~/.bashrc`) after `budi init` so the proxy env vars take effect for new shells.

## What you get

- `budi status` — quick overview: daemon, proxy, today's cost
- `budi stats` — usage analytics by agent, project, branch, model, or tag
- `budi sessions` — per-session breakdown with health signals
- `budi health` — session vitals: prompt growth, cache reuse, retry loops, cost acceleration
- `budi doctor` — health check for daemon, database, shell config, and autostart
- `budi launch <agent>` — explicit proxy-routed launch for Claude Code / Codex / Cursor / Copilot
- `budi import` — import historical transcripts (Claude Code, Codex CLI, Copilot CLI, Cursor)

## Optional cloud dashboard

An optional, opt-in cloud dashboard at [app.getbudi.dev](https://app.getbudi.dev) gives engineering managers team-wide cost visibility. Only aggregated daily rollups and session summaries leave the machine — prompts, code, responses, file paths, and email addresses are never uploaded. See [ADR-0083](https://github.com/siropkin/budi/blob/main/docs/adr/0083-cloud-ingest-identity-and-privacy-contract.md) for the full privacy contract. Cloud sync is disabled by default.

## Update

```bash
brew upgrade budi
```

## Uninstall

```bash
brew uninstall budi
budi uninstall   # removes local config, autostart service, and proxy shell block (keeps the binaries managed by brew)
```

## Platforms

| OS | Architectures |
|----|---------------|
| macOS | arm64, x86_64 |
| Linux | arm64, x86_64 |

For Windows, download the `.zip` from the [GitHub Releases](https://github.com/siropkin/budi/releases) page.

## Formula

The `Formula/budi.rb` file in this tap is **auto-generated** by the [Budi release workflow](https://github.com/siropkin/budi/blob/main/.github/workflows/release.yml) on every `v*` tag. Do not edit it manually — changes are overwritten on the next release.

## Links

- Project: [github.com/siropkin/budi](https://github.com/siropkin/budi)
- Cursor / VS Code extension: [github.com/siropkin/budi-cursor](https://github.com/siropkin/budi-cursor)
- Cloud dashboard: [github.com/siropkin/budi-cloud](https://github.com/siropkin/budi-cloud) · [app.getbudi.dev](https://app.getbudi.dev)
- Latest release: [v8.0.0](https://github.com/siropkin/budi/releases/latest)

## License

MIT — same as [the main Budi repo](https://github.com/siropkin/budi/blob/main/LICENSE).
