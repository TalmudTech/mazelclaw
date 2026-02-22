import Foundation

// Stable identifier used for both the macOS LaunchAgent label and Nix-managed defaults suite.
// nix-mazelclaw writes app defaults into this suite to survive app bundle identifier churn.
let launchdLabel = "ai.mazelclaw.mac"
let gatewayLaunchdLabel = "ai.mazelclaw.gateway"
let onboardingVersionKey = "mazelclaw.onboardingVersion"
let onboardingSeenKey = "mazelclaw.onboardingSeen"
let currentOnboardingVersion = 7
let pauseDefaultsKey = "mazelclaw.pauseEnabled"
let iconAnimationsEnabledKey = "mazelclaw.iconAnimationsEnabled"
let swabbleEnabledKey = "mazelclaw.swabbleEnabled"
let swabbleTriggersKey = "mazelclaw.swabbleTriggers"
let voiceWakeTriggerChimeKey = "mazelclaw.voiceWakeTriggerChime"
let voiceWakeSendChimeKey = "mazelclaw.voiceWakeSendChime"
let showDockIconKey = "mazelclaw.showDockIcon"
let defaultVoiceWakeTriggers = ["mazelclaw"]
let voiceWakeMaxWords = 32
let voiceWakeMaxWordLength = 64
let voiceWakeMicKey = "mazelclaw.voiceWakeMicID"
let voiceWakeMicNameKey = "mazelclaw.voiceWakeMicName"
let voiceWakeLocaleKey = "mazelclaw.voiceWakeLocaleID"
let voiceWakeAdditionalLocalesKey = "mazelclaw.voiceWakeAdditionalLocaleIDs"
let voicePushToTalkEnabledKey = "mazelclaw.voicePushToTalkEnabled"
let talkEnabledKey = "mazelclaw.talkEnabled"
let iconOverrideKey = "mazelclaw.iconOverride"
let connectionModeKey = "mazelclaw.connectionMode"
let remoteTargetKey = "mazelclaw.remoteTarget"
let remoteIdentityKey = "mazelclaw.remoteIdentity"
let remoteProjectRootKey = "mazelclaw.remoteProjectRoot"
let remoteCliPathKey = "mazelclaw.remoteCliPath"
let canvasEnabledKey = "mazelclaw.canvasEnabled"
let cameraEnabledKey = "mazelclaw.cameraEnabled"
let systemRunPolicyKey = "mazelclaw.systemRunPolicy"
let systemRunAllowlistKey = "mazelclaw.systemRunAllowlist"
let systemRunEnabledKey = "mazelclaw.systemRunEnabled"
let locationModeKey = "mazelclaw.locationMode"
let locationPreciseKey = "mazelclaw.locationPreciseEnabled"
let peekabooBridgeEnabledKey = "mazelclaw.peekabooBridgeEnabled"
let deepLinkKeyKey = "mazelclaw.deepLinkKey"
let modelCatalogPathKey = "mazelclaw.modelCatalogPath"
let modelCatalogReloadKey = "mazelclaw.modelCatalogReload"
let cliInstallPromptedVersionKey = "mazelclaw.cliInstallPromptedVersion"
let heartbeatsEnabledKey = "mazelclaw.heartbeatsEnabled"
let debugPaneEnabledKey = "mazelclaw.debugPaneEnabled"
let debugFileLogEnabledKey = "mazelclaw.debug.fileLogEnabled"
let appLogLevelKey = "mazelclaw.debug.appLogLevel"
let voiceWakeSupported: Bool = ProcessInfo.processInfo.operatingSystemVersion.majorVersion >= 26
