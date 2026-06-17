import SwiftUI

struct GuideCategoryGrid: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var expandedID: String?

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            ForEach(GuideCategoryReference.all) { reference in
                categoryRow(reference)
            }
        }
    }

    private func categoryRow(_ reference: GuideCategoryReference) -> some View {
        let isExpanded = expandedID == reference.id

        return VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Button {
                if reduceMotion {
                    expandedID = isExpanded ? nil : reference.id
                } else {
                    withAnimation(.smooth) {
                        expandedID = isExpanded ? nil : reference.id
                    }
                }
            } label: {
                HStack(alignment: .top) {
                    Text(reference.category.displayName)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.Colors.textPrimary)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.Colors.textSecondary)
                }
                .frame(minHeight: Theme.minTouchTarget)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier(AccessibilityIDs.Guide.categoryRow(reference.category))
            .accessibilityLabel(Text(GuideAccessibility.categoryRowLabel(reference.category, isExpanded: isExpanded)))
            .accessibilityHint(Text(L10n.string("guide.categories.row.hint")))
            .accessibilityAddTraits(isExpanded ? [.isButton, .isSelected] : .isButton)

            FlowLayout(spacing: Theme.Spacing.xs) {
                ForEach(reference.pillars) { pillar in
                    TagChip(pillar.displayName, systemImage: "checkmark.seal")
                        .accessibilityHidden(true)
                }
            }
            .accessibilityHidden(true)

            if isExpanded {
                Text(L10n.string(reference.examplesKey))
                    .font(.subheadline)
                    .foregroundStyle(Theme.Colors.textSecondary)
                    .accessibilityHidden(true)
            }
        }
        .padding(Theme.Spacing.md)
        .background(Theme.Colors.surfaceSecondary, in: RoundedRectangle(cornerRadius: Theme.Radius.md))
    }
}

/// Simple horizontal-wrapping layout for tag chips.
private struct FlowLayout: Layout {
    var spacing: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, frame) in result.frames.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + frame.minX, y: bounds.minY + frame.minY),
                proposal: ProposedViewSize(frame.size)
            )
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, frames: [CGRect]) {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var frames: [CGRect] = []

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            frames.append(CGRect(origin: CGPoint(x: x, y: y), size: size))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }

        return (CGSize(width: maxWidth, height: y + rowHeight), frames)
    }
}
