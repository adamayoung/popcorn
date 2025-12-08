//
//  ProfileImage.swift
//  DesignSystem
//
//  Created by Adam Young on 09/06/2025.
//

import SDWebImageSwiftUI
import SwiftUI

public struct ProfileImage: View {

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
                .background(Color.secondary.opacity(0.1))
        }
    }

}

#Preview {
    ProfileImage(
        url: URL(string: "https://image.tmdb.org/t/p/h632/uDnIdU4KGjQg7liFvb9wnALvg95.jpg")
    )
}
