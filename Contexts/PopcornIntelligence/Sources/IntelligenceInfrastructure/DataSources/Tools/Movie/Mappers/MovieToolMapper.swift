//
//  MovieToolMapper.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import IntelligenceDomain

struct MovieToolMapper {

    func map(_ movie: Movie) -> MovieToolMovie {
        MovieToolMovie(
            id: movie.id,
            title: movie.title,
            tagline: movie.tagline,
            originalTitle: movie.originalTitle,
            originalLanguage: movie.originalLanguage,
            overview: movie.overview,
            runtime: movie.runtime,
            genres: movie.genres?.map { genre in
                MovieToolGenre(id: genre.id, name: genre.name)
            },
            releaseDate: movie.releaseDate.map { $0.formatted(Date.ISO8601FormatStyle().year().month().day()) },
            posterPath: movie.posterPath?.absoluteString,
            backdropPath: movie.backdropPath?.absoluteString,
            budget: movie.budget.map { Int($0) },
            revenue: movie.revenue.map { Int($0) },
            homepageURL: movie.homepageURL?.absoluteString,
            imdbID: movie.imdbID,
            status: movie.status?.rawValue,
            productionCompanies: movie.productionCompanies?.map { company in
                MovieToolProductionCompany(
                    id: company.id,
                    name: company.name,
                    originCountry: company.originCountry
                )
            },
            productionCountries: movie.productionCountries?.map { country in
                MovieToolProductionCountry(countryCode: country.countryCode, name: country.name)
            },
            spokenLanguages: movie.spokenLanguages?.map { language in
                MovieToolSpokenLanguage(languageCode: language.languageCode, name: language.name)
            },
            originCountry: movie.originCountry,
            belongsToCollection: movie.belongsToCollection.map { collection in
                MovieToolMovieCollection(id: collection.id, name: collection.name)
            },
            popularity: movie.popularity,
            voteAverage: movie.voteAverage,
            voteCount: movie.voteCount,
            hasVideo: movie.hasVideo,
            isAdultOnly: movie.isAdultOnly
        )
    }

}
