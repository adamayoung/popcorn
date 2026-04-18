//
//  TVChannel+Mocks.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

extension TVChannel {

    static func mock(
        id: String = "BBC",
        name: String = "BBC",
        isHD: Bool = false,
        logoURL: URL? = nil,
        channelNumbers: [TVChannelNumber] = []
    ) -> TVChannel {
        TVChannel(
            id: id,
            name: name,
            isHD: isHD,
            logoURL: logoURL,
            channelNumbers: channelNumbers
        )
    }

}

extension TVProgramme {

    static func mock(
        channelID: String = "BBC",
        start: Date = Date(timeIntervalSince1970: 1_776_463_200),
        duration: TimeInterval = 1800,
        title: String = "Programme",
        description: String = "",
        episodeNumber: Int? = nil,
        seasonNumber: Int? = nil,
        imageURL: URL? = nil,
        tmdbTVSeriesID: Int? = nil,
        tmdbMovieID: Int? = nil
    ) -> TVProgramme {
        TVProgramme(
            id: TVProgramme.makeID(channelID: channelID, startTime: start),
            channelID: channelID,
            title: title,
            description: description,
            startTime: start,
            endTime: start.addingTimeInterval(duration),
            duration: duration,
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            imageURL: imageURL,
            tmdbTVSeriesID: tmdbTVSeriesID,
            tmdbMovieID: tmdbMovieID
        )
    }

}
