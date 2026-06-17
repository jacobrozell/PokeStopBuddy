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
        public static let titleField = "submissionEditor.titleField"
        public static let descriptionField = "submissionEditor.descriptionField"
        public static let supportingField = "submissionEditor.supportingField"
        public static let qualityScore = "submissionEditor.qualityScore"
    }

    public enum Settings {
        public static let root = "settings.root"
        public static let appearancePicker = "settings.appearancePicker"
        public static let defaultStylePicker = "settings.defaultStylePicker"
        public static let defaultCategoryPicker = "settings.defaultCategoryPicker"
        public static let privacyLink = "settings.privacyLink"
        public static let supportLink = "settings.supportLink"
        public static let accessibilityLink = "settings.accessibilityLink"
        public static let tipJarLink = "settings.tipJarLink"
        public static let deleteAllButton = "settings.deleteAllButton"
    }
}
