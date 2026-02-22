package ai.mazelclaw.android.protocol

import org.junit.Assert.assertEquals
import org.junit.Test

class MazelClawProtocolConstantsTest {
  @Test
  fun canvasCommandsUseStableStrings() {
    assertEquals("canvas.present", MazelClawCanvasCommand.Present.rawValue)
    assertEquals("canvas.hide", MazelClawCanvasCommand.Hide.rawValue)
    assertEquals("canvas.navigate", MazelClawCanvasCommand.Navigate.rawValue)
    assertEquals("canvas.eval", MazelClawCanvasCommand.Eval.rawValue)
    assertEquals("canvas.snapshot", MazelClawCanvasCommand.Snapshot.rawValue)
  }

  @Test
  fun a2uiCommandsUseStableStrings() {
    assertEquals("canvas.a2ui.push", MazelClawCanvasA2UICommand.Push.rawValue)
    assertEquals("canvas.a2ui.pushJSONL", MazelClawCanvasA2UICommand.PushJSONL.rawValue)
    assertEquals("canvas.a2ui.reset", MazelClawCanvasA2UICommand.Reset.rawValue)
  }

  @Test
  fun capabilitiesUseStableStrings() {
    assertEquals("canvas", MazelClawCapability.Canvas.rawValue)
    assertEquals("camera", MazelClawCapability.Camera.rawValue)
    assertEquals("screen", MazelClawCapability.Screen.rawValue)
    assertEquals("voiceWake", MazelClawCapability.VoiceWake.rawValue)
  }

  @Test
  fun screenCommandsUseStableStrings() {
    assertEquals("screen.record", MazelClawScreenCommand.Record.rawValue)
  }
}
