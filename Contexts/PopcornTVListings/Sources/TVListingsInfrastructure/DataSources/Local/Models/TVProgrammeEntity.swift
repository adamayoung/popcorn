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
    // Enrichment fields. Defaults let SwiftData lightweight-migrate an existing store
    // (added on first launch after upgrade) without a destructive wipe.
    var genres: [String] = []
    var certification: String?
    var voteAverage: Double?
    var voteCount: Int?
    var isPremiere: Bool = false
    var keywords: [String] = []
    var watchProviders: [String] = []

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
        tmdbMovieID: Int?,
        genres: [String] = [],
        certification: String? = nil,
        voteAverage: Double? = nil,
        voteCount: Int? = nil,
        isPremiere: Bool = false,
        keywords: [String] = [],
        watchProviders: [String] = []
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
        self.genres = genres
        self.certification = certification
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.isPremiere = isPremiere
        self.keywords = keywords
        self.watchProviders = watchProviders
    }

}
