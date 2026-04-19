//
//  TVProgramme+Mock.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

extension TVProgramme {

    static func mock(
        channelID: String = "BBC",
        offset: TimeInterval = 0,
        duration: TimeInterval = 1800,
        title: String = "Programme",
        description: String = "",
        episodeNumber: Int? = nil,
        seasonNumber: Int? = nil,
        imageURL: URL? = nil,
        tmdbTVSeriesID: Int? = nil,
        tmdbMovieID: Int? = nil,
        baseStart: TimeInterval = 1_776_463_200
    ) -> TVProgramme {
        let start = Date(timeIntervalSince1970: baseStart + offset)
        let end = start.addingTimeInterval(duration)
        return TVProgramme(
            id: TVProgramme.makeID(channelID: channelID, startTime: start),
            channelID: channelID,
            title: title,
            description: description,
            startTime: start,
            endTime: end,
            duration: duration,
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            imageURL: imageURL,
            tmdbTVSeriesID: tmdbTVSeriesID,
            tmdbMovieID: tmdbMovieID
        )
    }

}
