import Foundation

/// A single actionable finding about a submission.
public struct QualityIssue: Equatable, Sendable, Identifiable {
    public enum Severity: String, Sendable, CaseIterable, Comparable {
        case blocker
        case warning
        case tip

        public var penalty: Int {
            switch self {
            case .blocker: return 35
            case .warning: return 12
            case .tip: return 4
            }
        }

        /// SF Symbol used so severity is conveyed by icon + text, never color alone.
        public var systemImage: String {
            switch self {
            case .blocker: return "exclamationmark.octagon.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .tip: return "lightbulb.fill"
            }
        }

        private var sortRank: Int {
            switch self {
            case .blocker: return 0
            case .warning: return 1
            case .tip: return 2
            }
        }

        public static func < (lhs: Severity, rhs: Severity) -> Bool {
            lhs.sortRank < rhs.sortRank
        }
    }

    /// Which field the issue concerns (used for focus + grouping).
    public enum Field: String, Sendable {
        case title
        case description
        case eligibility
        case supporting
        case location
        case general
    }

    public let id: UUID
    public let severity: Severity
    public let field: Field
    public let message: String

    public init(id: UUID = UUID(), severity: Severity, field: Field, message: String) {
        self.id = id
        self.severity = severity
        self.field = field
        self.message = message
    }
}

/// Result of evaluating a submission against quality heuristics.
public struct QualityReport: Equatable, Sendable {
    public let score: Int
    public let issues: [QualityIssue]

    public init(score: Int, issues: [QualityIssue]) {
        self.score = score
        self.issues = issues
    }

    /// True when there are no blocker-level issues.
    public var isSubmittable: Bool {
        !issues.contains { $0.severity == .blocker }
    }

    public static let perfect = QualityReport(score: 100, issues: [])
}
