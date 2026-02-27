//
//  TVSeasonEpisodesEntity.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData

@Model
final class TVSeasonEpisodesEntity: Equatable, ModelExpirable {

    @Attribute(.unique) var compositeKey: String
    var tvSeriesID: Int
    var seasonID: Int
    var seasonName: String
    var seasonNumber: Int
    var overview: String?
    var posterPath: URL?
    @Relationship(deleteRule: .cascade) var episodes: [TVEpisodeEntity]
    var cachedAt: Date

    init(
        compositeKey: String,
        tvSeriesID: Int,
        seasonID: Int,
        seasonName: String,
        seasonNumber: Int,
        overview: String? = nil,
        posterPath: URL? = nil,
        episodes: [TVEpisodeEntity] = [],
        cachedAt: Date = Date.now
    ) {
        self.compositeKey = compositeKey
        self.tvSeriesID = tvSeriesID
        self.seasonID = seasonID
        self.seasonName = seasonName
        self.seasonNumber = seasonNumber
        self.overview = overview
        self.posterPath = posterPath
        self.episodes = episodes
        self.cachedAt = cachedAt
    }

}

extension TVSeasonEpisodesEntity {

    static func makeCompositeKey(tvSeriesID: Int, seasonNumber: Int) -> String {
        "\(tvSeriesID)-\(seasonNumber)"
    }

}
