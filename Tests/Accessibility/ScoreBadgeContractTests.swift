import XCTest
@testable import PokeStopBuddy

/// Contract tests for accessibility-relevant pure logic (no simulator needed).
/// Live AX-tree audits run in the UI suite via `performAccessibilityAudit`.
final class QualitySeverityContractTests: XCTestCase {
    func testEverySeverityHasNonColorIcon() {
        for severity in QualityIssue.Severity.allCases {
            XCTAssertFalse(severity.systemImage.isEmpty,
                           "Severity \(severity) must convey meaning with an icon, not color alone.")
        }
    }

    func testSeverityPenaltiesAreOrdered() {
        XCTAssertGreaterThan(QualityIssue.Severity.blocker.penalty, QualityIssue.Severity.warning.penalty)
        XCTAssertGreaterThan(QualityIssue.Severity.warning.penalty, QualityIssue.Severity.tip.penalty)
    }
}
