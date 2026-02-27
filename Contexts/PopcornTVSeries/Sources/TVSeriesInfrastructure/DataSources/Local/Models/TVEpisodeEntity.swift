//
//  TVEpisodeEntity.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData

@Model
final class TVEpisodeEntity: Equatable {

    @Attribute(.unique) var episodeID: Int
    var name: String
    var episodeNumber: Int
    var seasonNumber: Int
    var overview: String?
    var airDate: Date?
    var runtime: Int?
    var stillPath: URL?

    init(
        episodeID: Int,
        name: String,
        episodeNumber: Int,
        seasonNumber: Int,
        overview: String? = nil,
        airDate: Date? = nil,
        runtime: Int? = nil,
        stillPath: URL? = nil
    ) {
        self.episodeID = episodeID
        self.name = name
        self.episodeNumber = episodeNumber
        self.seasonNumber = seasonNumber
        self.overview = overview
        self.airDate = airDate
        self.runtime = runtime
        self.stillPath = stillPath
    }

}
