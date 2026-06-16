import SwiftUI

/// The home surface: a list of saved submissions with quick access to create a new one.
/// Adapts between a navigation stack (iPhone) and a sidebar + detail split (iPad).
struct SubmissionLibraryView: View {
    let dependencies: AppDependencies

    @Environment(\.layoutContext) private var layout
    @State private var model: SubmissionLibraryViewModel
    @State private var showingSettings = false
    @State private var selection: UUID?
    @State private var isCreating = false

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
        .sheet(isPresented: $showingSettings) {
            SettingsView(dependencies: dependencies)
        }
        .onAppear { model.load() }
    }

    // MARK: - iPhone: navigation stack

    private var stackBody: some View {
        NavigationStack {
            content
                .navigationTitle(L10n.string("library.title"))
                .toolbar { settingsToolbarItem; addToolbarItemLink }
                .accessibilityIdentifier(AccessibilityIDs.Library.root)
        }
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
            ForEach(model.submissions) { submission in
                NavigationLink {
                    editor(for: submission)
                } label: {
                    SubmissionRow(submission: submission, score: model.score(for: submission))
                }
                .accessibilityIdentifier(AccessibilityIDs.Library.row(submission.id.uuidString))
            }
            .onDelete(perform: deleteRows)
        }
        .listStyle(.insetGrouped)
    }

    // MARK: - iPad: sidebar + detail split

    private var splitBody: some View {
        NavigationSplitView {
            sidebar
                .navigationTitle(L10n.string("library.title"))
                .toolbar { settingsToolbarItem; addToolbarItemButton }
                .accessibilityIdentifier(AccessibilityIDs.Library.root)
        } detail: {
            detailColumn
        }
    }

    @ViewBuilder
    private var sidebar: some View {
        if model.isEmpty {
            emptyState
        } else {
            List(selection: $selection) {
                ForEach(model.submissions) { submission in
                    SubmissionRow(submission: submission, score: model.score(for: submission))
                        .tag(submission.id)
                        .accessibilityIdentifier(AccessibilityIDs.Library.row(submission.id.uuidString))
                }
                .onDelete(perform: deleteRows)
            }
        }
    }

    @ViewBuilder
    private var detailColumn: some View {
        if isCreating {
            NavigationStack { editor(for: nil) }
        } else if let selection, let submission = model.submissions.first(where: { $0.id == selection }) {
            NavigationStack { editor(for: submission) }
                .id(submission.id) // rebuild the editor when the selection changes
        } else {
            EmptyStateView(
                systemImage: "sidebar.left",
                title: L10n.string("library.detail.placeholder.title"),
                message: L10n.string("library.detail.placeholder.message"),
                identifier: "submissionLibrary.detailPlaceholder"
            )
        }
    }

    // MARK: - Shared pieces

    private var emptyState: some View {
        EmptyStateView(
            systemImage: "mappin.and.ellipse",
            title: L10n.string("library.empty.title"),
            message: L10n.string("library.empty.message"),
            identifier: AccessibilityIDs.Library.emptyState
        )
    }

    private var settingsToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                showingSettings = true
            } label: {
                Image(systemName: "gearshape")
            }
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
                selection = nil
                isCreating = true
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
            onSaved: {
                model.load()
                isCreating = false
            }
        )
    }

    private func deleteRows(_ offsets: IndexSet) {
        for index in offsets {
            let submission = model.submissions[index]
            if submission.id == selection { selection = nil }
            model.delete(submission)
        }
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
