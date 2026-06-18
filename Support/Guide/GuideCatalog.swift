import Foundation

/// Static submission-guide content. All user-facing copy resolves through `L10n`.
public enum GuideCatalog {
    public static let articles: [GuideArticle] = GuideTopic.allCases.map(article(for:))

    public static func article(for topic: GuideTopic) -> GuideArticle {
        switch topic {
        case .process: return processArticle
        case .fields: return fieldsArticle
        case .categories: return categoriesArticle
        case .eligibility: return eligibilityArticle
        case .photos: return photosArticle
        case .copyWorkflow: return copyWorkflowArticle
        }
    }

    // MARK: - Screenshots

    private static let processScreenshots: [GuideScreenshotRef] = [
        ref("guide.process.menu", caption: "guide.screenshot.menu.caption", a11y: "guide.screenshot.menu.a11y"),
        ref("guide.process.map", caption: "guide.screenshot.map.caption", a11y: "guide.screenshot.map.a11y"),
        ref("guide.process.mainPhoto", caption: "guide.screenshot.mainPhoto.caption", a11y: "guide.screenshot.mainPhoto.a11y"),
        ref("guide.process.supportingPhoto", caption: "guide.screenshot.supportingPhoto.caption", a11y: "guide.screenshot.supportingPhoto.a11y"),
        ref("guide.process.titleDescription", caption: "guide.screenshot.titleDescription.caption", a11y: "guide.screenshot.titleDescription.a11y"),
        ref("guide.process.category", caption: "guide.screenshot.category.caption", a11y: "guide.screenshot.category.a11y"),
        ref("guide.process.preview", caption: "guide.screenshot.preview.caption", a11y: "guide.screenshot.preview.a11y"),
        ref("guide.process.supporting", caption: "guide.screenshot.supporting.caption", a11y: "guide.screenshot.supporting.a11y"),
        ref("guide.process.upload", caption: "guide.screenshot.upload.caption", a11y: "guide.screenshot.upload.a11y")
    ]

    private static let photoScreenshots: [GuideScreenshotRef] = [
        ref("guide.process.map", caption: "guide.screenshot.map.caption", a11y: "guide.screenshot.map.a11y"),
        ref("guide.process.mainPhoto", caption: "guide.screenshot.mainPhoto.caption", a11y: "guide.screenshot.mainPhoto.a11y"),
        ref("guide.process.supportingPhoto", caption: "guide.screenshot.supportingPhoto.caption", a11y: "guide.screenshot.supportingPhoto.a11y")
    ]

    private static func ref(_ asset: String, caption: String, a11y: String) -> GuideScreenshotRef {
        GuideScreenshotRef(assetName: asset, captionKey: caption, accessibilityKey: a11y)
    }

    // MARK: - Articles

    private static let processArticle = GuideArticle(
        topic: .process,
        introKey: "guide.process.intro",
        sections: [
            GuideSection(
                headingKey: "guide.process.section.prerequisites.heading",
                bodyKey: "guide.process.section.prerequisites.body",
                callout: GuideCallout(
                    kind: .tip,
                    titleKey: "guide.process.callout.requirements.title",
                    bodyKey: "guide.process.callout.requirements.body"
                )
            ),
            GuideSection(
                headingKey: "guide.process.section.steps.heading",
                bulletKeys: [
                    "guide.process.step.1",
                    "guide.process.step.2",
                    "guide.process.step.3",
                    "guide.process.step.4",
                    "guide.process.step.5",
                    "guide.process.step.6",
                    "guide.process.step.7",
                    "guide.process.step.8",
                    "guide.process.step.9"
                ]
            )
        ],
        screenshots: processScreenshots,
        relatedTopics: [.fields, .copyWorkflow, .photos],
        appCalloutKey: "guide.process.app"
    )

