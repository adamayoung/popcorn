//
//  Movie+Mocks.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import IntelligenceDomain

extension Movie {

    static func mock(
        id: Int = 1,
        title: String = "Test Movie",
        tagline: String? = nil,
        originalTitle: String? = nil,
        originalLanguage: String? = nil,
        overview: String = "A test movie overview",
        runtime: Int? = nil,
        genres: [Genre]? = nil,
        releaseDate: Date? = Date(timeIntervalSince1970: 1_609_459_200),
        posterPath: URL? = URL(string: "/poster.jpg"),
        backdropPath: URL? = URL(string: "/backdrop.jpg"),
        budget: Int? = nil,
        revenue: Int? = nil,
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
