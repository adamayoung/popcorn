//
//  PosterImage.swift
//  DesignSystem
//
//  Copyright © 2026 Adam Young.
//

import SDWebImageSwiftUI
import SwiftUI

/// A view that displays a movie or TV series poster image.
///
/// Use this component to display poster images throughout the app, such as in
/// rows, grids, carousels, or detail views. The image maintains the standard
/// poster aspect ratio of 2:3 (500x750).
///
/// The image is loaded asynchronously with a 2-second fade transition and includes
/// a subtle background for when the image is loading or unavailable.
public struct PosterImage: View {

    /// The standard poster aspect ratio (2:3).
    private static let aspectRatio: CGFloat = 500.0 / 750.0

    /// The URL of the poster image to display.
    private var url: URL?

    /// Creates a new poster image view.
    ///
    /// - Parameter url: The URL of the poster image to display.
    public init(url: URL?) {
        self.url = url
    }

    public var body: some View {
        // Uses GeometryReader to fill available space while maintaining aspect ratio
        GeometryReader { proxy in
            ZStack {
                LinearGradient(
                    colors: [Color.secondary.opacity(0.15), Color.secondary.opacity(0.0)],
                    startPoint: .top,
                    endPoint: .bottom
                )

                WebImage(url: url)
                    .resizable()
                    .transition(.fade(duration: 2.0))
                    .scaledToFit()
                    .aspectRatio(Self.aspectRatio, contentMode: .fill)
                    .frame(width: proxy.size.width, height: proxy.size.height)
            }
        }
        .accessibilityHidden(true)
    }

    /// Sets the poster image height and automatically calculates the width to maintain aspect ratio.
    ///
    /// - Parameter height: The desired height for the poster image.
    /// - Returns: A view with the specified height and calculated width.
    public func posterHeight(_ height: CGFloat) -> some View {
        frame(width: height * Self.aspectRatio, height: height)
    }

    /// Sets the poster image width and automatically calculates the height to maintain aspect ratio.
    ///
    /// - Parameter width: The desired width for the poster image.
    /// - Returns: A view with the specified width and calculated height.
    public func posterWidth(_ width: CGFloat) -> some View {
        frame(width: width, height: width / Self.aspectRatio)
    }

}

#Preview {
    PosterImage(url: URL(string: "https://image.tmdb.org/t/p/w780/z53D72EAOxGRqdr7KXXWp9dJiDe.jpg"))
        .posterWidth(300)
}
