import Foundation
import Observation

/// Drives the create / generate / iterate / save journey. No business rules live in the
/// View — generation and evaluation come from injected Domain services.
@MainActor
@Observable
public final class SubmissionEditorViewModel {
    public var inputs: SubmissionInputs
    public var content: GeneratedContent
    public private(set) var versions: [GeneratedContent]
    public private(set) var quality: QualityReport
    public private(set) var errorMessage: String?
    public private(set) var didSave = false

    public var submissionID: UUID { id }

    private let id: UUID
    private let createdAt: Date
    private var status: SubmissionStatus
    private let repository: any SubmissionRepository
    private let generator: any ContentGenerating
    private let evaluator: any QualityEvaluating
    private let now: () -> Date

    public init(
        existing: Submission?,
        repository: any SubmissionRepository,
        generator: any ContentGenerating,
        evaluator: any QualityEvaluating,
        defaultStyle: GenerationStyle = .descriptive,
        defaultCategory: WayspotCategory = .publicArt,
        now: @escaping () -> Date = Date.init
    ) {
        // New submissions inherit the user's preferred defaults; existing ones keep theirs.
        let submission = existing ?? Submission(
            inputs: SubmissionInputs(category: defaultCategory, style: defaultStyle)
        )
        self.id = submission.id
        self.createdAt = submission.createdAt
        self.status = submission.status
        self.inputs = submission.inputs
        self.content = submission.content
        self.versions = submission.versions
        self.repository = repository
        self.generator = generator
        self.evaluator = evaluator
        self.now = now
        self.quality = evaluator.evaluate(submission)
    }

    public var isExisting: Bool { !versions.isEmpty || !content.title.isEmpty }

    /// True when the draft has enough input to persist or generate.
    public var canSave: Bool {
        !inputs.placeName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    public var canGenerate: Bool { canSave }

    /// True when there is generated or edited content to copy or share.
    public var hasShareableContent: Bool {
        !content.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Plain-text bundle for copying into Wayfarer.
    public var clipboardText: String {
        """
        Title: \(content.title)
        Description: \(content.description)
        Supporting: \(content.supportingStatement)
        """
    }

    /// Generate content from the current inputs and append it to version history.
    public func generate() {
        let generated = generator.generate(from: inputs)
        content = generated
        versions.append(generated)
        refreshQuality()
    }

    /// Snapshot a manual edit into history (so the user can revert later).
    public func snapshotManualEdit() {
        let snapshot = GeneratedContent(
            title: content.title,
            description: content.description,
            supportingStatement: content.supportingStatement,
            origin: .manualEdit
        )
        content = snapshot
        versions.append(snapshot)
        refreshQuality()
    }

    public func revert(to version: GeneratedContent) {
        content = version
        refreshQuality()
    }

    /// Recompute quality after any edit. Call from the View on field changes.
    public func refreshQuality() {
        quality = evaluator.evaluate(currentSubmission())
    }

    public func save() {
        if quality.isSubmittable, status == .draft {
            status = .readyToSubmit
        }
        do {
            try repository.save(currentSubmission())
            didSave = true
            errorMessage = nil
        } catch {
            didSave = false
            errorMessage = L10n.string("error.save_failed")
            AppLog.data.error("Save failed: \(String(describing: error))")
        }
    }

    public func clearError() {
        errorMessage = nil
    }

    private func currentSubmission() -> Submission {
        Submission(
            id: id,
            inputs: inputs,
            content: content,
            versions: versions,
            status: status,
            createdAt: createdAt,
            updatedAt: now()
        )
    }
}
