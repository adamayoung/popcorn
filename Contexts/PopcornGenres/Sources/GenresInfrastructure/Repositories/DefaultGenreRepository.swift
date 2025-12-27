//
//  DefaultGenreRepository.swift
//  PopcornGenres
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GenresDomain

final class DefaultGenreRepository: GenreRepository {

    private let remoteDataSource: any GenreRemoteDataSource
    private let localDataSource: any GenreLocalDataSource

    init(
        remoteDataSource: some GenreRemoteDataSource,
        localDataSource: some GenreLocalDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func movieGenres(cachePolicy: CachePolicy = .cacheFirst) async throws(GenreRepositoryError) -> [Genre] {
        switch cachePolicy {
        case .cacheFirst:
            do {
                if let cachedGenres = try await localDataSource.movieGenres() {
                    return cachedGenres
                }
            } catch let error {
                throw GenreRepositoryError(error)
            }

            let genres: [Genre]
            do {
                genres = try await remoteDataSource.movieGenres()
                try await localDataSource.setMovieGenres(genres)
            } catch let error {
                throw GenreRepositoryError(error)
            }

            return genres

        case .networkOnly:
            let genres: [Genre]
            do {
                genres = try await remoteDataSource.movieGenres()
                try await localDataSource.setMovieGenres(genres)
            } catch let error {
                throw GenreRepositoryError(error)
            }

            return genres

        case .cacheOnly:
            do {
                if let cachedGenres = try await localDataSource.movieGenres() {
                    return cachedGenres
                }
            } catch let error {
                throw GenreRepositoryError(error)
            }

            throw .cacheUnavailable
        }
    }

    func tvSeriesGenres(cachePolicy: CachePolicy = .cacheFirst) async throws(GenreRepositoryError) -> [Genre] {
        switch cachePolicy {
        case .cacheFirst:
            do {
                if let cachedGenres = try await localDataSource.tvSeriesGenres() {
                    return cachedGenres
                }
            } catch let error {
                throw GenreRepositoryError(error)
            }

            let genres: [Genre]
            do {
                genres = try await remoteDataSource.tvSeriesGenres()
                try await localDataSource.setTVSeriesGenres(genres)
            } catch let error {
                throw GenreRepositoryError(error)
            }

            return genres

        case .networkOnly:
            let genres: [Genre]
            do {
                genres = try await remoteDataSource.tvSeriesGenres()
                try await localDataSource.setTVSeriesGenres(genres)
            } catch let error {
                throw GenreRepositoryError(error)
            }

            return genres

        case .cacheOnly:
            do {
                if let cachedGenres = try await localDataSource.tvSeriesGenres() {
                    return cachedGenres
                }
            } catch let error {
                throw GenreRepositoryError(error)
            }

            throw .cacheUnavailable
        }
    }

}

extension GenreRepositoryError {

    init(_ error: Error) {
        if let error = error as? GenreLocalDataSourceError {
            self.init(error)
            return
        }

        if let error = error as? GenreRemoteDataSourceError {
            self.init(error)
            return
        }

        self = .unknown(error)
    }

    init(_ error: GenreLocalDataSourceError) {
        switch error {
        case .persistence(let error):
            self = .unknown(error)
        case .unknown(let error):
            self = .unknown(error)
        }
    }

    init(_ error: GenreRemoteDataSourceError) {
        switch error {
        case .unauthorised:
            self = .unauthorised
        case .unknown(let error):
            self = .unknown(error)
        }
    }

}
