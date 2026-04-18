//
//  TVProgrammeEntityMapper.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

struct TVProgrammeEntityMapper {

    func map(_ entity: TVProgrammeEntity) -> TVProgramme {
        TVProgramme(
            id: entity.programmeID,
            channelID: entity.channelID,
            title: entity.title,
            description: entity.programmeDescription,
            startTime: entity.startTime,
            endTime: entity.endTime,
            duration: entity.duration,
            episodeNumber: entity.episodeNumber,
            seasonNumber: entity.seasonNumber,
            imageURL: entity.imageURL,
            tmdbTVSeriesID: entity.tmdbTVSeriesID,
            tmdbMovieID: entity.tmdbMovieID
        )
    }

    func map(_ programme: TVProgramme) -> TVProgrammeEntity {
        TVProgrammeEntity(
            programmeID: programme.id,
            channelID: programme.channelID,
            title: programme.title,
            programmeDescription: programme.description,
            startTime: programme.startTime,
            endTime: programme.endTime,
            duration: programme.duration,
            episodeNumber: programme.episodeNumber,
            seasonNumber: programme.seasonNumber,
            imageURL: programme.imageURL,
            tmdbTVSeriesID: programme.tmdbTVSeriesID,
            tmdbMovieID: programme.tmdbMovieID
        )
    }

}
