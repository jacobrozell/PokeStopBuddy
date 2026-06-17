import Foundation

/// Stable topic identifiers for deep links, editor help, and UI tests.
public enum GuideTopic: String, CaseIterable, Identifiable, Sendable {
    case process
    case fields
    case categories
    case eligibility
    case photos
    case copyWorkflow

    public var id: String { rawValue }

    public var symbolName: String {
        switch self {
        case .process: return "list.number"
        case .fields: return "tablecells"
        case .categories: return "tag"
        case .eligibility: return "checkmark.seal"
        case .photos: return "camera"
        case .copyWorkflow: return "doc.on.doc"
        }
    }

    public var titleKey: String { "guide.topic.\(rawValue).title" }
    public var summaryKey: String { "guide.topic.\(rawValue).summary" }

    public var hubAccessibilityID: String { "guide.hub.\(rawValue)" }
    public var detailAccessibilityID: String { "guide.detail.\(rawValue)" }
}
