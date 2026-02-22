---
summary: "CLI reference for `mazelclaw doctor` (health checks + guided repairs)"
read_when:
  - You have connectivity/auth issues and want guided fixes
  - You updated and want a sanity check
title: "doctor"
---

# `mazelclaw doctor`

Health checks + quick fixes for the gateway and channels.

Related:

- Troubleshooting: [Troubleshooting](/gateway/troubleshooting)
- Security audit: [Security](/gateway/security)

## Examples

```bash
mazelclaw doctor
mazelclaw doctor --repair
mazelclaw doctor --deep
```

Notes:

- Interactive prompts (like keychain/OAuth fixes) only run when stdin is a TTY and `--non-interactive` is **not** set. Headless runs (cron, Telegram, no terminal) will skip prompts.
- `--fix` (alias for `--repair`) writes a backup to `~/.mazelclaw/mazelclaw.json.bak` and drops unknown config keys, listing each removal.

## macOS: `launchctl` env overrides

If you previously ran `launchctl setenv MAZELCLAW_GATEWAY_TOKEN ...` (or `...PASSWORD`), that value overrides your config file and can cause persistent “unauthorized” errors.

```bash
launchctl getenv MAZELCLAW_GATEWAY_TOKEN
launchctl getenv MAZELCLAW_GATEWAY_PASSWORD

launchctl unsetenv MAZELCLAW_GATEWAY_TOKEN
launchctl unsetenv MAZELCLAW_GATEWAY_PASSWORD
```
