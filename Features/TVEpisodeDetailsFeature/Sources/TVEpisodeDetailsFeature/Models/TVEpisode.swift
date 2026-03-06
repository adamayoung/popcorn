//
//  TVEpisode.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public struct TVEpisode: Equatable, Sendable {

    public let id: Int
    public let name: String
    public let episodeNumber: Int
    public let seasonNumber: Int
    public let tvSeasonID: Int
    public let tvSeriesID: Int
    public let overview: String?
    public let airDate: Date?
    public let stillURL: URL?

    public init(
        id: Int,
        name: String,
        episodeNumber: Int,
        seasonNumber: Int,
        tvSeasonID: Int,
        tvSeriesID: Int,
        overview: String?,
        airDate: Date?,
        stillURL: URL?
    ) {
        self.id = id
        self.name = name
        self.episodeNumber = episodeNumber
        self.seasonNumber = seasonNumber
        self.tvSeasonID = tvSeasonID
        self.tvSeriesID = tvSeriesID
        self.overview = overview
        self.airDate = airDate
        self.stillURL = stillURL
    }

}

extension TVEpisode {

    static var mock: TVEpisode {
        TVEpisode(
            id: 1396,
            name: "Pilot",
            episodeNumber: 1,
            seasonNumber: 1,
            tvSeasonID: 22,
            tvSeriesID: 222,
            overview: "A high school chemistry teacher diagnosed with lung cancer turns to manufacturing meth.",
            airDate: Date(timeIntervalSince1970: 1_200_528_000),
            stillURL: URL(
                string: "https://image.tmdb.org/t/p/original/ydlY3iPfeOAvu8gVqrxPoMvzfBj.jpg"
            )
        )
    }

}
