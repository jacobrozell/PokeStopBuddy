import Foundation

/// Tone applied when generating content. Affects wording, never facts.
public enum GenerationStyle: String, CaseIterable, Codable, Sendable, Identifiable {
    case concise
    case descriptive
    case formal

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .concise: return "Concise"
        case .descriptive: return "Descriptive"
        case .formal: return "Formal"
        }
    }
}
