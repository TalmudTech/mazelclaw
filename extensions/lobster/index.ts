import type {
  AnyAgentTool,
  MazelClawPluginApi,
  MazelClawPluginToolFactory,
} from "../../src/plugins/types.js";
import { createLobsterTool } from "./src/lobster-tool.js";

export default function register(api: MazelClawPluginApi) {
  api.registerTool(
    ((ctx) => {
      if (ctx.sandboxed) {
        return null;
      }
      return createLobsterTool(api) as AnyAgentTool;
    }) as MazelClawPluginToolFactory,
    { optional: true },
  );
}
