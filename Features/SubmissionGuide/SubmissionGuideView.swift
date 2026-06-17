import SwiftUI

/// Table of contents for the submission guide.
struct SubmissionGuideView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: Theme.Spacing.md) {
                ForEach(GuideTopic.allCases) { topic in
                    NavigationLink {
                        GuideTopicDetailView(topic: topic)
                    } label: {
                        GuideHubCard(topic: topic)
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier(AccessibilityIDs.Guide.hub(topic))
                }

                Link(destination: AppLinks.wayfarerGuidelines) {
                    Label(L10n.string("guide.wayfarerLink"), systemImage: "book")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, minHeight: Theme.minTouchTarget)
                }
                .accessibilityHint(Text(L10n.string("guide.wayfarerLink.hint")))
                .padding(.top, Theme.Spacing.sm)
                .accessibilityIdentifier(AccessibilityIDs.Guide.wayfarerLink)
            }
            .padding(Theme.Spacing.md)
        }
        .navigationTitle(L10n.string("guide.title"))
        .navigationBarTitleDisplayMode(.inline)
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(AccessibilityIDs.Guide.root)
    }
}

#Preview {
    NavigationStack {
        SubmissionGuideView()
    }
}
