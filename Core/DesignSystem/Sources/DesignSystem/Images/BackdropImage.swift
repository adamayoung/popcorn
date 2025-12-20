//
//  BackdropImage.swift
//  DesignSystem
//
//  Copyright © 2025 Adam Young.
//

import SDWebImageSwiftUI
import SwiftUI

public struct BackdropImage: View {

    private static let aspectRatio: CGFloat = 3840.0 / 2160.0

    private var url: URL?
    private var logoURL: URL?

    public init(
        url: URL?,
        logoURL: URL? = nil
    ) {
        self.url = url
        self.logoURL = logoURL
    }

    public var body: some View {
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

    public func backdropHeight(_ height: CGFloat) -> some View {
        frame(width: height * Self.aspectRatio, height: height)
    }

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
