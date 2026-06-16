import SwiftUI
import UIKit

/// The core journey screen: capture inputs → generate → review/iterate → save.
///
/// Adapts to width: a single scrolling form on iPhone portrait, and a two-column layout
/// (inputs | generated + coach) when there's regular width — iPad, or a large phone in
/// landscape (see `LayoutContext.editorUsesWideLayout`).
struct SubmissionEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.layoutContext) private var layout
    @State private var model: SubmissionEditorViewModel
    @State private var showVersions = false

    private let onSaved: () -> Void

    init(dependencies: AppDependencies, existing: Submission?, onSaved: @escaping () -> Void) {
        self.onSaved = onSaved
        _model = State(initialValue: SubmissionEditorViewModel(
            existing: existing,
            repository: dependencies.repository,
            generator: dependencies.generator,
            evaluator: dependencies.evaluator
        ))
    }

    var body: some View {
        Group {
            if layout.editorUsesWideLayout {
                wideLayout
            } else {
                narrowLayout
            }
        }
        .navigationTitle(L10n.string("editor.title"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(L10n.string("editor.save")) { save() }
                    .accessibilityIdentifier(AccessibilityIDs.Editor.saveButton)
            }
        }
        .accessibilityIdentifier(AccessibilityIDs.Editor.root)
    }

    // MARK: - Layouts

    private var narrowLayout: some View {
        Form {
            inputsSection
            generateSection
            generatedSection
            QualityPanel(report: model.quality)
            if !model.versions.isEmpty {
                versionsSection
            }
        }
    }

    private var wideLayout: some View {
        HStack(alignment: .top, spacing: 0) {
            Form {
                inputsSection
                generateSection
            }
            .frame(maxWidth: .infinity)

            Divider()

            Form {
                generatedSection
                QualityPanel(report: model.quality)
                if !model.versions.isEmpty {
                    versionsSection
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Sections

    private var inputsSection: some View {
        Section(L10n.string("editor.section.about")) {
            TextField(L10n.string("editor.placeName"), text: $model.inputs.placeName)
                .accessibilityIdentifier(AccessibilityIDs.Editor.placeNameField)

            Picker(L10n.string("editor.category"), selection: $model.inputs.category) {
                ForEach(WayspotCategory.allCases) { category in
                    Text(category.displayName).tag(category)
                }
            }
            .accessibilityIdentifier(AccessibilityIDs.Editor.categoryPicker)

            Picker(L10n.string("editor.style"), selection: $model.inputs.style) {
                ForEach(GenerationStyle.allCases) { style in
                    Text(style.displayName).tag(style)
                }
            }
            .accessibilityIdentifier(AccessibilityIDs.Editor.stylePicker)

            KeyFeaturesEditor(features: $model.inputs.keyFeatures)
            EligibilityEditor(selection: $model.inputs.eligibility)

            TextField(L10n.string("editor.locationHint"), text: $model.inputs.locationHint, axis: .vertical)
            TextField(L10n.string("editor.accessNotes"), text: $model.inputs.accessNotes, axis: .vertical)
        }
        .onChange(of: model.inputs) { _, _ in model.refreshQuality() }
    }

    private var generateSection: some View {
        Section {
            PrimaryButton(
                L10n.string("editor.generate"),
                systemImage: "wand.and.stars",
                identifier: AccessibilityIDs.Editor.generateButton,
                isEnabled: !model.inputs.placeName.trimmingCharacters(in: .whitespaces).isEmpty
            ) {
                model.generate()
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
        }
    }

    private var generatedSection: some View {
        Section(L10n.string("editor.section.generated")) {
            LabeledField(label: L10n.string("editor.field.title"),
                         text: $model.content.title,
                         identifier: AccessibilityIDs.Editor.titleField,
                         limit: GenerationLimits.titleMax)
            LabeledField(label: L10n.string("editor.field.description"),
                         text: $model.content.description,
                         identifier: AccessibilityIDs.Editor.descriptionField,
                         limit: GenerationLimits.descriptionMax)
            LabeledField(label: L10n.string("editor.field.supporting"),
                         text: $model.content.supportingStatement,
                         identifier: AccessibilityIDs.Editor.supportingField,
                         limit: GenerationLimits.supportingMax)

            Button {
                UIPasteboard.general.string = model.clipboardText
            } label: {
                Label(L10n.string("editor.copyAll"), systemImage: "doc.on.doc")
            }
            .accessibilityIdentifier(AccessibilityIDs.Editor.copyAllButton)
        }
        .onChange(of: model.content) { _, _ in model.refreshQuality() }
    }

    private var versionsSection: some View {
        Section {
            DisclosureGroup(L10n.string("editor.versions", model.versions.count), isExpanded: $showVersions) {
                ForEach(model.versions.reversed()) { version in
                    Button {
                        model.revert(to: version)
                    } label: {
                        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                            Text(version.title.isEmpty ? L10n.string("editor.untitled") : version.title)
                                .font(.subheadline.weight(.medium))
                            Text(version.origin == .generated
                                 ? L10n.string("editor.version.generated")
                                 : L10n.string("editor.version.edited"))
                                .font(.caption)
                                .foregroundStyle(Theme.Colors.textSecondary)
                        }
                    }
                }
            }
        }
    }

    private func save() {
        model.save()
        if model.didSave {
            onSaved()
            dismiss()
        }
    }
}

#Preview("Narrow") {
    NavigationStack {
        SubmissionEditorView(dependencies: .preview(), existing: nil, onSaved: {})
            .environment(\.layoutContext, LayoutContext(idiom: .phone, horizontal: .compact, vertical: .regular))
    }
}

#Preview("Wide") {
    NavigationStack {
        SubmissionEditorView(dependencies: .preview(), existing: nil, onSaved: {})
            .environment(\.layoutContext, LayoutContext(idiom: .pad, horizontal: .regular, vertical: .regular))
    }
}
