import type { MazelClawPluginApi } from "mazelclaw/plugin-sdk";
import { emptyPluginConfigSchema } from "mazelclaw/plugin-sdk";
import { twitchPlugin } from "./src/plugin.js";
import { setTwitchRuntime } from "./src/runtime.js";

export { monitorTwitchProvider } from "./src/monitor.js";

const plugin = {
  id: "twitch",
  name: "Twitch",
  description: "Twitch channel plugin",
  configSchema: emptyPluginConfigSchema(),
  register(api: MazelClawPluginApi) {
    setTwitchRuntime(api.runtime);
    // oxlint-disable-next-line typescript/no-explicit-any
    api.registerChannel({ plugin: twitchPlugin as any });
  },
};

export default plugin;
