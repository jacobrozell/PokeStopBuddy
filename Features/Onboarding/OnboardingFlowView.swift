import SwiftUI

struct OnboardingFlowView: View {
    let mode: OnboardingPresentationMode
    let dependencies: AppDependencies
    var store: OnboardingStore = OnboardingStore()
    let onFinished: () -> Void

    @State private var step: OnboardingStep = .welcome
    @State private var skippedFromWelcome = false

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.layoutDirection) private var layoutDirection

    var body: some View {
        NavigationStack {
            stepContent
                .id(step)
                .transition(onboardingTransition)
        }
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.28), value: step)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .preferredColorScheme(.dark)
        .interactiveDismissDisabled(mode == .firstLaunch)
        .accessibilityIdentifier(AccessibilityIDs.Onboarding.root)
    }

    @ViewBuilder
    private var stepContent: some View {
        switch step {
        case .welcome:
            OnboardingWelcomeStepView(
                onNext: { step = .defaults },
                onSkip: {
                    skippedFromWelcome = true
                    step = .ready
                }
            )
        case .defaults:
            OnboardingDefaultsStepView(
                dependencies: dependencies,
                progressIndex: OnboardingStep.defaults.progressIndex ?? 1,
                showsBack: true,
                onBack: { goBack() }
            ) {
                step = .howItWorks
            }
        case .howItWorks:
            OnboardingHowItWorksStepView(
                progressIndex: OnboardingStep.howItWorks.progressIndex ?? 2,
                showsBack: true,
                onBack: { goBack() }
            ) {
                step = .ready
            }
        case .ready:
            OnboardingReadyStepView(
                progressIndex: OnboardingStep.ready.progressIndex ?? 3,
                showsBack: step.backStep(skippedFromWelcome: skippedFromWelcome) != nil,
                onBack: { goBack() }
            ) {
                completeOnboarding()
            }
        }
    }

    private var onboardingTransition: AnyTransition {
        if reduceMotion {
            return .opacity
        }
        let insertion = AnyTransition.move(edge: layoutDirection == .rightToLeft ? .leading : .trailing)
            .combined(with: .opacity)
        let removal = AnyTransition.move(edge: layoutDirection == .rightToLeft ? .trailing : .leading)
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }

    private func goBack() {
        guard let previous = step.backStep(skippedFromWelcome: skippedFromWelcome) else { return }
        if previous == .welcome {
            skippedFromWelcome = false
        }
        step = previous
    }

    private func completeOnboarding() {
        if mode == .firstLaunch {
            store.markCompleted()
        }
        onFinished()
    }
}

#Preview {
    OnboardingFlowView(
        mode: .firstLaunch,
        dependencies: .preview(),
        store: OnboardingStore(isEnabled: false),
        onFinished: {}
    )
}
