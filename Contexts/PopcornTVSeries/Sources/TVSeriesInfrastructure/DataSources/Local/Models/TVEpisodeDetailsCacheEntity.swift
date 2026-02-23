//
//  TVEpisodeDetailsCacheEntity.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData

@Model
final class TVEpisodeDetailsCacheEntity: Equatable, ModelExpirable {

    @Attribute(.unique) var compositeKey: String
    var tvSeriesID: Int
    var episodeID: Int
    var name: String
    var episodeNumber: Int
    var seasonNumber: Int
    var overview: String?
    var airDate: Date?
    var runtime: Int?
    var stillPath: URL?
    var cachedAt: Date

    init(
        compositeKey: String,
        tvSeriesID: Int,
        episodeID: Int,
        name: String,
        episodeNumber: Int,
        seasonNumber: Int,
        overview: String? = nil,
        airDate: Date? = nil,
        runtime: Int? = nil,
        stillPath: URL? = nil,
        cachedAt: Date = Date.now
    ) {
        self.compositeKey = compositeKey
        self.tvSeriesID = tvSeriesID
        self.episodeID = episodeID
        self.name = name
        self.episodeNumber = episodeNumber
        self.seasonNumber = seasonNumber
        self.overview = overview
        self.airDate = airDate
        self.runtime = runtime
        self.stillPath = stillPath
        self.cachedAt = cachedAt
    }

}

extension TVEpisodeDetailsCacheEntity {

    static func makeCompositeKey(
        tvSeriesID: Int,
        seasonNumber: Int,
        episodeNumber: Int
    ) -> String {
        "\(tvSeriesID)-\(seasonNumber)-\(episodeNumber)"
    }

}
