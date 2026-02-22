import CoreLocation
import Foundation
import MazelClawKit
import UIKit

protocol CameraServicing: Sendable {
    func listDevices() async -> [CameraController.CameraDeviceInfo]
    func snap(params: MazelClawCameraSnapParams) async throws -> (format: String, base64: String, width: Int, height: Int)
    func clip(params: MazelClawCameraClipParams) async throws -> (format: String, base64: String, durationMs: Int, hasAudio: Bool)
}

protocol ScreenRecordingServicing: Sendable {
    func record(
        screenIndex: Int?,
        durationMs: Int?,
        fps: Double?,
        includeAudio: Bool?,
        outPath: String?) async throws -> String
}

@MainActor
protocol LocationServicing: Sendable {
    func authorizationStatus() -> CLAuthorizationStatus
    func accuracyAuthorization() -> CLAccuracyAuthorization
    func ensureAuthorization(mode: MazelClawLocationMode) async -> CLAuthorizationStatus
    func currentLocation(
        params: MazelClawLocationGetParams,
        desiredAccuracy: MazelClawLocationAccuracy,
        maxAgeMs: Int?,
        timeoutMs: Int?) async throws -> CLLocation
    func startLocationUpdates(
        desiredAccuracy: MazelClawLocationAccuracy,
        significantChangesOnly: Bool) -> AsyncStream<CLLocation>
    func stopLocationUpdates()
    func startMonitoringSignificantLocationChanges(onUpdate: @escaping @Sendable (CLLocation) -> Void)
    func stopMonitoringSignificantLocationChanges()
}

protocol DeviceStatusServicing: Sendable {
    func status() async throws -> MazelClawDeviceStatusPayload
    func info() -> MazelClawDeviceInfoPayload
}

protocol PhotosServicing: Sendable {
    func latest(params: MazelClawPhotosLatestParams) async throws -> MazelClawPhotosLatestPayload
}

protocol ContactsServicing: Sendable {
    func search(params: MazelClawContactsSearchParams) async throws -> MazelClawContactsSearchPayload
    func add(params: MazelClawContactsAddParams) async throws -> MazelClawContactsAddPayload
}

protocol CalendarServicing: Sendable {
    func events(params: MazelClawCalendarEventsParams) async throws -> MazelClawCalendarEventsPayload
    func add(params: MazelClawCalendarAddParams) async throws -> MazelClawCalendarAddPayload
}

protocol RemindersServicing: Sendable {
    func list(params: MazelClawRemindersListParams) async throws -> MazelClawRemindersListPayload
    func add(params: MazelClawRemindersAddParams) async throws -> MazelClawRemindersAddPayload
}

protocol MotionServicing: Sendable {
    func activities(params: MazelClawMotionActivityParams) async throws -> MazelClawMotionActivityPayload
    func pedometer(params: MazelClawPedometerParams) async throws -> MazelClawPedometerPayload
}

struct WatchMessagingStatus: Sendable, Equatable {
    var supported: Bool
    var paired: Bool
    var appInstalled: Bool
    var reachable: Bool
    var activationState: String
}

struct WatchQuickReplyEvent: Sendable, Equatable {
    var replyId: String
    var promptId: String
    var actionId: String
    var actionLabel: String?
    var sessionKey: String?
    var note: String?
    var sentAtMs: Int?
    var transport: String
}

struct WatchNotificationSendResult: Sendable, Equatable {
    var deliveredImmediately: Bool
    var queuedForDelivery: Bool
    var transport: String
}

protocol WatchMessagingServicing: AnyObject, Sendable {
    func status() async -> WatchMessagingStatus
    func setReplyHandler(_ handler: (@Sendable (WatchQuickReplyEvent) -> Void)?)
    func sendNotification(
        id: String,
        params: MazelClawWatchNotifyParams) async throws -> WatchNotificationSendResult
}

extension CameraController: CameraServicing {}
extension ScreenRecordService: ScreenRecordingServicing {}
extension LocationService: LocationServicing {}
