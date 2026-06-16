import SwiftUI

/// A single library row. Exposed to VoiceOver as one combined element.
struct SubmissionRow: View {
    let submission: Submission
    let score: Int

    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                Text(submission.displayTitle)
                    .font(.headline)
                    .lineLimit(2)
                HStack(spacing: Theme.Spacing.sm) {
                    Label(submission.inputs.category.displayName, systemImage: "tag")
                        .labelStyle(.titleAndIcon)
                    Text("·")
                    Text(submission.status.displayName)
                }
                .font(.caption)
                .foregroundStyle(Theme.Colors.textSecondary)
            }
            Spacer(minLength: Theme.Spacing.sm)
            ScoreBadge(score: score)
        }
        .padding(.vertical, Theme.Spacing.xs)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(
            "\(submission.displayTitle), \(submission.inputs.category.displayName), "
            + "quality \(score) of 100, \(submission.status.displayName)"
        ))
    }
}
