import XCTest
@testable import PokeStopBuddy

@MainActor
final class SubmissionLibraryViewModelTests: XCTestCase {
    private func makeModel(
        submissions: [Submission] = [],
        repository: InMemorySubmissionRepository = InMemorySubmissionRepository()
    ) -> SubmissionLibraryViewModel {
        for submission in submissions {
            try? repository.save(submission)
        }
        let model = SubmissionLibraryViewModel(
            repository: repository,
            evaluator: SubmissionQualityEvaluator()
        )
        model.load()
        return model
    }

    private func submission(
        placeName: String,
        category: WayspotCategory = .publicArt,
        title: String = "",
        status: SubmissionStatus = .draft
    ) -> Submission {
        var inputs = SubmissionInputs()
        inputs.placeName = placeName
        inputs.category = category
        var content = GeneratedContent.empty
        content.title = title
        return Submission(inputs: inputs, content: content, status: status)
    }

    func testFilteredSubmissions_emptyQueryReturnsAll() {
        let model = makeModel(submissions: [
            submission(placeName: "Alpha"),
            submission(placeName: "Beta")
        ])
        XCTAssertEqual(model.filteredSubmissions(matching: "").count, 2)
        XCTAssertEqual(model.filteredSubmissions(matching: "   ").count, 2)
    }

    func testFilteredSubmissions_matchesPlaceNameCategoryAndStatus() {
        let model = makeModel(submissions: [
            submission(placeName: "Town Fountain", category: .park, status: .draft),
            submission(placeName: "Mural Wall", category: .publicArt, title: "Riverside Mural", status: .readyToSubmit)
        ])

        XCTAssertEqual(model.filteredSubmissions(matching: "fountain").count, 1)
        XCTAssertEqual(model.filteredSubmissions(matching: "riverside").count, 1)
        XCTAssertEqual(model.filteredSubmissions(matching: "park").count, 1)
        XCTAssertEqual(model.filteredSubmissions(matching: "ready").count, 1)
        XCTAssertTrue(model.filteredSubmissions(matching: "nomatch").isEmpty)
    }
}
