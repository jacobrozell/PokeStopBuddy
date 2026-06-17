import Foundation

/// Single registry for external URLs. `tipJar == nil` hides the donate row.
public enum AppLinks {
    public static let privacy = URL(string: "https://jacobrozell.github.io/pokestopbuddy/privacy.html")!
    public static let support = URL(string: "https://jacobrozell.github.io/pokestopbuddy/support.html")!
    public static let accessibility = URL(string: "https://jacobrozell.github.io/pokestopbuddy/accessibility.html")!

    /// Niantic Wayfarer reference for users who want the official criteria.
    public static let wayfarerGuidelines = URL(string: "https://niantic.helpshift.com/hc/en/21-wayfarer/")!

    /// App Store review deep link — set when the listing exists.
    public static let appStoreReview: URL? = nil

    /// Optional tip/donate link. `nil` hides the row entirely (v1.0 default).
    public static let tipJar: URL? = nil
}
