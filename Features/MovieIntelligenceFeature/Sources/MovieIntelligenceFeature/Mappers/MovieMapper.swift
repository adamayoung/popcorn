//
//  MovieMapper.swift
//  MovieIntelligenceFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import IntelligenceDomain
import MoviesApplication

struct MovieMapper {

    func map(_ movieDetails: MovieDetails) -> IntelligenceDomain.Movie {
        IntelligenceDomain.Movie(
            id: movieDetails.id,
            title: movieDetails.title,
            tagline: movieDetails.tagline,
            originalTitle: movieDetails.originalTitle,
            originalLanguage: movieDetails.originalLanguage,
            overview: movieDetails.overview,
            runtime: movieDetails.runtime,
            genres: movieDetails.genres?.map { Genre(id: $0.id, name: $0.name) },
            releaseDate: movieDetails.releaseDate,
            posterPath: movieDetails.posterURLSet?.path,
            backdropPath: movieDetails.backdropURLSet?.path,
            budget: movieDetails.budget,
            revenue: movieDetails.revenue,
            homepageURL: movieDetails.homepageURL,
            imdbID: movieDetails.imdbID,
            status: movieDetails.status.map { status in
                switch status {
                case .rumoured: .rumoured
                case .planned: .planned
                case .inProduction: .inProduction
                case .postProduction: .postProduction
                case .released: .released
                case .cancelled: .cancelled
                }
            },
            productionCompanies: movieDetails.productionCompanies?.map {
                ProductionCompany(id: $0.id, name: $0.name, originCountry: $0.originCountry)
            },
            productionCountries: movieDetails.productionCountries?.map {
                ProductionCountry(countryCode: $0.countryCode, name: $0.name)
            },
            spokenLanguages: movieDetails.spokenLanguages?.map {
                SpokenLanguage(languageCode: $0.languageCode, name: $0.name)
            },
            originCountry: movieDetails.originCountry,
            belongsToCollection: movieDetails.belongsToCollection.map {
                MovieCollection(id: $0.id, name: $0.name)
            },
            popularity: movieDetails.popularity,
            voteAverage: movieDetails.voteAverage,
            voteCount: movieDetails.voteCount,
            hasVideo: movieDetails.hasVideo,
            isAdultOnly: movieDetails.isAdultOnly
        )
    }

}
