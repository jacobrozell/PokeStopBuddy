import SwiftUI

/// Binds nested editor controls to the guide topic sheet on `SubmissionEditorView`.
private struct PresentedGuideTopicKey: EnvironmentKey {
    static let defaultValue: Binding<GuideTopic?> = .constant(nil)
}

extension EnvironmentValues {
    var presentedGuideTopic: Binding<GuideTopic?> {
        get { self[PresentedGuideTopicKey.self] }
        set { self[PresentedGuideTopicKey.self] = newValue }
    }
}
