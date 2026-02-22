import Foundation

public enum MazelClawCameraCommand: String, Codable, Sendable {
    case list = "camera.list"
    case snap = "camera.snap"
    case clip = "camera.clip"
}

public enum MazelClawCameraFacing: String, Codable, Sendable {
    case back
    case front
}

public enum MazelClawCameraImageFormat: String, Codable, Sendable {
    case jpg
    case jpeg
}

public enum MazelClawCameraVideoFormat: String, Codable, Sendable {
    case mp4
}

public struct MazelClawCameraSnapParams: Codable, Sendable, Equatable {
    public var facing: MazelClawCameraFacing?
    public var maxWidth: Int?
    public var quality: Double?
    public var format: MazelClawCameraImageFormat?
    public var deviceId: String?
    public var delayMs: Int?

    public init(
        facing: MazelClawCameraFacing? = nil,
        maxWidth: Int? = nil,
        quality: Double? = nil,
        format: MazelClawCameraImageFormat? = nil,
        deviceId: String? = nil,
        delayMs: Int? = nil)
    {
        self.facing = facing
        self.maxWidth = maxWidth
        self.quality = quality
        self.format = format
        self.deviceId = deviceId
        self.delayMs = delayMs
    }
}

public struct MazelClawCameraClipParams: Codable, Sendable, Equatable {
    public var facing: MazelClawCameraFacing?
    public var durationMs: Int?
    public var includeAudio: Bool?
    public var format: MazelClawCameraVideoFormat?
    public var deviceId: String?

    public init(
        facing: MazelClawCameraFacing? = nil,
        durationMs: Int? = nil,
        includeAudio: Bool? = nil,
        format: MazelClawCameraVideoFormat? = nil,
        deviceId: String? = nil)
    {
        self.facing = facing
        self.durationMs = durationMs
        self.includeAudio = includeAudio
        self.format = format
        self.deviceId = deviceId
    }
}
