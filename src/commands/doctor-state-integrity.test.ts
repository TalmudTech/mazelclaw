import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import type { MazelClawConfig } from "../config/config.js";
import { resolveStorePath, resolveSessionTranscriptsDirForAgent } from "../config/sessions.js";
import { note } from "../terminal/note.js";
import { noteStateIntegrity } from "./doctor-state-integrity.js";

vi.mock("../terminal/note.js", () => ({
  note: vi.fn(),
}));

type EnvSnapshot = {
  HOME?: string;
  MAZELCLAW_HOME?: string;
  MAZELCLAW_STATE_DIR?: string;
  MAZELCLAW_OAUTH_DIR?: string;
};

function captureEnv(): EnvSnapshot {
  return {
    HOME: process.env.HOME,
    MAZELCLAW_HOME: process.env.MAZELCLAW_HOME,
    MAZELCLAW_STATE_DIR: process.env.MAZELCLAW_STATE_DIR,
    MAZELCLAW_OAUTH_DIR: process.env.MAZELCLAW_OAUTH_DIR,
  };
}

function restoreEnv(snapshot: EnvSnapshot) {
  for (const key of Object.keys(snapshot) as Array<keyof EnvSnapshot>) {
    const value = snapshot[key];
    if (value === undefined) {
      delete process.env[key];
    } else {
      process.env[key] = value;
    }
  }
}

function setupSessionState(cfg: MazelClawConfig, env: NodeJS.ProcessEnv, homeDir: string) {
  const agentId = "main";
  const sessionsDir = resolveSessionTranscriptsDirForAgent(agentId, env, () => homeDir);
  const storePath = resolveStorePath(cfg.session?.store, { agentId });
  fs.mkdirSync(sessionsDir, { recursive: true });
  fs.mkdirSync(path.dirname(storePath), { recursive: true });
}

describe("doctor state integrity oauth dir checks", () => {
  let envSnapshot: EnvSnapshot;
  let tempHome = "";

  beforeEach(() => {
    envSnapshot = captureEnv();
    tempHome = fs.mkdtempSync(path.join(os.tmpdir(), "mazelclaw-doctor-state-integrity-"));
    process.env.HOME = tempHome;
    process.env.MAZELCLAW_HOME = tempHome;
    process.env.MAZELCLAW_STATE_DIR = path.join(tempHome, ".mazelclaw");
    delete process.env.MAZELCLAW_OAUTH_DIR;
    fs.mkdirSync(process.env.MAZELCLAW_STATE_DIR, { recursive: true, mode: 0o700 });
    vi.mocked(note).mockReset();
  });

  afterEach(() => {
    restoreEnv(envSnapshot);
    fs.rmSync(tempHome, { recursive: true, force: true });
  });

  it("does not prompt for oauth dir when no whatsapp/pairing config is active", async () => {
    const cfg: MazelClawConfig = {};
    setupSessionState(cfg, process.env, tempHome);
    const confirmSkipInNonInteractive = vi.fn(async () => false);

    await noteStateIntegrity(cfg, { confirmSkipInNonInteractive });

    expect(confirmSkipInNonInteractive).not.toHaveBeenCalledWith(
      expect.objectContaining({
        message: expect.stringContaining("Create OAuth dir at"),
      }),
    );
    const stateIntegrityText = vi
      .mocked(note)
      .mock.calls.filter((call) => call[1] === "State integrity")
      .map((call) => String(call[0]))
      .join("\n");
    expect(stateIntegrityText).toContain("OAuth dir not present");
    expect(stateIntegrityText).not.toContain("CRITICAL: OAuth dir missing");
  });

  it("prompts for oauth dir when whatsapp is configured", async () => {
    const cfg: MazelClawConfig = {
      channels: {
        whatsapp: {},
      },
    };
    setupSessionState(cfg, process.env, tempHome);
    const confirmSkipInNonInteractive = vi.fn(async () => false);

    await noteStateIntegrity(cfg, { confirmSkipInNonInteractive });

    expect(confirmSkipInNonInteractive).toHaveBeenCalledWith(
      expect.objectContaining({
        message: expect.stringContaining("Create OAuth dir at"),
      }),
    );
    const stateIntegrityText = vi
      .mocked(note)
      .mock.calls.filter((call) => call[1] === "State integrity")
      .map((call) => String(call[0]))
      .join("\n");
    expect(stateIntegrityText).toContain("CRITICAL: OAuth dir missing");
  });

  it("prompts for oauth dir when a channel dmPolicy is pairing", async () => {
    const cfg: MazelClawConfig = {
      channels: {
        telegram: {
          dmPolicy: "pairing",
        },
      },
    };
    setupSessionState(cfg, process.env, tempHome);
    const confirmSkipInNonInteractive = vi.fn(async () => false);

    await noteStateIntegrity(cfg, { confirmSkipInNonInteractive });

    expect(confirmSkipInNonInteractive).toHaveBeenCalledWith(
      expect.objectContaining({
        message: expect.stringContaining("Create OAuth dir at"),
      }),
    );
  });
});
