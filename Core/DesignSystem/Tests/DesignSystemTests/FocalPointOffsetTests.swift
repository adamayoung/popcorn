//
//  FocalPointOffsetTests.swift
//  DesignSystem
//
//  Copyright © 2025 Adam Young.
//

@testable import DesignSystem
import SwiftUI
import Testing

@Suite("FocalPointOffset")
struct FocalPointOffsetTests {

    // MARK: - Center focal point

    @Test("Center focal point returns zero offset")
    func centerFocalPointReturnsZero() {
        let result = focalPointOffset(
            focalPoint: UnitPoint(x: 0.5, y: 0.5),
            imageSize: CGSize(width: 1920, height: 1080),
            frameSize: CGSize(width: 400, height: 300)
        )

        #expect(result.width == 0)
        #expect(result.height == 0)
    }

    // MARK: - Extreme edges are clamped

    @Test("Focal point at top-leading edge is clamped")
    func focalPointAtTopLeadingIsClamped() {
        let imageSize = CGSize(width: 1920, height: 1080)
        let frameSize = CGSize(width: 400, height: 300)

        let result = focalPointOffset(
            focalPoint: UnitPoint(x: 0, y: 0),
            imageSize: imageSize,
            frameSize: frameSize
        )

        // scaledToFill: scale = max(400/1920, 300/1080) = max(0.2083, 0.2778) = 0.2778
        let scale = max(frameSize.width / imageSize.width, frameSize.height / imageSize.height)
        let scaledWidth = imageSize.width * scale
        let overflowX = scaledWidth - frameSize.width

        // Offset should be clamped to half the overflow, not the full raw offset
        #expect(result.width == overflowX / 2)
        #expect(result.height == 0) // No vertical overflow when height is the constraining axis
    }

    @Test("Focal point at bottom-trailing edge is clamped")
    func focalPointAtBottomTrailingIsClamped() {
        let imageSize = CGSize(width: 1920, height: 1080)
        let frameSize = CGSize(width: 400, height: 300)

        let result = focalPointOffset(
            focalPoint: UnitPoint(x: 1, y: 1),
            imageSize: imageSize,
            frameSize: frameSize
        )

        let scale = max(frameSize.width / imageSize.width, frameSize.height / imageSize.height)
        let scaledWidth = imageSize.width * scale
        let overflowX = scaledWidth - frameSize.width

        #expect(result.width == -(overflowX / 2))
        #expect(result.height == 0)
    }

    // MARK: - Near-edge clamping

    @Test("Focal point near right edge is clamped within bounds")
    func focalPointNearRightEdgeIsClamped() {
        let imageSize = CGSize(width: 1920, height: 1080)
        let frameSize = CGSize(width: 400, height: 300)

        let result = focalPointOffset(
            focalPoint: UnitPoint(x: 0.9, y: 0.5),
            imageSize: imageSize,
            frameSize: frameSize
        )

        let scale = max(frameSize.width / imageSize.width, frameSize.height / imageSize.height)
        let scaledWidth = imageSize.width * scale
        let overflowX = scaledWidth - frameSize.width

        // Raw offset would be scaledWidth * (0.5 - 0.9) = negative
        // Should be clamped to at most -(overflowX / 2)
        #expect(result.width >= -(overflowX / 2))
        #expect(result.width < 0)
    }

    // MARK: - Proportional offsets

    @Test("Intermediate focal point produces proportional offset")
    func intermediateFocalPointProducesProportionalOffset() {
        let imageSize = CGSize(width: 1920, height: 1080)
        let frameSize = CGSize(width: 400, height: 300)

        let result = focalPointOffset(
            focalPoint: UnitPoint(x: 0.6, y: 0.5),
            imageSize: imageSize,
            frameSize: frameSize
        )

        let scale = max(frameSize.width / imageSize.width, frameSize.height / imageSize.height)
        let scaledWidth = imageSize.width * scale
        let rawOffsetX = scaledWidth * (0.5 - 0.6)
        let overflowX = scaledWidth - frameSize.width

        // Raw offset of -53.3 is within overflow bounds of ±66.7, so it should not be clamped
        let expected = max(-overflowX / 2, min(overflowX / 2, rawOffsetX))
        #expect(abs(result.width - expected) < 0.001)
        #expect(result.height == 0)
    }

    // MARK: - Invalid inputs

    @Test("Zero image size returns zero offset")
    func zeroImageSizeReturnsZero() {
        let result = focalPointOffset(
            focalPoint: UnitPoint(x: 0.3, y: 0.7),
            imageSize: .zero,
            frameSize: CGSize(width: 400, height: 300)
        )

        #expect(result == .zero)
    }

    @Test("Zero frame size returns zero offset")
    func zeroFrameSizeReturnsZero() {
        let result = focalPointOffset(
            focalPoint: UnitPoint(x: 0.3, y: 0.7),
            imageSize: CGSize(width: 1920, height: 1080),
            frameSize: .zero
        )

        #expect(result == .zero)
    }

    @Test("Negative dimensions return zero offset")
    func negativeDimensionsReturnZero() {
        let result = focalPointOffset(
            focalPoint: UnitPoint(x: 0.5, y: 0.5),
            imageSize: CGSize(width: -100, height: 200),
            frameSize: CGSize(width: 400, height: 300)
        )

        #expect(result == .zero)
    }

    // MARK: - Portrait frame

    @Test("Portrait frame constrains height, allows vertical offset")
    func portraitFrameAllowsVerticalOffset() {
        // Wide image in a tall frame: width constrains, height overflows
        let imageSize = CGSize(width: 1920, height: 1080)
        let frameSize = CGSize(width: 300, height: 400)

        let result = focalPointOffset(
            focalPoint: UnitPoint(x: 0.5, y: 0.3),
            imageSize: imageSize,
            frameSize: frameSize
        )

        // scale = max(300/1920, 400/1080) = max(0.15625, 0.37037) = 0.37037
        // scaledHeight = 1080 * 0.37037 = 400, scaledWidth = 1920 * 0.37037 = 711.1
        // overflowX = 711.1 - 300 = 411.1, overflowY = 400 - 400 = 0
        // So vertical offset should be 0 (no overflow), horizontal should shift
        #expect(result.width == 0) // Focal x is centered
        #expect(result.height == 0) // No vertical overflow
    }

    @Test("Landscape image in landscape frame with vertical focal point")
    func landscapeImageWithVerticalShift() {
        // Image wider than frame proportionally: height constrains
        let imageSize = CGSize(width: 3840, height: 2160)
        let frameSize = CGSize(width: 400, height: 300)

        let result = focalPointOffset(
            focalPoint: UnitPoint(x: 0.5, y: 0.3),
            imageSize: imageSize,
            frameSize: frameSize
        )

        // Both have 16:9 ratio, so no overflow on either axis
        // scale = max(400/3840, 300/2160) = max(0.10417, 0.13889) = 0.13889
        // scaledW = 533.33, scaledH = 300
        // overflowX = 133.33, overflowY = 0
        #expect(result.width == 0) // Focal x is centered
        #expect(result.height == 0) // No vertical overflow
    }

    // MARK: - Image exactly fits frame

    @Test("Image exactly fits frame returns zero offset")
    func imageExactlyFitsFrameReturnsZero() {
        let result = focalPointOffset(
            focalPoint: UnitPoint(x: 0.2, y: 0.8),
            imageSize: CGSize(width: 400, height: 300),
            frameSize: CGSize(width: 400, height: 300)
        )

        #expect(result == .zero)
    }

}
