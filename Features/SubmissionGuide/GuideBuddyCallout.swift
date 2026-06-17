import SwiftUI

struct GuideBuddyCallout: View {
    let textKey: String

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Label(L10n.string("guide.buddy.title"), systemImage: "sparkles")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Theme.Colors.accent)
            Text(L10n.string(textKey))
                .font(.subheadline)
                .foregroundStyle(Theme.Colors.textPrimary)
        }
        .padding(Theme.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.Colors.accent.opacity(0.1), in: RoundedRectangle(cornerRadius: Theme.Radius.md))
        .accessibilityElement(children: .combine)
    }
}
