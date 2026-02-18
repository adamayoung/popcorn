//
//  FetchWatchlistMoviesError.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain

public enum FetchWatchlistMoviesError: Error {

    case unauthorised
    case unknown(Error?)

}

extension FetchWatchlistMoviesError {

    init(_ error: Error) {
        if let repositoryError = error as? MovieWatchlistRepositoryError {
            self.init(repositoryError)
            return
        }

        if let configError = error as? AppConfigurationProviderError {
            self.init(configError)
            return
        }

        self = .unknown(error)
    }

    init(_ error: MovieWatchlistRepositoryError) {
        switch error {
        case .unknown(let error):
            self = .unknown(error)
        }
    }

    init(_ error: AppConfigurationProviderError) {
        switch error {
        case .unauthorised:
            self = .unauthorised
        case .unknown(let error):
            self = .unknown(error)
        }
    }

}
