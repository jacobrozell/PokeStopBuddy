import SwiftUI

/// Live quality coach. Announces score changes; severity by symbol + text, not color.
struct QualityPanel: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let report: QualityReport
    var onIssueTap: ((QualityIssue.Field) -> Void)?

    var body: some View {
        Section {
            HStack {
                Text(L10n.string("quality.title"))
                    .font(.headline)
                Spacer()
                ScoreBadge(score: report.score, identifier: AccessibilityIDs.Editor.qualityScore)
                    .contentTransition(.numericText())
            }

            if report.issues.isEmpty {
                Label(L10n.string("quality.allClear"), systemImage: "checkmark.seal.fill")
                    .foregroundStyle(Theme.Colors.success)
                    .padding(.vertical, Theme.Spacing.xs)
            } else {
                ForEach(report.issues) { issue in
                    Button {
                        onIssueTap?(issue.field)
                    } label: {
                        Label {
                            Text(issue.message)
                                .multilineTextAlignment(.leading)
                        } icon: {
                            Image(systemName: issue.severity.systemImage)
                                .foregroundStyle(color(for: issue.severity))
                        }
                    }
                    .buttonStyle(.plain)
                    .frame(minHeight: Theme.minTouchTarget)
                    .accessibilityLabel(Text("\(severityLabel(issue.severity)): \(issue.message)"))
                    .accessibilityHint(Text(L10n.string("quality.issue.focusHint")))
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityValue(Text(L10n.string("quality.scoreValue", report.score)))
        .animation(reduceMotion ? nil : .smooth, value: report.score)
        .onChange(of: report.score) { previous, current in
            guard previous != current else { return }
            AccessibilityAnnouncement.post(L10n.string("quality.announcement.score", current))
        }
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
