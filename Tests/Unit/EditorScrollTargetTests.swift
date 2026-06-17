import XCTest
@testable import WaypointWriter

final class EditorScrollTargetTests: XCTestCase {
    func testQualityFieldMapsToScrollTarget() {
        XCTAssertEqual(QualityIssue.Field.title.editorScrollTarget, .title)
        XCTAssertEqual(QualityIssue.Field.description.editorScrollTarget, .description)
        XCTAssertEqual(QualityIssue.Field.eligibility.editorScrollTarget, .eligibility)
        XCTAssertEqual(QualityIssue.Field.supporting.editorScrollTarget, .supporting)
        XCTAssertEqual(QualityIssue.Field.location.editorScrollTarget, .locationHint)
        XCTAssertEqual(QualityIssue.Field.general.editorScrollTarget, .placeName)
    }

    func testGeneratedColumnTargets() {
        XCTAssertTrue(EditorScrollTarget.title.usesGeneratedColumn)
        XCTAssertTrue(EditorScrollTarget.description.usesGeneratedColumn)
        XCTAssertTrue(EditorScrollTarget.supporting.usesGeneratedColumn)
        XCTAssertFalse(EditorScrollTarget.placeName.usesGeneratedColumn)
        XCTAssertFalse(EditorScrollTarget.eligibility.usesGeneratedColumn)
    }
}
