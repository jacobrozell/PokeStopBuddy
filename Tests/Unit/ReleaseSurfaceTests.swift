import XCTest
@testable import PokeStopBuddy

final class ReleaseSurfaceTests: XCTestCase {
    func testReleaseDefaults_hideGatedFeatures() {
        let surface = ReleaseSurface(flags: .release)
        XCTAssertTrue(surface.submissionEditor)
        XCTAssertTrue(surface.submissionLibrary)
        XCTAssertTrue(surface.qualityCoach)
        XCTAssertTrue(surface.settings)

        XCTAssertFalse(surface.photoGuidance)
        XCTAssertFalse(surface.llmEnhance)
        XCTAssertFalse(surface.exportSharePack)
    }

    func testFullSurfaceFlag_revealsGatedFeatures() {
        let flags = FeatureFlags.fromProcess(["-enable_full_product_surface"])
        let surface = ReleaseSurface(flags: flags)
        XCTAssertTrue(surface.photoGuidance)
        XCTAssertTrue(surface.llmEnhance)
        XCTAssertTrue(surface.exportSharePack)
    }

    func testTelemetry_offWhenDisabledArgPresent() {
        let flags = FeatureFlags.fromProcess(["-disable-telemetry"])
        XCTAssertFalse(flags.telemetryEnabled)
    }
}
