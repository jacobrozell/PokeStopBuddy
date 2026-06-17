import SwiftUI

/// Branded splash shown while bootstrap runs; pairs with solid-color `UILaunchScreen`.
struct LaunchSplashView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @State private var footerAppeared = false

    private let animateFooter: Bool

    init(animateFooter: Bool = true) {
        self.animateFooter = animateFooter
        _footerAppeared = State(initialValue: !animateFooter)
    }

    private var markSize: CGFloat {
        horizontalSizeClass == .regular ? 112 : 96
    }

    var body: some View {
        ZStack {
            Color("LaunchBackground")
                .ignoresSafeArea()

            VStack(spacing: Theme.Spacing.lg) {
                BrandMarkView(size: markSize, showsLongShadow: true)

                VStack(spacing: Theme.Spacing.md) {
                    LaunchSplashWordmark()
                    LaunchDotsIndicator()
                }
                .opacity(footerAppeared ? 1 : 0)
            }
            .padding(.horizontal, Theme.Spacing.lg)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(L10n.string("launch.loading"))
        .accessibilityIdentifier(AccessibilityIDs.Launch.splash)
        .onAppear(perform: runEntranceAnimation)
    }

    private func runEntranceAnimation() {
        guard animateFooter else { return }
        if reduceMotion {
            footerAppeared = true
            return
        }
        withAnimation(.easeOut(duration: 0.35).delay(0.15)) {
            footerAppeared = true
        }
    }
}

private struct LaunchSplashWordmark: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private var wordmarkFont: Font {
        if dynamicTypeSize.isAccessibilitySize {
            return .system(.title, design: .rounded).weight(.bold)
        }
        return .system(size: 32, weight: .heavy, design: .rounded)
    }

    var body: some View {
        Text(L10n.string("brand.title"))
            .font(wordmarkFont)
            .foregroundStyle(.white)
            .tracking(0.4)
            .multilineTextAlignment(.center)
    }
}

private struct LaunchDotsIndicator: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let dotSize: CGFloat = 8
    private let inactiveOpacity = 0.35
    private let stepInterval: TimeInterval = 0.42

    var body: some View {
        Group {
            if reduceMotion {
                dotRow(activeIndex: 0)
            } else {
                TimelineView(.periodic(from: .now, by: stepInterval)) { context in
                    dotRow(activeIndex: activeStep(for: context.date))
                }
            }
        }
        .accessibilityHidden(true)
    }

    private func activeStep(for date: Date) -> Int {
        Int(date.timeIntervalSinceReferenceDate / stepInterval) % 3
    }

    private func dotRow(activeIndex: Int) -> some View {
        HStack(spacing: Theme.Spacing.sm) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(Color.cyan)
                    .frame(width: dotSize, height: dotSize)
                    .opacity(index == activeIndex ? 1 : inactiveOpacity)
                    .scaleEffect(index == activeIndex ? 1.15 : 1)
                    .animation(.easeInOut(duration: 0.28), value: activeIndex)
            }
        }
    }
}

#Preview("Launch Splash") {
    LaunchSplashView(animateFooter: false)
}
