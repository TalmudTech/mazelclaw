package ai.mazelclaw.android.node

import android.os.Build
import ai.mazelclaw.android.BuildConfig
import ai.mazelclaw.android.SecurePrefs
import ai.mazelclaw.android.gateway.GatewayClientInfo
import ai.mazelclaw.android.gateway.GatewayConnectOptions
import ai.mazelclaw.android.gateway.GatewayEndpoint
import ai.mazelclaw.android.gateway.GatewayTlsParams
import ai.mazelclaw.android.protocol.MazelClawCanvasA2UICommand
import ai.mazelclaw.android.protocol.MazelClawCanvasCommand
import ai.mazelclaw.android.protocol.MazelClawCameraCommand
import ai.mazelclaw.android.protocol.MazelClawLocationCommand
import ai.mazelclaw.android.protocol.MazelClawScreenCommand
import ai.mazelclaw.android.protocol.MazelClawSmsCommand
import ai.mazelclaw.android.protocol.MazelClawCapability
import ai.mazelclaw.android.LocationMode
import ai.mazelclaw.android.VoiceWakeMode

class ConnectionManager(
  private val prefs: SecurePrefs,
  private val cameraEnabled: () -> Boolean,
  private val locationMode: () -> LocationMode,
  private val voiceWakeMode: () -> VoiceWakeMode,
  private val smsAvailable: () -> Boolean,
  private val hasRecordAudioPermission: () -> Boolean,
  private val manualTls: () -> Boolean,
) {
  companion object {
    internal fun resolveTlsParamsForEndpoint(
      endpoint: GatewayEndpoint,
      storedFingerprint: String?,
      manualTlsEnabled: Boolean,
    ): GatewayTlsParams? {
      val stableId = endpoint.stableId
      val stored = storedFingerprint?.trim().takeIf { !it.isNullOrEmpty() }
      val isManual = stableId.startsWith("manual|")

      if (isManual) {
        if (!manualTlsEnabled) return null
        if (!stored.isNullOrBlank()) {
          return GatewayTlsParams(
            required = true,
            expectedFingerprint = stored,
            allowTOFU = false,
            stableId = stableId,
          )
        }
        return GatewayTlsParams(
          required = true,
          expectedFingerprint = null,
          allowTOFU = false,
          stableId = stableId,
        )
      }

      // Prefer stored pins. Never let discovery-provided TXT override a stored fingerprint.
      if (!stored.isNullOrBlank()) {
        return GatewayTlsParams(
          required = true,
          expectedFingerprint = stored,
          allowTOFU = false,
          stableId = stableId,
        )
      }

      val hinted = endpoint.tlsEnabled || !endpoint.tlsFingerprintSha256.isNullOrBlank()
      if (hinted) {
        // TXT is unauthenticated. Do not treat the advertised fingerprint as authoritative.
        return GatewayTlsParams(
          required = true,
          expectedFingerprint = null,
          allowTOFU = false,
          stableId = stableId,
        )
      }

      return null
    }
  }

  fun buildInvokeCommands(): List<String> =
    buildList {
      add(MazelClawCanvasCommand.Present.rawValue)
      add(MazelClawCanvasCommand.Hide.rawValue)
      add(MazelClawCanvasCommand.Navigate.rawValue)
      add(MazelClawCanvasCommand.Eval.rawValue)
      add(MazelClawCanvasCommand.Snapshot.rawValue)
      add(MazelClawCanvasA2UICommand.Push.rawValue)
      add(MazelClawCanvasA2UICommand.PushJSONL.rawValue)
      add(MazelClawCanvasA2UICommand.Reset.rawValue)
      add(MazelClawScreenCommand.Record.rawValue)
      if (cameraEnabled()) {
        add(MazelClawCameraCommand.Snap.rawValue)
        add(MazelClawCameraCommand.Clip.rawValue)
      }
      if (locationMode() != LocationMode.Off) {
        add(MazelClawLocationCommand.Get.rawValue)
      }
      if (smsAvailable()) {
        add(MazelClawSmsCommand.Send.rawValue)
      }
      if (BuildConfig.DEBUG) {
        add("debug.logs")
        add("debug.ed25519")
      }
      add("app.update")
    }

  fun buildCapabilities(): List<String> =
    buildList {
      add(MazelClawCapability.Canvas.rawValue)
      add(MazelClawCapability.Screen.rawValue)
      if (cameraEnabled()) add(MazelClawCapability.Camera.rawValue)
      if (smsAvailable()) add(MazelClawCapability.Sms.rawValue)
      if (voiceWakeMode() != VoiceWakeMode.Off && hasRecordAudioPermission()) {
        add(MazelClawCapability.VoiceWake.rawValue)
      }
      if (locationMode() != LocationMode.Off) {
        add(MazelClawCapability.Location.rawValue)
      }
    }

  fun resolvedVersionName(): String {
    val versionName = BuildConfig.VERSION_NAME.trim().ifEmpty { "dev" }
    return if (BuildConfig.DEBUG && !versionName.contains("dev", ignoreCase = true)) {
      "$versionName-dev"
    } else {
      versionName
    }
  }

  fun resolveModelIdentifier(): String? {
    return listOfNotNull(Build.MANUFACTURER, Build.MODEL)
      .joinToString(" ")
      .trim()
      .ifEmpty { null }
  }

  fun buildUserAgent(): String {
    val version = resolvedVersionName()
    val release = Build.VERSION.RELEASE?.trim().orEmpty()
    val releaseLabel = if (release.isEmpty()) "unknown" else release
    return "MazelClawAndroid/$version (Android $releaseLabel; SDK ${Build.VERSION.SDK_INT})"
  }

  fun buildClientInfo(clientId: String, clientMode: String): GatewayClientInfo {
    return GatewayClientInfo(
      id = clientId,
      displayName = prefs.displayName.value,
      version = resolvedVersionName(),
      platform = "android",
      mode = clientMode,
      instanceId = prefs.instanceId.value,
      deviceFamily = "Android",
      modelIdentifier = resolveModelIdentifier(),
    )
  }

  fun buildNodeConnectOptions(): GatewayConnectOptions {
    return GatewayConnectOptions(
      role = "node",
      scopes = emptyList(),
      caps = buildCapabilities(),
      commands = buildInvokeCommands(),
      permissions = emptyMap(),
      client = buildClientInfo(clientId = "mazelclaw-android", clientMode = "node"),
      userAgent = buildUserAgent(),
    )
  }

  fun buildOperatorConnectOptions(): GatewayConnectOptions {
    return GatewayConnectOptions(
      role = "operator",
      scopes = listOf("operator.read", "operator.write", "operator.talk.secrets"),
      caps = emptyList(),
      commands = emptyList(),
      permissions = emptyMap(),
      client = buildClientInfo(clientId = "mazelclaw-control-ui", clientMode = "ui"),
      userAgent = buildUserAgent(),
    )
  }

  fun resolveTlsParams(endpoint: GatewayEndpoint): GatewayTlsParams? {
    val stored = prefs.loadGatewayTlsFingerprint(endpoint.stableId)
    return resolveTlsParamsForEndpoint(endpoint, storedFingerprint = stored, manualTlsEnabled = manualTls())
  }
}
