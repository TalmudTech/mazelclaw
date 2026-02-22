import type { MazelClawConfig } from "./config.js";

export function ensurePluginAllowlisted(cfg: MazelClawConfig, pluginId: string): MazelClawConfig {
  const allow = cfg.plugins?.allow;
  if (!Array.isArray(allow) || allow.includes(pluginId)) {
    return cfg;
  }
  return {
    ...cfg,
    plugins: {
      ...cfg.plugins,
      allow: [...allow, pluginId],
    },
  };
}
