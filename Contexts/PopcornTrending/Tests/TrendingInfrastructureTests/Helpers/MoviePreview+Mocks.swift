//
//  MoviePreview+Mocks.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TrendingDomain

extension MoviePreview {

    static func mock(
        id: Int = 1,
        title: String = "Fight Club",
        overview: String = "An insomniac office worker and a soap salesman build a fight club.",
        posterPath: URL? = URL(string: "/poster.jpg"),
        backdropPath: URL? = URL(string: "/backdrop.jpg")
    ) -> MoviePreview {
        MoviePreview(
            id: id,
            title: title,
            overview: overview,
            posterPath: posterPath,
            backdropPath: backdropPath
        )
    }

    static var mocks: [MoviePreview] {
        [
            .mock(id: 1, title: "Movie One"),
            .mock(id: 2, title: "Movie Two"),
            .mock(id: 3, title: "Movie Three")
        ]
    }

}

extension MoviePreviewPage {

    static func mock(
        page: Int = 1,
        totalPages: Int = 1,
        movies: [MoviePreview] = MoviePreview.mocks
    ) -> MoviePreviewPage {
        MoviePreviewPage(page: page, totalPages: totalPages, movies: movies)
    }

}
