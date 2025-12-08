//
//  DefaultSimilarMovieRepository.swift
//  PopcornMovies
//
//  Created by Adam Young on 03/12/2025.
//

import Foundation
import MoviesDomain

final class DefaultSimilarMovieRepository: SimilarMovieRepository {

    private let remoteDataSource: any MovieRemoteDataSource
    private let localDataSource: any SimilarMovieLocalDataSource

    init(
        remoteDataSource: some MovieRemoteDataSource,
        localDataSource: any SimilarMovieLocalDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func similar(
        toMovie movieID: Int,
        page: Int
    ) async throws(SimilarMovieRepositoryError) -> [MoviePreview] {
        do {
            if let cachedMovies = try await localDataSource.similar(toMovie: movieID, page: page) {
                return cachedMovies
            }
        } catch let error {
            throw SimilarMovieRepositoryError(error)
        }

        let movies: [MoviePreview]
        do { movies = try await remoteDataSource.similar(toMovie: movieID, page: page) } catch let
            error
        { throw SimilarMovieRepositoryError(error) }

        do { try await localDataSource.setSimilar(movies, toMovie: movieID, page: page) } catch let
            error
        { throw SimilarMovieRepositoryError(error) }

        return movies
    }

    func similarStream(
        toMovie movieID: Int
    ) async -> AsyncThrowingStream<[MoviePreview]?, Error> {
        await similarStream(toMovie: movieID, limit: nil)
    }

    func similarStream(
        toMovie movieID: Int,
        limit: Int?
    ) async -> AsyncThrowingStream<[MoviePreview]?, Error> {
        let stream = await localDataSource.similarStream(toMovie: movieID, limit: limit)

        Task {
            let page = 1
            if try await localDataSource.similar(toMovie: movieID, page: page) == nil {
                let movies = try await remoteDataSource.similar(toMovie: movieID, page: page)
                try await localDataSource.setSimilar(movies, toMovie: movieID, page: page)
            }
        }

        return stream
    }

    func nextSimilarStreamPage(forMovie movieID: Int) async throws(SimilarMovieRepositoryError) {
        let currentPage: Int
        do { currentPage = try await localDataSource.currentSimilarStreamPage() ?? 0 } catch let
            error
        { throw SimilarMovieRepositoryError(error) }

        let nextPage = currentPage + 1

        let movies: [MoviePreview]
        do {
            movies = try await remoteDataSource.similar(toMovie: movieID, page: nextPage)
        } catch let error { throw SimilarMovieRepositoryError(error) }

        do {
            try await localDataSource.setSimilar(movies, toMovie: movieID, page: nextPage)
        } catch let error { throw SimilarMovieRepositoryError(error) }
    }

}

extension SimilarMovieRepositoryError {

    init(_ error: SimilarMovieLocalDataSourceError) {
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
