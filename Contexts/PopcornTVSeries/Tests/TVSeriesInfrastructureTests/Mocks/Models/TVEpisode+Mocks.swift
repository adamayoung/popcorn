//
//  TVEpisode+Mocks.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

extension TVEpisode {

    static func mock(
        id: Int = 62085,
        name: String = "Pilot",
        episodeNumber: Int = 1,
        seasonNumber: Int = 1,
        overview: String? = "A chemistry teacher diagnosed with cancer turns to cooking meth.",
        airDate: Date? = Date(timeIntervalSince1970: 1_200_000_000),
        runtime: Int? = 58,
        stillPath: URL? = URL(string: "/still.jpg")
    ) -> TVEpisode {
        TVEpisode(
            id: id,
            name: name,
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            overview: overview,
            airDate: airDate,
            runtime: runtime,
            stillPath: stillPath
        )
    }

}
