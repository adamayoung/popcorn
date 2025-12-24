//
//  DefaultMovieRecommendationRepository.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
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

        do {
            try await localDataSource.setRecommendations(movies, forMovie: movieID, page: page)
        } catch let error {
            throw MovieRecommendationRepositoryError(error)
        }

        return movies
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
