import Foundation

public enum MazelClawDeviceCommand: String, Codable, Sendable {
    case status = "device.status"
    case info = "device.info"
}

public enum MazelClawBatteryState: String, Codable, Sendable {
    case unknown
    case unplugged
    case charging
    case full
}

public enum MazelClawThermalState: String, Codable, Sendable {
    case nominal
    case fair
    case serious
    case critical
}

public enum MazelClawNetworkPathStatus: String, Codable, Sendable {
    case satisfied
    case unsatisfied
    case requiresConnection
}

public enum MazelClawNetworkInterfaceType: String, Codable, Sendable {
    case wifi
    case cellular
    case wired
    case other
}

public struct MazelClawBatteryStatusPayload: Codable, Sendable, Equatable {
    public var level: Double?
    public var state: MazelClawBatteryState
    public var lowPowerModeEnabled: Bool

    public init(level: Double?, state: MazelClawBatteryState, lowPowerModeEnabled: Bool) {
        self.level = level
        self.state = state
        self.lowPowerModeEnabled = lowPowerModeEnabled
    }
}

public struct MazelClawThermalStatusPayload: Codable, Sendable, Equatable {
    public var state: MazelClawThermalState

    public init(state: MazelClawThermalState) {
        self.state = state
    }
}

public struct MazelClawStorageStatusPayload: Codable, Sendable, Equatable {
    public var totalBytes: Int64
    public var freeBytes: Int64
    public var usedBytes: Int64

    public init(totalBytes: Int64, freeBytes: Int64, usedBytes: Int64) {
        self.totalBytes = totalBytes
        self.freeBytes = freeBytes
        self.usedBytes = usedBytes
    }
}

public struct MazelClawNetworkStatusPayload: Codable, Sendable, Equatable {
    public var status: MazelClawNetworkPathStatus
    public var isExpensive: Bool
    public var isConstrained: Bool
    public var interfaces: [MazelClawNetworkInterfaceType]

    public init(
        status: MazelClawNetworkPathStatus,
        isExpensive: Bool,
        isConstrained: Bool,
        interfaces: [MazelClawNetworkInterfaceType])
    {
        self.status = status
        self.isExpensive = isExpensive
        self.isConstrained = isConstrained
        self.interfaces = interfaces
    }
}

public struct MazelClawDeviceStatusPayload: Codable, Sendable, Equatable {
    public var battery: MazelClawBatteryStatusPayload
    public var thermal: MazelClawThermalStatusPayload
    public var storage: MazelClawStorageStatusPayload
    public var network: MazelClawNetworkStatusPayload
    public var uptimeSeconds: Double

    public init(
        battery: MazelClawBatteryStatusPayload,
        thermal: MazelClawThermalStatusPayload,
        storage: MazelClawStorageStatusPayload,
        network: MazelClawNetworkStatusPayload,
        uptimeSeconds: Double)
    {
        self.battery = battery
        self.thermal = thermal
        self.storage = storage
        self.network = network
        self.uptimeSeconds = uptimeSeconds
    }
}

public struct MazelClawDeviceInfoPayload: Codable, Sendable, Equatable {
    public var deviceName: String
    public var modelIdentifier: String
    public var systemName: String
    public var systemVersion: String
    public var appVersion: String
    public var appBuild: String
    public var locale: String

    public init(
        deviceName: String,
        modelIdentifier: String,
        systemName: String,
        systemVersion: String,
        appVersion: String,
        appBuild: String,
        locale: String)
    {
        self.deviceName = deviceName
        self.modelIdentifier = modelIdentifier
        self.systemName = systemName
        self.systemVersion = systemVersion
        self.appVersion = appVersion
        self.appBuild = appBuild
        self.locale = locale
    }
}
