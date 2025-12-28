//
//  ToggleWatchlistMovieError.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

///
/// Errors that can occur when toggling a movie's watchlist status.
///
/// This error type represents all possible failure scenarios when attempting
/// to add or remove a movie from the watchlist through ``ToggleWatchlistMovieUseCase``.
///
public enum ToggleWatchlistMovieError: Error {

    /// The movie was not found.
    case notFound

    /// An unexpected error occurred.
    case unknown(Error?)

}

extension ToggleWatchlistMovieError {

    ///
    /// Creates a toggle watchlist movie error from any error type.
    ///
    /// This initializer maps known error types from repositories to the appropriate
    /// ``ToggleWatchlistMovieError`` case. Unrecognised errors are wrapped
    /// in the ``unknown(_:)`` case.
    ///
    /// - Parameter error: The error to convert.
    ///
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

    ///
    /// Creates a toggle watchlist movie error from a movie repository error.
    ///
    /// - Parameter error: The movie repository error to convert.
    ///
    init(_ error: MovieRepositoryError) {
        switch error {
        case .cacheUnavailable:
            self = .unknown(nil)

        case .notFound:
            self = .notFound

        case .unauthorised:
            self = .notFound

        case .unknown(let error):
            self = .unknown(error)
        }
    }

    ///
    /// Creates a toggle watchlist movie error from a movie watchlist repository error.
    ///
    /// - Parameter error: The movie watchlist repository error to convert.
    ///
    init(_ error: MovieWatchlistRepositoryError) {
        switch error {
        case .unknown(let error):
            self = .unknown(error)
        }
    }

}
