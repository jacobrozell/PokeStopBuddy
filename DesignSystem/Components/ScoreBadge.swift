import SwiftUI

/// Quality score badge. Conveys level by symbol + text + color (never color alone).
public struct ScoreBadge: View {
    private let score: Int
    private let identifier: String

    public init(score: Int, identifier: String = "scoreBadge") {
        self.score = score
        self.identifier = identifier
    }

    private var level: (symbol: String, color: Color, label: String) {
        switch score {
        case 80...: return ("checkmark.seal.fill", Theme.Colors.success, "Strong")
        case 50..<80: return ("exclamationmark.triangle.fill", Theme.Colors.warning, "Needs work")
        default: return ("exclamationmark.octagon.fill", Theme.Colors.critical, "Not ready")
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
