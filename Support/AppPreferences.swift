import Foundation
import Observation

/// Observable, persisted user preferences. Backed by `UserDefaults` so it survives
/// relaunch; inject a custom suite in tests for isolation. Acts as the settings model.
@MainActor
@Observable
public final class AppPreferences {
    public var appearance: AppearanceMode {
        didSet { defaults.set(appearance.rawValue, forKey: Key.appearance) }
    }

    /// Default writing style applied to newly created submissions.
    public var defaultStyle: GenerationStyle {
        didSet { defaults.set(defaultStyle.rawValue, forKey: Key.defaultStyle) }
    }

    /// Default category applied to newly created submissions.
    public var defaultCategory: WayspotCategory {
        didSet { defaults.set(defaultCategory.rawValue, forKey: Key.defaultCategory) }
    }

    private let defaults: UserDefaults

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.appearance = AppearanceMode(rawValue: defaults.string(forKey: Key.appearance) ?? "") ?? .system
        self.defaultStyle = GenerationStyle(rawValue: defaults.string(forKey: Key.defaultStyle) ?? "") ?? .descriptive
        let categoryRaw = defaults.string(forKey: Key.defaultCategory) ?? ""
        self.defaultCategory = WayspotCategory(rawValue: categoryRaw) ?? .publicArt
    }

    private enum Key {
        static let appearance = "pref.appearance"
        static let defaultStyle = "pref.defaultStyle"
        static let defaultCategory = "pref.defaultCategory"
    }
}
