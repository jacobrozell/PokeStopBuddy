import SwiftUI
import UIKit

/// The core journey screen: capture inputs → generate → review/iterate → save.
///
/// Adapts to width: a single scrolling form on iPhone portrait, and a two-column layout
/// (inputs | generated + coach) on iPad, Pro Max landscape, and standard iPhone
/// landscape (see `LayoutContext.editorUsesWideLayout`).
struct SubmissionEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.layoutContext) private var layout
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var model: SubmissionEditorViewModel
    @State private var showVersions = false
    @State private var didCopy = false
    @State private var scrollTarget: EditorScrollTarget?
    @State private var showSavedBanner = false
    @State private var presentedGuideTopic: GuideTopic?
    @FocusState private var focusedField: EditorScrollTarget?

    private let focusPlaceNameOnAppear: Bool
    private let onSaved: (UUID) -> Void

    init(
        dependencies: AppDependencies,
        existing: Submission?,
        focusPlaceNameOnAppear: Bool = false,
        onSaved: @escaping (UUID) -> Void
    ) {
        self.focusPlaceNameOnAppear = focusPlaceNameOnAppear
        self.onSaved = onSaved
        _model = State(initialValue: SubmissionEditorViewModel(
            existing: existing,
            repository: dependencies.repository,
            generator: dependencies.generator,
            evaluator: dependencies.evaluator,
            defaultStyle: dependencies.preferences.defaultStyle,
            defaultCategory: dependencies.preferences.defaultCategory
        ))
    }

    var body: some View {
        Group {
            if usesEffectiveWideLayout {
                wideLayout
            } else {
                narrowLayout
            }
        }
        .animation(reduceMotion ? nil : .smooth, value: usesEffectiveWideLayout)
        .navigationTitle(L10n.string("editor.title"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if layout.editorShowsToolbarGenerate {
                ToolbarItem(placement: .topBarLeading) {
                    Button(L10n.string("editor.generate")) {
                        generateContent()
                    }
                    .disabled(!model.canGenerate)
                    .accessibilityIdentifier(AccessibilityIDs.Editor.generateButton)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(L10n.string("editor.save")) { save() }
                    .fontWeight(model.quality.isSubmittable ? .semibold : .regular)
                    .disabled(!model.canSave)
                    .accessibilityIdentifier(AccessibilityIDs.Editor.saveButton)
                    .accessibilityHint(Text(
                        model.canSave
                            ? L10n.string("editor.save.hint")
                            : L10n.string("editor.save.disabledHint")
                    ))
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(AccessibilityIDs.Editor.root)
        .alert(
            L10n.string("error.save_failed"),
            isPresented: Binding(
                get: { model.errorMessage != nil },
                set: { if !$0 { model.clearError() } }
            )
        ) {
            Button(L10n.string("common.ok")) { model.clearError() }
        } message: {
            if let errorMessage = model.errorMessage {
                Text(errorMessage)
            }
        }
        .overlay(alignment: .top) {
            if showSavedBanner {
                SavedBanner(message: L10n.string("editor.savedBanner"))
                    .padding(.top, Theme.Spacing.sm)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(reduceMotion ? nil : .smooth, value: showSavedBanner)
        .onAppear(perform: focusPlaceNameIfNeeded)
        .environment(\.presentedGuideTopic, $presentedGuideTopic)
        .sheet(item: $presentedGuideTopic) { topic in
            GuideTopicSheet(topic: topic)
        }
    }

    private func focusPlaceNameIfNeeded() {
        guard focusPlaceNameOnAppear,
              !ProcessInfo.processInfo.arguments.contains("-uitest-disable-autofocus"),
              !UIAccessibility.isVoiceOverRunning else { return }
        DispatchQueue.main.async {
            focusedField = .placeName
        }
    }

    // MARK: - Layouts

    private var usesEffectiveWideLayout: Bool {
        layout.effectiveEditorUsesWideLayout(
            isAccessibilityTextSize: dynamicTypeSize.isAccessibilitySize
        )
    }

    private var narrowLayout: some View {
        scrollableForm {
            inputsSection
            generateSection
            generatedSection
            qualitySection
            if !model.versions.isEmpty {
                versionsSection
            }
        }
    }

    private var wideLayout: some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(spacing: 0) {
                if showsWideColumnHeaders {
                    columnHeader(L10n.string("editor.section.about"), topic: .fields)
                }
                scrollableForm(column: .inputs) {
                    inputsSection
                    generateSection
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

            Divider()

            VStack(spacing: 0) {
                if showsWideColumnHeaders {
                    columnHeader(L10n.string("editor.section.generated"), topic: .copyWorkflow)
                }
                scrollableForm(column: .generated) {
                    generatedSection
                    qualitySection
                    if !model.versions.isEmpty {
                        versionsSection
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }

    private enum FormColumn { case inputs, generated }

    private func scrollableForm(
        column: FormColumn? = nil,
        @ViewBuilder content: @escaping () -> some View
    ) -> some View {
        ScrollViewReader { proxy in
            Form(content: content)
                .scrollDismissesKeyboard(.interactively)
                .environment(\.presentedGuideTopic, $presentedGuideTopic)
                .onChange(of: scrollTarget) { _, target in
                    guard let target else { return }
                    let matchesColumn = column.map {
                        $0 == .generated ? target.usesGeneratedColumn : !target.usesGeneratedColumn
                    } ?? true
                    guard matchesColumn else { return }
                    withAnimation(reduceMotion ? nil : .smooth) {
                        proxy.scrollTo(target, anchor: .center)
                    }
                    focusedField = focusableTarget(target)
                    scrollTarget = nil
                }
        }
    }

    private func focusableTarget(_ target: EditorScrollTarget) -> EditorScrollTarget? {
        switch target {
        case .placeName, .locationHint, .accessNotes, .title, .description, .supporting:
            return target
        case .category, .eligibility:
            return nil
        }
    }

    private var qualitySection: some View {
        QualityPanel(report: model.quality, onIssueTap: focusIssue)
    }

    private func focusIssue(_ field: QualityIssue.Field) {
        scrollTarget = field.editorScrollTarget
        HapticFeedback.lightImpact()
    }

    /// Pinned column headers in wide layouts; always on iPad, landscape-only on phone.
    private var showsWideColumnHeaders: Bool {
        layout.idiom == .pad || layout.isLandscape
    }

    private func columnHeader(_ title: String, topic: GuideTopic) -> some View {
        HStack {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(Theme.Colors.textSecondary)
                .textCase(.uppercase)
                .accessibilityAddTraits(.isHeader)
            Spacer()
            GuideInfoButton(topic: topic)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Theme.Spacing.md)
        .padding(.vertical, Theme.Spacing.sm)
        .background(Theme.Colors.surfaceSecondary)
    }

    @ViewBuilder
    private func sectionWithOptionalHeader<Content: View>(
        _ title: String,
        hideHeader: Bool,
        guideTopic: GuideTopic? = nil,
        @ViewBuilder content: () -> Content
    ) -> some View {
        if hideHeader {
            Section(content: content)
        } else if let guideTopic {
            Section {
                content()
            } header: {
                editorSectionHeader(title, topic: guideTopic)
            }
        } else {
            Section(title, content: content)
        }
    }

    // MARK: - Sections

    private var inputsSection: some View {
        sectionWithOptionalHeader(
            L10n.string("editor.section.about"),
            hideHeader: showsWideColumnHeaders && usesEffectiveWideLayout,
            guideTopic: .fields
        ) {
            TextField(L10n.string("editor.placeName"), text: $model.inputs.placeName)
                .focused($focusedField, equals: .placeName)
                .id(EditorScrollTarget.placeName)
                .accessibilityIdentifier(AccessibilityIDs.Editor.placeNameField)

            CategoryPickerRow(
                selection: $model.inputs.category,
                presentedGuideTopic: $presentedGuideTopic
            )
                .id(EditorScrollTarget.category)

            Picker(L10n.string("editor.style"), selection: $model.inputs.style) {
                ForEach(GenerationStyle.allCases) { style in
                    Text(style.displayName).tag(style)
                }
            }
            .accessibilityIdentifier(AccessibilityIDs.Editor.stylePicker)

            KeyFeaturesEditor(features: $model.inputs.keyFeatures)
            EligibilityEditor(selection: $model.inputs.eligibility)
                .id(EditorScrollTarget.eligibility)

            TextField(L10n.string("editor.locationHint"), text: $model.inputs.locationHint, axis: .vertical)
                .focused($focusedField, equals: .locationHint)
                .id(EditorScrollTarget.locationHint)
            TextField(L10n.string("editor.accessNotes"), text: $model.inputs.accessNotes, axis: .vertical)
                .focused($focusedField, equals: .accessNotes)
                .id(EditorScrollTarget.accessNotes)
        }
        .onChange(of: model.inputs) { _, _ in model.refreshQuality() }
    }

    private var generateSection: some View {
        Section {
            if !layout.editorShowsToolbarGenerate {
                PrimaryButton(
                    L10n.string("editor.generate"),
                    systemImage: "wand.and.stars",
                    identifier: AccessibilityIDs.Editor.generateButton,
                    isEnabled: model.canGenerate
                ) {
                    generateContent()
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }
        }
    }

    private var generatedSection: some View {
        sectionWithOptionalHeader(
            L10n.string("editor.section.generated"),
            hideHeader: showsWideColumnHeaders && usesEffectiveWideLayout,
            guideTopic: .copyWorkflow
        ) {
            if !model.hasShareableContent {
                Text(L10n.string("editor.generated.empty"))
                    .font(.subheadline)
                    .foregroundStyle(Theme.Colors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            LabeledField(label: L10n.string("editor.field.title"),
                         text: $model.content.title,
                         identifier: AccessibilityIDs.Editor.titleField,
                         limit: GenerationLimits.titleMax)
            .id(EditorScrollTarget.title)
            LabeledField(label: L10n.string("editor.field.description"),
                         text: $model.content.description,
                         identifier: AccessibilityIDs.Editor.descriptionField,
                         limit: GenerationLimits.descriptionMax)
            .id(EditorScrollTarget.description)
            LabeledField(label: L10n.string("editor.field.supporting"),
                         text: $model.content.supportingStatement,
                         identifier: AccessibilityIDs.Editor.supportingField,
                         limit: GenerationLimits.supportingMax)
            .id(EditorScrollTarget.supporting)

            Button {
                UIPasteboard.general.string = model.clipboardText
                HapticFeedback.success()
                didCopy = true
                AccessibilityAnnouncement.post(L10n.string("editor.announcement.copied"))
                Task {
                    try? await Task.sleep(for: .seconds(2))
                    didCopy = false
                }
            } label: {
                Label(
                    didCopy ? L10n.string("editor.copied") : L10n.string("editor.copyAll"),
                    systemImage: didCopy ? "checkmark.circle.fill" : "doc.on.doc"
                )
                .foregroundStyle(didCopy ? Theme.Colors.success : .primary)
            }
            .accessibilityIdentifier(AccessibilityIDs.Editor.copyAllButton)
            .accessibilityLabel(Text(
                didCopy ? L10n.string("editor.copied") : L10n.string("editor.copyAll")
            ))
            .accessibilityAddTraits(.isButton)
            .disabled(!model.hasShareableContent)
            .opacity(model.hasShareableContent ? 1 : 0.45)

            ShareLink(item: model.clipboardText) {
                Label(L10n.string("editor.share"), systemImage: "square.and.arrow.up")
            }
            .accessibilityIdentifier(AccessibilityIDs.Editor.shareButton)
            .disabled(!model.hasShareableContent)
        }
        .onChange(of: model.content) { _, _ in model.refreshQuality() }
        .animation(reduceMotion ? nil : .smooth, value: model.content.title)
    }

    private func editorSectionHeader(_ title: String, topic: GuideTopic) -> some View {
        HStack {
            Text(title)
                .accessibilityAddTraits(.isHeader)
            Spacer()
            GuideInfoButton(topic: topic)
        }
    }

    private var versionsSection: some View {
        Section {
            DisclosureGroup(L10n.string("editor.versions", model.versions.count), isExpanded: $showVersions) {
                ForEach(model.versions.reversed()) { version in
                    Button {
                        model.revert(to: version)
                        HapticFeedback.lightImpact()
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

    private func generateContent() {
        guard !model.inputs.placeName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        model.generate()
        HapticFeedback.lightImpact()
        AccessibilityAnnouncement.post(L10n.string("editor.announcement.generated"))
    }

    private func save() {
        model.save()
        if model.didSave {
            HapticFeedback.success()
            AccessibilityAnnouncement.post(L10n.string("editor.announcement.saved"))
            onSaved(model.submissionID)
            if layout.usesSplitNavigation {
                showSavedBanner = true
                Task {
                    try? await Task.sleep(for: .seconds(2.5))
                    showSavedBanner = false
                }
            } else {
                dismiss()
            }
        }
    }
}

#Preview("Narrow") {
    NavigationStack {
        SubmissionEditorView(dependencies: .preview(), existing: nil, onSaved: { _ in })
            .environment(\.layoutContext, LayoutContext(idiom: .phone, horizontal: .compact, vertical: .regular))
    }
}

#Preview("Phone landscape") {
    NavigationStack {
        SubmissionEditorView(dependencies: .preview(), existing: nil, onSaved: { _ in })
            .environment(\.layoutContext, LayoutContext(idiom: .phone, horizontal: .compact, vertical: .compact))
    }
}

#Preview("Wide") {
    NavigationStack {
        SubmissionEditorView(dependencies: .preview(), existing: nil, onSaved: { _ in })
            .environment(\.layoutContext, LayoutContext(idiom: .pad, horizontal: .regular, vertical: .regular))
    }
}
