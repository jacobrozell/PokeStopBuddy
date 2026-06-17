import SwiftUI

struct OnboardingWelcomeStepView: View {
    let onNext: () -> Void
    let onSkip: () -> Void

    var body: some View {
        OnboardingStepChrome(showsSkip: true, onSkip: onSkip) {
            OnboardingHeroContent(
                showsBrandMark: true,
                titleKey: "onboarding.welcome.title",
                bodyKey: "onboarding.welcome.body"
            )
        } footer: {
            OnboardingPrimaryButton(
                titleKey: "common.continue",
                identifier: AccessibilityIDs.Onboarding.welcomeContinue
            ) {
                onNext()
            }
        }
        .accessibilityIdentifier(AccessibilityIDs.Onboarding.welcome)
    }
}
