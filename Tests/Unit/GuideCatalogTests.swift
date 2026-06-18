import XCTest
@testable import WaypointWriter

final class GuideCatalogTests: XCTestCase {
    func testEveryTopicHasArticle() {
        for topic in GuideTopic.allCases {
            let article = GuideCatalog.article(for: topic)
            XCTAssertEqual(article.topic, topic)
            XCTAssertFalse(article.sections.isEmpty, "Missing sections for \(topic)")
        }
    }

    func testArticlesCountMatchesTopics() {
        XCTAssertEqual(GuideCatalog.articles.count, GuideTopic.allCases.count)
    }

    func testCategoryReferenceCoversAllCategories() {
        let referenced = Set(GuideCategoryReference.all.map(\.category))
        let expected = Set(WayspotCategory.allCases)
        XCTAssertEqual(referenced, expected)
    }

    func testLocalizedTitlesResolve() {
        for topic in GuideTopic.allCases {
            let title = L10n.string(topic.titleKey)
            XCTAssertFalse(title.isEmpty)
            XCTAssertNotEqual(title, topic.titleKey)
        }
    }

    func testEditorAnchorMapping() {
        XCTAssertEqual(GuideTopic.topic(for: .categoryPicker), .categories)
        XCTAssertEqual(GuideTopic.topic(for: .eligibility), .eligibility)
        XCTAssertEqual(GuideTopic.topic(for: .generatedSection), .copyWorkflow)
    }

    func testAllContentKeysExistInEnglish() throws {
        var keys: [String] = [
            "guide.title", "guide.emptyLink", "guide.wayfarerLink", "guide.app.title",
            "guide.related.title", "guide.screenshot.placeholder", "guide.infoButton.label",
            "guide.schematic.appMenu", "guide.schematic.settings", "guide.schematic.uploads",
            "guide.schematic.newPokestop", "guide.schematic.pinOnObject", "guide.schematic.mainPhoto",
            "guide.schematic.supportingPhoto", "guide.schematic.titleField", "guide.schematic.descriptionField",
            "guide.schematic.sampleTitle", "guide.schematic.sampleDescription", "guide.schematic.tag.library",
            "guide.schematic.tag.publicArt", "guide.schematic.tag.park", "guide.schematic.tag.other",
            "guide.schematic.previewTitle", "guide.schematic.supportingHeading", "guide.schematic.eligibilityPillar",
            "guide.schematic.additionalInfo", "guide.schematic.sampleSupporting", "guide.schematic.uploadNow",
            "guide.schematic.uploadLater", "guide.schematic.generic",
            "guide.infoButton.hint", "guide.hub.card.label", "guide.hub.card.hint",
            "guide.wayfarerLink.hint", "guide.callout.kind.tip", "guide.callout.kind.do",
            "guide.callout.kind.dont", "guide.callout.summary", "guide.categories.row.hint",
            "guide.categories.row.collapsed", "guide.categories.row.expanded",
            "editor.category.typicalPillars", "editor.category.pillarSummary"
        ]

        for topic in GuideTopic.allCases {
            keys.append(topic.titleKey)
            keys.append(topic.summaryKey)
            let article = GuideCatalog.article(for: topic)
            keys.append(article.introKey)
            if let buddy = article.appCalloutKey { keys.append(buddy) }
            for section in article.sections {
                keys.append(section.headingKey)
                if let body = section.bodyKey { keys.append(body) }
                keys.append(contentsOf: section.bulletKeys)
                if let callout = section.callout {
                    keys.append(callout.titleKey)
                    keys.append(callout.bodyKey)
                }
            }
            for screenshot in article.screenshots {
                keys.append(screenshot.captionKey)
                keys.append(screenshot.accessibilityKey)
            }
        }

        for reference in GuideCategoryReference.all {
            keys.append(reference.examplesKey)
        }

        let bundle = Bundle(for: SubmissionEditorViewModel.self)
        let url = try XCTUnwrap(
            bundle.url(
                forResource: "Localizable",
                withExtension: "strings",
                subdirectory: nil,
                localization: "en"
            )
        )
        let en = try XCTUnwrap(NSDictionary(contentsOf: url) as? [String: String])
        let missing = Set(keys).filter { en[$0] == nil }.sorted()
        XCTAssertTrue(missing.isEmpty, "Missing en keys: \(missing)")
    }
}
