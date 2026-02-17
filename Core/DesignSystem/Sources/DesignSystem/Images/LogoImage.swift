//
//  LogoImage.swift
//  DesignSystem
//
//  Copyright © 2026 Adam Young.
//

import SDWebImageSwiftUI
import SwiftUI

/// A view that displays a logo image for a movie or TV series.
///
/// Use this component to display logo images in detail views or headers.
/// The logo is loaded asynchronously and appears with a smooth 2-second fade transition.
/// The image is resizable and scales to fit the available space while maintaining its aspect ratio.
public struct LogoImage: View {

    /// The URL of the logo image to display.
    private var url: URL?

    /// Creates a new logo image view.
    ///
    /// - Parameter url: The URL of the logo image to display.
    public init(url: URL?) {
        self.url = url
    }

    public var body: some View {
        WebImage(url: url)
            .resizable()
            .scaledToFit()
            .transition(.fade(duration: 2.0))
    }

}

#Preview {
    LogoImage(url: URL(string: "https://image.tmdb.org/t/p/w500/7yXEfWFDGpqIfq9wdpMOHcHbi8g.png"))
        .frame(width: 200)
}
