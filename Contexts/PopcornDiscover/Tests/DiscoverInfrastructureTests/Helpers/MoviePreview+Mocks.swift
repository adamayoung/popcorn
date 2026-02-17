//
//  MoviePreview+Mocks.swift
//  PopcornDiscover
//
//  Copyright © 2026 Adam Young.
//

import DiscoverDomain
import Foundation

extension MoviePreview {

    static func mock(
        id: Int = 1,
        title: String = "Test Movie",
        overview: String = "A test movie overview",
        releaseDate: Date = Date(timeIntervalSince1970: 0),
        genreIDs: [Int] = [28, 12],
        posterPath: URL? = URL(string: "/poster.jpg"),
        backdropPath: URL? = URL(string: "/backdrop.jpg")
    ) -> MoviePreview {
        MoviePreview(
            id: id,
            title: title,
            overview: overview,
            releaseDate: releaseDate,
            genreIDs: genreIDs,
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
