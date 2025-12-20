//
//  ToggleWatchlistMovieError.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

public enum ToggleWatchlistMovieError: Error {

    case notFound
    case unknown(Error?)

}

extension ToggleWatchlistMovieError {

    init(_ error: Error) {
        if let repositoryError = error as? MovieRepositoryError {
            self.init(repositoryError)
            return
        }

        if let repositoryError = error as? MovieWatchlistRepositoryError {
            self.init(repositoryError)
            return
        }

        self = .unknown(error)
    }

    init(_ error: MovieRepositoryError) {
        switch error {
        case .notFound:
            self = .notFound

        case .unauthorised:
            self = .notFound

        case .unknown(let error):
            self = .unknown(error)
        }
    }

    init(_ error: MovieWatchlistRepositoryError) {
        switch error {
        case .unknown(let error):
            self = .unknown(error)
        }
    }

}
