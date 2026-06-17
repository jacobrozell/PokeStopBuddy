import SwiftUI

/// Quality score badge. Conveys level by symbol + text + color (never color alone).
public struct ScoreBadge: View {
    private let score: Int
    private let identifier: String

    public init(score: Int, identifier: String = "scoreBadge") {
        self.score = score
        self.identifier = identifier
    }

    private struct Level {
        let symbol: String
        let color: Color
        let label: String
    }

    private var level: Level {
        switch score {
        case 80...:
            return Level(symbol: "checkmark.seal.fill", color: Theme.Colors.success, label: "Strong")
        case 50..<80:
            return Level(symbol: "exclamationmark.triangle.fill", color: Theme.Colors.warning, label: "Needs work")
        default:
            return Level(symbol: "exclamationmark.octagon.fill", color: Theme.Colors.critical, label: "Not ready")
        }
    }

    public var body: some View {
        let level = level
        HStack(spacing: Theme.Spacing.xs) {
            Image(systemName: level.symbol)
            Text("\(score)")
                .fontWeight(.semibold)
                .monospacedDigit()
        }
        .font(.subheadline)
        .foregroundStyle(level.color)
        .padding(.horizontal, Theme.Spacing.sm)
        .padding(.vertical, Theme.Spacing.xs)
        .background(level.color.opacity(0.12), in: Capsule())
        .accessibilityElement(children: .ignore)
        .accessibilityIdentifier(identifier)
        .accessibilityLabel(Text("Quality \(level.label), \(score) of 100"))
    }
}
