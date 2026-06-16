import Foundation

/// Maps between the persistence entity and the Domain `Submission`.
/// Kept in Data so Domain stays framework-free and Features never see entities.
enum SubmissionEntityMapping {
    static func makeEntity(from submission: Submission) -> SubmissionEntity {
        SubmissionEntity(
            id: submission.id,
            placeName: submission.inputs.placeName,
            categoryRaw: submission.inputs.category.rawValue,
            keyFeatures: submission.inputs.keyFeatures,
            eligibilityRaw: submission.inputs.eligibility.map(\.rawValue).sorted(),
            locationHint: submission.inputs.locationHint,
            accessNotes: submission.inputs.accessNotes,
            styleRaw: submission.inputs.style.rawValue,
            generatedTitle: submission.content.title,
            generatedDescription: submission.content.description,
            generatedSupporting: submission.content.supportingStatement,
            versionsData: encodeVersions(submission.versions),
            statusRaw: submission.status.rawValue,
            createdAt: submission.createdAt,
            updatedAt: submission.updatedAt
        )
    }

    static func apply(_ submission: Submission, to entity: SubmissionEntity) {
        entity.placeName = submission.inputs.placeName
        entity.categoryRaw = submission.inputs.category.rawValue
        entity.keyFeatures = submission.inputs.keyFeatures
        entity.eligibilityRaw = submission.inputs.eligibility.map(\.rawValue).sorted()
        entity.locationHint = submission.inputs.locationHint
        entity.accessNotes = submission.inputs.accessNotes
        entity.styleRaw = submission.inputs.style.rawValue
        entity.generatedTitle = submission.content.title
        entity.generatedDescription = submission.content.description
        entity.generatedSupporting = submission.content.supportingStatement
        entity.versionsData = encodeVersions(submission.versions)
        entity.statusRaw = submission.status.rawValue
        entity.updatedAt = submission.updatedAt
    }

    static func makeSubmission(from entity: SubmissionEntity) -> Submission {
        let inputs = SubmissionInputs(
            placeName: entity.placeName,
            category: WayspotCategory(rawValue: entity.categoryRaw) ?? .other,
            keyFeatures: entity.keyFeatures,
            eligibility: Set(entity.eligibilityRaw.compactMap(EligibilityCriterion.init(rawValue:))),
            locationHint: entity.locationHint,
            accessNotes: entity.accessNotes,
            style: GenerationStyle(rawValue: entity.styleRaw) ?? .descriptive
        )
        let content = GeneratedContent(
            title: entity.generatedTitle,
            description: entity.generatedDescription,
            supportingStatement: entity.generatedSupporting,
            origin: .generated
        )
        return Submission(
            id: entity.id,
            inputs: inputs,
            content: content,
            versions: decodeVersions(entity.versionsData),
            status: SubmissionStatus(rawValue: entity.statusRaw) ?? .draft,
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt
        )
    }

    // MARK: - Version blob

    private static func encodeVersions(_ versions: [GeneratedContent]) -> Data {
        (try? JSONEncoder().encode(versions)) ?? Data()
    }

    private static func decodeVersions(_ data: Data) -> [GeneratedContent] {
        guard !data.isEmpty else { return [] }
        return (try? JSONDecoder().decode([GeneratedContent].self, from: data)) ?? []
    }
}
