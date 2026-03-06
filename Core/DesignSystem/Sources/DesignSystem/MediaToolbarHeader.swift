//
//  MediaToolbarHeader.swift
//  DesignSystem
//
//  Copyright © 2026 Adam Young.
//

import SwiftUI

public struct MediaToolbarHeader: View {

    private let title: String
    private let posterURL: URL?

    public init(title: String, posterURL: URL? = nil) {
        self.title = title
        self.posterURL = posterURL
    }

    public var body: some View {
        VStack(spacing: 0) {
            PosterImage(url: posterURL)
                .posterHeight(50)
                .zIndex(1)

            Text(verbatim: title)
                .padding(.spacing8)
                .glassEffect(.regular, in: .capsule)
                .offset(y: -.spacing5)
        }
        .font(.headline)
        .padding(.top, .spacing30)
    }

}

#Preview {
    let title = "Fight Club"
    let posterURL = URL(string: "https://image.tmdb.org/t/p/w500/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg")

    NavigationStack {
        List {}
            .navigationTitle(title)
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    ZStack {
                        Color.clear.frame(height: 0)
                        MediaToolbarHeader(
                            title: title,
                            posterURL: posterURL
                        )
                        .transition(.opacity)
                    }
                }
            }
    }
}
