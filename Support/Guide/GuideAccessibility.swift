import Foundation

/// VoiceOver helpers for submission-guide content.
enum GuideAccessibility {
    static func hubCardLabel(topic: GuideTopic) -> String {
        L10n.string(
            "guide.hub.card.label",
            L10n.string(topic.titleKey),
            L10n.string(topic.summaryKey)
        )
    }

    static func categoryRowLabel(_ category: WayspotCategory, isExpanded: Bool) -> String {
        guard let reference = GuideCategoryReference.all.first(where: { $0.category == category }) else {
            return category.displayName
        }
        let pillars = reference.pillars.map(\.displayName).joined(separator: ", ")
        if isExpanded {
            let examples = L10n.string(reference.examplesKey)
            return L10n.string(
                "guide.categories.row.expanded",
                category.displayName,
                pillars,
                examples
            )
        }
        return L10n.string("guide.categories.row.collapsed", category.displayName, pillars)
    }

    static func calloutKindName(_ kind: GuideCalloutKind) -> String {
        switch kind {
        case .tip: return L10n.string("guide.callout.kind.tip")
        case .do: return L10n.string("guide.callout.kind.do")
        case .dont: return L10n.string("guide.callout.kind.dont")
        }
    }
}
