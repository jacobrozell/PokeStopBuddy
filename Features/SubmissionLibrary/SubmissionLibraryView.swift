import SwiftUI

/// The home surface: a list of saved submissions with quick access to create a new one.
/// Adapts between a navigation stack (iPhone) and a sidebar + detail split (iPad).
struct SubmissionLibraryView: View {
    let dependencies: AppDependencies

    @Environment(\.layoutContext) private var layout
    @State private var model: SubmissionLibraryViewModel
    @State private var showingSettings = false
    @State private var showingGuide = false
    @State private var selection: UUID?
    /// Drives the detail column on iPad; survives sidebar list rebuilds after the first save.
    @State private var activeDetailID: UUID?
    /// Stable identity for a new draft on iPad; matches the editor's submission id.
    @State private var draftID = UUID()
    @State private var searchText = ""
    @State private var submissionPendingDelete: Submission?

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _model = State(initialValue: SubmissionLibraryViewModel(
            repository: dependencies.repository,
            evaluator: dependencies.evaluator
        ))
    }

    var body: some View {
        Group {
            if layout.usesSplitNavigation {
                splitBody
            } else {
                stackBody
            }
        }
        .sheet(isPresented: $showingSettings, onDismiss: { model.load() }) {
            SettingsView(dependencies: dependencies, onOpenGuide: {
                showingSettings = false
                showingGuide = true
            })
        }
        .sheet(isPresented: $showingGuide) {
            GuideLibrarySheet(isPresented: $showingGuide)
        }
        .onAppear { model.load() }
        .onChange(of: layout.usesSplitNavigation) { _, usesSplit in
            if usesSplit {
                syncSplitSelection(with: model.submissions)
            }
        }
        .alert(
            L10n.string("error.load_failed"),
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
        .confirmationDialog(
            L10n.string("library.delete.confirm"),
            isPresented: Binding(
                get: { submissionPendingDelete != nil },
                set: { if !$0 { submissionPendingDelete = nil } }
            ),
            titleVisibility: .visible
        ) {
            Button(L10n.string("library.delete.action"), role: .destructive) {
                if let submission = submissionPendingDelete {
                    confirmDelete(submission)
                }
            }
            Button(L10n.string("common.cancel"), role: .cancel) {
                submissionPendingDelete = nil
            }
        } message: {
            if let submission = submissionPendingDelete {
                Text(L10n.string("library.delete.message", submission.displayTitle))
            }
        }
    }

    private var displayedSubmissions: [Submission] {
        model.filteredSubmissions(matching: searchText)
    }

    // MARK: - iPhone: navigation stack

    private var stackBody: some View {
        NavigationStack {
            content
                .navigationTitle(L10n.string("library.title"))
                .navigationBarTitleDisplayMode(layout.isLandscape ? .inline : .large)
                .toolbar { guideToolbarItem; addToolbarItemLink }
        }
        .accessibilityIdentifier(AccessibilityIDs.Library.root)
        .searchable(text: $searchText, prompt: Text(L10n.string("library.search.prompt")))
    }

    @ViewBuilder
    private var content: some View {
        if model.isEmpty {
            emptyState
        } else {
            stackList
        }
    }

    private var stackList: some View {
        List {
            if !searchText.isEmpty && displayedSubmissions.isEmpty {
                Text(L10n.string("library.search.empty"))
                    .foregroundStyle(Theme.Colors.textSecondary)
                    .listRowBackground(Color.clear)
            }

            ForEach(displayedSubmissions) { submission in
                NavigationLink {
                    editor(for: submission)
                } label: {
                    SubmissionRow(submission: submission, score: model.score(for: submission))
                }
                .accessibilityIdentifier(AccessibilityIDs.Library.row(submission.id.uuidString))
            }
            .onDelete { requestDelete(at: $0, in: displayedSubmissions) }
        }
        .listStyle(.insetGrouped)
        .refreshable { model.load() }
    }

    // MARK: - iPad: sidebar + detail split

    private var splitBody: some View {
        NavigationSplitView {
            sidebar
                .navigationTitle(L10n.string("library.title"))
                .navigationBarTitleDisplayMode(layout.isLandscape ? .inline : .large)
                .toolbar { guideToolbarItem; addToolbarItemButton }
                .navigationSplitViewColumnWidth(min: 280, ideal: 320, max: 400)
        } detail: {
            detailColumn
        }
        .navigationSplitViewStyle(.balanced)
        .accessibilityIdentifier(AccessibilityIDs.Library.root)
        .searchable(text: $searchText, prompt: Text(L10n.string("library.search.prompt")))
        .onChange(of: model.submissions) { _, submissions in
            syncSplitSelection(with: submissions)
        }
        .onChange(of: selection) { _, newSelection in
            guard layout.usesSplitNavigation, let newSelection else { return }
            activeDetailID = newSelection
        }
    }

    @ViewBuilder
    private var sidebar: some View {
        List(selection: $selection) {
            if model.isEmpty {
                Section {
                    Label(
                        L10n.string("library.empty.title"),
                        systemImage: "mappin.and.ellipse"
                    )
                    .foregroundStyle(.secondary)
                    .accessibilityIdentifier(AccessibilityIDs.Library.emptyState)
                }
            }

            ForEach(displayedSubmissions) { submission in
                SubmissionRow(submission: submission, score: model.score(for: submission))
                    .tag(submission.id)
                    .accessibilityIdentifier(AccessibilityIDs.Library.row(submission.id.uuidString))
            }
            .onDelete { requestDelete(at: $0, in: displayedSubmissions) }
        }
        .listStyle(.sidebar)
        .refreshable { model.load() }
    }

    @ViewBuilder
    private var detailColumn: some View {
        if let activeDetailID {
            NavigationStack {
                editor(for: submissionForDetail(activeDetailID))
            }
            .id(activeDetailID)
        } else {
            EmptyStateView(
                systemImage: "sidebar.left",
                title: L10n.string("library.detail.placeholder.title"),
                message: L10n.string("library.detail.placeholder.message"),
                identifier: "submissionLibrary.detailPlaceholder"
            )
        }
    }

    private func submissionForDetail(_ id: UUID) -> Submission? {
        model.submissions.first(where: { $0.id == id }) ?? Submission(id: id)
    }

    // MARK: - Shared pieces

    private var emptyState: some View {
        VStack(spacing: Theme.Spacing.lg) {
            EmptyStateView(
                systemImage: "mappin.and.ellipse",
                title: L10n.string("library.empty.title"),
                message: L10n.string("library.empty.message"),
                identifier: AccessibilityIDs.Library.emptyState
            )

            Button {
                showingGuide = true
            } label: {
                Text(L10n.string("guide.emptyLink"))
                    .font(.subheadline.weight(.medium))
            }
            .frame(minHeight: Theme.minTouchTarget)
            .accessibilityIdentifier(AccessibilityIDs.Guide.emptyStateLink)
        }
    }

    private var guideToolbarItem: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarLeading) {
            Button {
                showingGuide = true
            } label: {
                Image(systemName: "book")
            }
            .accessibilityIdentifier(AccessibilityIDs.Guide.openButton)
            .accessibilityLabel(Text(L10n.string("guide.title")))

            Button {
                showingSettings = true
            } label: {
                Image(systemName: "gearshape")
            }
            .accessibilityIdentifier(AccessibilityIDs.Settings.openButton)
            .accessibilityLabel(Text(L10n.string("settings.title")))
        }
    }

    /// iPhone add: pushes the editor via a link.
    private var addToolbarItemLink: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            NavigationLink {
                editor(for: nil)
            } label: {
                Image(systemName: "plus")
            }
            .accessibilityIdentifier(AccessibilityIDs.Library.addButton)
            .accessibilityLabel(Text(L10n.string("library.add")))
        }
    }

    /// iPad add: shows a new draft in the detail column.
    private var addToolbarItemButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                draftID = UUID()
                activeDetailID = draftID
                selection = nil
            } label: {
                Image(systemName: "plus")
            }
            .accessibilityIdentifier(AccessibilityIDs.Library.addButton)
            .accessibilityLabel(Text(L10n.string("library.add")))
        }
    }

    private func editor(for submission: Submission?) -> some View {
        SubmissionEditorView(
            dependencies: dependencies,
            existing: submission,
            focusPlaceNameOnAppear: isNewDraft(submission),
            onSaved: { savedID in
                if layout.usesSplitNavigation {
                    activeDetailID = savedID
                    selection = savedID
                }
                model.load()
            }
        )
    }

    /// Unsaved drafts (iPhone push or iPad detail column) should focus the place name field.
    private func isNewDraft(_ submission: Submission?) -> Bool {
        guard let submission else { return true }
        return !model.submissions.contains(where: { $0.id == submission.id })
    }

    /// Keeps the sidebar selection aligned with the list on iPad.
    private func syncSplitSelection(with submissions: [Submission]) {
        guard layout.usesSplitNavigation else { return }

        if let activeDetailID, !submissions.contains(where: { $0.id == activeDetailID }) {
            selection = nil
            return
        }

        if let activeDetailID, submissions.contains(where: { $0.id == activeDetailID }) {
            selection = activeDetailID
            return
        }

        activeDetailID = submissions.first?.id
        selection = submissions.first?.id
    }

    private func requestDelete(at offsets: IndexSet, in submissions: [Submission]) {
        guard let index = offsets.first else { return }
        submissionPendingDelete = submissions[index]
    }

    private func confirmDelete(_ submission: Submission) {
        if submission.id == selection { selection = nil }
        if submission.id == activeDetailID { activeDetailID = nil }
        model.delete(submission)
        submissionPendingDelete = nil
        HapticFeedback.lightImpact()
    }
}

#Preview("iPhone") {
    SubmissionLibraryView(dependencies: .preview())
        .environment(\.layoutContext, LayoutContext(idiom: .phone, horizontal: .compact, vertical: .regular))
}

#Preview("iPad") {
    SubmissionLibraryView(dependencies: .preview())
        .environment(\.layoutContext, LayoutContext(idiom: .pad, horizontal: .regular, vertical: .regular))
}
