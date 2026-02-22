import Foundation

public enum MazelClawLocationMode: String, Codable, Sendable, CaseIterable {
    case off
    case whileUsing
    case always
}
