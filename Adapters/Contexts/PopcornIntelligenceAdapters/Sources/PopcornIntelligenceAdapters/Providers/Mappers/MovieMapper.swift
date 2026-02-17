//
//  MovieMapper.swift
//  PopcornIntelligenceAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import IntelligenceDomain
import MoviesApplication

struct MovieMapper {

    func map(_ movieDetails: MovieDetails) -> Movie {
        Movie(
            id: movieDetails.id,
            title: movieDetails.title,
            tagline: movieDetails.tagline,
            originalTitle: movieDetails.originalTitle,
            originalLanguage: movieDetails.originalLanguage,
            overview: movieDetails.overview,
            runtime: movieDetails.runtime,
            genres: movieDetails.genres,
            releaseDate: movieDetails.releaseDate,
            posterPath: movieDetails.posterURLSet?.path,
            backdropPath: movieDetails.backdropURLSet?.path,
            budget: movieDetails.budget,
            revenue: movieDetails.revenue,
            homepageURL: movieDetails.homepageURL,
            imdbID: movieDetails.imdbID,
            status: movieDetails.status,
            productionCompanies: movieDetails.productionCompanies,
            productionCountries: movieDetails.productionCountries,
            spokenLanguages: movieDetails.spokenLanguages,
            originCountry: movieDetails.originCountry,
            belongsToCollection: movieDetails.belongsToCollection,
            popularity: movieDetails.popularity,
            voteAverage: movieDetails.voteAverage,
            voteCount: movieDetails.voteCount,
            hasVideo: movieDetails.hasVideo,
            isAdultOnly: movieDetails.isAdultOnly
        )
    }

}
