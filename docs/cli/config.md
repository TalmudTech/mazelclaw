---
summary: "CLI reference for `mazelclaw config` (get/set/unset config values)"
read_when:
  - You want to read or edit config non-interactively
title: "config"
---

# `mazelclaw config`

Config helpers: get/set/unset values by path. Run without a subcommand to open
the configure wizard (same as `mazelclaw configure`).

## Examples

```bash
mazelclaw config get browser.executablePath
mazelclaw config set browser.executablePath "/usr/bin/google-chrome"
mazelclaw config set agents.defaults.heartbeat.every "2h"
mazelclaw config set agents.list[0].tools.exec.node "node-id-or-name"
mazelclaw config unset tools.web.search.apiKey
```

## Paths

Paths use dot or bracket notation:

```bash
mazelclaw config get agents.defaults.workspace
mazelclaw config get agents.list[0].id
```

Use the agent list index to target a specific agent:

```bash
mazelclaw config get agents.list
mazelclaw config set agents.list[1].tools.exec.node "node-id-or-name"
```

## Values

Values are parsed as JSON5 when possible; otherwise they are treated as strings.
Use `--strict-json` to require JSON5 parsing. `--json` remains supported as a legacy alias.

```bash
mazelclaw config set agents.defaults.heartbeat.every "0m"
mazelclaw config set gateway.port 19001 --strict-json
mazelclaw config set channels.whatsapp.groups '["*"]' --strict-json
```

Restart the gateway after edits.
