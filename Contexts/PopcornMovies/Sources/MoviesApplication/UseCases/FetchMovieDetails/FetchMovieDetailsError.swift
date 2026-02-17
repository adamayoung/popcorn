//
//  FetchMovieDetailsError.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain

///
/// Errors that can occur when fetching movie details.
///
/// This error type represents all possible failure scenarios when attempting
/// to retrieve comprehensive movie information through ``FetchMovieDetailsUseCase``.
/// Errors from underlying repositories are mapped to this type for consistent
/// error handling at the application layer.
///
public enum FetchMovieDetailsError: Error {

    /// The requested movie was not found.
    case notFound

    /// Access to the movie data or API is unauthorised.
    case unauthorised

    /// An unexpected error occurred.
    ///
    /// - Parameter Error: The underlying error that caused the failure, if available
    case unknown(Error?)

}

extension FetchMovieDetailsError {

    ///
    /// Creates a fetch movie details error from any error type.
    ///
    /// This initializer maps known error types from repositories and providers
    /// to the appropriate ``FetchMovieDetailsError`` case. Unrecognised errors
    /// are wrapped in the ``unknown(_:)`` case.
    ///
    /// - Parameter error: The error to convert
    ///
    init(_ error: Error) {
        if let repositoryError = error as? MovieRepositoryError {
            self.init(repositoryError)
            return
        }

        if let appConfigurationProviderError = error as? AppConfigurationProviderError {
            self.init(appConfigurationProviderError)
            return
        }

        self = .unknown(error)
    }

    ///
    /// Creates a fetch movie details error from a movie repository error.
    ///
    /// This initializer maps ``MovieRepositoryError`` cases to their corresponding
    /// ``FetchMovieDetailsError`` equivalents.
    ///
    /// - Parameter error: The movie repository error to convert
    ///
    init(_ error: MovieRepositoryError) {
        switch error {
        case .notFound:
            self = .notFound
        case .unauthorised:
            self = .unauthorised
        case .unknown(let error):
            self = .unknown(error)
        }
    }

    ///
    /// Creates a fetch movie details error from an app configuration provider error.
    ///
    /// This initializer maps ``AppConfigurationProviderError`` cases to their
    /// corresponding ``FetchMovieDetailsError`` equivalents. Note that configuration
    /// errors cannot produce ``notFound`` errors.
    ///
    /// - Parameter error: The app configuration provider error to convert
    ///
    init(_ error: AppConfigurationProviderError) {
        switch error {
        case .unauthorised:
            self = .unauthorised
        case .unknown(let error):
            self = .unknown(error)
        }
    }

}
