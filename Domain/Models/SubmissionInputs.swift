import Foundation

/// Structured user inputs that drive content generation.
public struct SubmissionInputs: Codable, Equatable, Sendable {
    public var placeName: String
    public var category: WayspotCategory
    public var keyFeatures: [String]
    public var eligibility: Set<EligibilityCriterion>
    public var locationHint: String
    public var accessNotes: String
    public var style: GenerationStyle

    public init(
        placeName: String = "",
        category: WayspotCategory = .publicArt,
        keyFeatures: [String] = [],
        eligibility: Set<EligibilityCriterion> = [],
        locationHint: String = "",
        accessNotes: String = "",
        style: GenerationStyle = .descriptive
    ) {
        self.placeName = placeName
        self.category = category
        self.keyFeatures = keyFeatures
        self.eligibility = eligibility
        self.locationHint = locationHint
        self.accessNotes = accessNotes
        self.style = style
    }

    /// Feature bullets with whitespace trimmed and empties removed.
    var cleanedFeatures: [String] {
        keyFeatures
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
}
