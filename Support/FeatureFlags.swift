import Foundation

/// Reads launch arguments / environment once at startup. No scattered `#if` in views.
public struct FeatureFlags: Sendable {
    public let fullProductSurface: Bool
    public let telemetryEnabled: Bool
    public let resetStore: Bool
    public let seedFixtures: Bool

    public init(
        fullProductSurface: Bool,
        telemetryEnabled: Bool,
        resetStore: Bool,
        seedFixtures: Bool
    ) {
        self.fullProductSurface = fullProductSurface
        self.telemetryEnabled = telemetryEnabled
        self.resetStore = resetStore
        self.seedFixtures = seedFixtures
    }

    public static func fromProcess(_ arguments: [String] = ProcessInfo.processInfo.arguments) -> FeatureFlags {
        let args = Set(arguments)
        return FeatureFlags(
            fullProductSurface: args.contains("-enable_full_product_surface"),
            telemetryEnabled: !args.contains("-disable-telemetry"), // off in tests
            resetStore: args.contains("-uitest-reset"),
            seedFixtures: args.contains("-uitest-seed")
        )
    }

    /// Conservative defaults for the shipped App Store build.
    public static let release = FeatureFlags(
        fullProductSurface: false,
        telemetryEnabled: false, // telemetry off in v1.0
        resetStore: false,
        seedFixtures: false
    )
}
