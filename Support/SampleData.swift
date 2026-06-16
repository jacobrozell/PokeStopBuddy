import Foundation

/// Deterministic fixtures for previews and the `-uitest-seed` launch path.
public enum SampleData {
    public static func submissions() -> [Submission] {
        let generator = TemplateContentGenerator()

        let muralInputs = SubmissionInputs(
            placeName: "riverside community mural",
            category: .publicArt,
            keyFeatures: ["hand-painted", "depicts local wildlife"],
            eligibility: [.historicCultural, .socialExploration],
            locationHint: "on the east wall of the rec center",
            accessNotes: "visible from the public sidewalk",
            style: .descriptive
        )
        var mural = Submission(inputs: muralInputs)
        mural.content = generator.generate(from: muralInputs)
        mural.versions = [mural.content]

        let trailInputs = SubmissionInputs(
            placeName: "oakwood trailhead",
            category: .trailhead,
            keyFeatures: ["marked map board", "connects three trails"],
            eligibility: [.exercise, .socialExploration],
            locationHint: "at the north end of the parking lot",
            style: .concise
        )
        var trail = Submission(inputs: trailInputs, status: .readyToSubmit)
        trail.content = generator.generate(from: trailInputs)
        trail.versions = [trail.content]

        return [mural, trail]
    }
}
