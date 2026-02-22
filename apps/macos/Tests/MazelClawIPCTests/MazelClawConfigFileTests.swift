import Foundation
import Testing
@testable import MazelClaw

@Suite(.serialized)
struct MazelClawConfigFileTests {
    @Test
    func configPathRespectsEnvOverride() async {
        let override = FileManager().temporaryDirectory
            .appendingPathComponent("mazelclaw-config-\(UUID().uuidString)")
            .appendingPathComponent("mazelclaw.json")
            .path

        await TestIsolation.withEnvValues(["MAZELCLAW_CONFIG_PATH": override]) {
            #expect(MazelClawConfigFile.url().path == override)
        }
    }

    @MainActor
    @Test
    func remoteGatewayPortParsesAndMatchesHost() async {
        let override = FileManager().temporaryDirectory
            .appendingPathComponent("mazelclaw-config-\(UUID().uuidString)")
            .appendingPathComponent("mazelclaw.json")
            .path

        await TestIsolation.withEnvValues(["MAZELCLAW_CONFIG_PATH": override]) {
            MazelClawConfigFile.saveDict([
                "gateway": [
                    "remote": [
                        "url": "ws://gateway.ts.net:19999",
                    ],
                ],
            ])
            #expect(MazelClawConfigFile.remoteGatewayPort() == 19999)
            #expect(MazelClawConfigFile.remoteGatewayPort(matchingHost: "gateway.ts.net") == 19999)
            #expect(MazelClawConfigFile.remoteGatewayPort(matchingHost: "gateway") == 19999)
            #expect(MazelClawConfigFile.remoteGatewayPort(matchingHost: "other.ts.net") == nil)
        }
    }

    @MainActor
    @Test
    func setRemoteGatewayUrlPreservesScheme() async {
        let override = FileManager().temporaryDirectory
            .appendingPathComponent("mazelclaw-config-\(UUID().uuidString)")
            .appendingPathComponent("mazelclaw.json")
            .path

        await TestIsolation.withEnvValues(["MAZELCLAW_CONFIG_PATH": override]) {
            MazelClawConfigFile.saveDict([
                "gateway": [
                    "remote": [
                        "url": "wss://old-host:111",
                    ],
                ],
            ])
            MazelClawConfigFile.setRemoteGatewayUrl(host: "new-host", port: 2222)
            let root = MazelClawConfigFile.loadDict()
            let url = ((root["gateway"] as? [String: Any])?["remote"] as? [String: Any])?["url"] as? String
            #expect(url == "wss://new-host:2222")
        }
    }

    @MainActor
    @Test
    func clearRemoteGatewayUrlRemovesOnlyUrlField() async {
        let override = FileManager().temporaryDirectory
            .appendingPathComponent("mazelclaw-config-\(UUID().uuidString)")
            .appendingPathComponent("mazelclaw.json")
            .path

        await TestIsolation.withEnvValues(["MAZELCLAW_CONFIG_PATH": override]) {
            MazelClawConfigFile.saveDict([
                "gateway": [
                    "remote": [
                        "url": "wss://old-host:111",
                        "token": "tok",
                    ],
                ],
            ])
            MazelClawConfigFile.clearRemoteGatewayUrl()
            let root = MazelClawConfigFile.loadDict()
            let remote = ((root["gateway"] as? [String: Any])?["remote"] as? [String: Any]) ?? [:]
            #expect((remote["url"] as? String) == nil)
            #expect((remote["token"] as? String) == "tok")
        }
    }

    @Test
    func stateDirOverrideSetsConfigPath() async {
        let dir = FileManager().temporaryDirectory
            .appendingPathComponent("mazelclaw-state-\(UUID().uuidString)", isDirectory: true)
            .path

        await TestIsolation.withEnvValues([
            "MAZELCLAW_CONFIG_PATH": nil,
            "MAZELCLAW_STATE_DIR": dir,
        ]) {
            #expect(MazelClawConfigFile.stateDirURL().path == dir)
            #expect(MazelClawConfigFile.url().path == "\(dir)/mazelclaw.json")
        }
    }

    @MainActor
    @Test
    func saveDictAppendsConfigAuditLog() async throws {
        let stateDir = FileManager().temporaryDirectory
            .appendingPathComponent("mazelclaw-state-\(UUID().uuidString)", isDirectory: true)
        let configPath = stateDir.appendingPathComponent("mazelclaw.json")
        let auditPath = stateDir.appendingPathComponent("logs/config-audit.jsonl")

        defer { try? FileManager().removeItem(at: stateDir) }

        try await TestIsolation.withEnvValues([
            "MAZELCLAW_STATE_DIR": stateDir.path,
            "MAZELCLAW_CONFIG_PATH": configPath.path,
        ]) {
            MazelClawConfigFile.saveDict([
                "gateway": ["mode": "local"],
            ])

            let configData = try Data(contentsOf: configPath)
            let configRoot = try JSONSerialization.jsonObject(with: configData) as? [String: Any]
            #expect((configRoot?["meta"] as? [String: Any]) != nil)

            let rawAudit = try String(contentsOf: auditPath, encoding: .utf8)
            let lines = rawAudit
                .split(whereSeparator: \.isNewline)
                .map(String.init)
            #expect(!lines.isEmpty)
            guard let last = lines.last else {
                Issue.record("Missing config audit line")
                return
            }
            let auditRoot = try JSONSerialization.jsonObject(with: Data(last.utf8)) as? [String: Any]
            #expect(auditRoot?["source"] as? String == "macos-mazelclaw-config-file")
            #expect(auditRoot?["event"] as? String == "config.write")
            #expect(auditRoot?["result"] as? String == "success")
            #expect(auditRoot?["configPath"] as? String == configPath.path)
        }
    }
}
