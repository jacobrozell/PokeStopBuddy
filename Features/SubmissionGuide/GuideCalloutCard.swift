import SwiftUI

struct GuideCalloutCard: View {
    let callout: GuideCallout

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Label(L10n.string(callout.titleKey), systemImage: symbolName)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(foregroundColor)
            Text(L10n.string(callout.bodyKey))
                .font(.subheadline)
                .foregroundStyle(Theme.Colors.textPrimary)
        }
        .padding(Theme.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(foregroundColor.opacity(0.12), in: RoundedRectangle(cornerRadius: Theme.Radius.md))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text(accessibilitySummary))
    }

    private var accessibilitySummary: String {
        L10n.string(
            "guide.callout.summary",
            GuideAccessibility.calloutKindName(callout.kind),
            L10n.string(callout.titleKey),
            L10n.string(callout.bodyKey)
        )
    }

    private var symbolName: String {
        switch callout.kind {
        case .tip: return "lightbulb.fill"
        case .do: return "checkmark.circle.fill"
        case .dont: return "xmark.octagon.fill"
        }
    }

    private var foregroundColor: Color {
        switch callout.kind {
        case .tip: return Theme.Colors.accent
        case .do: return Theme.Colors.success
        case .dont: return Theme.Colors.critical
        }
    }
}
