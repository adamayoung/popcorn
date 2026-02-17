//
//  Movie+Mocks.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain

extension Movie {

    static func mock(
        id: Int = 1,
        title: String = "Test Movie",
        tagline: String? = "Test Tagline",
        originalTitle: String? = "Test Movie",
        originalLanguage: String? = "en",
        overview: String = "Test Overview",
        runtime: Int? = 120,
        genres: [Genre]? = nil,
        releaseDate: Date? = Date(timeIntervalSince1970: 0),
        posterPath: URL? = URL(string: "/poster.jpg"),
        backdropPath: URL? = URL(string: "/backdrop.jpg"),
        budget: Double? = 100_000_000,
        revenue: Double? = 500_000_000,
        homepageURL: URL? = URL(string: "https://example.com/movie"),
        imdbID: String? = "tt0000001",
        status: MovieStatus? = .released,
        productionCompanies: [ProductionCompany]? = nil,
        productionCountries: [ProductionCountry]? = nil,
        spokenLanguages: [SpokenLanguage]? = nil,
        originCountry: [String]? = ["US"],
        belongsToCollection: MovieCollection? = nil,
        popularity: Double? = 10.0,
        voteAverage: Double? = 7.5,
        voteCount: Int? = 1000,
        hasVideo: Bool? = false,
        isAdultOnly: Bool? = false
    ) -> Movie {
        Movie(
            id: id,
            title: title,
            tagline: tagline,
            originalTitle: originalTitle,
            originalLanguage: originalLanguage,
            overview: overview,
            runtime: runtime,
            genres: genres,
            releaseDate: releaseDate,
            posterPath: posterPath,
            backdropPath: backdropPath,
            budget: budget,
            revenue: revenue,
            homepageURL: homepageURL,
            imdbID: imdbID,
            status: status,
            productionCompanies: productionCompanies,
            productionCountries: productionCountries,
            spokenLanguages: spokenLanguages,
            originCountry: originCountry,
            belongsToCollection: belongsToCollection,
            popularity: popularity,
            voteAverage: voteAverage,
            voteCount: voteCount,
            hasVideo: hasVideo,
            isAdultOnly: isAdultOnly
        )
    }

}
