import Foundation

/// Typed errors surfaced at the data boundary. ViewModels map these to localized text.
public enum RepositoryError: Error, Equatable {
    case notFound
    case persistenceFailed(String)
}

/// Storage contract for submissions. Features depend on `any SubmissionRepository`,
/// never on a concrete persistence type.
public protocol SubmissionRepository: Sendable {
    func all() throws -> [Submission]
    func submission(id: UUID) throws -> Submission?
    /// Insert or update.
    func save(_ submission: Submission) throws
    func delete(id: UUID) throws
    func deleteAll() throws
}
