import Foundation

/// Deterministic, offline content generator. Same inputs always produce the same
/// output, which keeps it unit-testable and reproducible for fine-tuning workflows.
public struct TemplateContentGenerator: ContentGenerating {
    public init() {}

    public func generate(from inputs: SubmissionInputs) -> GeneratedContent {
        GeneratedContent(
            title: makeTitle(inputs),
            description: makeDescription(inputs),
            supportingStatement: makeSupporting(inputs),
            origin: .generated
        )
    }

    // MARK: - Title

    private func makeTitle(_ inputs: SubmissionInputs) -> String {
        let name = inputs.placeName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return "" }
        let titled = TextFormatting.titleCased(TextFormatting.collapsedSpaces(name))
        return TextFormatting.truncatedOnWordBoundary(titled, max: GenerationLimits.titleMax)
    }

    // MARK: - Description

    private func makeDescription(_ inputs: SubmissionInputs) -> String {
        let noun = inputs.category.nounPhrase
        let features = inputs.cleanedFeatures.prefix(2)
        let name = inputs.placeName.trimmingCharacters(in: .whitespacesAndNewlines)
        let subject = name.isEmpty ? "This \(noun)" : TextFormatting.titleCased(name)

        var sentence: String
        let featureClause = featurePhrase(Array(features))

        switch inputs.style {
        case .concise:
            sentence = featureClause.isEmpty
                ? "\(subject) is a \(noun)."
                : "\(subject) is a \(noun) — \(featureClause)."
        case .descriptive:
            sentence = featureClause.isEmpty
                ? "\(subject) is a distinctive \(noun) and a recognizable part of the neighborhood."
                : "\(subject) is a distinctive \(noun), \(featureClause), and a recognizable part of the neighborhood."
        case .formal:
            sentence = featureClause.isEmpty
                ? "\(subject) is a \(noun) located in the local community."
                : "\(subject) is a \(noun) located in the local community and is \(featureClause)."
        }

        return TextFormatting.truncatedOnWordBoundary(
            TextFormatting.collapsedSpaces(sentence),
            max: GenerationLimits.descriptionMax
        )
    }

    private func featurePhrase(_ features: [String]) -> String {
        let cleaned = features.map { $0.lowercased() }
        switch cleaned.count {
        case 0: return ""
        case 1: return cleaned[0]
        default: return "\(cleaned[0]) and \(cleaned[1])"
        }
    }

    // MARK: - Supporting statement

    private func makeSupporting(_ inputs: SubmissionInputs) -> String {
        var sentences: [String] = []

        let rationale = eligibilityRationale(inputs.eligibility, style: inputs.style)
        if !rationale.isEmpty { sentences.append(rationale) }

        let locator = locationSentence(inputs)
        if !locator.isEmpty { sentences.append(locator) }

        if sentences.isEmpty {
            sentences.append("This is a permanent, safely accessible spot that adds value to the local community.")
        }

        let joined = sentences.joined(separator: " ")
        return TextFormatting.truncatedOnWordBoundary(
            TextFormatting.collapsedSpaces(joined),
            max: GenerationLimits.supportingMax
        )
    }

    private func eligibilityRationale(_ criteria: Set<EligibilityCriterion>, style: GenerationStyle) -> String {
        // Stable ordering for determinism.
        let ordered = EligibilityCriterion.allCases.filter { criteria.contains($0) }
        guard !ordered.isEmpty else { return "" }

        let fragments = ordered.map { $0.rationaleFragment }
        let list = TextFormatting.naturalList(fragments)
        let lead: String
        switch style {
        case .concise: lead = "It"
        case .descriptive: lead = "This location"
        case .formal: lead = "This nomination qualifies because it"
        }
        return "\(lead) \(list)."
    }

    private func locationSentence(_ inputs: SubmissionInputs) -> String {
        let hint = inputs.locationHint.trimmingCharacters(in: .whitespacesAndNewlines)
        let access = inputs.accessNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        switch (hint.isEmpty, access.isEmpty) {
        case (false, false):
            return "You can find it \(lowercasedFirst(hint)); \(lowercasedFirst(access))."
        case (false, true):
            return "You can find it \(lowercasedFirst(hint))."
        case (true, false):
            return "\(TextFormatting.sentenceCased(access))."
        case (true, true):
            return ""
        }
    }

    private func lowercasedFirst(_ string: String) -> String {
        guard let first = string.first else { return string }
        return first.lowercased() + string.dropFirst()
    }
}
