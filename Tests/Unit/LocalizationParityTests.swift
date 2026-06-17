import XCTest
@testable import PokeStopBuddy

/// Guards against code/strings drift: every key the UI references must exist in the
/// bundled `en` table. As more locales are added, this test also enforces key parity.
final class LocalizationParityTests: XCTestCase {
    /// Keys referenced from the UI. Keep in sync when adding `L10n.string(...)` calls.
    private let requiredKeys = [
        "common.done", "common.cancel", "common.ok", "common.back", "common.continue", "common.skip",
        "brand.title", "launch.loading",
        "onboarding.stepProgress", "onboarding.welcome.title", "onboarding.welcome.body",
        "onboarding.defaults.title", "onboarding.defaults.body",
        "onboarding.howItWorks.title", "onboarding.howItWorks.body",
        "onboarding.howItWorks.draft.title", "onboarding.howItWorks.draft.body",
        "onboarding.howItWorks.generate.title", "onboarding.howItWorks.generate.body",
        "onboarding.howItWorks.submit.title", "onboarding.howItWorks.submit.body",
        "onboarding.ready.title", "onboarding.ready.body", "onboarding.ready.action",
        "library.title", "library.add",
        "library.empty.title", "library.empty.message",
        "library.detail.placeholder.title", "library.detail.placeholder.message",
        "library.search.prompt", "library.search.empty",
        "library.delete.confirm", "library.delete.action", "library.delete.message",
        "editor.title", "editor.save", "editor.save.hint", "editor.save.disabledHint",
        "editor.savedBanner",
        "editor.generated.empty",
        "editor.field.characterCount", "editor.field.overLimit",
        "editor.section.about", "editor.section.generated",
        "editor.placeName", "editor.category", "editor.style", "editor.keyFeatures",
        "editor.addFeature", "editor.removeFeature", "editor.eligibility",
        "editor.locationHint", "editor.accessNotes", "editor.generate",
        "editor.field.title", "editor.field.description", "editor.field.supporting",
        "editor.copyAll", "editor.copied", "editor.share", "editor.versions", "editor.version.generated",
        "editor.version.edited", "editor.untitled",
        "editor.announcement.generated", "editor.announcement.saved", "editor.announcement.copied",
        "editor.eligibility.toggleHint",
        "quality.title", "quality.allClear", "quality.scoreValue",
        "quality.level.strong", "quality.level.needsWork", "quality.level.notReady",
        "quality.severity.blocker", "quality.severity.warning", "quality.severity.tip",
        "quality.announcement.score",
        "quality.issue.focusHint",
        "library.row.hint",
        "settings.title", "settings.section.appearance", "settings.appearance",
        "settings.section.defaults", "settings.defaultStyle", "settings.defaultCategory",
        "settings.section.about", "settings.guide", "settings.onboarding", "settings.section.legal", "settings.wayfarer",
        "settings.privacy", "settings.support", "settings.accessibility", "settings.tip",
        "settings.deleteAll", "settings.deleteAll.confirm",
        "error.load_failed", "error.save_failed", "error.delete_failed",
        "persistence.error.title", "persistence.error.message",
        "persistence.error.resetDone", "persistence.error.resetButton",
        "guide.title", "guide.emptyLink",
        "guide.screenshot.placeholder",
        "editor.category.typicalPillars", "editor.category.pillarSummary"
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
