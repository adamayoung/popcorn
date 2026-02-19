//
//  TVSeason+Mocks.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

extension TVSeason {

    static func mock(
        id: Int = 3572,
        name: String = "Season 1",
        seasonNumber: Int = 1,
        posterPath: URL? = URL(string: "/season1poster.jpg")
    ) -> TVSeason {
        TVSeason(
            id: id,
            name: name,
            seasonNumber: seasonNumber,
            posterPath: posterPath
        )
    }

}
