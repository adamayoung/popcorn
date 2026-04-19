//
//  EPGProgrammeMapper.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

struct EPGProgrammeMapper {

    func map(_ dto: EPGProgrammeDTO, channelID: String) -> TVProgramme {
        let start = Date(timeIntervalSince1970: dto.startTime)
        let end = start.addingTimeInterval(dto.duration)

        return TVProgramme(
            id: TVProgramme.makeID(channelID: channelID, startTime: start),
            channelID: channelID,
            title: dto.title,
            description: dto.description ?? "",
            startTime: start,
            endTime: end,
            duration: dto.duration,
            episodeNumber: dto.episodeNumber,
            seasonNumber: dto.seasonNumber,
            imageURL: dto.imageURL,
            tmdbTVSeriesID: dto.tmdbTVSeriesID,
            tmdbMovieID: dto.tmdbMovieID
        )
    }

}
