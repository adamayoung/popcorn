//
//  DefaultPopularMovieRepository.swift
//  PopcornMovies
//
//  Created by Adam Young on 03/12/2025.
//

import Foundation
import MoviesDomain

final class DefaultPopularMovieRepository: PopularMovieRepository {

    private let remoteDataSource: any MovieRemoteDataSource
    private let localDataSource: any PopularMovieLocalDataSource

    init(
        remoteDataSource: some MovieRemoteDataSource,
        localDataSource: any PopularMovieLocalDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func popular(page: Int) async throws(PopularMovieRepositoryError) -> [MoviePreview] {
        do {
            if let cachedMovies = try await localDataSource.popular(page: page) {
                return cachedMovies
            }
        } catch let error {
            throw PopularMovieRepositoryError(error)
        }

        let movies: [MoviePreview]
        do { movies = try await remoteDataSource.popular(page: page) } catch let error {
            throw PopularMovieRepositoryError(error)
        }

        do { try await localDataSource.setPopular(movies, page: page) } catch let error {
            throw PopularMovieRepositoryError(error)
        }

        return movies
    }

    func popularStream() async -> AsyncThrowingStream<[MoviePreview]?, Error> {
        let stream = await localDataSource.popularStream()

        Task {
            let page = 1
            if try await localDataSource.popular(page: 1) == nil {
                let movies = try await remoteDataSource.popular(page: page)
                try await localDataSource.setPopular(movies, page: page)
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

        let movies: [MoviePreview]
        do { movies = try await remoteDataSource.popular(page: nextPage) } catch let error {
            throw PopularMovieRepositoryError(error)
        }

        do { try await localDataSource.setPopular(movies, page: nextPage) } catch let error {
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
