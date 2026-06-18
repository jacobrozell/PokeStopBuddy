import XCTest
@testable import WaypointWriter

@MainActor
final class AppPreferencesTests: XCTestCase {
    private let suiteName = "com.jacobrozell.waypointwriter.tests.preferences"
    private var defaults: UserDefaults!

    override func setUp() {
        super.setUp()
        defaults = UserDefaults(suiteName: suiteName)
        defaults.removePersistentDomain(forName: suiteName)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suiteName)
        defaults = nil
        super.tearDown()
    }

    func testDefaults_whenUnset() {
        let prefs = AppPreferences(defaults: defaults)
        XCTAssertEqual(prefs.appearance, .system)
        XCTAssertEqual(prefs.defaultStyle, .descriptive)
        XCTAssertEqual(prefs.defaultCategory, .publicArt)
    }

    func testValuesPersistAcrossInstances() {
        let prefs = AppPreferences(defaults: defaults)
        prefs.appearance = .dark
        prefs.defaultStyle = .formal
        prefs.defaultCategory = .trailhead

        let reloaded = AppPreferences(defaults: defaults)
        XCTAssertEqual(reloaded.appearance, .dark)
        XCTAssertEqual(reloaded.defaultStyle, .formal)
        XCTAssertEqual(reloaded.defaultCategory, .trailhead)
    }

    func testNewSubmissionInheritsPreferredDefaults() {
        let prefs = AppPreferences(defaults: defaults)
        prefs.defaultStyle = .concise
        prefs.defaultCategory = .monument

        let model = SubmissionEditorViewModel(
            existing: nil,
            repository: InMemorySubmissionRepository(),
            generator: TemplateContentGenerator(),
            evaluator: SubmissionQualityEvaluator(),
            defaultStyle: prefs.defaultStyle,
            defaultCategory: prefs.defaultCategory
        )
        XCTAssertEqual(model.inputs.style, .concise)
        XCTAssertEqual(model.inputs.category, .monument)
    }

    func testExistingSubmissionKeepsItsOwnValues() {
        let existing = Submission(inputs: SubmissionInputs(category: .library, style: .formal))
        let model = SubmissionEditorViewModel(
            existing: existing,
            repository: InMemorySubmissionRepository(),
            generator: TemplateContentGenerator(),
            evaluator: SubmissionQualityEvaluator(),
            defaultStyle: .concise,
            defaultCategory: .monument
        )
        XCTAssertEqual(model.inputs.style, .formal)
        XCTAssertEqual(model.inputs.category, .library)
    }
}
