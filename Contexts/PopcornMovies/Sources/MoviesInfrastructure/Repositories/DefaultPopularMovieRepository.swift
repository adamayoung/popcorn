//
//  DefaultPopularMovieRepository.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain
import OSLog

final class DefaultPopularMovieRepository: PopularMovieRepository {

    private static let logger = Logger.moviesInfrastructure

    private let remoteDataSource: any MovieRemoteDataSource
    private let localDataSource: any PopularMovieLocalDataSource

    init(
        remoteDataSource: some MovieRemoteDataSource,
        localDataSource: any PopularMovieLocalDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func popular(page: Int) async throws(PopularMovieRepositoryError) -> MoviePreviewPage {
        do {
            if let cachedPage = try await localDataSource.popular(page: page) {
                return cachedPage
            }
        } catch let error {
            throw PopularMovieRepositoryError(error)
        }

        let moviePage: MoviePreviewPage
        do { moviePage = try await remoteDataSource.popular(page: page) } catch let error {
            throw PopularMovieRepositoryError(error)
        }

        try? await localDataSource.setPopular(moviePage)

        return moviePage
    }

    func popularStream() async -> AsyncThrowingStream<[MoviePreview]?, Error> {
        let stream = await localDataSource.popularStream()

        Task {
            do {
                if try await localDataSource.popular(page: 1) == nil {
                    let moviePage = try await remoteDataSource.popular(page: 1)
                    try await localDataSource.setPopular(moviePage)
                }
            } catch {
                Self.logger.error("Failed to fetch/cache popular movies in stream: \(error)")
            }
        }

        return stream
    }

    func nextPopularStreamPage() async throws(PopularMovieRepositoryError) {
        let currentPage: Int
        do {
            currentPage = try await localDataSource.currentPopularStreamPage() ?? 0
        } catch let error {
            throw PopularMovieRepositoryError(error)
        }

        let nextPage = currentPage + 1

        let moviePage: MoviePreviewPage
        do { moviePage = try await remoteDataSource.popular(page: nextPage) } catch let error {
            throw PopularMovieRepositoryError(error)
        }

        do { try await localDataSource.setPopular(moviePage) } catch let error {
            throw PopularMovieRepositoryError(error)
        }
    }

}

extension PopularMovieRepositoryError {

    init(_ error: PopularMovieLocalDataSourceError) {
        switch error {
        case .persistence(let error):
            self = .unknown(error)
        case .unknown(let error):
            self = .unknown(error)
        }
    }

    init(_ error: MovieRemoteDataSourceError) {
        switch error {
        case .notFound:
            self = .notFound
        case .unauthorised:
            self = .unauthorised
        case .unknown(let error):
            self = .unknown(error)
        }
    }

}
