import Foundation

/// In-memory repository for tests, SwiftUI previews, and the `-uitest-reset` launch path.
public final class InMemorySubmissionRepository: SubmissionRepository, @unchecked Sendable {
    private var storage: [UUID: Submission] = [:]
    private let lock = NSLock()

    public init(seed: [Submission] = []) {
        for submission in seed { storage[submission.id] = submission }
    }

    public func all() throws -> [Submission] {
        lock.withLock {
            storage.values.sorted { $0.updatedAt > $1.updatedAt }
        }
    }

    public func submission(id: UUID) throws -> Submission? {
        lock.withLock { storage[id] }
    }

    public func save(_ submission: Submission) throws {
        lock.withLock { storage[submission.id] = submission }
    }

    public func delete(id: UUID) throws {
        lock.withLock {
            guard storage[id] != nil else { return }
            storage[id] = nil
        }
    }

    public func deleteAll() throws {
        lock.withLock { storage.removeAll() }
    }
}
