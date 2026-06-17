import SwiftUI

struct GuideHubCard: View {
    let topic: GuideTopic

    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            Image(systemName: topic.symbolName)
                .font(.title3)
                .foregroundStyle(Theme.Colors.accent)
                .frame(width: 36, height: 36)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                Text(L10n.string(topic.titleKey))
                    .font(.headline)
                    .foregroundStyle(Theme.Colors.textPrimary)
                Text(L10n.string(topic.summaryKey))
                    .font(.subheadline)
                    .foregroundStyle(Theme.Colors.textSecondary)
                    .lineLimit(2)
            }

            Spacer(minLength: Theme.Spacing.sm)

            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Theme.Colors.textSecondary)
                .accessibilityHidden(true)
        }
        .padding(Theme.Spacing.md)
        .frame(minHeight: Theme.minTouchTarget)
        .background(Theme.Colors.surfaceSecondary, in: RoundedRectangle(cornerRadius: Theme.Radius.md))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(GuideAccessibility.hubCardLabel(topic: topic)))
        .accessibilityHint(Text(L10n.string("guide.hub.card.hint")))
        .accessibilityAddTraits(.isButton)
    }
}
