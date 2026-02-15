//
//  FocalPointAnalyzer.swift
//  DesignSystem
//
//  Copyright © 2025 Adam Young.
//

import SwiftUI
import Vision

/// Analyzes images using the Vision framework to detect a focal point
/// based on face detection with saliency-based fallback.
///
/// Use this to determine the most visually important region of an image,
/// allowing backdrop images to be aligned to faces or salient content
/// rather than always centering on the geometric middle.
public actor FocalPointAnalyzer {

    static let shared = FocalPointAnalyzer()

    private let cache = NSCache<NSString, FocalPointResult>()

    private init() {
        cache.countLimit = 100
    }

    /// Pre-warms Vision ML models by running dummy requests on a 1x1 pixel image.
    ///
    /// Call this early in the app lifecycle (e.g. during setup) to avoid a UI
    /// freeze on the first real focal point analysis.
    public static func warmUp() {
        Task.detached(priority: .utility) {
            guard let cgImage = CGContext(
                data: nil,
                width: 1,
                height: 1,
                bitsPerComponent: 8,
                bytesPerRow: 4,
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            )?.makeImage()
            else {
                return
            }

            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try? handler.perform([
                VNDetectFaceRectanglesRequest(),
                VNGenerateAttentionBasedSaliencyImageRequest()
            ])
        }
    }

    /// Analyzes the given image to find the most prominent focal point.
    ///
    /// Vision analysis runs off the actor to avoid blocking cache lookups.
    ///
    /// - Parameters:
    ///   - cgImage: The `CGImage` to analyze.
    ///   - url: The URL used as a cache key.
    /// - Returns: A `UnitPoint` representing the focal point in SwiftUI coordinates
    ///   (0,0 = top-leading, 1,1 = bottom-trailing), or `nil` if no focal point was detected.
    func focalPoint(for cgImage: CGImage, url: URL) async -> UnitPoint? {
        let key = url.absoluteString as NSString

        if let cached = cache.object(forKey: key) {
            return cached.point
        }

        // Run Vision analysis off the actor — it's CPU-intensive and doesn't need actor state
        let result = await Task.detached(priority: .userInitiated) {
            detectFocalPoint(in: cgImage)
        }.value

        cache.setObject(FocalPointResult(point: result), forKey: key)
        return result
    }

}

// MARK: - Detection (nonisolated, runs on cooperative pool)

private func detectFocalPoint(in cgImage: CGImage) -> UnitPoint? {
    if let faceCenter = detectFaces(in: cgImage) {
        return faceCenter
    }

    return detectSaliency(in: cgImage)
}

private func detectFaces(in cgImage: CGImage) -> UnitPoint? {
    let request = VNDetectFaceRectanglesRequest()
    let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

    do {
        try handler.perform([request])
    } catch {
        return nil
    }

    guard let results = request.results, !results.isEmpty else {
        return nil
    }

    var weightedX: CGFloat = 0
    var weightedY: CGFloat = 0
    var totalWeight: CGFloat = 0

    for face in results {
        let box = face.boundingBox
        let area = box.width * box.height
        weightedX += box.midX * area
        weightedY += box.midY * area
        totalWeight += area
    }

    guard totalWeight > 0 else {
        return nil
    }

    let centerX = weightedX / totalWeight
    let centerY = weightedY / totalWeight

    // Vision uses bottom-left origin; flip Y for SwiftUI's top-left origin
    return UnitPoint(x: centerX, y: 1 - centerY)
}

private func detectSaliency(in cgImage: CGImage) -> UnitPoint? {
    let request = VNGenerateAttentionBasedSaliencyImageRequest()
    let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

    do {
        try handler.perform([request])
    } catch {
        return nil
    }

    guard let result = request.results?.first,
          let salientObjects = result.salientObjects, !salientObjects.isEmpty
    else {
        return nil
    }

    var weightedX: CGFloat = 0
    var weightedY: CGFloat = 0
    var totalWeight: CGFloat = 0

    for object in salientObjects {
        let box = object.boundingBox
        let weight = CGFloat(object.confidence) * box.width * box.height
        weightedX += box.midX * weight
        weightedY += box.midY * weight
        totalWeight += weight
    }

    guard totalWeight > 0 else {
        return nil
    }

    let centerX = weightedX / totalWeight
    let centerY = weightedY / totalWeight

    // Vision uses bottom-left origin; flip Y for SwiftUI's top-left origin
    return UnitPoint(x: centerX, y: 1 - centerY)
}

// MARK: - Cache Value Wrapper

// Safety: @unchecked Sendable is safe because all stored properties are immutable (let).
private final class FocalPointResult: @unchecked Sendable {

    let point: UnitPoint?

    init(point: UnitPoint?) {
        self.point = point
    }

}
