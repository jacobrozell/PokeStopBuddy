import Foundation

/// Scores a submission and lists actionable issues so the user can fine-tune.
public protocol QualityEvaluating: Sendable {
    func evaluate(_ submission: Submission) -> QualityReport
}
