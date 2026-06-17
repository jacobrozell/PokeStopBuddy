import SwiftUI

struct OnboardingReadyStepView: View {
    let progressIndex: Int
    let showsBack: Bool
    let onBack: () -> Void
    let onFinish: () -> Void

    var body: some View {
        OnboardingStepChrome(
            showsSkip: false,
            onSkip: {},
            progressIndex: progressIndex,
            showsBack: showsBack,
            onBack: onBack
        ) {
            OnboardingHeroContent(
                symbolName: "checkmark.circle",
                titleKey: "onboarding.ready.title",
                bodyKey: "onboarding.ready.body"
            )
        } footer: {
            OnboardingPrimaryButton(
                titleKey: "onboarding.ready.action",
                identifier: AccessibilityIDs.Onboarding.readyFinish
            ) {
                onFinish()
            }
        }
        .accessibilityIdentifier(AccessibilityIDs.Onboarding.ready)
    }
}
