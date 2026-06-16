import Foundation
import SwiftData

/// Explicit migration plan. v1.0 has a single schema; future versions add stages here
/// and a migration test (N−1 → N) in CI.
public enum SubmissionMigrationPlan: SchemaMigrationPlan {
    public static var schemas: [any VersionedSchema.Type] {
        [SchemaV1.self]
    }

    public static var stages: [MigrationStage] {
        []
    }
}
