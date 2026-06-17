import SwiftUI

struct OnboardingDefaultsStepView: View {
    let dependencies: AppDependencies
    let progressIndex: Int
    let showsBack: Bool
    let onBack: () -> Void
    let onNext: () -> Void

    var body: some View {
        @Bindable var preferences = dependencies.preferences
        return OnboardingStepChrome(
            showsSkip: false,
            onSkip: {},
            progressIndex: progressIndex,
            showsBack: showsBack,
            onBack: onBack
        ) {
            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                OnboardingHeroContent(
                    symbolName: "slider.horizontal.3",
                    titleKey: "onboarding.defaults.title",
                    bodyKey: "onboarding.defaults.body"
                )

                VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                    onboardingPicker(
                        titleKey: "settings.appearance",
                        identifier: AccessibilityIDs.Onboarding.appearancePicker
                    ) {
                        Picker(L10n.string("settings.appearance"), selection: $preferences.appearance) {
                            ForEach(AppearanceMode.allCases) { mode in
                                Text(mode.displayName).tag(mode)
                            }
                        }
                        .pickerStyle(.menu)
                    }

                    onboardingPicker(
                        titleKey: "settings.defaultStyle",
                        identifier: AccessibilityIDs.Onboarding.defaultStylePicker
                    ) {
                        Picker(L10n.string("settings.defaultStyle"), selection: $preferences.defaultStyle) {
                            ForEach(GenerationStyle.allCases) { style in
                                Text(style.displayName).tag(style)
                            }
                        }
                        .pickerStyle(.menu)
                    }

                    onboardingPicker(
                        titleKey: "settings.defaultCategory",
                        identifier: AccessibilityIDs.Onboarding.defaultCategoryPicker
                    ) {
                        Picker(L10n.string("settings.defaultCategory"), selection: $preferences.defaultCategory) {
                            ForEach(WayspotCategory.allCases) { category in
                                Text(category.displayName).tag(category)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
            }
        } footer: {
            OnboardingPrimaryButton(
                titleKey: "common.continue",
                identifier: AccessibilityIDs.Onboarding.defaultsContinue
            ) {
                onNext()
            }
        }
        .accessibilityIdentifier(AccessibilityIDs.Onboarding.defaults)
    }

    private func onboardingPicker<Content: View>(
        titleKey: String,
        identifier: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
            Text(L10n.string(titleKey))
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white.opacity(0.72))
            content()
                .tint(.cyan)
                .foregroundStyle(.white)
        }
        .padding(Theme.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: Theme.Radius.md))
        .accessibilityIdentifier(identifier)
    }
}
