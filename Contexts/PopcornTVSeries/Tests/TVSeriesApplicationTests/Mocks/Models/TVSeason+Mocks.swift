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
        overview: String? = "The first season of Breaking Bad.",
        posterPath: URL? = URL(string: "/season1poster.jpg"),
        episodes: [TVEpisode] = [
            TVEpisode.mock(id: 1, name: "Pilot", episodeNumber: 1),
            TVEpisode.mock(id: 2, name: "Cat's in the Bag...", episodeNumber: 2)
        ]
    ) -> TVSeason {
        TVSeason(
            id: id,
            name: name,
            seasonNumber: seasonNumber,
            overview: overview,
            posterPath: posterPath,
            episodes: episodes
        )
    }

}
