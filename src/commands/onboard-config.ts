import type { MazelClawConfig } from "../config/config.js";

export function applyOnboardingLocalWorkspaceConfig(
  baseConfig: MazelClawConfig,
  workspaceDir: string,
): MazelClawConfig {
  return {
    ...baseConfig,
    agents: {
      ...baseConfig.agents,
      defaults: {
        ...baseConfig.agents?.defaults,
        workspace: workspaceDir,
      },
    },
    gateway: {
      ...baseConfig.gateway,
      mode: "local",
    },
  };
}
