import Foundation
import SwiftData

/// Versioned schema. New schema versions get their own enum + migration stage.
public enum SchemaV1: VersionedSchema {
    public static var versionIdentifier = Schema.Version(1, 0, 0)

    public static var models: [any PersistentModel.Type] {
        [SubmissionEntity.self]
    }
}

/// SwiftData-backed persistence record. Flat by design (JSON blob for version history)
/// to keep migrations simple. Never leaks past the Data layer.
@Model
public final class SubmissionEntity {
    @Attribute(.unique) public var id: UUID
    public var placeName: String
    public var categoryRaw: String
    public var keyFeatures: [String]
    public var eligibilityRaw: [String]
    public var locationHint: String
    public var accessNotes: String
    public var styleRaw: String

    public var generatedTitle: String
    public var generatedDescription: String
    public var generatedSupporting: String
    /// JSON-encoded `[GeneratedContent]` iteration history.
    public var versionsData: Data

    public var statusRaw: String
    public var createdAt: Date
    public var updatedAt: Date

    public init(
        id: UUID,
        placeName: String,
        categoryRaw: String,
        keyFeatures: [String],
        eligibilityRaw: [String],
        locationHint: String,
        accessNotes: String,
        styleRaw: String,
        generatedTitle: String,
        generatedDescription: String,
        generatedSupporting: String,
        versionsData: Data,
        statusRaw: String,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.placeName = placeName
        self.categoryRaw = categoryRaw
        self.keyFeatures = keyFeatures
        self.eligibilityRaw = eligibilityRaw
        self.locationHint = locationHint
        self.accessNotes = accessNotes
        self.styleRaw = styleRaw
        self.generatedTitle = generatedTitle
        self.generatedDescription = generatedDescription
        self.generatedSupporting = generatedSupporting
        self.versionsData = versionsData
        self.statusRaw = statusRaw
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
