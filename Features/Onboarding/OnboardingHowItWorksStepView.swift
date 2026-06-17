import SwiftUI

struct OnboardingHowItWorksStepView: View {
    let progressIndex: Int
    let showsBack: Bool
    let onBack: () -> Void
    let onNext: () -> Void

    var body: some View {
        OnboardingStepChrome(
            showsSkip: false,
            onSkip: {},
            progressIndex: progressIndex,
            showsBack: showsBack,
            onBack: onBack
        ) {
            VStack(spacing: Theme.Spacing.lg) {
                OnboardingHeroContent(
                    symbolName: "map",
                    titleKey: "onboarding.howItWorks.title",
                    bodyKey: "onboarding.howItWorks.body"
                )

                VStack(spacing: Theme.Spacing.sm) {
                    OnboardingFeatureRow(
                        systemImage: "square.and.pencil",
                        titleKey: "onboarding.howItWorks.draft.title",
                        bodyKey: "onboarding.howItWorks.draft.body",
                        identifier: AccessibilityIDs.Onboarding.howItWorksDraft
                    )
                    OnboardingFeatureRow(
                        systemImage: "wand.and.stars",
                        titleKey: "onboarding.howItWorks.generate.title",
                        bodyKey: "onboarding.howItWorks.generate.body",
                        identifier: AccessibilityIDs.Onboarding.howItWorksGenerate
                    )
                    OnboardingFeatureRow(
                        systemImage: "doc.on.clipboard",
                        titleKey: "onboarding.howItWorks.submit.title",
                        bodyKey: "onboarding.howItWorks.submit.body",
                        identifier: AccessibilityIDs.Onboarding.howItWorksSubmit
                    )
                }
            }
        } footer: {
            OnboardingPrimaryButton(
                titleKey: "common.continue",
                identifier: AccessibilityIDs.Onboarding.howItWorksContinue
            ) {
                onNext()
            }
        }
        .accessibilityIdentifier(AccessibilityIDs.Onboarding.howItWorks)
    }
}
