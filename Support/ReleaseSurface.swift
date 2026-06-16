import Foundation

/// The single source of truth for "is feature X reachable in this build?".
/// Build wide internally; ship narrow publicly. See specs/feature-flags.md.
public struct ReleaseSurface: Sendable {
    private let fullSurface: Bool

    public init(flags: FeatureFlags) {
        self.fullSurface = flags.fullProductSurface
    }

    // Always-on core (v1.0).
    public var submissionEditor: Bool { true }
    public var submissionLibrary: Bool { true }
    public var qualityCoach: Bool { true }
    public var settings: Bool { true }

    // Gated until a later slice; revealed only with -enable_full_product_surface.
    public var photoGuidance: Bool { fullSurface }     // v1.1
    public var llmEnhance: Bool { fullSurface }         // v1.x
    public var exportSharePack: Bool { fullSurface }    // v1.2
}
