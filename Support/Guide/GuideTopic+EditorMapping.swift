import Foundation

public extension GuideTopic {
    /// Topics opened from contextual (?) buttons in the submission editor.
    enum EditorAnchor: Sendable {
        case aboutSection
        case categoryPicker
        case keyFeatures
        case eligibility
        case locationHint
        case generatedSection
    }

    static func topic(for anchor: EditorAnchor) -> GuideTopic {
        switch anchor {
        case .aboutSection: return .fields
        case .categoryPicker: return .categories
        case .keyFeatures: return .fields
        case .eligibility: return .eligibility
        case .locationHint: return .photos
        case .generatedSection: return .copyWorkflow
        }
    }
}
