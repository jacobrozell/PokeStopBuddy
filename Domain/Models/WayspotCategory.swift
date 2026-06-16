import Foundation

/// The kind of real-world object/place being nominated as a Wayspot / PokeStop.
/// Drives category-specific phrasing in the content generator.
public enum WayspotCategory: String, CaseIterable, Codable, Sendable, Identifiable {
    case publicArt
    case historicalMarker
    case building
    case placeOfWorship
    case park
    case playground
    case trailhead
    case sportsField
    case library
    case localBusiness
    case monument
    case fountain
    case garden
    case other

    public var id: String { rawValue }

    /// Short human label (localized at the UI boundary via `L10n`).
    public var displayName: String {
        switch self {
        case .publicArt: return "Public Art"
        case .historicalMarker: return "Historical Marker"
        case .building: return "Notable Building"
        case .placeOfWorship: return "Place of Worship"
        case .park: return "Park"
        case .playground: return "Playground"
        case .trailhead: return "Trailhead"
        case .sportsField: return "Sports Field"
        case .library: return "Library"
        case .localBusiness: return "Local Business"
        case .monument: return "Monument"
        case .fountain: return "Fountain"
        case .garden: return "Garden"
        case .other: return "Other"
        }
    }

    /// A noun phrase used when composing descriptions, e.g. "a hand-painted mural".
    var nounPhrase: String {
        switch self {
        case .publicArt: return "piece of public art"
        case .historicalMarker: return "historical marker"
        case .building: return "notable building"
        case .placeOfWorship: return "place of worship"
        case .park: return "public park"
        case .playground: return "playground"
        case .trailhead: return "trailhead"
        case .sportsField: return "sports field"
        case .library: return "public library"
        case .localBusiness: return "local business"
        case .monument: return "monument"
        case .fountain: return "fountain"
        case .garden: return "garden"
        case .other: return "local landmark"
        }
    }
}
