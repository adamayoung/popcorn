//
//  ProfileImage.swift
//  DesignSystem
//
//  Copyright © 2026 Adam Young.
//

import SDWebImageSwiftUI
import SwiftUI

/// A view that displays a person's profile image.
///
/// Use this component to display profile images for people such as actors, directors,
/// or crew members. The image fills the available space using a geometry reader and
/// includes a subtle background for when the image is loading or unavailable.
///
/// The image is loaded asynchronously with a smooth transition effect.
public struct ProfileImage: View {

    /// The URL of the profile image to display.
    private var url: URL?

    /// Creates a new profile image view.
    ///
    /// - Parameter url: The URL of the profile image to display.
    public init(url: URL?) {
        self.url = url
    }

    public var body: some View {
        // Uses GeometryReader to fill available space
        GeometryReader { proxy in
            WebImage(url: url, options: .forceTransition)
                .resizable()
                .scaledToFill()
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                .background(Color.secondary.opacity(0.1))
        }
    }

}

#Preview {
    ProfileImage(
        url: URL(string: "https://image.tmdb.org/t/p/h632/uDnIdU4KGjQg7liFvb9wnALvg95.jpg")
    )
}
