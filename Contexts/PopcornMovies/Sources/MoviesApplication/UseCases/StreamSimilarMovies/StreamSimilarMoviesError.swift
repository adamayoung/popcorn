//
//  StreamSimilarMoviesError.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

///
/// Errors that can occur when streaming similar movies.
///
/// This error type represents all possible failure scenarios when attempting
/// to stream or paginate similar movies through ``StreamSimilarMoviesUseCase``.
///
public enum StreamSimilarMoviesError: Error {

    /// The requested similar movies were not found.
    case notFound

    /// Access to the movie data or API is unauthorised.
    case unauthorised

    /// An unexpected error occurred.
    case unknown(Error?)

}

extension StreamSimilarMoviesError {

    ///
    /// Creates a stream similar movies error from any error type.
    ///
    /// This initializer maps known error types from repositories to the appropriate
    /// ``StreamSimilarMoviesError`` case. Unrecognised errors are wrapped
    /// in the ``unknown(_:)`` case.
    ///
    /// - Parameter error: The error to convert.
    ///
    init(_ error: Error) {
        if let repositoryError = error as? MovieRepositoryError {
            self.init(repositoryError)
            return
        }

        self = .unknown(error)
    }

    ///
    /// Creates a stream similar movies error from a movie repository error.
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
            self = .unauthorised
        case .unknown(let error):
            self = .unknown(error)
        }
    }

}
