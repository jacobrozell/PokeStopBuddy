#!/usr/bin/env swift
// Generates educational placeholder PNGs in Resources/Assets.xcassets.
// Replace with real Pokémon GO captures per docs/guide-screenshot-checklist.md.
//
// Usage: swift Scripts/generate_guide_assets.swift

import AppKit
import Foundation

let assetIDs = [
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

let repoRoot = URL(fileURLWithPath: #file)
    .deletingLastPathComponent()
    .deletingLastPathComponent()
let catalogRoot = repoRoot.appendingPathComponent("Resources/Assets.xcassets")

func shortLabel(for assetID: String) -> String {
    assetID.replacingOccurrences(of: "guide.process.", with: "")
        .replacingOccurrences(of: "Photo", with: " photo")
}

func drawPlaceholder(assetID: String, size: NSSize) -> NSImage {
    let image = NSImage(size: size)
    image.lockFocus()

    let bg = NSColor(calibratedRed: 0.93, green: 0.96, blue: 0.98, alpha: 1)
    bg.setFill()
    NSBezierPath(rect: NSRect(origin: .zero, size: size)).fill()

    let accent = NSColor(calibratedRed: 0.12, green: 0.55, blue: 0.62, alpha: 1)
    accent.setStroke()
    let inset = NSRect(x: 12, y: 12, width: size.width - 24, height: size.height - 24)
    let border = NSBezierPath(roundedRect: inset, xRadius: 12, yRadius: 12)
    border.lineWidth = 2
    border.stroke()

    let title = "Illustrated guide"
    let subtitle = shortLabel(for: assetID)
    let footer = "Replace with GO screenshot"

    let titleAttrs: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: 20, weight: .semibold),
        .foregroundColor: NSColor(calibratedWhite: 0.15, alpha: 1)
    ]
    let subtitleAttrs: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: 16, weight: .medium),
        .foregroundColor: accent
    ]
    let footerAttrs: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: 11, weight: .regular),
        .foregroundColor: NSColor(calibratedWhite: 0.45, alpha: 1)
    ]

    let titleSize = (title as NSString).size(withAttributes: titleAttrs)
    let subtitleSize = (subtitle as NSString).size(withAttributes: subtitleAttrs)
    let footerSize = (footer as NSString).size(withAttributes: footerAttrs)

    let blockHeight = titleSize.height + 8 + subtitleSize.height + 12 + footerSize.height
    var y = (size.height + blockHeight) / 2

    (title as NSString).draw(
        at: NSPoint(x: (size.width - titleSize.width) / 2, y: y),
        withAttributes: titleAttrs
    )
    y -= titleSize.height + 8

    (subtitle as NSString).draw(
        at: NSPoint(x: (size.width - subtitleSize.width) / 2, y: y),
        withAttributes: subtitleAttrs
    )
    y -= subtitleSize.height + 12

    (footer as NSString).draw(
        at: NSPoint(x: (size.width - footerSize.width) / 2, y: y),
        withAttributes: footerAttrs
    )

    image.unlockFocus()
    return image
}

func writePNG(_ image: NSImage, to url: URL) throws {
    guard let tiff = image.tiffRepresentation,
          let rep = NSBitmapImageRep(data: tiff),
          let data = rep.representation(using: .png, properties: [:]) else {
        throw NSError(domain: "generate_guide_assets", code: 1)
    }
    try data.write(to: url)
}

func writeContentsJSON(in folder: URL, filename: String) throws {
    let json: [String: Any] = [
        "images": [
            ["filename": filename, "idiom": "universal", "scale": "1x"],
            ["idiom": "universal", "scale": "2x"],
            ["idiom": "universal", "scale": "3x"]
        ],
        "info": ["author": "xcode", "version": 1]
    ]
    let data = try JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted, .sortedKeys])
    try data.write(to: folder.appendingPathComponent("Contents.json"))
}

for assetID in assetIDs {
    let imageset = catalogRoot.appendingPathComponent("\(assetID).imageset")
    try FileManager.default.createDirectory(at: imageset, withIntermediateDirectories: true)
    let filename = "\(assetID).png"
    let image = drawPlaceholder(assetID: assetID, size: NSSize(width: 390, height: 280))
    try writePNG(image, to: imageset.appendingPathComponent(filename))
    try writeContentsJSON(in: imageset, filename: filename)
    print("Wrote \(imageset.path)")
}

print("Done — \(assetIDs.count) guide assets.")
