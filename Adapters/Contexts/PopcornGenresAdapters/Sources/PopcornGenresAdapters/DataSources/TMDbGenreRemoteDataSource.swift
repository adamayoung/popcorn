//
//  TMDbGenreRemoteDataSource.swift
//  PopcornGenresAdapters
//
//  Created by Adam Young on 09/12/2025.
//

import Foundation
import GenresDomain
import GenresInfrastructure
import TMDb

final class TMDbGenreRemoteDataSource: GenreRemoteDataSource {

    private let genreService: any GenreService

    init(genreService: any GenreService) {
        self.genreService = genreService
    }

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

extension GenreRemoteDataSourceError {

    fileprivate init(_ error: Error) {
        guard let error = error as? TMDbError else {
            self = .unknown(error)
            return
        }

        self.init(error)
    }

    fileprivate init(_ error: TMDbError) {
        switch error {
        case .unauthorised:
            self = .unauthorised
        default:
            self = .unknown(error)
        }
    }

}
