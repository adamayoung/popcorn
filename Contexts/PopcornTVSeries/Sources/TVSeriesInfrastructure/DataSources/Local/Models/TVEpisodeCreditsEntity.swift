//
//  TVEpisodeCreditsEntity.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData

@Model
final class TVEpisodeCreditsEntity: Equatable, Identifiable, ModelExpirable {

    @Attribute(.unique) var compositeKey: String
    var tvSeriesID: Int
    var seasonNumber: Int
    var episodeNumber: Int
    @Relationship(deleteRule: .cascade) var cast: [TVEpisodeCastMemberEntity]
    @Relationship(deleteRule: .cascade) var crew: [TVEpisodeCrewMemberEntity]
    var cachedAt: Date

    init(
        tvSeriesID: Int,
        seasonNumber: Int,
        episodeNumber: Int,
        cast: [TVEpisodeCastMemberEntity] = [],
        crew: [TVEpisodeCrewMemberEntity] = [],
        cachedAt: Date = Date.now
    ) {
        self.compositeKey = "\(tvSeriesID)-\(seasonNumber)-\(episodeNumber)"
        self.tvSeriesID = tvSeriesID
        self.seasonNumber = seasonNumber
        self.episodeNumber = episodeNumber
        self.cast = cast
        self.crew = crew
        self.cachedAt = cachedAt
    }

}
