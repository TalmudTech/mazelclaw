---
summary: "CLI reference for `mazelclaw agents` (list/add/delete/set identity)"
read_when:
  - You want multiple isolated agents (workspaces + routing + auth)
title: "agents"
---

# `mazelclaw agents`

Manage isolated agents (workspaces + auth + routing).

Related:

- Multi-agent routing: [Multi-Agent Routing](/concepts/multi-agent)
- Agent workspace: [Agent workspace](/concepts/agent-workspace)

## Examples

```bash
mazelclaw agents list
mazelclaw agents add work --workspace ~/.mazelclaw/workspace-work
mazelclaw agents set-identity --workspace ~/.mazelclaw/workspace --from-identity
mazelclaw agents set-identity --agent main --avatar avatars/mazelclaw.png
mazelclaw agents delete work
```

## Identity files

Each agent workspace can include an `IDENTITY.md` at the workspace root:

- Example path: `~/.mazelclaw/workspace/IDENTITY.md`
- `set-identity --from-identity` reads from the workspace root (or an explicit `--identity-file`)

Avatar paths resolve relative to the workspace root.

## Set identity

`set-identity` writes fields into `agents.list[].identity`:

- `name`
- `theme`
- `emoji`
- `avatar` (workspace-relative path, http(s) URL, or data URI)

Load from `IDENTITY.md`:

```bash
mazelclaw agents set-identity --workspace ~/.mazelclaw/workspace --from-identity
```

Override fields explicitly:

```bash
mazelclaw agents set-identity --agent main --name "MazelClaw" --emoji "🦞" --avatar avatars/mazelclaw.png
```

Config sample:

```json5
{
  agents: {
    list: [
      {
        id: "main",
        identity: {
          name: "MazelClaw",
          theme: "space lobster",
          emoji: "🦞",
          avatar: "avatars/mazelclaw.png",
        },
      },
    ],
  },
}
```
