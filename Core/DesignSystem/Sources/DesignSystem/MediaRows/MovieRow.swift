//
//  MovieRow.swift
//  DesignSystem
//
//  Created by Adam Young on 28/05/2025.
//

import SwiftUI

public struct MovieRow: View {

    public var id: Int
    public var title: String
    public var posterURL: URL?

    public init(
        id: Int,
        title: String,
        posterURL: URL? = nil
    ) {
        self.id = id
        self.title = title
        self.posterURL = posterURL
    }

    public var body: some View {
        HStack {
            PosterImage(url: posterURL)
                .posterWidth(80)
                .cornerRadius(10)
                .clipped()

            Text(verbatim: title)
        }
    }

}

#Preview {
    NavigationStack {
        List {
            MovieRow(
                id: 550,
                title: "Fight Club",
                posterURL: URL(
                    string: "https://image.tmdb.org/t/p/w500/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg")
            )

            MovieRow(
                id: 575265,
                title: "Mission: Impossible - The Final Reckoning"
            )
        }
    }

}
