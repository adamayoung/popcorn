//
//  ProfileImage.swift
//  DesignSystem
//
//  Copyright © 2026 Adam Young.
//

import SDWebImageSwiftUI
import SwiftUI

/// A view that displays a person's profile image with initials as a placeholder.
///
/// Use this component to display profile images for people such as actors, directors,
/// or crew members. The image fills the available space using a geometry reader.
///
/// When a profile image URL is provided, the image is loaded asynchronously with a
/// smooth transition effect. While loading or when no image is available, the person's
/// initials are shown as a placeholder over a subtle gradient background.
public struct ProfileImage: View {

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// The URL of the profile image to display.
    private var url: URL?

    /// The person's initials to show as a placeholder.
    private var initials: String?

    /// Whether to detect and align to the focal point of the image.
    private var detectFocalPoint = false

    @State private var isInitialsVisible = false
    @State private var focalOffset: CGSize = .zero
    @State private var focalPointResolved = false

    /// Creates a new profile image view.
    ///
    /// - Parameters:
    ///   - url: The URL of the profile image to display.
    ///   - initials: The person's initials to show as a placeholder. Defaults to `nil`.
    public init(url: URL?, initials: String? = nil) {
        self.url = url
        self.initials = initials
        self._isInitialsVisible = .init(initialValue: url == nil)
    }

    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                LinearGradient(
                    colors: [.white.opacity(0.25), .white.opacity(0.0)],
                    startPoint: .top,
                    endPoint: .bottom
                )

                if isInitialsVisible, let initials {
                    Text(verbatim: initials)
                        .font(.system(size: proxy.size.width * 0.4, weight: .medium))
                        .foregroundStyle(.secondary)
                }

                WebImage(url: url, options: detectFocalPoint ? [] : .forceTransition)
                    .onSuccess { image, _, _ in
                        if detectFocalPoint, !focalPointResolved {
                            analyzeImage(image, frameSize: proxy.size)
                        }
                    }
                    .onFailure { _ in
                        Task { @MainActor in
                            if detectFocalPoint, !focalPointResolved {
                                focalPointResolved = true
                            }

                            isInitialsVisible = true
                        }
                    }
                    .resizable()
                    .scaledToFill()
                    .offset(focalOffset)
                    .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                    .clipped()
                    .opacity(imageOpacity)
                    .onAppear {
                        if detectFocalPoint, url == nil {
                            focalPointResolved = true
                        }
                    }
            }
        }
    }

    /// Enables focal point detection on the profile image.
    ///
    /// When enabled, the image is analyzed using Vision framework face detection
    /// (with saliency fallback) to find the most important region. The visible
    /// portion of the image is then shifted to center on that region, while
    /// ensuring the image always fully covers the frame.
    ///
    /// The image is kept hidden until analysis completes so the user only ever
    /// sees the image at its final focal-point-aligned position.
    ///
    /// - Returns: A `ProfileImage` with focal point detection enabled.
    public func focalPointAlignment() -> ProfileImage {
        var copy = self
        copy.detectFocalPoint = true
        return copy
    }

}

// MARK: - Focal Point Analysis

extension ProfileImage {

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
                if reduceMotion {
                    focalPointResolved = true
                } else {
                    withAnimation(.easeIn(duration: 0.3)) {
                        focalPointResolved = true
                    }
                }
            }
        }
    }

}

#Preview("With Image") {
    ProfileImage(
        url: URL(string: "https://image.tmdb.org/t/p/h632/q4TanMDI5Rgsvw4SfyNbPBh4URr.jpg"),
        initials: "ST"
    )
    .frame(width: 150, height: 150)
    .clipShape(.circle)
}

#Preview("Without Image") {
    ProfileImage(
        url: nil,
        initials: "TC"
    )
    .frame(width: 150, height: 150)
    .clipShape(.circle)
}
