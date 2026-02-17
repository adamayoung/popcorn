//
//  Movie.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Represents a movie in the domain model.
///
/// A movie contains essential information including its title, overview, release date,
/// and associated imagery paths. This is the core domain entity used throughout the
/// movies context for representing movie data.
///
public struct Movie: Identifiable, Equatable, Sendable {

    /// The unique identifier for the movie.
    public let id: Int

    /// The movie's title.
    public let title: String

    public let tagline: String?

    public let originalTitle: String?

    public let originalLanguage: String?

    /// A brief description or plot summary of the movie.
    public let overview: String

    public let runtime: Int?

    public let genres: [Genre]?

    /// The movie's theatrical release date, if known.
    public let releaseDate: Date?

    /// URL path to the movie's poster image.
    public let posterPath: URL?

    /// URL path to the movie's backdrop image.
    public let backdropPath: URL?

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

    ///
    /// Creates a new movie instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the movie.
    ///   - title: The movie's title.
    ///   - overview: A brief description or plot summary.
    ///   - releaseDate: The movie's theatrical release date. Defaults to `nil`.
    ///   - posterPath: URL path to the poster image. Defaults to `nil`.
    ///   - backdropPath: URL path to the backdrop image. Defaults to `nil`.
    ///
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
        posterPath: URL? = nil,
        backdropPath: URL? = nil,
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
        isAdultOnly: Bool? = nil
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
        self.posterPath = posterPath
        self.backdropPath = backdropPath
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
    }

}
