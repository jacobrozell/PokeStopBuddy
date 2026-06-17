import SwiftUI

/// Settings: external links + destructive "delete all" with confirmation.
struct SettingsView: View {
    let dependencies: AppDependencies
    @Environment(\.dismiss) private var dismiss
    @State private var showingDeleteConfirm = false
    @State private var deleteError: String?

    var body: some View {
        @Bindable var preferences = dependencies.preferences
        return NavigationStack {
            Form {
                Section(L10n.string("settings.section.appearance")) {
                    Picker(L10n.string("settings.appearance"), selection: $preferences.appearance) {
                        ForEach(AppearanceMode.allCases) { mode in
                            Text(mode.displayName).tag(mode)
                        }
                    }
                    .accessibilityIdentifier(AccessibilityIDs.Settings.appearancePicker)
                }

                Section(L10n.string("settings.section.defaults")) {
                    Picker(L10n.string("settings.defaultStyle"), selection: $preferences.defaultStyle) {
                        ForEach(GenerationStyle.allCases) { style in
                            Text(style.displayName).tag(style)
                        }
                    }
                    .accessibilityIdentifier(AccessibilityIDs.Settings.defaultStylePicker)

                    Picker(L10n.string("settings.defaultCategory"), selection: $preferences.defaultCategory) {
                        ForEach(WayspotCategory.allCases) { category in
                            Text(category.displayName).tag(category)
                        }
                    }
                    .accessibilityIdentifier(AccessibilityIDs.Settings.defaultCategoryPicker)
                }

                Section(L10n.string("settings.section.about")) {
                    Link(destination: AppLinks.wayfarerGuidelines) {
                        Label(L10n.string("settings.wayfarer"), systemImage: "book")
                    }
                }

                Section(L10n.string("settings.section.legal")) {
                    Link(destination: AppLinks.privacy) {
                        Label(L10n.string("settings.privacy"), systemImage: "hand.raised")
                    }
                    .accessibilityIdentifier(AccessibilityIDs.Settings.privacyLink)

                    Link(destination: AppLinks.support) {
                        Label(L10n.string("settings.support"), systemImage: "questionmark.circle")
                    }
                    .accessibilityIdentifier(AccessibilityIDs.Settings.supportLink)

                    Link(destination: AppLinks.accessibility) {
                        Label(L10n.string("settings.accessibility"), systemImage: "accessibility")
                    }
                    .accessibilityIdentifier(AccessibilityIDs.Settings.accessibilityLink)

                    // Tip jar row only appears when a URL is configured.
                    if let tipJar = AppLinks.tipJar {
                        Link(destination: tipJar) {
                            Label(L10n.string("settings.tip"), systemImage: "heart")
                        }
                        .accessibilityIdentifier(AccessibilityIDs.Settings.tipJarLink)
                    }
                }

                Section {
                    Button(role: .destructive) {
                        showingDeleteConfirm = true
                    } label: {
                        Label(L10n.string("settings.deleteAll"), systemImage: "trash")
                    }
                    .accessibilityIdentifier(AccessibilityIDs.Settings.deleteAllButton)
                }
            }
            .navigationTitle(L10n.string("settings.title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(L10n.string("common.done")) { dismiss() }
                }
            }
            .accessibilityIdentifier(AccessibilityIDs.Settings.root)
            .confirmationDialog(
                L10n.string("settings.deleteAll.confirm"),
                isPresented: $showingDeleteConfirm,
                titleVisibility: .visible
            ) {
                Button(L10n.string("settings.deleteAll"), role: .destructive) {
                    deleteAll()
                }
                Button(L10n.string("common.cancel"), role: .cancel) {}
            }
            .alert(
                L10n.string("error.delete_failed"),
                isPresented: Binding(
                    get: { deleteError != nil },
                    set: { if !$0 { deleteError = nil } }
                )
            ) {
                Button(L10n.string("common.ok")) { deleteError = nil }
            } message: {
                if let deleteError { Text(deleteError) }
            }
        }
    }

    private func deleteAll() {
        do {
            try dependencies.repository.deleteAll()
        } catch {
            deleteError = error.localizedDescription
        }
    }
}

#Preview {
    SettingsView(dependencies: .preview())
}
