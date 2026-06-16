import Foundation

/// Lifecycle of a submission draft within the app.
public enum SubmissionStatus: String, CaseIterable, Codable, Sendable, Identifiable {
    case draft
    case readyToSubmit
    case submitted
    case accepted
    case rejected
    case archived

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .draft: return "Draft"
        case .readyToSubmit: return "Ready to Submit"
        case .submitted: return "Submitted"
        case .accepted: return "Accepted"
        case .rejected: return "Rejected"
        case .archived: return "Archived"
        }
    }
}
