import UIKit
import XCTest
@testable import WaypointWriter

/// Verifies guide screenshot assets referenced by the catalog are bundled (or schematics apply).
final class GuideAssetCatalogTests: XCTestCase {
    private let expectedAssetNames = [
        "guide.process.menu",
        "guide.process.map",
        "guide.process.mainPhoto",
        "guide.process.supportingPhoto",
        "guide.process.titleDescription",
        "guide.process.category",
        "guide.process.preview",
        "guide.process.supporting",
        "guide.process.upload"
    ]

    func testProcessScreenshotAssetsAreBundled() {
        for name in expectedAssetNames {
            XCTAssertNotNil(
                UIImage(named: name),
                "Missing bundled guide asset \(name). Run Scripts/generate_guide_assets.swift or add captures per docs/guide-screenshot-checklist.md."
            )
        }
    }

    func testCatalogReferencesMatchExpectedAssets() {
        let referenced = Set(GuideCatalog.article(for: .process).screenshots.map(\.assetName))
        XCTAssertTrue(referenced.isSubset(of: Set(expectedAssetNames)))
        XCTAssertFalse(referenced.isEmpty)
    }
}
