import Foundation

/// A candidate PokeStop / Wayspot the user is drafting content for.
public struct Submission: Identifiable, Equatable, Sendable {
    public let id: UUID
    public var inputs: SubmissionInputs
    /// The current working content (latest generation or manual edit).
    public var content: GeneratedContent
    /// Iteration history, oldest first. The last entry usually equals `content`.
    public var versions: [GeneratedContent]
    public var status: SubmissionStatus
    public let createdAt: Date
    public var updatedAt: Date

    public init(
        id: UUID = UUID(),
        inputs: SubmissionInputs = SubmissionInputs(),
        content: GeneratedContent = .empty,
        versions: [GeneratedContent] = [],
        status: SubmissionStatus = .draft,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.inputs = inputs
        self.content = content
        self.versions = versions
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    /// Display title prefers generated content, falling back to the raw place name.
    public var displayTitle: String {
        let trimmed = content.title.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty { return trimmed }
        let name = inputs.placeName.trimmingCharacters(in: .whitespacesAndNewlines)
        return name.isEmpty ? "Untitled submission" : name
    }
}
