//
//  ImageAverageColorExtractorTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import CoreGraphics
import CoreImage
import Foundation
import Testing
@testable import ThemeColorProvider

@Suite("ImageAverageColorExtractor")
struct ImageAverageColorExtractorTests {

    @Test("extracts average color from solid red image")
    func extractsAverageColorFromSolidRedImage() throws {
        let data = try Self.solidColorPNGData(red: 255, green: 0, blue: 0)

        let result = ImageAverageColorExtractor.averageColor(from: data)

        let themeColor = try #require(result)
        #expect(abs(themeColor.red - 1.0) < 0.02)
        #expect(abs(themeColor.green - 0.0) < 0.02)
        #expect(abs(themeColor.blue - 0.0) < 0.02)
    }

    @Test("extracts average color from solid green image")
    func extractsAverageColorFromSolidGreenImage() throws {
        let data = try Self.solidColorPNGData(red: 0, green: 255, blue: 0)

        let result = ImageAverageColorExtractor.averageColor(from: data)

        let themeColor = try #require(result)
        #expect(abs(themeColor.red - 0.0) < 0.02)
        #expect(abs(themeColor.green - 1.0) < 0.02)
        #expect(abs(themeColor.blue - 0.0) < 0.02)
    }

    @Test("returns nil for invalid data")
    func returnsNilForInvalidData() {
        let result = ImageAverageColorExtractor.averageColor(from: Data([0xFF, 0x00, 0x42]))

        #expect(result == nil)
    }

    @Test("returns nil for empty data")
    func returnsNilForEmptyData() {
        let result = ImageAverageColorExtractor.averageColor(from: Data())

        #expect(result == nil)
    }

    @Test("grayscale image returns equal RGB values")
    func grayscaleImageReturnsEqualRGBValues() throws {
        let data = try Self.solidColorPNGData(red: 128, green: 128, blue: 128)

        let result = ImageAverageColorExtractor.averageColor(from: data)

        let themeColor = try #require(result)
        #expect(abs(themeColor.red - themeColor.green) < 0.02)
        #expect(abs(themeColor.green - themeColor.blue) < 0.02)
    }

}

extension ImageAverageColorExtractorTests {

    private static func solidColorPNGData(red: UInt8, green: UInt8, blue: UInt8) throws -> Data {
        let width = 2
        let height = 2
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue

        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        )
        else {
            throw ImageTestError.failedToCreateContext
        }

        guard let fillColor = CGColor(
            colorSpace: colorSpace,
            components: [
                CGFloat(red) / 255.0,
                CGFloat(green) / 255.0,
                CGFloat(blue) / 255.0,
                1.0
            ]
        )
        else {
            throw ImageTestError.failedToCreateContext
        }

        context.setFillColor(fillColor)
        context.fill(CGRect(x: 0, y: 0, width: width, height: height))

        guard let cgImage = context.makeImage() else {
            throw ImageTestError.failedToCreateImage
        }

        let ciImage = CIImage(cgImage: cgImage)
        let ciContext = CIContext()
        guard let pngData = ciContext.pngRepresentation(
            of: ciImage,
            format: .RGBA8,
            colorSpace: colorSpace
        )
        else {
            throw ImageTestError.failedToCreatePNG
        }

        return pngData
    }

    private enum ImageTestError: Error {
        case failedToCreateContext
        case failedToCreateImage
        case failedToCreatePNG
    }

}
