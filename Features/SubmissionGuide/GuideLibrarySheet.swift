import SwiftUI

/// Presents the submission guide hub from the library toolbar or empty-state link.
struct GuideLibrarySheet: View {
    @Binding var isPresented: Bool

    var body: some View {
        NavigationStack {
            SubmissionGuideView()
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(L10n.string("common.done")) { isPresented = false }
                            .accessibilityIdentifier(AccessibilityIDs.Guide.doneButton)
                    }
                }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
}
