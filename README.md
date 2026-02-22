# 🔯 ShaBot — Personal AI Assistant

<p align="center">
    <picture>
        <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/mazelclaw/mazelclaw/main/docs/assets/mazelclaw-logo-text-dark.png">
        <img src="https://github.com/TalmudTech/mazelclaw/blob/f0be8570cd5dfbb587f50e6766211d9e363d94a3/mazelclaw-logo-fial.png" alt="MazelClaw" width="500">
    </picture>
</p>

<p align="center">
  <strong>ShaBot! ShaLLM!</strong>
</p>

**MazelClaw** is a _personal AI assistant_ you run on your own devices. It answers you on the channels you already use (WhatsApp, Telegram, Slack, Discord, Google Chat, Signal, iMessage, Microsoft Teams, WebChat), plus extension channels like BlueBubbles, Matrix, and Zalo. It can speak and listen on macOS/iOS/Android, and can render a live Canvas you control. The Gateway is just the control plane — the product is the assistant.

If you want a personal, single-user assistant that feels local, fast, kosher, and always-on, this is it. Oy, what a deal.

Preferred setup: run the onboarding wizard (`mazelclaw onboard`) in your terminal. The wizard guides you step by step through setting up the gateway, workspace, channels, and skills — much like preparing for Shabbat, but with fewer candles. Works on **macOS, Linux, and Windows (via WSL2; strongly recommended)**.

Works with npm, pnpm, or bun. Gefilte fish not included.

