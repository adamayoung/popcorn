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
    var originalTitle: String?
    var originalLanguage: String?
    var overview: String
    var runtime: Int?
    var releaseDate: Date?
    var posterPath: URL?
    var backdropPath: URL?
    var budget: Double?
    var revenue: Double?
    var homepageURL: URL?
    var imdbID: String?
    var status: String?
    var originCountry: [String]?
    var popularity: Double?
    var voteAverage: Double?
    var voteCount: Int?
    var hasVideo: Bool?
    var isAdultOnly: Bool?
    @Relationship(deleteRule: .cascade) var genres: [MoviesGenreEntity]?
    @Relationship(deleteRule: .cascade) var productionCompanies: [MoviesProductionCompanyEntity]?
    @Relationship(deleteRule: .cascade) var productionCountries: [MoviesProductionCountryEntity]?
    @Relationship(deleteRule: .cascade) var spokenLanguages: [MoviesSpokenLanguageEntity]?
    @Relationship(deleteRule: .cascade) var belongsToCollection: MoviesMovieCollectionEntity?
    var cachedAt: Date

    init(
        movieID: Int,
        title: String,
        tagline: String? = nil,
        originalTitle: String? = nil,
        originalLanguage: String? = nil,
        overview: String,
        runtime: Int? = nil,
        releaseDate: Date? = nil,
        posterPath: URL? = nil,
        backdropPath: URL? = nil,
        budget: Double? = nil,
        revenue: Double? = nil,
        homepageURL: URL? = nil,
        imdbID: String? = nil,
        status: String? = nil,
        originCountry: [String]? = nil,
        popularity: Double? = nil,
        voteAverage: Double? = nil,
        voteCount: Int? = nil,
        hasVideo: Bool? = nil,
        isAdultOnly: Bool? = nil,
        genres: [MoviesGenreEntity]? = nil,
        productionCompanies: [MoviesProductionCompanyEntity]? = nil,
        productionCountries: [MoviesProductionCountryEntity]? = nil,
        spokenLanguages: [MoviesSpokenLanguageEntity]? = nil,
        belongsToCollection: MoviesMovieCollectionEntity? = nil,
        cachedAt: Date = Date.now
    ) {
        self.movieID = movieID
        self.title = title
        self.tagline = tagline
        self.originalTitle = originalTitle
        self.originalLanguage = originalLanguage
        self.overview = overview
        self.runtime = runtime
        self.releaseDate = releaseDate
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.budget = budget
        self.revenue = revenue
        self.homepageURL = homepageURL
        self.imdbID = imdbID
        self.status = status
        self.originCountry = originCountry
        self.popularity = popularity
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.hasVideo = hasVideo
        self.isAdultOnly = isAdultOnly
        self.genres = genres
        self.productionCompanies = productionCompanies
        self.productionCountries = productionCountries
        self.spokenLanguages = spokenLanguages
        self.belongsToCollection = belongsToCollection
        self.cachedAt = cachedAt
    }

}
