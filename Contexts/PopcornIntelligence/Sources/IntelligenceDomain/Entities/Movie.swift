//
//  Movie.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

///
/// Represents a movie in the domain model.
///
/// A movie contains essential information including its title, overview, release date,
/// and associated imagery paths. This is the core domain entity used throughout the
/// movies context for representing movie data.
///
/// Represents ``Movie``.
public struct Movie: Identifiable, Equatable, Sendable {

    /// The unique identifier for the movie.
    /// The ``id`` value.
    public let id: Int

    /// The movie's title.
    /// The ``title`` value.
    public let title: String

    /// The ``tagline`` value.
    public let tagline: String?

    /// The ``originalTitle`` value.
    public let originalTitle: String?

    /// The ``originalLanguage`` value.
    public let originalLanguage: String?

    /// A brief description or plot summary of the movie.
    /// The ``overview`` value.
    public let overview: String

    /// The ``runtime`` value.
    public let runtime: Int?

    /// The ``genres`` value.
    public let genres: [Genre]?

    /// The movie's theatrical release date, if known.
    /// The ``releaseDate`` value.
    public let releaseDate: Date?

    /// URL path to the movie's poster image.
    /// The ``posterPath`` value.
    public let posterPath: URL?

    /// URL path to the movie's backdrop image.
    /// The ``backdropPath`` value.
    public let backdropPath: URL?

    /// The ``budget`` value.
    public let budget: Double?

    /// The ``revenue`` value.
    public let revenue: Double?

    /// The ``homepageURL`` value.
    public let homepageURL: URL?

    /// The ``imdbID`` value.
    public let imdbID: String?

    /// The ``status`` value.
    public let status: MovieStatus?

    /// The ``productionCompanies`` value.
    public let productionCompanies: [ProductionCompany]?

    /// The ``productionCountries`` value.
    public let productionCountries: [ProductionCountry]?

    /// The ``spokenLanguages`` value.
    public let spokenLanguages: [SpokenLanguage]?

    /// The ``originCountry`` value.
    public let originCountry: [String]?

    /// The ``belongsToCollection`` value.
    public let belongsToCollection: MovieCollection?

    /// The ``popularity`` value.
    public let popularity: Double?

    /// The ``voteAverage`` value.
    public let voteAverage: Double?

    /// The ``voteCount`` value.
    public let voteCount: Int?

    /// The ``hasVideo`` value.
    public let hasVideo: Bool?

    /// The ``isAdultOnly`` value.
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
    /// Creates a new instance.
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
