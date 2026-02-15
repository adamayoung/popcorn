//
//  BackdropImage.swift
//  DesignSystem
//
//  Copyright © 2025 Adam Young.
//

import SDWebImageSwiftUI
import SwiftUI

/// A view that displays a backdrop image with an optional logo overlay.
///
/// Use this component to display wide-format backdrop images for movies and TV series,
/// typically in headers, detail views, or carousels. The image maintains the standard
/// backdrop aspect ratio of 16:9 (3840x2160).
///
/// The view supports an optional logo overlay positioned at the bottom center of the backdrop.
/// Images are loaded asynchronously with a smooth transition effect.
public struct BackdropImage: View {

    /// The standard backdrop aspect ratio (16:9).
    private static let aspectRatio: CGFloat = 3840.0 / 2160.0

    /// The URL of the backdrop image to display.
    private var url: URL?

    /// The URL of the logo image to overlay on the backdrop, if available.
    private var logoURL: URL?

    /// Whether to detect and align to the focal point of the image.
    private var detectFocalPoint = false

    @State private var focalOffset: CGSize = .zero
    @State private var focalPointResolved = false

    public init(
        url: URL?,
        logoURL: URL? = nil
    ) {
        self.url = url
        self.logoURL = logoURL
    }

    public var body: some View {
        GeometryReader { proxy in
            WebImage(url: url, options: detectFocalPoint ? [] : .forceTransition)
                .onSuccess { image, _, _ in
                    if detectFocalPoint, !focalPointResolved {
                        analyzeImage(image, frameSize: proxy.size)
                    }
                }
                .resizable()
                .scaledToFill()
                .aspectRatio(Self.aspectRatio, contentMode: .fill)
                .offset(focalOffset)
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                .clipped()
                .opacity(imageOpacity)
                .background(Color.secondary.opacity(0.1))
                .overlay(alignment: .bottom) {
                    if let logoURL {
                        WebImage(url: logoURL, options: .forceTransition)
                            .resizable()
                            .scaledToFit()
                            .frame(width: proxy.size.width / 1.5)
                            .padding(.bottom, proxy.size.height / 10)
                    }
                }
        }
    }

    /// Enables focal point detection on the backdrop image.
    ///
    /// When enabled, the image is analyzed using Vision framework face detection
    /// (with saliency fallback) to find the most important region. The visible
    /// portion of the image is then shifted to center on that region, while
    /// ensuring the image always fully covers the frame.
    ///
    /// The image is kept hidden until analysis completes so the user only ever
    /// sees the image at its final focal-point-aligned position.
    ///
    /// - Returns: A `BackdropImage` with focal point detection enabled.
    public func focalPointAlignment() -> BackdropImage {
        var copy = self
        copy.detectFocalPoint = true
        return copy
    }

    /// Sets the backdrop image height and automatically calculates the width to maintain aspect ratio.
    ///
    /// - Parameter height: The desired height for the backdrop image.
    /// - Returns: A view with the specified height and calculated width.
    public func backdropHeight(_ height: CGFloat) -> some View {
        frame(width: height * Self.aspectRatio, height: height)
    }

    /// Sets the backdrop image width and automatically calculates the height to maintain aspect ratio.
    ///
    /// - Parameter width: The desired width for the backdrop image.
    /// - Returns: A view with the specified width and calculated height.
    public func backdropWidth(_ width: CGFloat) -> some View {
        frame(width: width, height: width / Self.aspectRatio)
    }

}

// MARK: - Focal Point Analysis

extension BackdropImage {

    /// Image opacity: always visible when not detecting focal point,
    /// hidden until analysis resolves when detecting.
    private var imageOpacity: Double {
        detectFocalPoint ? (focalPointResolved ? 1 : 0) : 1
    }

    private func analyzeImage(_ image: SDWebImageSwiftUI.PlatformImage, frameSize: CGSize) {
        guard let url else {
            focalPointResolved = true
            return
        }

        let cgImage: CGImage?
        #if canImport(UIKit)
            cgImage = image.cgImage
        #elseif canImport(AppKit)
            cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil)
        #endif

        guard let cgImage else {
            focalPointResolved = true
            return
        }

        let imageSize = CGSize(width: cgImage.width, height: cgImage.height)

        Task {
            let point = await FocalPointAnalyzer.shared.focalPoint(for: cgImage, url: url)
            let offset = point.map { focalPointOffset(focalPoint: $0, imageSize: imageSize, frameSize: frameSize) }

            await MainActor.run {
                if let offset { focalOffset = offset }
                withAnimation(.easeIn(duration: 0.3)) {
                    focalPointResolved = true
                }
            }
        }
    }

}

#Preview {
    BackdropImage(
        url: URL(string: "https://image.tmdb.org/t/p/w1280/aESb695wTIF0tB7RTGRebnYrjFK.jpg")
    )
    .backdropWidth(350)
}
