//
//  TVSeriesEntity.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData

@Model
final class TVSeriesEntity: Equatable, ModelExpirable {

    @Attribute(.unique) var tvSeriesID: Int
    var name: String
    var tagline: String?
    var overview: String
    var numberOfSeasons: Int
    var firstAirDate: Date?
    var posterPath: URL?
    var backdropPath: URL?
    @Relationship(deleteRule: .cascade) var genres: [TVSeriesGenreEntity]?
    @Relationship(deleteRule: .cascade) var seasons: [TVSeriesSeasonEntity]
    var cachedAt: Date

    init(
        tvSeriesID: Int,
        name: String,
        tagline: String? = nil,
        overview: String,
        numberOfSeasons: Int = 0,
        firstAirDate: Date? = nil,
        posterPath: URL? = nil,
        backdropPath: URL? = nil,
        genres: [TVSeriesGenreEntity]? = nil,
        seasons: [TVSeriesSeasonEntity] = [],
        cachedAt: Date = Date.now
    ) {
        self.tvSeriesID = tvSeriesID
        self.name = name
        self.tagline = tagline
        self.overview = overview
        self.numberOfSeasons = numberOfSeasons
        self.firstAirDate = firstAirDate
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.genres = genres
        self.seasons = seasons
        self.cachedAt = cachedAt
    }

}
