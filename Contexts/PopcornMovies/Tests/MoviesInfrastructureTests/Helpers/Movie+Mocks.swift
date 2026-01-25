//
//  Movie+Mocks.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

extension Movie {

    static func mock(
        id: Int = 1,
        title: String = "Test Movie",
        tagline: String? = "Test Tagline",
        overview: String = "Test Overview",
        runtime: Int? = 120,
        genres: [Genre]? = Genre.mocks,
        releaseDate: Date? = Date(timeIntervalSince1970: 0),
        posterPath: URL? = URL(string: "https://example.com/poster.jpg"),
        backdropPath: URL? = URL(string: "https://example.com/backdrop.jpg"),
        budget: Double? = 100_000_000,
        revenue: Double? = 500_000_000,
        homepageURL: URL? = URL(string: "https://example.com/movie")
    ) -> Movie {
        Movie(
            id: id,
            title: title,
            tagline: tagline,
            overview: overview,
            runtime: runtime,
            genres: genres,
            releaseDate: releaseDate,
            posterPath: posterPath,
            backdropPath: backdropPath,
            budget: budget,
            revenue: revenue,
            homepageURL: homepageURL
        )
    }

}

extension Genre {

    static let mocks: [Genre] = [
        Genre(id: 28, name: "Action"),
        Genre(id: 12, name: "Adventure")
    ]

}
