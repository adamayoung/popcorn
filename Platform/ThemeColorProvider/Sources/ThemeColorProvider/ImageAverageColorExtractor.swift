//
//  ImageAverageColorExtractor.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import CoreImage
import Foundation

/// Extracts the average color from image data using Core Image.
enum ImageAverageColorExtractor {

    /// Extracts the average color from raw image data.
    ///
    /// Uses `CIAreaAverage` to compute the mean color across the entire image,
    /// then reads the resulting 1x1 pixel as RGBA values.
    ///
    /// - Parameter data: The raw image data (PNG, JPEG, etc.).
    ///
    /// - Returns: A ``ThemeColor`` with the average RGB values, or `nil` if extraction fails.
    static func averageColor(from data: Data) -> ThemeColor? {
        guard let ciImage = CIImage(data: data) else {
            return nil
        }

        let extent = ciImage.extent
        guard let filter = CIFilter(name: "CIAreaAverage") else {
            return nil
        }

        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(CIVector(cgRect: extent), forKey: kCIInputExtentKey)

        guard let outputImage = filter.outputImage else {
            return nil
        }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext()
        context.render(
            outputImage,
            toBitmap: &bitmap,
            rowBytes: 4,
            bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
            format: .RGBA8,
            colorSpace: nil
        )

        let red = Double(bitmap[0]) / 255.0
        let green = Double(bitmap[1]) / 255.0
        let blue = Double(bitmap[2]) / 255.0

        return ThemeColor(red: red, green: green, blue: blue)
    }

}