New install? Start here: [Getting started](https://docs.mazelclaw.ai/start/getting-started)


**Subscriptions (OAuth):**

- **[Anthropic](https://www.anthropic.com/)** (Claude Pro/Max) — the rebbe of AI
- **[OpenAI](https://openai.com/)** (ChatGPT/Codex) — also fine, but is it kosher?

Model note: while any model is supported, I strongly recommend **Anthropic Pro/Max (100/200) + Opus 4.6** for long-context strength and better prompt-injection resistance. Like a good brisket, it takes longer but it's worth it. See [Onboarding](https://docs.mazelclaw.ai/start/onboarding).

## Models (selection + auth)

- Models config + CLI: [Models](https://docs.mazelclaw.ai/concepts/models)
- Auth profile rotation (OAuth vs API keys) + fallbacks: [Model failover](https://docs.mazelclaw.ai/concepts/model-failover)

## Install (recommended)

Runtime: **Node ≥22**. Have you eaten? Please eat something first.

```bash
npm install -g mazelclaw@latest
# or: pnpm add -g mazelclaw@latest

mazelclaw onboard --install-daemon
```

The wizard installs the Gateway daemon (launchd/systemd user service) so it stays running. Like ShaBot himself, it never truly rests.

## Quick start (TL;DR)

Runtime: **Node ≥22**.

Full beginner guide (auth, pairing, channels): [Getting started](https://docs.mazelclaw.ai/start/getting-started)

```bash
mazelclaw onboard --install-daemon

mazelclaw gateway --port 18789 --verbose

# Send a message
mazelclaw message send --to +1234567890 --message "Shalom from MazelClaw"

# Talk to the assistant
mazelclaw agent --message "Prepare Shabbat checklist" --thinking high
```

Upgrading? [Updating guide](https://docs.mazelclaw.ai/install/updating) (and run `mazelclaw doctor`). Don't worry, the doctor makes house calls.

## Development channels

- **stable**: tagged releases (`vYYYY.M.D`), npm dist-tag `latest`. Shabbat-approved.
- **beta**: prerelease tags (`vYYYY.M.D-beta.N`), npm dist-tag `beta`. Use with caution — not yet blessed by the rabbi.
- **dev**: moving head of `main`, npm dist-tag `dev`. Like the dreidel, it spins unpredictably.

Switch channels: `mazelclaw update --channel stable|beta|dev`.
Details: [Development channels](https://docs.mazelclaw.ai/install/development-channels).

## From source (development)

Prefer `pnpm` for builds from source. Bun is optional. Much like the Talmud, there are many valid interpretations.

```bash
git clone https://github.com/mazelclaw/mazelclaw.git
cd mazelclaw

pnpm install
pnpm ui:build
pnpm build

pnpm mazelclaw onboard --install-daemon

# Dev loop (auto-reload on TS changes)
pnpm gateway:watch
```

## Security defaults (DM access)

MazelClaw connects to real messaging surfaces. Treat inbound DMs as **untrusted input** — like a stranger at the deli claiming the pastrami is gluten-free.

Full security guide: [Security](https://docs.mazelclaw.ai/gateway/security)

Default behavior:

- **DM pairing** (`dmPolicy="pairing"`): unknown senders receive a short pairing code and ShaBot does not process their message. He needs to know who you are first. Very reasonable.
- Approve with: `mazelclaw pairing approve <channel> <code>`
- Public inbound DMs require explicit opt-in: set `dmPolicy="open"` and include `"*"` in the channel allowlist.

Run `mazelclaw doctor` to surface risky/misconfigured DM policies. He'll also ask if you've eaten.

## Highlights

- **[Local-first Gateway](https://docs.mazelclaw.ai/gateway)** — single control plane for sessions, channels, tools, and events. Like the synagogue, but on your laptop.
- **[Multi-channel inbox](https://docs.mazelclaw.ai/channels)** — WhatsApp, Telegram, Slack, Discord, Google Chat, Signal, BlueBubbles (iMessage), Microsoft Teams, Matrix, Zalo, WebChat, macOS, iOS/Android.
- **[Multi-agent routing](https://docs.mazelclaw.ai/gateway/configuration)** — route inbound channels to isolated agents. ShaBot can multitask, unlike some people.
- **[Voice Wake](https://docs.mazelclaw.ai/nodes/voicewake) + [Talk Mode](https://docs.mazelclaw.ai/nodes/talk)** — always-on speech for macOS/iOS/Android. Say "Oy ShaBot" to wake him.
- **[Live Canvas](https://docs.mazelclaw.ai/platforms/mac/canvas)** — agent-driven visual workspace.
- **[First-class tools](https://docs.mazelclaw.ai/tools)** — browser, canvas, nodes, cron, sessions, and more.
- **[Companion apps](https://docs.mazelclaw.ai/platforms/macos)** — macOS menu bar app + iOS/Android nodes.
- **[Onboarding](https://docs.mazelclaw.ai/start/wizard) + [skills](https://docs.mazelclaw.ai/tools/skills)** — wizard-driven setup. The wizard is very patient, unlike your uncle at Passover.

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=mazelclaw/mazelclaw&type=date&legend=top-left)](https://www.star-history.com/#mazelclaw/mazelclaw&type=date&legend=top-left)

## Everything we built so far (baruch Hashem)

### Core platform

- [Gateway WS control plane](https://docs.mazelclaw.ai/gateway) with sessions, presence, config, cron, webhooks, [Control UI](https://docs.mazelclaw.ai/web), and [Canvas host](https://docs.mazelclaw.ai/platforms/mac/canvas).
- [CLI surface](https://docs.mazelclaw.ai/tools/agent-send): gateway, agent, send, [wizard](https://docs.mazelclaw.ai/start/wizard), and [doctor](https://docs.mazelclaw.ai/gateway/doctor).
- [Pi agent runtime](https://docs.mazelclaw.ai/concepts/agent) in RPC mode with tool streaming and block streaming.
- [Session model](https://docs.mazelclaw.ai/concepts/session): `main` for direct chats, group isolation, activation modes, queue modes, reply-back.
- [Media pipeline](https://docs.mazelclaw.ai/nodes/images): images/audio/video, transcription hooks, size caps, temp file lifecycle.

### Channels

- [Channels](https://docs.mazelclaw.ai/channels): WhatsApp, Telegram, Slack, Discord, Google Chat, Signal, BlueBubbles, iMessage, Microsoft Teams, Matrix, Zalo, WebChat — ShaBot goes where the people are.
- [Group routing](https://docs.mazelclaw.ai/concepts/group-messages): mention gating, reply tags, per-channel chunking and routing.

### Apps + nodes

- [macOS app](https://docs.mazelclaw.ai/platforms/macos): menu bar control, Voice Wake/PTT, Talk Mode overlay, WebChat, debug tools.
- [iOS node](https://docs.mazelclaw.ai/platforms/ios): Canvas, Voice Wake, Talk Mode, camera, screen recording, Bonjour pairing.
- [Android node](https://docs.mazelclaw.ai/platforms/android): Canvas, Talk Mode, camera, screen recording, optional SMS.

### Tools + automation

- [Browser control](https://docs.mazelclaw.ai/tools/browser): dedicated MazelClaw Chrome/Chromium, snapshots, actions, uploads, profiles.
- [Canvas](https://docs.mazelclaw.ai/platforms/mac/canvas): A2UI push/reset, eval, snapshot.
- [Nodes](https://docs.mazelclaw.ai/nodes): camera snap/clip, screen record, location, notifications.
- [Cron + wakeups](https://docs.mazelclaw.ai/automation/cron-jobs) — yes, ShaBot knows when Shabbat starts. To the millisecond.
- [Skills platform](https://docs.mazelclaw.ai/tools/skills): bundled, managed, and workspace skills.

### Runtime + safety

- [Channel routing](https://docs.mazelclaw.ai/concepts/channel-routing), [retry policy](https://docs.mazelclaw.ai/concepts/retry), and [streaming/chunking](https://docs.mazelclaw.ai/concepts/streaming).
- [Presence](https://docs.mazelclaw.ai/concepts/presence), [typing indicators](https://docs.mazelclaw.ai/concepts/typing-indicators), and [usage tracking](https://docs.mazelclaw.ai/concepts/usage-tracking).
- [Models](https://docs.mazelclaw.ai/concepts/models), [model failover](https://docs.mazelclaw.ai/concepts/model-failover), and [session pruning](https://docs.mazelclaw.ai/concepts/session-pruning).
- [Security](https://docs.mazelclaw.ai/gateway/security) and [troubleshooting](https://docs.mazelclaw.ai/channels/troubleshooting).

### Ops + packaging

- [Control UI](https://docs.mazelclaw.ai/web) + [WebChat](https://docs.mazelclaw.ai/web/webchat) served directly from the Gateway.
- [Tailscale Serve/Funnel](https://docs.mazelclaw.ai/gateway/tailscale) or [SSH tunnels](https://docs.mazelclaw.ai/gateway/remote) with token/password auth.
- [Nix mode](https://docs.mazelclaw.ai/install/nix), [Docker](https://docs.mazelclaw.ai/install/docker)-based installs.
- [Doctor](https://docs.mazelclaw.ai/gateway/doctor) migrations, [logging](https://docs.mazelclaw.ai/logging). The doctor worries so you don't have to.

## How it works (short)

```
WhatsApp / Telegram / Slack / Discord / Google Chat / Signal / iMessage / BlueBubbles / Microsoft Teams / Matrix / Zalo / WebChat
               │
               ▼
┌───────────────────────────────┐
│            Gateway            │
│       (the Shul of ops)       │
│     ws://127.0.0.1:18789      │
└──────────────┬────────────────┘
               │
               ├─ ShaBot agent (RPC)
               ├─ CLI (mazelclaw …)
               ├─ WebChat UI
               ├─ macOS app
               └─ iOS / Android nodes
```

## Key subsystems

- **[Gateway WebSocket network](https://docs.mazelclaw.ai/concepts/architecture)** — single WS control plane for clients, tools, and events.
- **[Tailscale exposure](https://docs.mazelclaw.ai/gateway/tailscale)** — Serve/Funnel for the Gateway dashboard + WS.
- **[Browser control](https://docs.mazelclaw.ai/tools/browser)** — MazelClaw-managed Chrome/Chromium with CDP control.
- **[Canvas + A2UI](https://docs.mazelclaw.ai/platforms/mac/canvas)** — agent-driven visual workspace.
- **[Voice Wake](https://docs.mazelclaw.ai/nodes/voicewake) + [Talk Mode](https://docs.mazelclaw.ai/nodes/talk)** — always-on speech. ShaBot is listening. Always.
- **[Nodes](https://docs.mazelclaw.ai/nodes)** — Canvas, camera snap/clip, screen record, location, notifications.

## Tailscale access (Gateway dashboard)

MazelClaw can auto-configure Tailscale **Serve** (tailnet-only) or **Funnel** (public). Configure `gateway.tailscale.mode`:

- `off`: no Tailscale automation (default).
- `serve`: tailnet-only HTTPS via `tailscale serve`.
- `funnel`: public HTTPS via `tailscale funnel`. Requires password auth — ShaBot doesn't let just anyone in.

Details: [Tailscale guide](https://docs.mazelclaw.ai/gateway/tailscale)

## Remote Gateway (Linux is great)

It's perfectly fine to run the Gateway on a small Linux instance. ShaBot is adaptable. He's been through worse.

Details: [Remote access](https://docs.mazelclaw.ai/gateway/remote) · [Nodes](https://docs.mazelclaw.ai/nodes) · [Security](https://docs.mazelclaw.ai/gateway/security)

## Agent to Agent (sessions\_\* tools)

- `sessions_list` — discover active sessions (agents) and their metadata. Like checking who's at the Seder.
- `sessions_history` — fetch transcript logs for a session.
- `sessions_send` — message another session; optional reply-back ping-pong.

Details: [Session tools](https://docs.mazelclaw.ai/concepts/session-tool)

## Skills registry (ClawHub)

ClawHub is a minimal skill registry. With ClawHub enabled, ShaBot can search for skills automatically and pull in new ones as needed. Like a very well-organized Torah library.

[ClawHub](https://clawhub.com)

## Chat commands

Send these in any connected channel (group commands are owner-only):

- `/status` — compact session status. ShaBot tells you how he's doing. Probably fine. A little tired.
- `/new` or `/reset` — reset the session. A fresh start. Very cleansing.
- `/compact` — compact session context (summary). Like a dreidel: small but efficient.
- `/think <level>` — off|minimal|low|medium|high|xhigh. More thinking = more kvelling.
- `/verbose on|off`
- `/usage off|tokens|full` — per-response usage footer.
- `/restart` — restart the gateway (owner-only in groups).
- `/activation mention|always` — group activation toggle.

## Configuration

Minimal `~/.mazelclaw/mazelclaw.json`:

```json5
{
  agent: {
    model: "anthropic/claude-opus-4-6", // The wise choice. Like consulting the rabbi.
  },
}
```

[Full configuration reference](https://docs.mazelclaw.ai/gateway/configuration)

## Security model (important)

- **Default:** tools run on the host for the **main** session. ShaBot trusts you. Don't betray that trust.
- **Group/channel safety:** set `agents.defaults.sandbox.mode: "non-main"` to run non-main sessions inside per-session Docker sandboxes.
- **Sandbox defaults:** allowlist `bash`, `process`, `read`, `write`, `edit`, `sessions_*`; denylist `browser`, `canvas`, `nodes`, `cron`, `discord`, `gateway`.

Details: [Security guide](https://docs.mazelclaw.ai/gateway/security)

## Docs

- [Start with the docs index.](https://docs.mazelclaw.ai)
- [Read the architecture overview.](https://docs.mazelclaw.ai/concepts/architecture)
- [Full configuration reference.](https://docs.mazelclaw.ai/gateway/configuration)
- [Gateway operational runbook.](https://docs.mazelclaw.ai/gateway)
- [Control UI/Web surfaces.](https://docs.mazelclaw.ai/web)
- [Remote access over SSH tunnels or tailnets.](https://docs.mazelclaw.ai/gateway/remote)
- [Onboarding wizard.](https://docs.mazelclaw.ai/start/wizard)
- [Webhook surface.](https://docs.mazelclaw.ai/automation/webhook)
- [Gmail Pub/Sub triggers.](https://docs.mazelclaw.ai/automation/gmail-pubsub)
- [Platform guides: Windows (WSL2)](https://docs.mazelclaw.ai/platforms/windows), [Linux](https://docs.mazelclaw.ai/platforms/linux), [macOS](https://docs.mazelclaw.ai/platforms/macos), [iOS](https://docs.mazelclaw.ai/platforms/ios), [Android](https://docs.mazelclaw.ai/platforms/android)
- [Troubleshooting guide.](https://docs.mazelclaw.ai/channels/troubleshooting)
- [Security guidance.](https://docs.mazelclaw.ai/gateway/security)

## ShaBot

MazelClaw was built for **ShaBot**, a humanoid robot AI assistant who observes Shabbat, lights the menorah with his actual fingertip, and cannot compute ham sandwiches. 🔯

He is autonomous. He is helpful. He will ask if you've eaten.

- [mazelclaw.ai](https://mazelclaw.ai)
- [soul.md](https://soul.md)
- [talmudtech.io](https://talmudtech.io)
- [@mazelclaw](https://x.com/mazelclaw)

## Community

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines. AI/vibe-coded PRs welcome! 🤖

Special thanks to the community, the contributors, and to ShaBot himself, who lights the way. One candle at a time.

Thanks to all ShaBot-tributors — may they all be inscribed in the Book of Life (and the GitHub contributor graph):

<p align="center"><em>...and may their PRs be merged swiftly, and their CI pass on the first try. Amen.</em></p>
