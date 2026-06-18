import XCTest
@testable import WaypointWriter

final class TemplateContentGeneratorTests: XCTestCase {
    private let generator = TemplateContentGenerator()

    func testDeterministic_sameInputsProduceSameText() {
        let inputs = SubmissionInputs(
            placeName: "riverside mural",
            category: .publicArt,
            keyFeatures: ["hand-painted"],
            eligibility: [.historicCultural],
            style: .descriptive
        )
        let first = generator.generate(from: inputs)
        let second = generator.generate(from: inputs)
        // id/createdAt differ by design; the generated text must be identical.
        XCTAssertEqual(first.title, second.title)
        XCTAssertEqual(first.description, second.description)
        XCTAssertEqual(first.supportingStatement, second.supportingStatement)
    }

    func testTitle_isTitleCasedAndTrimmed() {
        let inputs = SubmissionInputs(placeName: "  riverside   community   mural ", category: .publicArt)
        let result = generator.generate(from: inputs)
        XCTAssertEqual(result.title, "Riverside Community Mural")
    }

    func testTitle_respectsMaxLength() {
        let long = String(repeating: "word ", count: 60)
        let inputs = SubmissionInputs(placeName: long, category: .other)
        let result = generator.generate(from: inputs)
        XCTAssertLessThanOrEqual(result.title.count, GenerationLimits.titleMax)
    }

    func testDescription_includesUpToTwoFeatures() {
        let inputs = SubmissionInputs(
            placeName: "oak fountain",
            category: .fountain,
            keyFeatures: ["1923 origin", "carved stone", "ignored third"],
            style: .concise
        )
        let result = generator.generate(from: inputs)
        XCTAssertTrue(result.description.lowercased().contains("1923 origin"))
        XCTAssertTrue(result.description.lowercased().contains("carved stone"))
        XCTAssertFalse(result.description.lowercased().contains("ignored third"))
    }

    func testSupporting_composesEligibilityInStableOrder() {
        let inputs = SubmissionInputs(
            placeName: "trail marker",
            category: .trailhead,
            eligibility: [.socialExploration, .historicCultural, .exercise],
            style: .formal
        )
        let result = generator.generate(from: inputs)
        // Stable ordering: historic → exercise → social.
        let text = result.supportingStatement
        let historic = text.range(of: "historic")
        let exercise = text.range(of: "physically active")
        XCTAssertNotNil(historic)
        XCTAssertNotNil(exercise)
        if let h = historic, let e = exercise {
            XCTAssertTrue(h.lowerBound < e.lowerBound)
        }
    }

    func testSupporting_includesLocationWhenProvided() {
        let inputs = SubmissionInputs(
            placeName: "bench",
            category: .park,
            eligibility: [.exercise],
            locationHint: "by the south gate"
        )
        let result = generator.generate(from: inputs)
        XCTAssertTrue(result.supportingStatement.lowercased().contains("south gate"))
    }

    func testEmptyName_producesEmptyTitle() {
        let result = generator.generate(from: SubmissionInputs(placeName: "   "))
        XCTAssertTrue(result.title.isEmpty)
    }
}

private extension GeneratedContent {
    /// Helper to compare ignoring the random id/date for determinism assertions.
    func withID(_ id: UUID) -> GeneratedContent {
        GeneratedContent(id: id, title: title, description: description,
                         supportingStatement: supportingStatement, origin: origin, createdAt: createdAt)
    }
}
