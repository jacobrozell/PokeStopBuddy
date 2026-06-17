import XCTest
@testable import PokeStopBuddy

/// Guards against code/strings drift: every key the UI references must exist in the
/// bundled `en` table. As more locales are added, this test also enforces key parity.
final class LocalizationParityTests: XCTestCase {
    /// Keys referenced from the UI. Keep in sync when adding `L10n.string(...)` calls.
    private let requiredKeys = [
        "common.done", "common.cancel", "common.ok",
        "library.title", "library.add",
        "library.empty.title", "library.empty.message",
        "library.detail.placeholder.title", "library.detail.placeholder.message",
        "editor.title", "editor.save", "editor.section.about", "editor.section.generated",
        "editor.placeName", "editor.category", "editor.style", "editor.keyFeatures",
        "editor.addFeature", "editor.removeFeature", "editor.eligibility",
        "editor.locationHint", "editor.accessNotes", "editor.generate",
        "editor.field.title", "editor.field.description", "editor.field.supporting",
        "editor.copyAll", "editor.share", "editor.versions", "editor.version.generated",
        "editor.version.edited", "editor.untitled",
        "quality.title", "quality.allClear", "quality.scoreValue",
        "quality.severity.blocker", "quality.severity.warning", "quality.severity.tip",
        "settings.title", "settings.section.appearance", "settings.appearance",
        "settings.section.defaults", "settings.defaultStyle", "settings.defaultCategory",
        "settings.section.about", "settings.section.legal", "settings.wayfarer",
        "settings.privacy", "settings.support", "settings.accessibility", "settings.tip",
        "settings.deleteAll", "settings.deleteAll.confirm",
        "error.load_failed", "error.save_failed", "error.delete_failed"
    ]

    private func table(for localization: String) throws -> [String: String] {
        let bundle = Bundle(for: SubmissionEditorViewModel.self)
        let url = try XCTUnwrap(
            bundle.url(forResource: "Localizable", withExtension: "strings",
                       subdirectory: nil, localization: localization),
            "Missing Localizable.strings for \(localization)"
        )
        return try XCTUnwrap(NSDictionary(contentsOf: url) as? [String: String])
    }

    func testEnglishTableHasAllRequiredKeys() throws {
        let en = try table(for: "en")
        let missing = requiredKeys.filter { en[$0] == nil }
        XCTAssertTrue(missing.isEmpty, "Missing en keys: \(missing)")
    }

    func testNoEmptyValues() throws {
        let en = try table(for: "en")
        let empty = en.filter { $0.value.trimmingCharacters(in: .whitespaces).isEmpty }.map(\.key)
        XCTAssertTrue(empty.isEmpty, "Empty values for: \(empty)")
    }
}
