import Foundation

/// Deterministic, heuristic quality evaluator (v1.0). See specs/features/quality-coach.md.
public struct SubmissionQualityEvaluator: QualityEvaluating {
    /// Title words that are too generic to identify a real Wayspot on their own.
    static let genericTitleWords: Set<String> = [
        "sign", "pole", "bench", "tree", "rock", "fence", "gate", "post", "door"
    ]
    /// Keywords hinting at a potentially ineligible / sensitive location.
    static let sensitiveKeywords: [String] = [
        "school", "elementary", "kindergarten", "private residence",
        "my house", "my home", "apartment", "hospital"
    ]

    public init() {}

    public func evaluate(_ submission: Submission) -> QualityReport {
        var issues: [QualityIssue] = []
        issues += titleIssues(submission.content)
        issues += descriptionIssues(submission.content)
        issues += eligibilityIssues(submission.inputs)
        issues += supportingIssues(submission)
        if let keyword = sensitiveMatch(submission) {
            issues.append(.init(severity: .warning, field: .general,
                                message: sensitiveMessage(keyword)))
        }
        return QualityReport(score: score(for: issues), issues: sorted(issues))
    }

    // MARK: - Per-field checks

    private func titleIssues(_ content: GeneratedContent) -> [QualityIssue] {
        let title = content.title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else {
            return [.init(severity: .blocker, field: .title,
                          message: "Add a title — the real-world name of the place.")]
        }
        var issues: [QualityIssue] = []
        if title.count < 3 {
            issues.append(.init(severity: .warning, field: .title,
                                message: "Title looks very short; use the place's full name."))
        }
        if title.count > GenerationLimits.titleMax {
            issues.append(.init(severity: .warning, field: .title,
                                message: "Title exceeds \(GenerationLimits.titleMax) characters."))
        }
        if isGenericTitle(title) {
            issues.append(.init(severity: .warning, field: .title,
                                message: "Title is generic. Name the specific landmark, not just its type."))
        }
        return issues
    }

    private func descriptionIssues(_ content: GeneratedContent) -> [QualityIssue] {
        let description = content.description.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !description.isEmpty else {
            return [.init(severity: .blocker, field: .description,
                          message: "Add a description of what this place is.")]
        }
        var issues: [QualityIssue] = []
        if description.count < 20 {
            issues.append(.init(severity: .warning, field: .description,
                                message: "Description is thin; describe what makes it distinct."))
        }
        if description.count > GenerationLimits.descriptionMax {
            issues.append(.init(severity: .warning, field: .description,
                                message: "Description exceeds \(GenerationLimits.descriptionMax) characters."))
        }
        return issues
    }

    private func eligibilityIssues(_ inputs: SubmissionInputs) -> [QualityIssue] {
        guard inputs.eligibility.isEmpty else { return [] }
        return [.init(severity: .blocker, field: .eligibility,
                      message: "Select at least one eligibility criterion it meets.")]
    }

    private func supportingIssues(_ submission: Submission) -> [QualityIssue] {
        let supporting = submission.content.supportingStatement
            .trimmingCharacters(in: .whitespacesAndNewlines)
        if supporting.isEmpty {
            return [.init(severity: .warning, field: .supporting,
                          message: "Add a supporting statement explaining why it qualifies.")]
        }
        if !mentionsLocation(submission) {
            return [.init(severity: .tip, field: .location,
                          message: "Tip: tell the reviewer how to find it (a location or access note).")]
        }
        return []
    }

    // MARK: - Helpers

    private func sensitiveMessage(_ keyword: String) -> String {
        "Mentions \"\(keyword)\" — schools and private property are usually ineligible."
    }

    private func isGenericTitle(_ title: String) -> Bool {
        let words = title.lowercased().split(separator: " ").map(String.init)
        guard words.count <= 2 else { return false }
        return words.contains { Self.genericTitleWords.contains($0) }
    }

    private func mentionsLocation(_ submission: Submission) -> Bool {
        !submission.inputs.locationHint.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || !submission.inputs.accessNotes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func sensitiveMatch(_ submission: Submission) -> String? {
        let haystack = [
            submission.content.title,
            submission.content.description,
            submission.content.supportingStatement,
            submission.inputs.placeName,
            submission.inputs.locationHint,
            submission.inputs.accessNotes
        ].joined(separator: " ").lowercased()
        return Self.sensitiveKeywords.first { haystack.contains($0) }
    }

    private func score(for issues: [QualityIssue]) -> Int {
        let penalty = issues.reduce(0) { $0 + $1.severity.penalty }
        return max(0, min(100, 100 - penalty))
    }

    private func sorted(_ issues: [QualityIssue]) -> [QualityIssue] {
        issues.sorted { $0.severity < $1.severity }
    }
}
