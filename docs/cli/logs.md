---
summary: "CLI reference for `mazelclaw logs` (tail gateway logs via RPC)"
read_when:
  - You need to tail Gateway logs remotely (without SSH)
  - You want JSON log lines for tooling
title: "logs"
---

# `mazelclaw logs`

Tail Gateway file logs over RPC (works in remote mode).

Related:

- Logging overview: [Logging](/logging)

## Examples

```bash
mazelclaw logs
mazelclaw logs --follow
mazelclaw logs --json
mazelclaw logs --limit 500
mazelclaw logs --local-time
mazelclaw logs --follow --local-time
```

Use `--local-time` to render timestamps in your local timezone.
