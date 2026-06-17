import Foundation

/// Stable UI test identifiers. Convention: `screen.element`.
public enum AccessibilityIDs {
    public enum Library {
        public static let root = "submissionLibrary.root"
        public static let addButton = "submissionLibrary.addButton"
        public static let emptyState = "submissionLibrary.emptyState"
        public static func row(_ id: String) -> String { "submissionLibrary.row.\(id)" }
    }

    public enum Editor {
        public static let root = "submissionEditor.root"
        public static let placeNameField = "submissionEditor.placeNameField"
        public static let categoryPicker = "submissionEditor.categoryPicker"
        public static let stylePicker = "submissionEditor.stylePicker"
        public static let generateButton = "submissionEditor.generateButton"
        public static let saveButton = "submissionEditor.saveButton"
        public static let copyAllButton = "submissionEditor.copyAllButton"
        public static let shareButton = "submissionEditor.shareButton"
        public static let titleField = "submissionEditor.titleField"
        public static let descriptionField = "submissionEditor.descriptionField"
        public static let supportingField = "submissionEditor.supportingField"
        public static let qualityScore = "submissionEditor.qualityScore"
    }

    public enum Guide {
        public static let root = "guide.root"
        public static let openButton = "guide.openButton"
        public static let doneButton = "guide.doneButton"
        public static let wayfarerLink = "guide.wayfarerLink"
        public static let emptyStateLink = "guide.emptyStateLink"

        public static func hub(_ topic: GuideTopic) -> String { "guide.hub.\(topic.rawValue)" }
        public static func detail(_ topic: GuideTopic) -> String { "guide.detail.\(topic.rawValue)" }
        public static func infoButton(_ topic: GuideTopic) -> String { "guide.info.\(topic.rawValue)" }
        public static func categoryRow(_ category: WayspotCategory) -> String {
            "guide.categories.row.\(category.rawValue)"
        }
    }

    public enum Settings {
        public static let root = "settings.root"
        public static let openButton = "settings.openButton"
        public static let guideLink = "settings.guideLink"
        public static let onboardingLink = "settings.onboardingLink"
        public static let appearancePicker = "settings.appearancePicker"
        public static let defaultStylePicker = "settings.defaultStylePicker"
        public static let defaultCategoryPicker = "settings.defaultCategoryPicker"
        public static let privacyLink = "settings.privacyLink"
        public static let supportLink = "settings.supportLink"
        public static let accessibilityLink = "settings.accessibilityLink"
        public static let tipJarLink = "settings.tipJarLink"
        public static let deleteAllButton = "settings.deleteAllButton"
    }

    public enum Launch {
        public static let splash = "launch.splash"
    }

    public enum Onboarding {
        public static let root = "onboarding.root"
        public static let welcome = "onboarding.welcome"
        public static let welcomeContinue = "onboarding.welcomeContinue"
        public static let defaults = "onboarding.defaults"
        public static let defaultsContinue = "onboarding.defaultsContinue"
        public static let appearancePicker = "onboarding.appearancePicker"
        public static let defaultStylePicker = "onboarding.defaultStylePicker"
        public static let defaultCategoryPicker = "onboarding.defaultCategoryPicker"
        public static let howItWorks = "onboarding.howItWorks"
        public static let howItWorksDraft = "onboarding.howItWorks.draft"
        public static let howItWorksGenerate = "onboarding.howItWorks.generate"
        public static let howItWorksSubmit = "onboarding.howItWorks.submit"
        public static let howItWorksContinue = "onboarding.howItWorksContinue"
        public static let ready = "onboarding.ready"
        public static let readyFinish = "onboarding.readyFinish"
        public static let stepProgress = "onboarding.stepProgress"
        public static let back = "onboarding.back"
        public static let skip = "onboarding.skip"
    }
}
