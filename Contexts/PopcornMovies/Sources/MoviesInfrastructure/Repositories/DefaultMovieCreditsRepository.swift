//
//  DefaultMovieCreditsRepository.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain

final class DefaultMovieCreditsRepository: MovieCreditsRepository {

    private let remoteDataSource: any MovieRemoteDataSource
    private let localDataSource: any MovieCreditsLocalDataSource

    init(
        remoteDataSource: some MovieRemoteDataSource,
        localDataSource: some MovieCreditsLocalDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func credits(forMovie movieID: Int) async throws(MovieCreditsRepositoryError) -> Credits {
        do {
            if let cachedCredits = try await localDataSource.credits(forMovie: movieID) {
                return cachedCredits
            }
        } catch let error {
            throw MovieCreditsRepositoryError(error)
        }

        let credits: Credits
        do {
            credits = try await remoteDataSource.credits(forMovie: movieID)
        } catch let error {
            throw MovieCreditsRepositoryError(error)
        }

        do {
            try await localDataSource.setCredits(credits, forMovie: movieID)
        } catch let error {
            throw MovieCreditsRepositoryError(error)
        }

        return credits
    }

}

extension MovieCreditsRepositoryError {

    init(_ error: MovieCreditsLocalDataSourceError) {
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
