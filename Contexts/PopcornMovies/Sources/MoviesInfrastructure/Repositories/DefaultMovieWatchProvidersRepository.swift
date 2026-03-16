//
//  DefaultMovieWatchProvidersRepository.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain

final class DefaultMovieWatchProvidersRepository: MovieWatchProvidersRepository {

    private let remoteDataSource: any MovieRemoteDataSource

    init(remoteDataSource: some MovieRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func watchProviders(
        forMovie movieID: Int
    ) async throws(MovieWatchProvidersRepositoryError) -> WatchProviderCollection? {
        do {
            return try await remoteDataSource.watchProviders(forMovie: movieID)
        } catch let error {
            throw MovieWatchProvidersRepositoryError(error)
        }
    }

}

private extension MovieWatchProvidersRepositoryError {

    init(_ error: Error) {
        if let remoteError = error as? MovieRemoteDataSourceError {
            self.init(remoteError)
            return
        }
        self = .unknown(error)
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
