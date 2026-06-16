import XCTest
@testable import PokeStopBuddy

@MainActor
final class SubmissionEditorViewModelTests: XCTestCase {
    private func makeModel(
        existing: Submission? = nil,
        repository: InMemorySubmissionRepository = InMemorySubmissionRepository()
    ) -> SubmissionEditorViewModel {
        SubmissionEditorViewModel(
            existing: existing,
            repository: repository,
            generator: TemplateContentGenerator(),
            evaluator: SubmissionQualityEvaluator(),
            now: { Date(timeIntervalSince1970: 0) }
        )
    }

    func testGenerate_populatesContentAndAppendsVersion() {
        let model = makeModel()
        model.inputs.placeName = "oak fountain"
        model.inputs.eligibility = [.historicCultural]
        model.generate()

        XCTAssertFalse(model.content.title.isEmpty)
        XCTAssertEqual(model.versions.count, 1)
    }

    func testGenerate_refreshesQuality() {
        let model = makeModel()
        let before = model.quality.score
        model.inputs.placeName = "riverside mural"
        model.inputs.eligibility = [.socialExploration]
        model.generate()
        XCTAssertGreaterThan(model.quality.score, before)
    }

    func testRevert_restoresPreviousVersion() {
        let model = makeModel()
        model.inputs.placeName = "first name"
        model.inputs.eligibility = [.exercise]
        model.generate()
        let firstVersion = model.versions[0]

        model.inputs.placeName = "second name"
        model.generate()
        XCTAssertNotEqual(model.content.title, firstVersion.title)

        model.revert(to: firstVersion)
        XCTAssertEqual(model.content.title, firstVersion.title)
    }

    func testSave_persistsAndSetsReadyWhenSubmittable() throws {
        let repo = InMemorySubmissionRepository()
        let model = makeModel(repository: repo)
        model.inputs.placeName = "riverside community mural"
        model.inputs.eligibility = [.historicCultural]
        model.inputs.locationHint = "by the rec center"
        model.generate()
        model.save()

        XCTAssertTrue(model.didSave)
        let stored = try repo.all()
        XCTAssertEqual(stored.count, 1)
    }

    func testClipboardText_containsAllFields() {
        let model = makeModel()
        model.inputs.placeName = "test place"
        model.inputs.eligibility = [.exercise]
        model.generate()
        let text = model.clipboardText
        XCTAssertTrue(text.contains("Title:"))
        XCTAssertTrue(text.contains("Description:"))
        XCTAssertTrue(text.contains("Supporting:"))
    }
}
