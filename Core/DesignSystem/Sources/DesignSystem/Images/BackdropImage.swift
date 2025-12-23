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

    /// Creates a new backdrop image view.
    ///
    /// - Parameters:
    ///   - url: The URL of the backdrop image to display.
    ///   - logoURL: The URL of the logo image to overlay. Defaults to `nil`.
    public init(
        url: URL?,
        logoURL: URL? = nil
    ) {
        self.url = url
        self.logoURL = logoURL
    }

    public var body: some View {
        // Uses GeometryReader to fill available space while maintaining aspect ratio
        GeometryReader { proxy in
            WebImage(url: url, options: .forceTransition)
                .resizable()
                .scaledToFill()
                .aspectRatio(Self.aspectRatio, contentMode: .fill)
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
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

#Preview {
    BackdropImage(
        url: URL(string: "https://image.tmdb.org/t/p/w1280/aESb695wTIF0tB7RTGRebnYrjFK.jpg")
    )
    .backdropWidth(350)
}
