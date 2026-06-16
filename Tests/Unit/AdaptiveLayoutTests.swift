import XCTest
@testable import PokeStopBuddy

final class AdaptiveLayoutTests: XCTestCase {
    private func context(_ idiom: LayoutIdiom, _ h: LayoutSizeClass, _ v: LayoutSizeClass) -> LayoutContext {
        LayoutContext(idiom: idiom, horizontal: h, vertical: v)
    }

    // MARK: - Split navigation (iPad only)

    func testIPadRegular_usesSplitNavigation() {
        XCTAssertTrue(context(.pad, .regular, .regular).usesSplitNavigation)
    }

    func testIPadSlideOverCompact_doesNotSplit() {
        // iPad in a narrow multitasking slot reports compact width.
        XCTAssertFalse(context(.pad, .compact, .regular).usesSplitNavigation)
    }

    func testPhonePortrait_doesNotSplit() {
        XCTAssertFalse(context(.phone, .compact, .regular).usesSplitNavigation)
    }

    /// The classic trap: iPhone Pro Max in landscape has a *regular* horizontal size
    /// class but must NOT be treated as an iPad split view.
    func testProMaxLandscape_doesNotSplit() {
        XCTAssertFalse(context(.phone, .regular, .compact).usesSplitNavigation)
    }

    // MARK: - Editor wide layout (width-driven)

    func testIPad_usesWideEditor() {
        XCTAssertTrue(context(.pad, .regular, .regular).editorUsesWideLayout)
    }

    func testProMaxLandscape_usesWideEditor() {
        // Width is genuinely available here, so the two-column editor is appropriate.
        XCTAssertTrue(context(.phone, .regular, .compact).editorUsesWideLayout)
    }

    func testPhonePortrait_usesNarrowEditor() {
        XCTAssertFalse(context(.phone, .compact, .regular).editorUsesWideLayout)
    }

    // MARK: - Landscape detection

    func testLandscapeDetectedFromCompactVertical() {
        XCTAssertTrue(context(.phone, .regular, .compact).isLandscape)
        XCTAssertFalse(context(.phone, .compact, .regular).isLandscape)
    }

    // MARK: - Size-class bridging

    func testSizeClassBridging() {
        XCTAssertEqual(LayoutSizeClass(.regular), .regular)
        XCTAssertEqual(LayoutSizeClass(.compact), .compact)
        XCTAssertEqual(LayoutSizeClass(nil), .compact) // unknown defaults to compact
    }
}
