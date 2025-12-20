//
//  TVSeriesRow.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import SwiftUI

public struct TVSeriesRow: View {

    public var id: Int
    public var name: String
    public var posterURL: URL?

    public init(
        id: Int,
        name: String,
        posterURL: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.posterURL = posterURL
    }

    public var body: some View {
        HStack {
            PosterImage(url: posterURL)
                .posterWidth(80)
                .cornerRadius(10)
                .clipped()

            Text(verbatim: name)
        }
    }

}

#Preview {
    NavigationStack {
        List {
            TVSeriesRow(
                id: 247_718,
                name: "MobLand",
                posterURL: URL(
                    string: "https://image.tmdb.org/t/p/w500/abeH7n5pcuQcwYcTxG6DTZvXLP1.jpg"
                )
            )

            TVSeriesRow(
                id: 100_088,
                name: "The Last of Us",
                posterURL: URL(
                    string: "https://image.tmdb.org/t/p/w500/dmo6TYuuJgaYinXBPjrgG9mB5od.jpg"
                )
            )
        }
    }
}
