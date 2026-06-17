import SwiftUI

struct GuideTopicDetailView: View {
    @Environment(\.layoutContext) private var layout
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    let topic: GuideTopic

    private var article: GuideArticle { GuideCatalog.article(for: topic) }

    var body: some View {
        ScrollView {
            if usesWideLayout {
                wideContent
            } else {
                narrowContent
            }
        }
        .navigationTitle(L10n.string(topic.titleKey))
        .navigationBarTitleDisplayMode(.inline)
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(topic.detailAccessibilityID)
    }

    private var usesWideLayout: Bool {
        layout.horizontal == .regular && !dynamicTypeSize.isAccessibilitySize
    }

    private var narrowContent: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
            introBlock
            screenshotsBlock
            sectionsBlock
            categoryGridIfNeeded
            appCalloutBlock
            relatedTopicsBlock
        }
        .padding(Theme.Spacing.md)
    }

    private var wideContent: some View {
        HStack(alignment: .top, spacing: Theme.Spacing.lg) {
            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                if !article.screenshots.isEmpty {
                    screenshotsBlock
                }
            }
            .frame(maxWidth: .infinity)

            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                introBlock
                sectionsBlock
                categoryGridIfNeeded
                appCalloutBlock
                relatedTopicsBlock
            }
            .frame(maxWidth: .infinity)
        }
        .padding(Theme.Spacing.md)
    }

    @ViewBuilder
    private var introBlock: some View {
        Text(L10n.string(article.introKey))
            .font(.body)
            .foregroundStyle(Theme.Colors.textPrimary)
    }

    @ViewBuilder
    private var screenshotsBlock: some View {
        if !article.screenshots.isEmpty {
            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                ForEach(article.screenshots, id: \.assetName) { screenshot in
                    GuideScreenshot(reference: screenshot)
                }
            }
        }
    }

    @ViewBuilder
    private var sectionsBlock: some View {
        ForEach(Array(article.sections.enumerated()), id: \.offset) { _, section in
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                Text(L10n.string(section.headingKey))
                    .font(.headline)
                    .accessibilityAddTraits(.isHeader)

                if let bodyKey = section.bodyKey {
                    Text(L10n.string(bodyKey))
                        .font(.subheadline)
                        .foregroundStyle(Theme.Colors.textSecondary)
                }

                if !section.bulletKeys.isEmpty {
                    VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                        ForEach(section.bulletKeys, id: \.self) { key in
                            HStack(alignment: .top, spacing: Theme.Spacing.sm) {
                                Text("•")
                                    .accessibilityHidden(true)
                                Text(L10n.string(key))
                                    .font(.subheadline)
                            }
                            .accessibilityElement(children: .combine)
                        }
                    }
                }

                if let callout = section.callout {
                    GuideCalloutCard(callout: callout)
                }
            }
        }
    }

    @ViewBuilder
    private var categoryGridIfNeeded: some View {
        if topic == .categories {
            GuideCategoryGrid()
        }
    }

    @ViewBuilder
    private var appCalloutBlock: some View {
        if let appCalloutKey = article.appCalloutKey {
            GuideAppCallout(textKey: appCalloutKey)
        }
    }

    @ViewBuilder
    private var relatedTopicsBlock: some View {
        if !article.relatedTopics.isEmpty {
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                Text(L10n.string("guide.related.title"))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.Colors.textSecondary)

                ForEach(article.relatedTopics) { related in
                    NavigationLink {
                        GuideTopicDetailView(topic: related)
                    } label: {
                        GuideHubCard(topic: related)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        GuideTopicDetailView(topic: .process)
            .environment(\.layoutContext, LayoutContext(idiom: .phone, horizontal: .compact, vertical: .regular))
    }
}
