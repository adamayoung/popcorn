//
//  MovieMapper.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

struct MovieMapper {

    func map(_ entity: MoviesMovieEntity) -> Movie {
        Movie(
            id: entity.movieID,
            title: entity.title,
            tagline: entity.tagline,
            originalTitle: entity.originalTitle,
            originalLanguage: entity.originalLanguage,
            overview: entity.overview,
            runtime: entity.runtime,
            genres: entity.genres.map { mapGenresToDomain($0) },
            releaseDate: entity.releaseDate,
            posterPath: entity.posterPath,
            backdropPath: entity.backdropPath,
            budget: entity.budget,
            revenue: entity.revenue,
            homepageURL: entity.homepageURL,
            imdbID: entity.imdbID,
            status: entity.status.flatMap { MovieStatus(rawValue: $0) },
            productionCompanies: entity.productionCompanies.map { mapProductionCompaniesToDomain($0) },
            productionCountries: entity.productionCountries.map { mapProductionCountriesToDomain($0) },
            spokenLanguages: entity.spokenLanguages.map { mapSpokenLanguagesToDomain($0) },
            originCountry: entity.originCountry,
            belongsToCollection: entity.belongsToCollection.map { mapCollectionToDomain($0) },
            popularity: entity.popularity,
            voteAverage: entity.voteAverage,
            voteCount: entity.voteCount,
            hasVideo: entity.hasVideo,
            isAdultOnly: entity.isAdultOnly
        )
    }

    func compactMap(_ entity: MoviesMovieEntity?) -> Movie? {
        guard let entity else {
            return nil
        }

        return map(entity)
    }

    func map(_ movie: Movie) -> MoviesMovieEntity {
        MoviesMovieEntity(
            movieID: movie.id,
            title: movie.title,
            tagline: movie.tagline,
            originalTitle: movie.originalTitle,
            originalLanguage: movie.originalLanguage,
            overview: movie.overview,
            runtime: movie.runtime,
            releaseDate: movie.releaseDate,
            posterPath: movie.posterPath,
            backdropPath: movie.backdropPath,
            budget: movie.budget,
            revenue: movie.revenue,
            homepageURL: movie.homepageURL,
            imdbID: movie.imdbID,
            status: movie.status?.rawValue,
            originCountry: movie.originCountry,
            popularity: movie.popularity,
            voteAverage: movie.voteAverage,
            voteCount: movie.voteCount,
            hasVideo: movie.hasVideo,
            isAdultOnly: movie.isAdultOnly,
            genres: movie.genres.map { mapGenresToEntity($0) },
            productionCompanies: movie.productionCompanies.map { mapProductionCompaniesToEntity($0) },
            productionCountries: movie.productionCountries.map { mapProductionCountriesToEntity($0) },
            spokenLanguages: movie.spokenLanguages.map { mapSpokenLanguagesToEntity($0) },
            belongsToCollection: movie.belongsToCollection.map { mapCollectionToEntity($0) }
        )
    }

    func map(_ movie: Movie, to entity: MoviesMovieEntity) {
        entity.title = movie.title
        entity.tagline = movie.tagline
        entity.originalTitle = movie.originalTitle
        entity.originalLanguage = movie.originalLanguage
        entity.overview = movie.overview
        entity.runtime = movie.runtime
        entity.releaseDate = movie.releaseDate
        entity.posterPath = movie.posterPath
        entity.backdropPath = movie.backdropPath
        entity.budget = movie.budget
        entity.revenue = movie.revenue
        entity.homepageURL = movie.homepageURL
        entity.imdbID = movie.imdbID
        entity.status = movie.status?.rawValue
        entity.originCountry = movie.originCountry
        entity.popularity = movie.popularity
        entity.voteAverage = movie.voteAverage
        entity.voteCount = movie.voteCount
        entity.hasVideo = movie.hasVideo
        entity.isAdultOnly = movie.isAdultOnly
        entity.genres = movie.genres.map { mapGenresToEntity($0) }
        entity.productionCompanies = movie.productionCompanies.map { mapProductionCompaniesToEntity($0) }
        entity.productionCountries = movie.productionCountries.map { mapProductionCountriesToEntity($0) }
        entity.spokenLanguages = movie.spokenLanguages.map { mapSpokenLanguagesToEntity($0) }
        entity.belongsToCollection = movie.belongsToCollection.map { mapCollectionToEntity($0) }
        entity.cachedAt = .now
    }

    // MARK: - Private

    private func mapGenresToDomain(_ genres: [MoviesGenreEntity]) -> [Genre] {
        genres.map { Genre(id: $0.genreID, name: $0.name) }
    }

    private func mapGenresToEntity(_ genres: [Genre]) -> [MoviesGenreEntity] {
        genres.map { MoviesGenreEntity(genreID: $0.id, name: $0.name) }
    }

    private func mapProductionCompaniesToDomain(
        _ companies: [MoviesProductionCompanyEntity]
    ) -> [ProductionCompany] {
        companies.map {
            ProductionCompany(id: $0.companyID, name: $0.name, originCountry: $0.originCountry, logoPath: $0.logoPath)
        }
    }

    private func mapProductionCompaniesToEntity(
        _ companies: [ProductionCompany]
    ) -> [MoviesProductionCompanyEntity] {
        companies.map {
            MoviesProductionCompanyEntity(
                companyID: $0.id, name: $0.name, originCountry: $0.originCountry, logoPath: $0.logoPath
            )
        }
    }

    private func mapProductionCountriesToDomain(
        _ countries: [MoviesProductionCountryEntity]
    ) -> [ProductionCountry] {
        countries.map { ProductionCountry(countryCode: $0.countryCode, name: $0.name) }
    }

    private func mapProductionCountriesToEntity(
        _ countries: [ProductionCountry]
    ) -> [MoviesProductionCountryEntity] {
        countries.map { MoviesProductionCountryEntity(countryCode: $0.countryCode, name: $0.name) }
    }

    private func mapSpokenLanguagesToDomain(
        _ languages: [MoviesSpokenLanguageEntity]
    ) -> [SpokenLanguage] {
        languages.map { SpokenLanguage(languageCode: $0.languageCode, name: $0.name) }
    }

    private func mapSpokenLanguagesToEntity(
        _ languages: [SpokenLanguage]
    ) -> [MoviesSpokenLanguageEntity] {
        languages.map { MoviesSpokenLanguageEntity(languageCode: $0.languageCode, name: $0.name) }
    }

    private func mapCollectionToDomain(_ collection: MoviesMovieCollectionEntity) -> MovieCollection {
        MovieCollection(
            id: collection.collectionID,
            name: collection.name,
            posterPath: collection.posterPath,
            backdropPath: collection.backdropPath
        )
    }

    private func mapCollectionToEntity(_ collection: MovieCollection) -> MoviesMovieCollectionEntity {
        MoviesMovieCollectionEntity(
            collectionID: collection.id,
            name: collection.name,
            posterPath: collection.posterPath,
            backdropPath: collection.backdropPath
        )
    }

}
