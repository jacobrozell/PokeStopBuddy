import Foundation
import SwiftData

/// SwiftData-backed repository. Uses the container's main context, so instances must be
/// used from the main actor (ViewModels driving SwiftUI satisfy this).
@MainActor
public final class SwiftDataSubmissionRepository: SubmissionRepository {
    private let context: ModelContext

    public init(container: ModelContainer) {
        self.context = container.mainContext
    }

    public func all() throws -> [Submission] {
        let descriptor = FetchDescriptor<SubmissionEntity>(
            sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
        )
        return try context.fetch(descriptor).map(SubmissionEntityMapping.makeSubmission)
    }

    public func submission(id: UUID) throws -> Submission? {
        try fetchEntity(id: id).map(SubmissionEntityMapping.makeSubmission)
    }

    public func save(_ submission: Submission) throws {
        do {
            if let existing = try fetchEntity(id: submission.id) {
                SubmissionEntityMapping.apply(submission, to: existing)
            } else {
                context.insert(SubmissionEntityMapping.makeEntity(from: submission))
            }
            try context.save()
        } catch {
            throw RepositoryError.persistenceFailed(error.localizedDescription)
        }
    }

    public func delete(id: UUID) throws {
        do {
            guard let entity = try fetchEntity(id: id) else { return }
            context.delete(entity)
            try context.save()
        } catch {
            throw RepositoryError.persistenceFailed(error.localizedDescription)
        }
    }

    public func deleteAll() throws {
        do {
            try context.delete(model: SubmissionEntity.self)
            try context.save()
        } catch {
            throw RepositoryError.persistenceFailed(error.localizedDescription)
        }
    }

    // MARK: - Helpers

    private func fetchEntity(id: UUID) throws -> SubmissionEntity? {
        let descriptor = FetchDescriptor<SubmissionEntity>(
            predicate: #Predicate { $0.id == id }
        )
        return try context.fetch(descriptor).first
    }
}

// SwiftDataSubmissionRepository is @MainActor-isolated; conformance to the Sendable
// `SubmissionRepository` is satisfied by that isolation.
extension SwiftDataSubmissionRepository: @unchecked Sendable {}
