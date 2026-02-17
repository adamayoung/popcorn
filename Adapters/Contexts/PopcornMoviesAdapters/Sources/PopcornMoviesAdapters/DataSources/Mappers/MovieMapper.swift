//
//  MovieMapper.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain
import TMDb

struct MovieMapper {

    private let genreMapper = GenreMapper()
    private let movieStatusMapper = MovieStatusMapper()
    private let productionCompanyMapper = ProductionCompanyMapper()
    private let productionCountryMapper = ProductionCountryMapper()
    private let spokenLanguageMapper = SpokenLanguageMapper()
    private let movieCollectionMapper = MovieCollectionMapper()

    func map(_ dto: TMDb.Movie) -> MoviesDomain.Movie {
        MoviesDomain.Movie(
            id: dto.id,
            title: dto.title,
            tagline: dto.tagline,
            originalTitle: dto.originalTitle,
            originalLanguage: dto.originalLanguage,
            overview: dto.overview ?? "",
            runtime: dto.runtime,
            genres: dto.genres?.map(genreMapper.map),
            releaseDate: dto.releaseDate,
            posterPath: dto.posterPath,
            backdropPath: dto.backdropPath,
            budget: dto.budget,
            revenue: dto.revenue,
            homepageURL: dto.homepageURL,
            imdbID: dto.imdbID,
            status: dto.status.map(movieStatusMapper.map),
            productionCompanies: dto.productionCompanies?.map(productionCompanyMapper.map),
            productionCountries: dto.productionCountries?.map(productionCountryMapper.map),
            spokenLanguages: dto.spokenLanguages?.map(spokenLanguageMapper.map),
            originCountry: dto.originCountry,
            belongsToCollection: dto.belongsToCollection.map(movieCollectionMapper.map),
            popularity: dto.popularity,
            voteAverage: dto.voteAverage,
            voteCount: dto.voteCount,
            hasVideo: dto.hasVideo,
            isAdultOnly: dto.isAdultOnly
        )
    }

}
