//
//  FocalPointOffset.swift
//  DesignSystem
//
//  Copyright © 2025 Adam Young.
//

import SwiftUI

/// Computes the offset needed to center a focal point within a frame,
/// clamped so the scaled image always fully covers the frame.
///
/// When a `scaledToFill` image is displayed in a frame, the geometric center
/// of the image is shown by default. This function computes an offset that
/// shifts the visible portion toward the given focal point. The offset is
/// clamped so the image never shifts far enough to reveal empty space.
///
/// - Parameters:
///   - focalPoint: The focal point in image coordinates as a `UnitPoint`
///     (0,0 = top-leading, 1,1 = bottom-trailing).
///   - imageSize: The original size of the image in points.
///   - frameSize: The size of the frame the image is displayed in.
/// - Returns: A `CGSize` offset to apply to the image. Returns `.zero` for
///   invalid inputs or when the focal point is already centered.
func focalPointOffset(focalPoint: UnitPoint, imageSize: CGSize, frameSize: CGSize) -> CGSize {
    guard imageSize.width > 0,
          imageSize.height > 0,
          frameSize.width > 0,
          frameSize.height > 0
    else {
        return .zero
    }

    // scaledToFill uses the larger scale factor
    let scaleX = frameSize.width / imageSize.width
    let scaleY = frameSize.height / imageSize.height
    let scale = max(scaleX, scaleY)

    let scaledWidth = imageSize.width * scale
    let scaledHeight = imageSize.height * scale

    // How much the scaled image overflows the frame on each axis
    let overflowX = scaledWidth - frameSize.width
    let overflowY = scaledHeight - frameSize.height

    // Raw offset to center the focal point in the frame
    let rawOffsetX = scaledWidth * (0.5 - focalPoint.x)
    let rawOffsetY = scaledHeight * (0.5 - focalPoint.y)

    // Clamp so the image always fills the frame
    let clampedX = max(-overflowX / 2, min(overflowX / 2, rawOffsetX))
    let clampedY = max(-overflowY / 2, min(overflowY / 2, rawOffsetY))

    return CGSize(width: clampedX, height: clampedY)
}
