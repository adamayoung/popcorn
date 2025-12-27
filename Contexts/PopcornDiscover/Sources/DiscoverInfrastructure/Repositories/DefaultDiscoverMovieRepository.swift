//
//  DefaultDiscoverMovieRepository.swift
//  PopcornDiscover
//
//  Copyright © 2025 Adam Young.
//

import DiscoverDomain
import Foundation

final class DefaultDiscoverMovieRepository: DiscoverMovieRepository {

    private let remoteDataSource: any DiscoverRemoteDataSource
    private let localDataSource: any DiscoverMovieLocalDataSource

    init(
        remoteDataSource: some DiscoverRemoteDataSource,
        localDataSource: any DiscoverMovieLocalDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func movies(
        filter: MovieFilter?,
        page: Int,
        cachePolicy: CachePolicy = .cacheFirst
    ) async throws(DiscoverMovieRepositoryError) -> [MoviePreview] {
        switch cachePolicy {
        case .cacheFirst:
            do {
                if let cachedMovies = try await localDataSource.movies(filter: filter, page: page) {
                    return cachedMovies
                }
            } catch let error {
                throw DiscoverMovieRepositoryError(error)
            }

            let movies: [MoviePreview]
            do {
                movies = try await remoteDataSource.movies(filter: filter, page: page)
            } catch let error {
                throw DiscoverMovieRepositoryError(error)
            }

            do {
                try await localDataSource.setMovies(movies, filter: filter, page: page)
            } catch let error {
                throw DiscoverMovieRepositoryError(error)
            }

            return movies

        case .networkOnly:
            let movies: [MoviePreview]
            do {
                movies = try await remoteDataSource.movies(filter: filter, page: page)
            } catch let error {
                throw DiscoverMovieRepositoryError(error)
            }

            do {
                try await localDataSource.setMovies(movies, filter: filter, page: page)
            } catch let error {
                throw DiscoverMovieRepositoryError(error)
            }

            return movies

        case .cacheOnly:
            do {
                if let cachedMovies = try await localDataSource.movies(filter: filter, page: page) {
                    return cachedMovies
                }
            } catch let error {
                throw DiscoverMovieRepositoryError(error)
            }

            throw .cacheUnavailable
        }
    }

}

extension DiscoverMovieRepositoryError {

    init(_ error: DiscoverMovieLocalDataSourceError) {
        switch error {
        case .persistence(let error):
            self = .unknown(error)
        case .unknown(let error):
            self = .unknown(error)
        }
    }

    init(_ error: DiscoverRemoteDataSourceError) {
        switch error {
        case .unauthorised:
            self = .unauthorised
        case .unknown(let error):
            self = .unknown(error)
        }
    }

}
