import Foundation

/// In-memory repository for tests, SwiftUI previews, and the `-uitest-reset` launch path.
/// Main-actor isolated to match the `SubmissionRepository` contract.
@MainActor
public final class InMemorySubmissionRepository: SubmissionRepository {
    private var storage: [UUID: Submission] = [:]

    public init(seed: [Submission] = []) {
        for submission in seed { storage[submission.id] = submission }
    }

    public func all() throws -> [Submission] {
        storage.values.sorted { $0.updatedAt > $1.updatedAt }
    }

    public func submission(id: UUID) throws -> Submission? {
        storage[id]
    }

    public func save(_ submission: Submission) throws {
        storage[submission.id] = submission
    }

    public func delete(id: UUID) throws {
        storage[id] = nil
    }

    public func deleteAll() throws {
        storage.removeAll()
    }
}
