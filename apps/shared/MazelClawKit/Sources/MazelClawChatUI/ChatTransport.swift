import Foundation

public enum MazelClawChatTransportEvent: Sendable {
    case health(ok: Bool)
    case tick
    case chat(MazelClawChatEventPayload)
    case agent(MazelClawAgentEventPayload)
    case seqGap
}

public protocol MazelClawChatTransport: Sendable {
    func requestHistory(sessionKey: String) async throws -> MazelClawChatHistoryPayload
    func sendMessage(
        sessionKey: String,
        message: String,
        thinking: String,
        idempotencyKey: String,
        attachments: [MazelClawChatAttachmentPayload]) async throws -> MazelClawChatSendResponse

    func abortRun(sessionKey: String, runId: String) async throws
    func listSessions(limit: Int?) async throws -> MazelClawChatSessionsListResponse

    func requestHealth(timeoutMs: Int) async throws -> Bool
    func events() -> AsyncStream<MazelClawChatTransportEvent>

    func setActiveSessionKey(_ sessionKey: String) async throws
}

extension MazelClawChatTransport {
    public func setActiveSessionKey(_: String) async throws {}

    public func abortRun(sessionKey _: String, runId _: String) async throws {
        throw NSError(
            domain: "MazelClawChatTransport",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "chat.abort not supported by this transport"])
    }

    public func listSessions(limit _: Int?) async throws -> MazelClawChatSessionsListResponse {
        throw NSError(
            domain: "MazelClawChatTransport",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "sessions.list not supported by this transport"])
    }
}