    private static let fieldsArticle = GuideArticle(
        topic: .fields,
        introKey: "guide.fields.intro",
        sections: [
            GuideSection(
                headingKey: "guide.fields.section.inputs.heading",
                bulletKeys: [
                    "guide.fields.row.placeName",
                    "guide.fields.row.category",
                    "guide.fields.row.style",
                    "guide.fields.row.keyFeatures",
                    "guide.fields.row.eligibility",
                    "guide.fields.row.locationHint",
                    "guide.fields.row.accessNotes"
                ]
            ),
            GuideSection(
                headingKey: "guide.fields.section.generated.heading",
                bulletKeys: [
                    "guide.fields.row.title",
                    "guide.fields.row.description",
                    "guide.fields.row.supporting"
                ]
            )
        ],
        screenshots: [
            ref("guide.process.titleDescription", caption: "guide.screenshot.titleDescription.caption", a11y: "guide.screenshot.titleDescription.a11y")
        ],
        relatedTopics: [.process, .categories, .eligibility],
        appCalloutKey: "guide.fields.app"
    )

    private static let categoriesArticle = GuideArticle(
        topic: .categories,
        introKey: "guide.categories.intro",
        sections: [
            GuideSection(
                headingKey: "guide.categories.section.picker.heading",
                bodyKey: "guide.categories.section.picker.body"
            ),
            GuideSection(
                headingKey: "guide.categories.section.reference.heading",
                bodyKey: "guide.categories.section.reference.body"
            )
        ],
        screenshots: [
            ref("guide.process.category", caption: "guide.screenshot.category.caption", a11y: "guide.screenshot.category.a11y")
        ],
        relatedTopics: [.eligibility, .fields],
        appCalloutKey: "guide.categories.app"
    )

    private static let eligibilityArticle = GuideArticle(
        topic: .eligibility,
        introKey: "guide.eligibility.intro",
        sections: [
            GuideSection(
                headingKey: "guide.eligibility.section.pillars.heading",
                bulletKeys: [
                    "guide.eligibility.pillar.historicCultural",
                    "guide.eligibility.pillar.exercise",
                    "guide.eligibility.pillar.socialExploration"
                ]
            ),
            GuideSection(
                headingKey: "guide.eligibility.section.rules.heading",
                bulletKeys: [
                    "guide.eligibility.rule.oneRequired",
                    "guide.eligibility.rule.notEnough",
                    "guide.eligibility.rule.noGameMentions"
                ],
                callout: GuideCallout(
                    kind: .dont,
                    titleKey: "guide.eligibility.callout.mistakes.title",
                    bodyKey: "guide.eligibility.callout.mistakes.body"
                )
            )
        ],
        screenshots: [
            ref("guide.process.supporting", caption: "guide.screenshot.supporting.caption", a11y: "guide.screenshot.supporting.a11y")
        ],
        relatedTopics: [.categories, .fields],
        appCalloutKey: "guide.eligibility.app"
    )

    private static let photosArticle = GuideArticle(
        topic: .photos,
        introKey: "guide.photos.intro",
        sections: [
            GuideSection(
                headingKey: "guide.photos.section.pin.heading",
                bodyKey: "guide.photos.section.pin.body"
            ),
            GuideSection(
                headingKey: "guide.photos.section.main.heading",
                bulletKeys: [
                    "guide.photos.tip.main.clear",
                    "guide.photos.tip.main.close",
                    "guide.photos.tip.main.noFaces"
                ]
            ),
            GuideSection(
                headingKey: "guide.photos.section.supporting.heading",
                bodyKey: "guide.photos.section.supporting.body"
            )
        ],
        screenshots: photoScreenshots,
        relatedTopics: [.process, .fields],
        appCalloutKey: "guide.photos.app"
    )

    private static let copyWorkflowArticle = GuideArticle(
        topic: .copyWorkflow,
        introKey: "guide.copyWorkflow.intro",
        sections: [
            GuideSection(
                headingKey: "guide.copyWorkflow.section.steps.heading",
                bulletKeys: [
                    "guide.copyWorkflow.step.1",
                    "guide.copyWorkflow.step.2",
                    "guide.copyWorkflow.step.3",
                    "guide.copyWorkflow.step.4",
                    "guide.copyWorkflow.step.5",
                    "guide.copyWorkflow.step.6"
                ],
                callout: GuideCallout(
                    kind: .tip,
                    titleKey: "guide.copyWorkflow.callout.uploadLater.title",
                    bodyKey: "guide.copyWorkflow.callout.uploadLater.body"
                )
            )
        ],
        screenshots: [
            ref("guide.process.preview", caption: "guide.screenshot.preview.caption", a11y: "guide.screenshot.preview.a11y")
        ],
        relatedTopics: [.process, .fields],
        appCalloutKey: "guide.copyWorkflow.app"
    )
}
