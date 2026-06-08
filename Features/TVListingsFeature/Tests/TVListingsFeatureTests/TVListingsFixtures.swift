//
//  TVListingsFixtures.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

enum TVListingsFixtures {

    static func makeChannel(id: String, name: String) -> TVChannel {
        TVChannel(
            id: id,
            name: name,
            isHD: false,
            logoURL: nil,
            channelNumbers: []
        )
    }

    static func makeProgramme(id: String, channelID: String, title: String) -> TVProgramme {
        TVProgramme(
            id: id,
            channelID: channelID,
            title: title,
            description: "",
            startTime: Date(timeIntervalSince1970: 1000),
            endTime: Date(timeIntervalSince1970: 1900),
            duration: 900,
            episodeNumber: nil,
            seasonNumber: nil,
            imageURL: nil,
            tmdbTVSeriesID: nil,
            tmdbMovieID: nil
        )
    }

}
