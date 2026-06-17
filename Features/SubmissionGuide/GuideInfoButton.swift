import SwiftUI

/// Contextual help button that presents a guide topic in a sheet.
struct GuideInfoButton: View {
    let topic: GuideTopic
    var presentedGuideTopic: Binding<GuideTopic?>?

    @Environment(\.presentedGuideTopic) private var environmentTopic

    private var topicBinding: Binding<GuideTopic?> {
        presentedGuideTopic ?? environmentTopic
    }

    var body: some View {
        Button {
            topicBinding.wrappedValue = topic
        } label: {
            Image(systemName: "info.circle")
                .foregroundStyle(Theme.Colors.accent)
        }
        .buttonStyle(.borderless)
        .frame(width: Theme.minTouchTarget, height: Theme.minTouchTarget)
        .accessibilityLabel(Text(L10n.string("guide.infoButton.label", L10n.string(topic.titleKey))))
        .accessibilityHint(Text(L10n.string("guide.infoButton.hint")))
        .accessibilityIdentifier(AccessibilityIDs.Guide.infoButton(topic))
    }
}
