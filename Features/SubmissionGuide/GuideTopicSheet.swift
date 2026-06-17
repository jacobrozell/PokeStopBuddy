import SwiftUI

/// Presents a single guide topic (editor info buttons, contextual help).
struct GuideTopicSheet: View {
    let topic: GuideTopic
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            GuideTopicDetailView(topic: topic)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(L10n.string("common.done")) { dismiss() }
                            .accessibilityIdentifier(AccessibilityIDs.Guide.doneButton)
                    }
                }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
}
