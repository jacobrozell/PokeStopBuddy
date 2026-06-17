import XCTest
@testable import WaypointWriter

/// Contract tests for core-journey accessibility semantics (no simulator).
final class CoreJourneyAccessibilityContractTests: XCTestCase {
    func testEveryQualityFieldMapsToScrollTarget() {
        for field in [
            QualityIssue.Field.title,
            .description,
            .eligibility,
            .supporting,
            .location,
            .general
        ] {
            XCTAssertNotNil(
                field.editorScrollTarget,
                "Quality field \(field) should scroll/focus a related editor control."
            )
        }
    }

    func testLibraryDeleteDialogKeysResolve() {
        XCTAssertFalse(L10n.string("library.delete.confirm").isEmpty)
        XCTAssertFalse(L10n.string("library.delete.action").isEmpty)
        XCTAssertFalse(L10n.string("library.delete.message", "Sample").isEmpty)
    }

    func testSearchAndSavedBannerKeysResolve() {
        XCTAssertFalse(L10n.string("library.search.prompt").isEmpty)
        XCTAssertFalse(L10n.string("library.search.empty").isEmpty)
        XCTAssertFalse(L10n.string("editor.savedBanner").isEmpty)
        XCTAssertFalse(L10n.string("quality.issue.focusHint").isEmpty)
    }

    func testGuideOpenAndDoneIdentifiersAreStable() {
        XCTAssertEqual(AccessibilityIDs.Guide.openButton, "guide.openButton")
        XCTAssertEqual(AccessibilityIDs.Guide.doneButton, "guide.doneButton")
    }
}
