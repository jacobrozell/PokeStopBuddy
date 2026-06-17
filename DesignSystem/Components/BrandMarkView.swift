import SwiftUI

/// Flat-top hexagon used for the PokeStop Buddy brand mark.
struct BrandHexagonShape: Shape {
    var cornerRadius: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        let points = [
            CGPoint(x: rect.minX + rect.width * 0.25, y: rect.minY),
            CGPoint(x: rect.minX + rect.width * 0.75, y: rect.minY),
            CGPoint(x: rect.maxX, y: rect.midY),
            CGPoint(x: rect.minX + rect.width * 0.75, y: rect.maxY),
            CGPoint(x: rect.minX + rect.width * 0.25, y: rect.maxY),
            CGPoint(x: rect.minX, y: rect.midY)
        ]

        guard cornerRadius > 0, points.count > 2 else {
            var path = Path()
            path.addLines(points)
            path.closeSubpath()
            return path
        }

        return roundedPolygonPath(points: points, radius: cornerRadius)
    }

    private func roundedPolygonPath(points: [CGPoint], radius: CGFloat) -> Path {
        var path = Path()
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

            let corner = min(
                radius,
                previousLength * 0.45,
                nextLength * 0.45
            )

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
                path.addLine(to: start)
            }
            path.addQuadCurve(to: end, control: current)
        }

        path.closeSubpath()
        return path
    }
}

/// Vector brand mark (hex waypoint + cyan dot). Avoids stretching bitmap app-icon assets
/// on splash, launch, and onboarding.
struct BrandMarkView: View {
    var size: CGFloat = 120
    var showsLongShadow: Bool = true

    private var markWidth: CGFloat { size }
    /// Flat-top regular hexagon: height = width × √3/2.
    private var markHeight: CGFloat { size * 0.866_025_4 }
    private var cornerRadius: CGFloat { size * 0.09 }

    var body: some View {
        ZStack(alignment: .center) {
            if showsLongShadow {
                BrandHexagonShape(cornerRadius: cornerRadius)
                    .fill(Color(red: 0.03, green: 0.05, blue: 0.11))
                    .frame(width: markWidth, height: markHeight)
                    .offset(x: markWidth * 0.1, y: markHeight * 0.09)
            }

            BrandHexagonShape(cornerRadius: cornerRadius)
                .fill(.white)
                .frame(width: markWidth, height: markHeight)

            Circle()
                .fill(Color(red: 0.30, green: 0.82, blue: 0.88))
                .frame(width: markWidth * 0.24, height: markWidth * 0.24)
        }
        .frame(
            width: markWidth + (showsLongShadow ? markWidth * 0.14 : 0),
            height: markHeight + (showsLongShadow ? markHeight * 0.12 : 0),
            alignment: .center
        )
        .accessibilityHidden(true)
    }
}

#Preview("Brand Mark") {
    ZStack {
        Color("LaunchBackground").ignoresSafeArea()
        BrandMarkView(size: 120)
    }
}
