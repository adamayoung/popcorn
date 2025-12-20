//
//  DiscoverMoviePreviewEntity.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import DataPersistenceInfrastructure
import Foundation
import SwiftData

@Model
final class DiscoverMoviePreviewEntity: Equatable, Identifiable, ModelExpirable {

    @Attribute(.unique) var movieID: Int
    var title: String
    var overview: String
    var releaseDate: Date
    var genreIDs: [Int]
    var posterPath: URL?
    var backdropPath: URL?
    var cachedAt: Date

    init(
        movieID: Int,
        title: String,
        overview: String,
        releaseDate: Date,
        genreIDs: [Int] = [],
        posterPath: URL? = nil,
        backdropPath: URL? = nil,
        cachedAt: Date = .now
    ) {
        self.movieID = movieID
        self.title = title
        self.overview = overview
        self.releaseDate = releaseDate
        self.genreIDs = genreIDs
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.cachedAt = cachedAt
    }

}
