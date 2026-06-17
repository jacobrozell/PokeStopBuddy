import XCTest
@testable import WaypointWriter

/// Contract tests for submission-guide accessibility semantics (no simulator).
final class GuideAccessibilityContractTests: XCTestCase {
    func testEveryCalloutKindHasNonColorName() {
        let kinds: [GuideCalloutKind] = [.tip, .do, .dont]
        for kind in kinds {
            let name = GuideAccessibility.calloutKindName(kind)
            XCTAssertFalse(name.isEmpty, "Callout kind \(kind) needs a spoken label beyond color.")
        }
    }

    func testHubCardLabelsIncludeTitleAndSummary() {
        for topic in GuideTopic.allCases {
            let label = GuideAccessibility.hubCardLabel(topic: topic)
            XCTAssertTrue(label.contains(L10n.string(topic.titleKey)))
            XCTAssertTrue(label.contains(L10n.string(topic.summaryKey)))
        }
    }

    func testCategoryRowLabelsMentionPillars() {
        guard let reference = GuideCategoryReference.all.first else {
            return XCTFail("Expected at least one category reference")
        }
        let collapsed = GuideAccessibility.categoryRowLabel(reference.category, isExpanded: false)
        XCTAssertTrue(collapsed.contains(reference.category.displayName))
        XCTAssertTrue(reference.pillars.allSatisfy { collapsed.contains($0.displayName) })
    }
}
