import SwiftUI
import UIKit

/// Pure, testable layout decisions. Kept free of live `UIScreen`/environment reads so the
/// predicates can be unit-tested across the full device/orientation matrix.
///
/// Key rule (Phase 7.4): distinguish iPad from a large phone in landscape with the
/// **idiom**, not horizontal size class alone — iPhone Pro Max in landscape reports a
/// `.regular` horizontal size class but is NOT an iPad.

public enum LayoutIdiom: Equatable, Sendable {
    case phone
    case pad

    /// Current device idiom, mapped from UIKit. Treats CarPlay/TV/etc. as phone-like.
    @MainActor public static var current: LayoutIdiom {
        UIDevice.current.userInterfaceIdiom == .pad ? .pad : .phone
    }
}

public enum LayoutSizeClass: Equatable, Sendable {
    case compact
    case regular

    init(_ sizeClass: UserInterfaceSizeClass?) {
        self = (sizeClass == .regular) ? .regular : .compact
    }
}

/// A snapshot of the inputs that drive adaptive layout.
public struct LayoutContext: Equatable, Sendable {
    public let idiom: LayoutIdiom
    public let horizontal: LayoutSizeClass
    public let vertical: LayoutSizeClass

    public init(idiom: LayoutIdiom, horizontal: LayoutSizeClass, vertical: LayoutSizeClass) {
        self.idiom = idiom
        self.horizontal = horizontal
        self.vertical = vertical
    }

    /// Landscape on phones reports a compact vertical size class.
    public var isLandscape: Bool { vertical == .compact }

    /// Use a sidebar + detail split only on a true iPad with regular width. This
    /// deliberately excludes Pro Max landscape (idiom `.phone`, horizontal `.regular`).
    public var usesSplitNavigation: Bool {
        idiom == .pad && horizontal == .regular
    }

    /// Use the editor's two-column layout when horizontal width is regular (iPad, Pro Max
    /// landscape) **or** when a phone is in landscape. Phones in landscape report compact
    /// width but have ample horizontal points — splitting inputs from generated content
    /// keeps the keyboard from burying Generate and the quality coach.
    public var editorUsesWideLayout: Bool {
        horizontal == .regular || (idiom == .phone && isLandscape)
    }

    /// At accessibility text sizes, prefer a single scrolling column so content is not
    /// clipped or squeezed side-by-side.
    public func effectiveEditorUsesWideLayout(isAccessibilityTextSize: Bool) -> Bool {
        guard !isAccessibilityTextSize else { return false }
        return editorUsesWideLayout
    }

    /// Generate moves to the nav toolbar in landscape on phones (compact reachability)
    /// and in rare single-column landscape on iPad (e.g. slide-over).
    public var editorShowsToolbarGenerate: Bool {
        isLandscape && (idiom == .phone || !editorUsesWideLayout)
    }
}

// MARK: - Environment bridge

private struct LayoutContextKey: EnvironmentKey {
    static let defaultValue = LayoutContext(idiom: .phone, horizontal: .compact, vertical: .regular)
}

public extension EnvironmentValues {
    var layoutContext: LayoutContext {
        get { self[LayoutContextKey.self] }
        set { self[LayoutContextKey.self] = newValue }
    }
}

public extension View {
    /// Computes a `LayoutContext` from the live idiom + size classes and injects it into
    /// the environment for descendants to read.
    func resolveLayoutContext() -> some View {
        modifier(ResolveLayoutContext())
    }
}

private struct ResolveLayoutContext: ViewModifier {
    @Environment(\.horizontalSizeClass) private var horizontal
    @Environment(\.verticalSizeClass) private var vertical

    func body(content: Content) -> some View {
        content.environment(\.layoutContext, LayoutContext(
            idiom: .current,
            horizontal: LayoutSizeClass(horizontal),
            vertical: LayoutSizeClass(vertical)
        ))
    }
}
