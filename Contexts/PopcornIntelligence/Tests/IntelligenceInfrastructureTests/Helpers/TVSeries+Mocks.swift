//
//  TVSeries+Mocks.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import IntelligenceDomain

extension TVSeries {

    static func mock(
        id: Int = 1,
        name: String = "Test TV Series",
        tagline: String? = "A great show",
        overview: String = "A test TV series overview",
        numberOfSeasons: Int = 5,
        posterPath: URL? = URL(string: "/poster.jpg"),
        backdropPath: URL? = URL(string: "/backdrop.jpg")
    ) -> TVSeries {
        TVSeries(
            id: id,
            name: name,
            tagline: tagline,
            overview: overview,
            numberOfSeasons: numberOfSeasons,
            posterPath: posterPath,
            backdropPath: backdropPath
        )
    }

}
