import Foundation

/// Produces submission content from structured inputs.
///
/// v1.0 ships `TemplateContentGenerator` (offline, deterministic). An LLM-backed
/// generator can conform to this same protocol later, behind a feature flag.
public protocol ContentGenerating: Sendable {
    func generate(from inputs: SubmissionInputs) -> GeneratedContent
}
