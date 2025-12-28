//
//  FetchMovieImageCollectionError.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

///
/// Errors that can occur when fetching a movie's image collection.
///
/// This error type represents all possible failure scenarios when attempting
/// to retrieve image data through ``FetchMovieImageCollectionUseCase``.
///
public enum FetchMovieImageCollectionError: Error {

    /// The requested movie images were not found.
    case notFound

    /// Access to the image data or API is unauthorised.
    case unauthorised

    /// An unexpected error occurred.
    case unknown(Error?)

}

extension FetchMovieImageCollectionError {

    ///
    /// Creates a fetch movie image collection error from any error type.
    ///
    /// This initializer maps known error types from repositories to the appropriate
    /// ``FetchMovieImageCollectionError`` case. Unrecognised errors are wrapped
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
    /// Creates a fetch movie image collection error from a movie repository error.
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
