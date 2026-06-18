#!/usr/bin/env swift
// Renders AppIcon-1024.png from the same flat-top hex geometry as BrandMarkView.
//
// Usage: swift Scripts/generate_app_icon.swift

import AppKit
import Foundation

let repoRoot = URL(fileURLWithPath: #file)
    .deletingLastPathComponent()
    .deletingLastPathComponent()

let canvas = CGSize(width: 1024, height: 1024)
let launchBackground = NSColor(
    calibratedRed: 0.039,
    green: 0.086,
    blue: 0.157,
    alpha: 1
)
let shadowColor = NSColor(calibratedRed: 0.03, green: 0.05, blue: 0.11, alpha: 1)
let dotColor = NSColor(calibratedRed: 0.30, green: 0.82, blue: 0.88, alpha: 1)

/// Matches `BrandMarkView` layout at a given mark width.
private struct MarkLayout {
    let markWidth: CGFloat
    let markHeight: CGFloat
    let cornerRadius: CGFloat
    let shadowOffset: CGSize
    let bounds: CGRect
    let hexFrame: CGRect
    let shadowFrame: CGRect
    let dotFrame: CGRect

    init(markWidth: CGFloat) {
        self.markWidth = markWidth
        markHeight = markWidth * 0.866_025_4
        cornerRadius = markWidth * 0.09
        shadowOffset = CGSize(width: markWidth * 0.1, height: markHeight * 0.09)

        let clusterWidth = markWidth + markWidth * 0.14
        let clusterHeight = markHeight + markHeight * 0.12
        let origin = CGPoint(
            x: (canvas.width - clusterWidth) / 2,
            y: (canvas.height - clusterHeight) / 2
        )
        bounds = CGRect(origin: origin, size: CGSize(width: clusterWidth, height: clusterHeight))
        hexFrame = CGRect(
            x: bounds.minX,
            y: bounds.minY,
            width: markWidth,
            height: markHeight
        )
        shadowFrame = hexFrame.offsetBy(dx: shadowOffset.width, dy: shadowOffset.height)
        let dotDiameter = markWidth * 0.24
        dotFrame = CGRect(
            x: hexFrame.midX - dotDiameter / 2,
            y: hexFrame.midY - dotDiameter / 2,
            width: dotDiameter,
            height: dotDiameter
        )
    }
}

private func flatTopHexPoints(in rect: CGRect) -> [CGPoint] {
    [
        CGPoint(x: rect.minX + rect.width * 0.25, y: rect.minY),
        CGPoint(x: rect.minX + rect.width * 0.75, y: rect.minY),
        CGPoint(x: rect.maxX, y: rect.midY),
        CGPoint(x: rect.minX + rect.width * 0.75, y: rect.maxY),
        CGPoint(x: rect.minX + rect.width * 0.25, y: rect.maxY),
        CGPoint(x: rect.minX, y: rect.midY)
    ]
}

private func roundedPolygonPath(points: [CGPoint], radius: CGFloat) -> NSBezierPath {
    let path = NSBezierPath()
    let count = points.count

    for index in 0..<count {
        let current = points[index]
        let previous = points[(index - 1 + count) % count]
        let next = points[(index + 1) % count]

        let toPrevious = CGPoint(x: previous.x - current.x, y: previous.y - current.y)
        let toNext = CGPoint(x: next.x - current.x, y: next.y - current.y)

        let previousLength = hypot(toPrevious.x, toPrevious.y)
        let nextLength = hypot(toNext.x, toNext.y)
        guard previousLength > 0, nextLength > 0 else { continue }

        let corner = min(radius, previousLength * 0.45, nextLength * 0.45)
        let start = CGPoint(
            x: current.x + toPrevious.x / previousLength * corner,
            y: current.y + toPrevious.y / previousLength * corner
        )
        let end = CGPoint(
            x: current.x + toNext.x / nextLength * corner,
            y: current.y + toNext.y / nextLength * corner
        )

        if index == 0 {
            path.move(to: start)
        } else {
            path.line(to: start)
        }
        path.curve(to: end, controlPoint1: current, controlPoint2: current)
    }

    path.close()
    return path
}

private func hexPath(in rect: CGRect, cornerRadius: CGFloat) -> NSBezierPath {
    let points = flatTopHexPoints(in: rect)
    guard cornerRadius > 0 else {
        let path = NSBezierPath()
        path.move(to: points[0])
        for point in points.dropFirst() {
            path.line(to: point)
        }
        path.close()
        return path
    }
    return roundedPolygonPath(points: points, radius: cornerRadius)
}

private func drawIcon(into rep: NSBitmapImageRep) {
    guard let graphicsContext = NSGraphicsContext(bitmapImageRep: rep) else { return }

    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = graphicsContext

    // Bitmap contexts use a bottom-left origin; flip to match SwiftUI / BrandMarkView.
    graphicsContext.cgContext.translateBy(x: 0, y: canvas.height)
    graphicsContext.cgContext.scaleBy(x: 1, y: -1)

    let layout = MarkLayout(markWidth: canvas.width * 0.58)

    launchBackground.setFill()
    NSBezierPath(rect: CGRect(origin: .zero, size: canvas)).fill()

    shadowColor.setFill()
    hexPath(in: layout.shadowFrame, cornerRadius: layout.cornerRadius).fill()

    NSColor.white.setFill()
    hexPath(in: layout.hexFrame, cornerRadius: layout.cornerRadius).fill()

    dotColor.setFill()
    NSBezierPath(ovalIn: layout.dotFrame).fill()

    NSGraphicsContext.restoreGraphicsState()
}

private func writePNG(to url: URL) throws {
    guard let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: Int(canvas.width),
        pixelsHigh: Int(canvas.height),
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: .deviceRGB,
        bytesPerRow: 0,
        bitsPerPixel: 0
    ) else {
        throw NSError(domain: "generate_app_icon", code: 1)
    }

    drawIcon(into: rep)

    guard let data = rep.representation(using: .png, properties: [:]) else {
        throw NSError(domain: "generate_app_icon", code: 2)
    }
    try data.write(to: url)
}

let output = repoRoot
    .appendingPathComponent("Resources/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png")
try writePNG(to: output)
print("Wrote \(output.path)")
