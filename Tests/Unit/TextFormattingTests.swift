import XCTest
@testable import WaypointWriter

final class TextFormattingTests: XCTestCase {
    func testCollapsedSpaces() {
        XCTAssertEqual(TextFormatting.collapsedSpaces("  a   b \n c "), "a b c")
    }

    func testTitleCased_basic() {
        XCTAssertEqual(TextFormatting.titleCased("riverside community mural"),
                       "Riverside Community Mural")
    }

    func testTitleCased_preservesAcronyms() {
        XCTAssertEqual(TextFormatting.titleCased("WWII memorial"), "WWII Memorial")
    }

    func testSentenceCased() {
        XCTAssertEqual(TextFormatting.sentenceCased("by the gate"), "By the gate")
        XCTAssertEqual(TextFormatting.sentenceCased(""), "")
    }

    func testTruncate_noTruncationWhenWithinLimit() {
        XCTAssertEqual(TextFormatting.truncatedOnWordBoundary("short", max: 20), "short")
    }

    func testTruncate_breaksOnWordBoundaryWithEllipsis() {
        let result = TextFormatting.truncatedOnWordBoundary("one two three four", max: 10)
        XCTAssertLessThanOrEqual(result.count, 10)
        XCTAssertTrue(result.hasSuffix("…"))
        XCTAssertFalse(result.contains("thr")) // didn't cut mid-word into "three"
    }

    func testTruncate_singleLongWord() {
        let result = TextFormatting.truncatedOnWordBoundary("supercalifragilistic", max: 8)
        XCTAssertLessThanOrEqual(result.count, 8)
        XCTAssertTrue(result.hasSuffix("…"))
    }

    func testNaturalList() {
        XCTAssertEqual(TextFormatting.naturalList([]), "")
        XCTAssertEqual(TextFormatting.naturalList(["a"]), "a")
        XCTAssertEqual(TextFormatting.naturalList(["a", "b"]), "a and b")
        XCTAssertEqual(TextFormatting.naturalList(["a", "b", "c"]), "a, b, and c")
    }
}
