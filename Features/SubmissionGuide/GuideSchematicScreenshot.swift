import SwiftUI

/// Illustrated wireframes for guide steps when real Pokémon GO screenshots are not bundled.
/// Educational mockups — not game UI. Replace with assets in `Assets.xcassets` when available.
struct GuideSchematicScreenshot: View {
    let assetName: String

    var body: some View {
        schematic
            .padding(Theme.Spacing.md)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 140)
            .background(Theme.Colors.surfaceSecondary, in: RoundedRectangle(cornerRadius: Theme.Radius.md))
            .overlay {
                RoundedRectangle(cornerRadius: Theme.Radius.md)
                    .strokeBorder(Theme.Colors.accent.opacity(0.25), lineWidth: 1)
            }
            .accessibilityHidden(true)
    }

    @ViewBuilder
    private var schematic: some View {
        switch assetName {
        case "guide.process.menu": menuSchematic
        case "guide.process.map": mapSchematic
        case "guide.process.mainPhoto": cameraSchematic(labelKey: "guide.schematic.mainPhoto")
        case "guide.process.supportingPhoto": cameraSchematic(labelKey: "guide.schematic.supportingPhoto")
        case "guide.process.titleDescription": formSchematic
        case "guide.process.category": categorySchematic
        case "guide.process.preview": previewSchematic
        case "guide.process.supporting": supportingSchematic
        case "guide.process.upload": uploadSchematic
        default: genericSchematic
        }
    }

    // MARK: - Schematics

    private var menuSchematic: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            schematicBar("guide.schematic.appMenu")
            schematicRow("guide.schematic.settings", highlighted: false)
            schematicRow("guide.schematic.uploads", highlighted: true)
            schematicRow("guide.schematic.newPokestop", highlighted: true, indent: true)
        }
    }

    private var mapSchematic: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Theme.Radius.sm)
                .fill(Theme.Colors.accent.opacity(0.08))
            Image(systemName: "map")
                .font(.largeTitle)
                .foregroundStyle(Theme.Colors.accent.opacity(0.35))
            Image(systemName: "mappin.circle.fill")
                .font(.title)
                .foregroundStyle(Theme.Colors.critical)
                .offset(y: -8)
        }
        .frame(height: 100)
        .overlay(alignment: .bottomLeading) {
            schematicCaption("guide.schematic.pinOnObject")
        }
    }

    private func cameraSchematic(labelKey: String) -> some View {
        VStack(spacing: Theme.Spacing.sm) {
            RoundedRectangle(cornerRadius: Theme.Radius.sm)
                .fill(Color.black.opacity(0.85))
                .frame(height: 88)
                .overlay {
                    Image(systemName: "camera.viewfinder")
                        .font(.largeTitle)
                        .foregroundStyle(.white.opacity(0.9))
                }
            schematicCaption(labelKey)
        }
    }

    private var formSchematic: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            schematicField("guide.schematic.titleField", sample: "guide.schematic.sampleTitle")
            schematicField("guide.schematic.descriptionField", sample: "guide.schematic.sampleDescription")
        }
    }

    private var categorySchematic: some View {
        FlowLayout(spacing: Theme.Spacing.xs) {
            schematicTag("guide.schematic.tag.library", selected: false)
            schematicTag("guide.schematic.tag.publicArt", selected: true)
            schematicTag("guide.schematic.tag.park", selected: false)
            schematicTag("guide.schematic.tag.other", selected: false)
        }
    }

    private var previewSchematic: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
            schematicCaption("guide.schematic.previewTitle")
            Text(L10n.string("guide.schematic.sampleTitle"))
                .font(.subheadline.weight(.semibold))
            Text(L10n.string("guide.schematic.sampleDescription"))
                .font(.caption)
                .foregroundStyle(Theme.Colors.textSecondary)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var supportingSchematic: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            schematicCaption("guide.schematic.supportingHeading")
            schematicRow("guide.schematic.eligibilityPillar", highlighted: true)
            schematicField("guide.schematic.additionalInfo", sample: "guide.schematic.sampleSupporting")
        }
    }

    private var uploadSchematic: some View {
        HStack(spacing: Theme.Spacing.md) {
            schematicButton("guide.schematic.uploadNow", prominent: true)
            schematicButton("guide.schematic.uploadLater", prominent: false)
        }
    }

    private var genericSchematic: some View {
        VStack(spacing: Theme.Spacing.sm) {
            Image(systemName: "iphone")
                .font(.title2)
                .foregroundStyle(Theme.Colors.accent)
            schematicCaption("guide.schematic.generic")
        }
    }

    // MARK: - Primitives

    private func schematicBar(_ key: String) -> some View {
        Text(L10n.string(key))
            .font(.caption2.weight(.semibold))
            .foregroundStyle(Theme.Colors.textSecondary)
            .textCase(.uppercase)
    }

    private func schematicRow(_ key: String, highlighted: Bool, indent: Bool = false) -> some View {
        HStack(spacing: Theme.Spacing.sm) {
            if indent {
                Spacer().frame(width: Theme.Spacing.md)
            }
            RoundedRectangle(cornerRadius: 4)
                .fill(highlighted ? Theme.Colors.accent.opacity(0.2) : Theme.Colors.surface)
                .frame(height: 28)
                .overlay(alignment: .leading) {
                    Text(L10n.string(key))
                        .font(.caption)
                        .padding(.horizontal, Theme.Spacing.sm)
                }
                .overlay {
                    if highlighted {
                        RoundedRectangle(cornerRadius: 4)
                            .strokeBorder(Theme.Colors.accent, lineWidth: 1.5)
                    }
                }
        }
    }

    private func schematicField(_ labelKey: String, sample: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(L10n.string(labelKey))
                .font(.caption2.weight(.semibold))
                .foregroundStyle(Theme.Colors.textSecondary)
            Text(L10n.string(sample))
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(Theme.Spacing.sm)
                .background(Theme.Colors.surface, in: RoundedRectangle(cornerRadius: Theme.Radius.sm))
        }
    }

    private func schematicTag(_ key: String, selected: Bool) -> some View {
        Text(L10n.string(key))
            .font(.caption2.weight(.medium))
            .padding(.horizontal, Theme.Spacing.sm)
            .padding(.vertical, Theme.Spacing.xs)
            .background(
                selected ? Theme.Colors.accent.opacity(0.2) : Theme.Colors.surface,
                in: Capsule()
            )
            .overlay {
                if selected {
                    Capsule().strokeBorder(Theme.Colors.accent, lineWidth: 1)
                }
            }
    }

    private func schematicButton(_ key: String, prominent: Bool) -> some View {
        Text(L10n.string(key))
            .font(.caption.weight(.semibold))
            .frame(maxWidth: .infinity)
            .padding(.vertical, Theme.Spacing.sm)
            .background(
                prominent ? Theme.Colors.accent : Theme.Colors.surface,
                in: RoundedRectangle(cornerRadius: Theme.Radius.sm)
            )
            .foregroundStyle(prominent ? Color.white : Theme.Colors.textPrimary)
    }

    private func schematicCaption(_ key: String) -> some View {
        Text(L10n.string(key))
            .font(.caption2)
            .foregroundStyle(Theme.Colors.textSecondary)
    }
}

/// Simple flow layout for schematic tags.
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
