import Foundation

/// User's appearance preference. Pure (no SwiftUI) so it lives in Support; the mapping to
/// SwiftUI's `ColorScheme` is provided in the DesignSystem layer.
public enum AppearanceMode: String, CaseIterable, Identifiable, Sendable {
    case system
    case light
    case dark

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
}
