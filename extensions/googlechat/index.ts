import type { MazelClawPluginApi } from "mazelclaw/plugin-sdk";
import { emptyPluginConfigSchema } from "mazelclaw/plugin-sdk";
import { googlechatDock, googlechatPlugin } from "./src/channel.js";
import { handleGoogleChatWebhookRequest } from "./src/monitor.js";
import { setGoogleChatRuntime } from "./src/runtime.js";

const plugin = {
  id: "googlechat",
  name: "Google Chat",
  description: "MazelClaw Google Chat channel plugin",
  configSchema: emptyPluginConfigSchema(),
  register(api: MazelClawPluginApi) {
    setGoogleChatRuntime(api.runtime);
    api.registerChannel({ plugin: googlechatPlugin, dock: googlechatDock });
    api.registerHttpHandler(handleGoogleChatWebhookRequest);
  },
};

export default plugin;
