//
//  StillImage.swift
//  DesignSystem
//
//  Copyright © 2026 Adam Young.
//

import SDWebImageSwiftUI
import SwiftUI

/// A view that displays an episode still image.
///
/// Use this component to display widescreen episode still frames for TV episodes,
/// typically in list rows or detail views. The image maintains a 16:9 aspect ratio.
///
/// Images are loaded asynchronously with a smooth transition effect.
public struct StillImage: View {

    /// The standard still aspect ratio (16:9).
    private static let aspectRatio: CGFloat = 16.0 / 9.0

    /// The URL of the still image to display.
    private var url: URL?

    public init(url: URL?) {
        self.url = url
    }

    public var body: some View {
        GeometryReader { proxy in
            WebImage(url: url, options: .forceTransition)
                .resizable()
                .scaledToFill()
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                .clipped()
                .background(Color.secondary.opacity(0.1))
        }
        .accessibilityHidden(true)
    }

    /// Sets the still image height and automatically calculates the width to maintain aspect ratio.
    ///
    /// - Parameter height: The desired height for the still image.
    /// - Returns: A view with the specified height and calculated width.
    public func stillHeight(_ height: CGFloat) -> some View {
        frame(width: height * Self.aspectRatio, height: height)
    }

    /// Sets the still image width and automatically calculates the height to maintain aspect ratio.
    ///
    /// - Parameter width: The desired width for the still image.
    /// - Returns: A view with the specified width and calculated height.
    public func stillWidth(_ width: CGFloat) -> some View {
        frame(width: width, height: width / Self.aspectRatio)
    }

}

#Preview {
    StillImage(
        url: URL(string: "https://image.tmdb.org/t/p/w300/wrGWeW4WKxnaeA8sxJb2T9O6ryo.jpg")
    )
    .stillHeight(80)
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .overlay {
        RoundedRectangle(cornerRadius: 8)
            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
    }
}
