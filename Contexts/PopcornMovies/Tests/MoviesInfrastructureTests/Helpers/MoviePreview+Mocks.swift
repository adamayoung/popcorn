//
//  MoviePreview+Mocks.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain

extension MoviePreview {

    static func mock(
        id: Int = 1,
        title: String = "Inception",
        overview: String = "A mind-bending thriller",
        releaseDate: Date? = Date(timeIntervalSince1970: 1_279_324_800),
        posterPath: URL? = URL(string: "/poster.jpg"),
        backdropPath: URL? = URL(string: "/backdrop.jpg")
    ) -> MoviePreview {
        MoviePreview(
            id: id,
            title: title,
            overview: overview,
            releaseDate: releaseDate,
            posterPath: posterPath,
            backdropPath: backdropPath
        )
    }

    static var mocks: [MoviePreview] {
        [
            .mock(id: 1, title: "Inception"),
            .mock(id: 2, title: "The Dark Knight"),
            .mock(id: 3, title: "Interstellar")
        ]
    }

}
