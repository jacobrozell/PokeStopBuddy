import SwiftUI

/// Live quality coach. Announces score changes; severity by symbol + text, not color.
struct QualityPanel: View {
    let report: QualityReport

    var body: some View {
        Section {
            HStack {
                Text(L10n.string("quality.title"))
                    .font(.headline)
                Spacer()
                ScoreBadge(score: report.score, identifier: AccessibilityIDs.Editor.qualityScore)
            }

            if report.issues.isEmpty {
                Label(L10n.string("quality.allClear"), systemImage: "checkmark.seal.fill")
                    .foregroundStyle(Theme.Colors.success)
            } else {
                ForEach(report.issues) { issue in
                    Label {
                        Text(issue.message)
                    } icon: {
                        Image(systemName: issue.severity.systemImage)
                            .foregroundStyle(color(for: issue.severity))
                    }
                    .accessibilityLabel(Text("\(severityLabel(issue.severity)): \(issue.message)"))
                }
            }
        }
        .accessibilityElement(children: .contain)
        // Announce the score whenever it changes so VoiceOver users hear progress.
        .accessibilityValue(Text(L10n.string("quality.scoreValue", report.score)))
    }

    private func color(for severity: QualityIssue.Severity) -> Color {
        switch severity {
        case .blocker: return Theme.Colors.critical
        case .warning: return Theme.Colors.warning
        case .tip: return Theme.Colors.accent
        }
    }

    private func severityLabel(_ severity: QualityIssue.Severity) -> String {
        switch severity {
        case .blocker: return L10n.string("quality.severity.blocker")
        case .warning: return L10n.string("quality.severity.warning")
        case .tip: return L10n.string("quality.severity.tip")
        }
    }
}
