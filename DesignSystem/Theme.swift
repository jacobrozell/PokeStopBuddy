import SwiftUI

/// Design tokens. Semantic colors map to system materials so light/dark + increased
/// contrast settings are respected automatically.
public enum Theme {
    public enum Spacing {
        public static let xs: CGFloat = 4
        public static let sm: CGFloat = 8
        public static let md: CGFloat = 16
        public static let lg: CGFloat = 24
        public static let xl: CGFloat = 32
    }

    public enum Radius {
        public static let sm: CGFloat = 8
        public static let md: CGFloat = 12
        public static let lg: CGFloat = 20
    }

    /// Minimum interactive touch target (HIG / WCAG).
    public static let minTouchTarget: CGFloat = 44

    public enum Colors {
        public static let accent = Color.accentColor
        public static let surface = Color(.systemBackground)
        public static let surfaceSecondary = Color(.secondarySystemBackground)
        public static let textPrimary = Color(.label)
        public static let textSecondary = Color(.secondaryLabel)
        public static let success = Color(.systemGreen)
        public static let warning = Color(.systemOrange)
        public static let critical = Color(.systemRed)
    }
}
