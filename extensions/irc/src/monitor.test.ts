import { describe, expect, it } from "vitest";
import { resolveIrcInboundTarget } from "./monitor.js";

describe("irc monitor inbound target", () => {
  it("keeps channel target for group messages", () => {
    expect(
      resolveIrcInboundTarget({
        target: "#mazelclaw",
        senderNick: "alice",
      }),
    ).toEqual({
      isGroup: true,
      target: "#mazelclaw",
      rawTarget: "#mazelclaw",
    });
  });

  it("maps DM target to sender nick and preserves raw target", () => {
    expect(
      resolveIrcInboundTarget({
        target: "mazelclaw-bot",
        senderNick: "alice",
      }),
    ).toEqual({
      isGroup: false,
      target: "alice",
      rawTarget: "mazelclaw-bot",
    });
  });

  it("falls back to raw target when sender nick is empty", () => {
    expect(
      resolveIrcInboundTarget({
        target: "mazelclaw-bot",
        senderNick: " ",
      }),
    ).toEqual({
      isGroup: false,
      target: "mazelclaw-bot",
      rawTarget: "mazelclaw-bot",
    });
  });
});
