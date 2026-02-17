//
//  Movie+Mocks.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import IntelligenceDomain

extension Movie {

    static func mock(
        id: Int = 1,
        title: String = "Test Movie",
        overview: String = "A test movie overview",
        releaseDate: Date? = Date(timeIntervalSince1970: 1_609_459_200),
        posterPath: URL? = URL(string: "/poster.jpg"),
        backdropPath: URL? = URL(string: "/backdrop.jpg")
    ) -> Movie {
        Movie(
            id: id,
            title: title,
            overview: overview,
            releaseDate: releaseDate,
            posterPath: posterPath,
            backdropPath: backdropPath
        )
    }

}
