import SwiftUI

/// The home surface: a list of saved submissions with quick access to create a new one.
struct SubmissionLibraryView: View {
    let dependencies: AppDependencies

    @State private var model: SubmissionLibraryViewModel
    @State private var showingSettings = false

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _model = State(initialValue: SubmissionLibraryViewModel(
            repository: dependencies.repository,
            evaluator: dependencies.evaluator
        ))
    }

    var body: some View {
        NavigationStack {
            Group {
                if model.isEmpty {
                    EmptyStateView(
                        systemImage: "mappin.and.ellipse",
                        title: L10n.string("library.empty.title"),
                        message: L10n.string("library.empty.message"),
                        identifier: AccessibilityIDs.Library.emptyState
                    )
                } else {
                    list
                }
            }
            .navigationTitle(L10n.string("library.title"))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    .accessibilityLabel(Text(L10n.string("settings.title")))
                }
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
            .accessibilityIdentifier(AccessibilityIDs.Library.root)
            .sheet(isPresented: $showingSettings) {
                SettingsView(dependencies: dependencies)
            }
            .onAppear { model.load() }
        }
    }

    private var list: some View {
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

    private func editor(for submission: Submission?) -> some View {
        SubmissionEditorView(
            dependencies: dependencies,
            existing: submission,
            onSaved: { model.load() }
        )
    }

    private func deleteRows(_ offsets: IndexSet) {
        for index in offsets {
            model.delete(model.submissions[index])
        }
    }
}

#Preview {
    SubmissionLibraryView(dependencies: .preview())
}
