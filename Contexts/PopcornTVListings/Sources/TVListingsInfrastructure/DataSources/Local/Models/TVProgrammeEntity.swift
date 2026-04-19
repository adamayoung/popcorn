//
//  TVProgrammeEntity.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData

@Model
final class TVProgrammeEntity: Equatable {

    #Index<TVProgrammeEntity>([\.channelID, \.startTime], [\.startTime, \.endTime])

    @Attribute(.unique) var programmeID: String
    var channelID: String
    var title: String
    var programmeDescription: String
    var startTime: Date
    var endTime: Date
    var duration: TimeInterval
    var episodeNumber: Int?
    var seasonNumber: Int?
    var imageURL: URL?
    var tmdbTVSeriesID: Int?
    var tmdbMovieID: Int?

    init(
        programmeID: String,
        channelID: String,
        title: String,
        programmeDescription: String,
        startTime: Date,
        endTime: Date,
        duration: TimeInterval,
        episodeNumber: Int?,
        seasonNumber: Int?,
        imageURL: URL?,
        tmdbTVSeriesID: Int?,
        tmdbMovieID: Int?
    ) {
        self.programmeID = programmeID
        self.channelID = channelID
        self.title = title
        self.programmeDescription = programmeDescription
        self.startTime = startTime
        self.endTime = endTime
        self.duration = duration
        self.episodeNumber = episodeNumber
        self.seasonNumber = seasonNumber
        self.imageURL = imageURL
        self.tmdbTVSeriesID = tmdbTVSeriesID
        self.tmdbMovieID = tmdbMovieID
    }

}
