//
//  FetchMovieCreditsError.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

///
/// Errors that can occur when fetching movie credits.
///
/// This error type represents all possible failure scenarios when attempting
/// to retrieve comprehensive movie information through ``FetchMovieCreditsUseCase``.
/// Errors from underlying repositories are mapped to this type for consistent
/// error handling at the application layer.
///
public enum FetchMovieCreditsError: Error {

    /// The requested movie was not found.
    case notFound

    /// Access to the movie data or API is unauthorised.
    case unauthorised

    /// An unexpected error occurred.
    ///
    /// - Parameter Error: The underlying error that caused the failure, if available
    case unknown(Error?)

}

extension FetchMovieCreditsError {

    init(_ error: Error) {
        if let repositoryError = error as? MovieCreditsRepositoryError {
            self.init(repositoryError)
            return
        }

        if let appConfigurationProviderError = error as? AppConfigurationProviderError {
            self.init(appConfigurationProviderError)
            return
        }

        self = .unknown(error)
    }

    init(_ error: MovieCreditsRepositoryError) {
        switch error {
        case .notFound:
            self = .notFound
        case .unauthorised:
            self = .unauthorised
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
