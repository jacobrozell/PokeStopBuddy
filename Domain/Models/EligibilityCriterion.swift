import Foundation

/// Wayfarer eligibility criteria. A nomination should satisfy at least one.
public enum EligibilityCriterion: String, CaseIterable, Codable, Sendable, Identifiable {
    /// Historic, cultural, or educational significance.
    case historicCultural
    /// A great place to be physically active.
    case exercise
    /// A great place to be social or to explore.
    case socialExploration

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .historicCultural: return "Historic / Cultural"
        case .exercise: return "Great for Exercise"
        case .socialExploration: return "Social / Exploration"
        }
    }

    /// Reviewer-facing rationale fragment used in the supporting statement.
    var rationaleFragment: String {
        switch self {
        case .historicCultural:
            return "holds local historic, cultural, or educational significance"
        case .exercise:
            return "encourages people to get outside and be physically active"
        case .socialExploration:
            return "is a welcoming spot to gather, socialize, and explore the area"
        }
    }
}
