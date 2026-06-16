import SwiftUI

/// Root navigation. v1.0 is a single-stack experience centered on the library; the
/// editor is pushed for create/iterate. Settings is presented as a sheet.
struct RootView: View {
    let dependencies: AppDependencies

    var body: some View {
        SubmissionLibraryView(dependencies: dependencies)
    }
}

#Preview {
    RootView(dependencies: .preview())
}
