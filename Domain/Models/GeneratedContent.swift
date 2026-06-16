import Foundation

/// One generated (or hand-edited) draft of submission text. Stored in version history
/// so users can compare and revert while fine-tuning.
public struct GeneratedContent: Codable, Equatable, Sendable, Identifiable {
    public let id: UUID
    public var title: String
    public var description: String
    public var supportingStatement: String
    /// How this version was produced — useful in the history UI.
    public var origin: Origin
    public var createdAt: Date

    public enum Origin: String, Codable, Sendable {
        case generated
        case manualEdit
    }

    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        supportingStatement: String,
        origin: Origin = .generated,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.supportingStatement = supportingStatement
        self.origin = origin
        self.createdAt = createdAt
    }

    public static let empty = GeneratedContent(
        title: "",
        description: "",
        supportingStatement: "",
        origin: .manualEdit
    )
}
