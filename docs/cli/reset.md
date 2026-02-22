---
summary: "CLI reference for `mazelclaw reset` (reset local state/config)"
read_when:
  - You want to wipe local state while keeping the CLI installed
  - You want a dry-run of what would be removed
title: "reset"
---

# `mazelclaw reset`

Reset local config/state (keeps the CLI installed).

```bash
mazelclaw reset
mazelclaw reset --dry-run
mazelclaw reset --scope config+creds+sessions --yes --non-interactive
```
