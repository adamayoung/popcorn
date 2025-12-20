//
//  PosterImage.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import SDWebImageSwiftUI
import SwiftUI

public struct PosterImage: View {

    private static let aspectRatio: CGFloat = 500.0 / 750.0

    private var url: URL?

    public init(url: URL?) {
        self.url = url
    }

    public var body: some View {
        GeometryReader { proxy in
            WebImage(url: url)
                .resizable()
                .transition(.fade(duration: 2.0))
                .scaledToFit()
                .aspectRatio(Self.aspectRatio, contentMode: .fill)
                .frame(width: proxy.size.width, height: proxy.size.height)
                .background(Color.secondary.opacity(0.1))
        }
    }

    public func posterHeight(_ height: CGFloat) -> some View {
        frame(width: height * Self.aspectRatio, height: height)
    }

    public func posterWidth(_ width: CGFloat) -> some View {
        frame(width: width, height: width / Self.aspectRatio)
    }

}

#Preview {
    PosterImage(url: URL(string: "https://image.tmdb.org/t/p/w780/z53D72EAOxGRqdr7KXXWp9dJiDe.jpg"))
        .posterWidth(300)
}
