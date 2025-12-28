//
//  TMDbGenreRemoteDataSource.swift
//  PopcornGenresAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GenresDomain
import GenresInfrastructure
import TMDb

///
/// A remote data source that fetches movie and TV series genres from TMDb API.
///
/// This data source adapts the TMDb genre service to the domain's
/// ``GenreRemoteDataSource`` protocol, providing access to genre catalogs
/// for both movies and TV series.
///
final class TMDbGenreRemoteDataSource: GenreRemoteDataSource {

    private let genreService: any GenreService

    ///
    /// Creates a new TMDb genre remote data source.
    ///
    /// - Parameter genreService: The TMDb genre service for fetching genre data.
    ///
    init(genreService: any GenreService) {
        self.genreService = genreService
    }

    ///
    /// Fetches the list of movie genres from the TMDb API.
    ///
    /// - Returns: An array of genres applicable to movies.
    ///
    /// - Throws: ``GenreRemoteDataSourceError`` if the fetch operation fails.
    ///
    func movieGenres() async throws(GenreRemoteDataSourceError) -> [GenresDomain.Genre] {
        let tmdbGenres: [TMDb.Genre]
        do {
            tmdbGenres = try await genreService.movieGenres(language: "en")
        } catch let error {
            throw GenreRemoteDataSourceError(error)
        }

        let mapper = GenreMapper()
        let genres = tmdbGenres.map(mapper.map)

        return genres
    }

    ///
    /// Fetches the list of TV series genres from the TMDb API.
    ///
    /// - Returns: An array of genres applicable to TV series.
    ///
    /// - Throws: ``GenreRemoteDataSourceError`` if the fetch operation fails.
    ///
    func tvSeriesGenres() async throws(GenreRemoteDataSourceError) -> [GenresDomain.Genre] {
        let tmdbGenres: [TMDb.Genre]
        do {
            tmdbGenres = try await genreService.tvSeriesGenres(language: "en")
        } catch let error {
            throw GenreRemoteDataSourceError(error)
        }

        let mapper = GenreMapper()
        let genres = tmdbGenres.map(mapper.map)

        return genres
    }

}

private extension GenreRemoteDataSourceError {

    init(_ error: Error) {
        guard let error = error as? TMDbError else {
            self = .unknown(error)
            return
        }

        self.init(error)
    }

    init(_ error: TMDbError) {
        switch error {
        case .unauthorised:
            self = .unauthorised
        default:
            self = .unknown(error)
        }
    }

}
