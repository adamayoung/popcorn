//
//  MovieDetails.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import MoviesDomain

public struct MovieDetails: Identifiable, Equatable, Sendable {

    public let id: Int
    public let title: String
    public let tagline: String?
    public let originalTitle: String?
    public let originalLanguage: String?
    public let overview: String
    public let runtime: Int?
    public let genres: [Genre]?
    public let releaseDate: Date?
    public let posterURLSet: ImageURLSet?
    public let backdropURLSet: ImageURLSet?
    public let logoURLSet: ImageURLSet?
    public let budget: Double?
    public let revenue: Double?
    public let homepageURL: URL?
    public let imdbID: String?
    public let status: MovieStatus?
    public let productionCompanies: [ProductionCompany]?
    public let productionCountries: [ProductionCountry]?
    public let spokenLanguages: [SpokenLanguage]?
    public let originCountry: [String]?
    public let belongsToCollection: MovieCollection?
    public let popularity: Double?
    public let voteAverage: Double?
    public let voteCount: Int?
    public let hasVideo: Bool?
    public let isAdultOnly: Bool?
    public let certification: String?
    public let isOnWatchlist: Bool

    public init(
        id: Int,
        title: String,
        tagline: String? = nil,
        originalTitle: String? = nil,
        originalLanguage: String? = nil,
        overview: String,
        runtime: Int? = nil,
        genres: [Genre]? = nil,
        releaseDate: Date? = nil,
        posterURLSet: ImageURLSet? = nil,
        backdropURLSet: ImageURLSet? = nil,
        logoURLSet: ImageURLSet? = nil,
        budget: Double? = nil,
        revenue: Double? = nil,
        homepageURL: URL? = nil,
        imdbID: String? = nil,
        status: MovieStatus? = nil,
        productionCompanies: [ProductionCompany]? = nil,
        productionCountries: [ProductionCountry]? = nil,
        spokenLanguages: [SpokenLanguage]? = nil,
        originCountry: [String]? = nil,
        belongsToCollection: MovieCollection? = nil,
        popularity: Double? = nil,
        voteAverage: Double? = nil,
        voteCount: Int? = nil,
        hasVideo: Bool? = nil,
        isAdultOnly: Bool? = nil,
        certification: String? = nil,
        isOnWatchlist: Bool
    ) {
        self.id = id
        self.title = title
        self.tagline = tagline
        self.originalTitle = originalTitle
        self.originalLanguage = originalLanguage
        self.overview = overview
        self.runtime = runtime
        self.genres = genres
        self.releaseDate = releaseDate
        self.posterURLSet = posterURLSet
        self.backdropURLSet = backdropURLSet
        self.logoURLSet = logoURLSet
        self.budget = budget
        self.revenue = revenue
        self.homepageURL = homepageURL
        self.imdbID = imdbID
        self.status = status
        self.productionCompanies = productionCompanies
        self.productionCountries = productionCountries
        self.spokenLanguages = spokenLanguages
        self.originCountry = originCountry
        self.belongsToCollection = belongsToCollection
        self.popularity = popularity
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.hasVideo = hasVideo
        self.isAdultOnly = isAdultOnly
        self.certification = certification
        self.isOnWatchlist = isOnWatchlist
    }

}
