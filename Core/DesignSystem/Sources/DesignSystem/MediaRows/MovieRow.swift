//
//  MovieRow.swift
//  DesignSystem
//
//  Copyright © 2025 Adam Young.
//

import SwiftUI

/// A row component that displays a movie with its poster image and title.
///
/// Use this component in lists or scroll views to display movie information,
/// such as in search results, recommendations, or browsing collections.
///
/// The row displays a rectangular poster image on the left with the movie's title
/// to the right in a horizontal layout.
public struct MovieRow: View {

    /// The unique identifier of the movie.
    public var id: Int

    /// The title of the movie to display.
    public var title: String

    /// The URL of the movie's poster image, if available.
    public var posterURL: URL?

    /// Creates a new movie row.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the movie.
    ///   - title: The title of the movie to display.
    ///   - posterURL: The URL of the movie's poster image. Defaults to `nil`.
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
                    string: "https://image.tmdb.org/t/p/w500/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg"
                )
            )

            MovieRow(
                id: 575_265,
                title: "Mission: Impossible - The Final Reckoning"
            )
        }
    }
}
