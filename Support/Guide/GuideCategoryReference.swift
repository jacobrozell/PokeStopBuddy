import Foundation

/// Educational mapping from app categories to typical eligibility pillars.
public struct GuideCategoryReference: Sendable, Identifiable {
    public let category: WayspotCategory
    public let pillars: [EligibilityCriterion]
    public let examplesKey: String

    public var id: String { category.id }

    public static let all: [GuideCategoryReference] = [
        GuideCategoryReference(
            category: .publicArt,
            pillars: [.historicCultural, .socialExploration],
            examplesKey: "guide.categories.examples.publicArt"
        ),
        GuideCategoryReference(
            category: .historicalMarker,
            pillars: [.historicCultural],
            examplesKey: "guide.categories.examples.historicalMarker"
        ),
        GuideCategoryReference(
            category: .monument,
            pillars: [.historicCultural],
            examplesKey: "guide.categories.examples.monument"
        ),
        GuideCategoryReference(
            category: .building,
            pillars: [.historicCultural, .socialExploration],
            examplesKey: "guide.categories.examples.building"
        ),
        GuideCategoryReference(
            category: .placeOfWorship,
            pillars: [.historicCultural, .socialExploration],
            examplesKey: "guide.categories.examples.placeOfWorship"
        ),
        GuideCategoryReference(
            category: .library,
            pillars: [.historicCultural, .socialExploration],
            examplesKey: "guide.categories.examples.library"
        ),
        GuideCategoryReference(
            category: .park,
            pillars: [.exercise, .socialExploration],
            examplesKey: "guide.categories.examples.park"
        ),
        GuideCategoryReference(
            category: .playground,
            pillars: [.exercise, .socialExploration],
            examplesKey: "guide.categories.examples.playground"
        ),
        GuideCategoryReference(
            category: .trailhead,
            pillars: [.exercise, .historicCultural],
            examplesKey: "guide.categories.examples.trailhead"
        ),
        GuideCategoryReference(
            category: .sportsField,
            pillars: [.exercise, .socialExploration],
            examplesKey: "guide.categories.examples.sportsField"
        ),
        GuideCategoryReference(
            category: .fountain,
            pillars: [.socialExploration, .historicCultural],
            examplesKey: "guide.categories.examples.fountain"
        ),
        GuideCategoryReference(
            category: .garden,
            pillars: [.exercise, .historicCultural],
            examplesKey: "guide.categories.examples.garden"
        ),
        GuideCategoryReference(
            category: .localBusiness,
            pillars: [.socialExploration],
            examplesKey: "guide.categories.examples.localBusiness"
        ),
        GuideCategoryReference(
            category: .other,
            pillars: [.historicCultural, .exercise, .socialExploration],
            examplesKey: "guide.categories.examples.other"
        )
    ]
}
