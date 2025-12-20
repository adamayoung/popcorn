//
//  LogoImage.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import SDWebImageSwiftUI
import SwiftUI

public struct LogoImage: View {

    private var url: URL?

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
