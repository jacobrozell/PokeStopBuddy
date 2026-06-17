import Foundation
import SwiftData

/// Persistence bootstrap failure surfaced to the recovery screen.
public struct BootstrapError: LocalizedError, Sendable {
    public let message: String

    public var errorDescription: String? { message }
}

/// Composition root. Wires concrete implementations once at launch; Features receive
/// protocol types only.
@MainActor
public final class AppDependencies {
    public let repository: any SubmissionRepository
    public let generator: any ContentGenerating
    public let evaluator: any QualityEvaluating
    public let preferences: AppPreferences
    public let releaseSurface: ReleaseSurface
    public let flags: FeatureFlags

    public init(
        repository: any SubmissionRepository,
        generator: any ContentGenerating,
        evaluator: any QualityEvaluating,
        preferences: AppPreferences,
        flags: FeatureFlags
    ) {
        self.repository = repository
        self.generator = generator
        self.evaluator = evaluator
        self.preferences = preferences
        self.flags = flags
        self.releaseSurface = ReleaseSurface(flags: flags)
    }

    /// Live bootstrap. Returns a fail-fast error if persistence can't start so the
    /// app can show a recovery screen instead of crashing.
    public static func bootstrap(flags: FeatureFlags = .fromProcess()) -> Result<AppDependencies, BootstrapError> {
        do {
            let container = try PersistenceContainerFactory.makeContainer()
            let repository = SwiftDataSubmissionRepository(container: container)

            if flags.resetStore {
                try? repository.deleteAll()
            }
            if flags.seedFixtures {
                for submission in SampleData.submissions() {
                    try? repository.save(submission)
                }
            }

            return .success(AppDependencies(
                repository: repository,
                generator: TemplateContentGenerator(),
                evaluator: SubmissionQualityEvaluator(),
                preferences: AppPreferences(),
                flags: flags
            ))
        } catch {
            AppLog.data.error("Persistence bootstrap failed: \(error.localizedDescription)")
            return .failure(BootstrapError(message: error.localizedDescription))
        }
    }

    /// In-memory dependencies for previews and tests.
    public static func preview(seed: [Submission] = SampleData.submissions()) -> AppDependencies {
        AppDependencies(
            repository: InMemorySubmissionRepository(seed: seed),
            generator: TemplateContentGenerator(),
            evaluator: SubmissionQualityEvaluator(),
            preferences: AppPreferences(defaults: previewDefaults()),
            flags: .release
        )
    }

    /// An isolated, ephemeral defaults suite so previews/tests never touch `.standard`.
    private static func previewDefaults() -> UserDefaults {
        UserDefaults(suiteName: "com.pokestopbuddy.preview") ?? .standard
    }
}
