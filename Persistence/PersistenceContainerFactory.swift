import Foundation
import SwiftData

/// Builds the SwiftData `ModelContainer`. Bootstrap failure policy (v1.0): fail-fast;
/// the app shows a recovery screen offering "Reset local data".
public enum PersistenceContainerFactory {
    public static func makeContainer(inMemory: Bool = false) throws -> ModelContainer {
        let configuration = ModelConfiguration(
            schema: Schema(SchemaV1.models),
            isStoredInMemoryOnly: inMemory
        )
        return try ModelContainer(
            for: Schema(SchemaV1.models),
            migrationPlan: SubmissionMigrationPlan.self,
            configurations: [configuration]
        )
    }
}
