//
//  DiscoverTVSeriesPreviewEntity.swift
//  PopcornDiscover
//
//  Copyright © 2025 Adam Young.
//

import DataPersistenceInfrastructure
import Foundation
import SwiftData

@Model
final class DiscoverTVSeriesPreviewEntity: Equatable, Identifiable, ModelExpirable {

    @Attribute(.unique) var tvSeriesID: Int
    var name: String
    var overview: String
    var firstAirDate: Date
    var genreIDs: [Int]
    var posterPath: URL?
    var backdropPath: URL?
    var cachedAt: Date

    init(
        tvSeriesID: Int,
        name: String,
        overview: String,
        firstAirDate: Date,
        genreIDs: [Int] = [],
        posterPath: URL? = nil,
        backdropPath: URL? = nil,
        cachedAt: Date = .now
    ) {
        self.tvSeriesID = tvSeriesID
        self.name = name
        self.overview = overview
        self.firstAirDate = firstAirDate
        self.genreIDs = genreIDs
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.cachedAt = cachedAt
    }

}
