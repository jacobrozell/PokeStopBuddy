import XCTest
@testable import PokeStopBuddy

final class SubmissionQualityEvaluatorTests: XCTestCase {
    private let evaluator = SubmissionQualityEvaluator()

    private func makeSubmission(
        title: String = "Riverside Mural",
        description: String = "A distinctive hand-painted mural in the neighborhood.",
        supporting: String = "It holds local cultural significance. You can find it by the rec center.",
        eligibility: Set<EligibilityCriterion> = [.historicCultural],
        locationHint: String = "by the rec center"
    ) -> Submission {
        Submission(
            inputs: SubmissionInputs(
                placeName: title,
                category: .publicArt,
                eligibility: eligibility,
                locationHint: locationHint
            ),
            content: GeneratedContent(title: title, description: description, supportingStatement: supporting)
        )
    }

    func testStrongSubmission_isSubmittableWithHighScore() {
        let report = evaluator.evaluate(makeSubmission())
        XCTAssertTrue(report.isSubmittable)
        XCTAssertGreaterThanOrEqual(report.score, 80)
    }

    func testMissingTitle_isBlocker() {
        let report = evaluator.evaluate(makeSubmission(title: ""))
        XCTAssertFalse(report.isSubmittable)
        XCTAssertTrue(report.issues.contains { $0.field == .title && $0.severity == .blocker })
    }

    func testMissingEligibility_isBlocker() {
        let report = evaluator.evaluate(makeSubmission(eligibility: []))
        XCTAssertTrue(report.issues.contains { $0.field == .eligibility && $0.severity == .blocker })
    }

    func testGenericTitle_warns() {
        let report = evaluator.evaluate(makeSubmission(title: "Bench"))
        XCTAssertTrue(report.issues.contains { $0.field == .title && $0.severity == .warning })
    }

    func testSensitiveLocation_warns() {
        let report = evaluator.evaluate(makeSubmission(description: "Located at the local elementary school."))
        XCTAssertTrue(report.issues.contains { $0.field == .general && $0.severity == .warning })
    }

    func testMissingLocation_addsTip() {
        let report = evaluator.evaluate(makeSubmission(
            supporting: "It holds local cultural significance.",
            locationHint: ""
        ))
        XCTAssertTrue(report.issues.contains { $0.field == .location && $0.severity == .tip })
    }

    func testScoreClampedToZero() {
        let empty = Submission(inputs: SubmissionInputs(), content: .empty)
        let report = evaluator.evaluate(empty)
        XCTAssertGreaterThanOrEqual(report.score, 0)
    }

    func testIssuesSortedBySeverity() {
        let report = evaluator.evaluate(Submission(inputs: SubmissionInputs(), content: .empty))
        let severities = report.issues.map(\.severity)
        XCTAssertEqual(severities, severities.sorted())
    }
}
