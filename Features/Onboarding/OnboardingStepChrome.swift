import SwiftUI

enum OnboardingStep: Equatable {
    case welcome
    case defaults
    case howItWorks
    case ready

    static let progressTotal = 3

    var progressIndex: Int? {
        switch self {
        case .welcome: nil
        case .defaults: 1
        case .howItWorks: 2
        case .ready: 3
        }
    }

    func backStep(skippedFromWelcome: Bool) -> OnboardingStep? {
        switch self {
        case .welcome: nil
        case .defaults: .welcome
        case .howItWorks: skippedFromWelcome ? .welcome : .defaults
        case .ready: skippedFromWelcome ? .welcome : .howItWorks
        }
    }
}

struct OnboardingStepChrome<Content: View, Footer: View>: View {
    let showsSkip: Bool
    let onSkip: () -> Void
    var progressIndex: Int? = nil
    var progressTotal: Int = OnboardingStep.progressTotal
    var showsBack: Bool = false
    var onBack: () -> Void = {}
    @ViewBuilder let content: () -> Content
    @ViewBuilder let footer: () -> Footer

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private var contentMaxWidth: CGFloat {
        horizontalSizeClass == .regular ? 560 : .infinity
    }

    private var scrollBottomPadding: CGFloat {
        dynamicTypeSize.isAccessibilitySize ? 120 : Theme.Spacing.md
    }

    private var footerReservedHeight: CGFloat {
        dynamicTypeSize.isAccessibilitySize ? 148 : 120
    }

    var body: some View {
        ZStack {
            Color("LaunchBackground")
                .ignoresSafeArea()

            GeometryReader { geometry in
                VStack(spacing: 0) {
                    ScrollView {
                        content()
                            .frame(maxWidth: contentMaxWidth)
                            .frame(maxWidth: .infinity)
                            .frame(
                                minHeight: horizontalSizeClass == .regular
                                    ? max(0, geometry.size.height - footerReservedHeight)
                                    : nil,
                                alignment: .center
                            )
                            .padding(.horizontal, Theme.Spacing.md)
                            .padding(.top, Theme.Spacing.lg)
                            .padding(.bottom, scrollBottomPadding)
                    }
                    .scrollDismissesKeyboard(.interactively)
                    .scrollIndicators(.hidden)

                    footer()
                        .frame(maxWidth: contentMaxWidth)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, Theme.Spacing.md)
                        .padding(.top, Theme.Spacing.md)
                        .padding(.bottom, Theme.Spacing.lg)
                }
            }
        }
        .toolbar {
            if let progressIndex {
                ToolbarItem(placement: .principal) {
                    Text(L10n.string("onboarding.stepProgress", progressIndex, progressTotal))
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.72))
                        .accessibilityLabel(
                            L10n.string("onboarding.stepProgress", progressIndex, progressTotal)
                        )
                        .accessibilityIdentifier(AccessibilityIDs.Onboarding.stepProgress)
                }
            }

            if showsBack {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.body.weight(.semibold))
                            .foregroundStyle(.white)
                    }
                    .frame(minWidth: Theme.minTouchTarget, minHeight: Theme.minTouchTarget)
                    .accessibilityLabel(L10n.string("common.back"))
                    .accessibilityIdentifier(AccessibilityIDs.Onboarding.back)
                }
            }

            if showsSkip {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(L10n.string("common.skip")) {
                        onSkip()
                    }
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.72))
                    .frame(minWidth: Theme.minTouchTarget, minHeight: Theme.minTouchTarget)
                    .accessibilityIdentifier(AccessibilityIDs.Onboarding.skip)
                }
            }
        }
    }
}

struct OnboardingHeroContent: View {
    let symbolName: String?
    let showsBrandMark: Bool
    let titleKey: String
    let bodyKey: String

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    init(
        symbolName: String? = nil,
        showsBrandMark: Bool = false,
        titleKey: String,
        bodyKey: String
    ) {
        self.symbolName = symbolName
        self.showsBrandMark = showsBrandMark
        self.titleKey = titleKey
        self.bodyKey = bodyKey
    }

    private var pageIconSize: CGFloat {
        dynamicTypeSize.isAccessibilitySize ? 44 : 56
    }

    var body: some View {
        VStack(spacing: Theme.Spacing.md) {
            if showsBrandMark {
                BrandMarkView(size: horizontalSizeClass == .regular ? 96 : 80, showsLongShadow: true)
            } else if let symbolName {
                Image(systemName: symbolName)
                    .font(.system(size: pageIconSize, weight: .medium))
                    .foregroundStyle(Color.cyan)
                    .symbolRenderingMode(.hierarchical)
                    .accessibilityHidden(true)
            }

            Text(L10n.string(titleKey))
                .font(.title.bold())
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .accessibilityAddTraits(.isHeader)

            Text(L10n.string(bodyKey))
                .font(.body)
                .foregroundStyle(.white.opacity(0.78))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

struct OnboardingFeatureRow: View {
    let systemImage: String
    let titleKey: String
    let bodyKey: String
    let identifier: String

    var body: some View {
        HStack(alignment: .top, spacing: Theme.Spacing.md) {
            Image(systemName: systemImage)
                .font(.title2.weight(.medium))
                .foregroundStyle(Color.cyan)
                .symbolRenderingMode(.hierarchical)
                .frame(width: Theme.minTouchTarget, height: Theme.minTouchTarget)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                Text(L10n.string(titleKey))
                    .font(.headline)
                    .foregroundStyle(.white)
                Text(L10n.string(bodyKey))
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.78))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(Theme.Spacing.md)
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: Theme.Radius.md))
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier(identifier)
    }
}

struct OnboardingPrimaryButton: View {
    let titleKey: String
    let identifier: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(L10n.string(titleKey))
                .font(.headline.weight(.bold))
                .foregroundStyle(Color("LaunchBackground"))
                .frame(maxWidth: .infinity, minHeight: 52)
                .background(Color.cyan, in: Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier(identifier)
        .accessibilityLabel(L10n.string(titleKey))
        .accessibilityAddTraits(.isButton)
    }
}
