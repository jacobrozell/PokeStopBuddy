import Foundation

/// Scroll/focus targets in the submission editor for quality-coach navigation.
enum EditorScrollTarget: String, Hashable {
    case placeName
    case category
    case eligibility
    case locationHint
    case accessNotes
    case title
    case description
    case supporting

    /// Which wide-layout column contains this target.
    var usesGeneratedColumn: Bool {
        switch self {
        case .title, .description, .supporting: return true
        default: return false
        }
    }
}

extension QualityIssue.Field {
    var editorScrollTarget: EditorScrollTarget? {
        switch self {
        case .title: return .title
        case .description: return .description
        case .eligibility: return .eligibility
        case .supporting: return .supporting
        case .location: return .locationHint
        case .general: return .placeName
        }
    }
}
