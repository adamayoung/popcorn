//
//  TVProgramme.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Represents a single TV programme airing on a channel.
///
public struct TVProgramme: Identifiable, Equatable, Sendable {

    public let id: String

    public let channelID: String

    public let title: String

    public let description: String

    public let startTime: Date

    public let endTime: Date

    public let duration: TimeInterval

    public let episodeNumber: Int?

    public let seasonNumber: Int?

    public let imageURL: URL?

    public let tmdbTVSeriesID: Int?

    public let tmdbMovieID: Int?

    public let genres: [String]

    public let certification: String?

    public let voteAverage: Double?

    public let voteCount: Int?

    public let isPremiere: Bool

    public let keywords: [String]

    public let watchProviders: [String]

    public init(
        id: String,
        channelID: String,
        title: String,
        description: String,
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
        self.id = id
        self.channelID = channelID
        self.title = title
        self.description = description
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

public extension TVProgramme {

    ///
    /// Builds the stable composite identifier for a programme.
    ///
    /// The EPG feed has no stable programme IDs, so `channelID` + Unix start-time seconds is used.
    ///
    static func makeID(channelID: String, startTime: Date) -> String {
        "\(channelID):\(Int(startTime.timeIntervalSince1970))"
    }

}
