import SwiftUI

/// A single library row. Exposed to VoiceOver as one combined element.
struct SubmissionRow: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    let submission: Submission
    let score: Int

    var body: some View {
        Group {
            if dynamicTypeSize.isAccessibilitySize {
                accessibilityLayout
            } else {
                compactLayout
            }
        }
        .padding(.vertical, Theme.Spacing.xs)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(rowLabel))
        .accessibilityHint(Text(L10n.string("library.row.hint")))
    }

    private var rowLabel: String {
        "\(submission.displayTitle), \(submission.inputs.category.displayName), "
        + "\(L10n.string("quality.scoreValue", score)), \(submission.status.displayName)"
    }

    private var compactLayout: some View {
        HStack(spacing: Theme.Spacing.md) {
            rowText
            Spacer(minLength: Theme.Spacing.sm)
            ScoreBadge(score: score)
        }
    }

    private var accessibilityLayout: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            rowText
            ScoreBadge(score: score)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var rowText: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
            Text(submission.displayTitle)
                .font(.headline)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: Theme.Spacing.sm) {
                Label(submission.inputs.category.displayName, systemImage: "tag")
                    .labelStyle(.titleAndIcon)
                Text("·")
                statusLabel
            }
            .font(.caption)
            .foregroundStyle(Theme.Colors.textSecondary)

            Text(submission.updatedAt, style: .relative)
                .font(.caption2)
                .foregroundStyle(Theme.Colors.textSecondary)
        }
    }

    @ViewBuilder
    private var statusLabel: some View {
        if submission.status == .readyToSubmit {
            Label(submission.status.displayName, systemImage: "checkmark.circle.fill")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(Theme.Colors.success)
                .labelStyle(.titleOnly)
                .padding(.horizontal, Theme.Spacing.sm)
                .padding(.vertical, 2)
                .background(Theme.Colors.success.opacity(0.14), in: Capsule())
        } else {
            Text(submission.status.displayName)
        }
    }
}
