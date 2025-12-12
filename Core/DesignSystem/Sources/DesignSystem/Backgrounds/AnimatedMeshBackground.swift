//
//  AnimatedMeshBackground.swift
//  DesignSystem
//
//  Created by Adam Young on 12/12/2025.
//

import SwiftUI
import UIKit

public struct AnimatedMeshBackground: View {

    private var baseColor: Color

    private let basePositions: [SIMD2<Float>] = [
        .init(x: 0, y: 0), .init(x: 0.2, y: 0), .init(x: 1, y: 0),
        .init(x: 0, y: 0.7), .init(x: 0.1, y: 0.5), .init(x: 1, y: 0.2),
        .init(x: 0, y: 1), .init(x: 0.9, y: 1), .init(x: 1, y: 1)
    ]

    public init(baseColor: Color) {
        self.baseColor = baseColor
    }

    public var body: some View {
        TimelineView(.animation) { timeline in
            let t = timeline.date.timeIntervalSince1970
            let positions = animatedPositions(at: t)

            MeshGradient(
                width: 3,
                height: 3,
                points: positions,
                colors: [
                    .black, baseColor, baseColor.lighter(),
                    baseColor, baseColor, baseColor,
                    baseColor, baseColor.lighter(), .black
                ]
            )
        }
    }

    private func animatedPositions(at time: TimeInterval) -> [SIMD2<Float>] {
        var positions = basePositions
        let t = time

        // index 1: move horizontally in [0.2, 0.9]
        positions[1].x = oscillate(
            time: t,
            range: (0.2, 0.9),
            phase: 0.0,
            speed: 0.3
        )
        positions[1].y = 0

        // index 3: move vertically in [0.2, 0.8]
        positions[3].x = 0
        positions[3].y = oscillate(
            time: t,
            range: (0.2, 0.8),
            phase: 1.0,
            speed: 0.25
        )

        // index 4: move in both x and y in [0.3, 0.8]
        positions[4].x = oscillate(
            time: t,
            range: (0.3, 0.8),
            phase: 0.5,
            speed: 0.35
        )
        positions[4].y = oscillate(
            time: t,
            range: (0.3, 0.8),
            phase: 2.0,
            speed: 0.28
        )

        // index 5: move vertically on right edge in [0.1, 0.9]
        positions[5].x = 1
        positions[5].y = oscillate(
            time: t,
            range: (0.1, 0.9),
            phase: 1.5,
            speed: 0.32
        )

        // index 7: move horizontally on bottom edge in [0.1, 0.9]
        positions[7].x = oscillate(
            time: t,
            range: (0.1, 0.9),
            phase: 0.8,
            speed: 0.3
        )
        positions[7].y = 1

        return positions
    }

    private func oscillate(
        time: TimeInterval,
        range: (min: Float, max: Float),
        phase: Double,
        speed: Double
    ) -> Float {
        let u = Float((sin(time * speed + phase) + 1) * 0.5)  // 0...1
        return range.min + (range.max - range.min) * u
    }
}

extension Color {

    fileprivate func lighter(by amount: CGFloat = 0.2) -> Color {
        let uiColor = UIColor(self)

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return self
        }

        return Color(
            .sRGB,
            red: Double(min(r + amount, 1)),
            green: Double(min(g + amount, 1)),
            blue: Double(min(b + amount, 1)),
            opacity: Double(a)
        )
    }

}
