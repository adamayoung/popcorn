//
//  DefaultMovieRecommendationRepository.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain

final class DefaultMovieRecommendationRepository: MovieRecommendationRepository {

    private let remoteDataSource: any MovieRemoteDataSource
    private let localDataSource: any MovieRecommendationLocalDataSource

    init(
        remoteDataSource: some MovieRemoteDataSource,
        localDataSource: any MovieRecommendationLocalDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func recommendations(
        forMovie movieID: Int,
        page: Int
    ) async throws(MovieRecommendationRepositoryError) -> [MoviePreview] {
        do {
            if let cachedMovies = try await localDataSource.recommendations(forMovie: movieID, page: page) {
                return cachedMovies
            }
        } catch let error {
            throw MovieRecommendationRepositoryError(error)
        }

        let movies: [MoviePreview]
        do {
            movies = try await remoteDataSource.recommendations(forMovie: movieID, page: page)
        } catch let error {
            throw MovieRecommendationRepositoryError(error)
        }

        try? await localDataSource.setRecommendations(movies, forMovie: movieID, page: page)

        return movies
    }

    func recommendationsStream(
        forMovie movieID: Int
    ) async -> AsyncThrowingStream<[MoviePreview]?, Error> {
        await recommendationsStream(forMovie: movieID, limit: nil)
    }

    func recommendationsStream(
        forMovie movieID: Int,
        limit: Int?
    ) async -> AsyncThrowingStream<[MoviePreview]?, Error> {
        let stream = await localDataSource.recommendationsStream(forMovie: movieID, limit: limit)

        Task {
            let page = 1
            let movies = try await remoteDataSource.recommendations(forMovie: movieID, page: page)
            try await localDataSource.setRecommendations(movies, forMovie: movieID, page: page)
        }

        return stream
    }

    func nextRecommendationsStreamPage(forMovie movieID: Int) async throws(MovieRecommendationRepositoryError) {
        let currentPage: Int
        do {
            currentPage = try await localDataSource.currentRecommendationsStreamPage(forMovie: movieID) ?? 0
        } catch let error {
            throw MovieRecommendationRepositoryError(error)
        }

        let nextPage = currentPage + 1

        let movies: [MoviePreview]
        do {
            movies = try await remoteDataSource.recommendations(forMovie: movieID, page: nextPage)
        } catch let error {
            throw MovieRecommendationRepositoryError(error)
        }

        do {
            try await localDataSource.setRecommendations(movies, forMovie: movieID, page: nextPage)
        } catch let error {
            throw MovieRecommendationRepositoryError(error)
        }
    }

}

extension MovieRecommendationRepositoryError {

    init(_ error: MovieRecommendationLocalDataSourceError) {
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
