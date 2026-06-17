import Foundation
import Observation

/// Drives the list of saved submissions. Reads what the editor writes.
@MainActor
@Observable
public final class SubmissionLibraryViewModel {
    public private(set) var submissions: [Submission] = []
    public private(set) var errorMessage: String?

    private let repository: any SubmissionRepository
    private let evaluator: any QualityEvaluating
    private var scoreCache: [UUID: Int] = [:]

    public init(repository: any SubmissionRepository, evaluator: any QualityEvaluating) {
        self.repository = repository
        self.evaluator = evaluator
    }

    public var isEmpty: Bool { submissions.isEmpty }

    public func load() {
        do {
            submissions = try repository.all()
            scoreCache.removeAll()
            errorMessage = nil
        } catch {
            errorMessage = L10n.string("error.load_failed")
            AppLog.data.error("Library load failed: \(String(describing: error))")
        }
    }

    public func clearError() {
        errorMessage = nil
    }

    /// Cached quality score for a row (avoids re-evaluating on every redraw).
    public func score(for submission: Submission) -> Int {
        if let cached = scoreCache[submission.id] { return cached }
        let value = evaluator.evaluate(submission).score
        scoreCache[submission.id] = value
        return value
    }

    public func delete(_ submission: Submission) {
        do {
            try repository.delete(id: submission.id)
            submissions.removeAll { $0.id == submission.id }
            scoreCache[submission.id] = nil
        } catch {
            errorMessage = L10n.string("error.delete_failed")
            AppLog.data.error("Delete failed: \(String(describing: error))")
        }
    }

    /// Case-insensitive filter across title, place name, category, and status.
    public func filteredSubmissions(matching query: String) -> [Submission] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return submissions }
        let needle = trimmed.lowercased()
        return submissions.filter { submission in
            submission.displayTitle.lowercased().contains(needle)
                || submission.inputs.placeName.lowercased().contains(needle)
                || submission.inputs.category.displayName.lowercased().contains(needle)
                || submission.status.displayName.lowercased().contains(needle)
        }
    }
}
