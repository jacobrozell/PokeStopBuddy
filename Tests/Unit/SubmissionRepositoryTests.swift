import XCTest
@testable import PokeStopBuddy

@MainActor
final class InMemorySubmissionRepositoryTests: XCTestCase {
    func testSaveAndFetch() throws {
        let repo = InMemorySubmissionRepository()
        let submission = Submission(inputs: SubmissionInputs(placeName: "test"))
        try repo.save(submission)
        XCTAssertEqual(try repo.submission(id: submission.id)?.inputs.placeName, "test")
    }

    func testSave_updatesExisting() throws {
        let repo = InMemorySubmissionRepository()
        var submission = Submission(inputs: SubmissionInputs(placeName: "old"))
        try repo.save(submission)
        submission.inputs.placeName = "new"
        try repo.save(submission)
        XCTAssertEqual(try repo.all().count, 1)
        XCTAssertEqual(try repo.submission(id: submission.id)?.inputs.placeName, "new")
    }

    func testAll_sortedByUpdatedAtDescending() throws {
        let repo = InMemorySubmissionRepository()
        let older = Submission(updatedAt: Date(timeIntervalSince1970: 100))
        let newer = Submission(updatedAt: Date(timeIntervalSince1970: 200))
        try repo.save(older)
        try repo.save(newer)
        XCTAssertEqual(try repo.all().first?.id, newer.id)
    }

    func testDelete() throws {
        let repo = InMemorySubmissionRepository()
        let submission = Submission()
        try repo.save(submission)
        try repo.delete(id: submission.id)
        XCTAssertNil(try repo.submission(id: submission.id))
    }

    func testDeleteAll() throws {
        let repo = InMemorySubmissionRepository(seed: SampleData.submissions())
        try repo.deleteAll()
        XCTAssertTrue(try repo.all().isEmpty)
    }
}
