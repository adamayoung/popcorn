//
//  MoviesMovieEntity.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import SwiftData

@Model
final class MoviesMovieEntity: Equatable, ModelExpirable {

    @Attribute(.unique) var movieID: Int
    var title: String
    var tagline: String?
    var overview: String
    var runtime: Int?
    var releaseDate: Date?
    var posterPath: URL?
    var backdropPath: URL?
    var budget: Double?
    var revenue: Double?
    var homepageURL: URL?
    @Relationship(deleteRule: .cascade) var genres: [MoviesGenreEntity]?
    var cachedAt: Date

    init(
        movieID: Int,
        title: String,
        tagline: String? = nil,
        overview: String,
        runtime: Int? = nil,
        releaseDate: Date? = nil,
        posterPath: URL? = nil,
        backdropPath: URL? = nil,
        budget: Double? = nil,
        revenue: Double? = nil,
        homepageURL: URL? = nil,
        cachedAt: Date = Date.now
    ) {
        self.movieID = movieID
        self.title = title
        self.tagline = tagline
        self.overview = overview
        self.runtime = runtime
        self.releaseDate = releaseDate
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.budget = budget
        self.revenue = revenue
        self.homepageURL = homepageURL
        self.cachedAt = cachedAt
    }

}
