//
//  FetchMovieRecommendationsError.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

///
/// Errors that can occur when fetching movie recommendations.
///
/// This error type represents all possible failure scenarios when attempting
/// to retrieve recommendations through ``FetchMovieRecommendationsUseCase``.
///
public enum FetchMovieRecommendationsError: Error {

    /// The requested movie recommendations were not found.
    case notFound

    /// Access to the recommendation data or API is unauthorised.
    case unauthorised

    /// An unexpected error occurred.
    case unknown(Error?)

}

extension FetchMovieRecommendationsError {

    ///
    /// Creates a fetch movie recommendations error from any error type.
    ///
    /// This initializer maps known error types from repositories to the appropriate
    /// ``FetchMovieRecommendationsError`` case. Unrecognised errors are wrapped
    /// in the ``unknown(_:)`` case.
    ///
    /// - Parameter error: The error to convert.
    ///
    init(_ error: Error) {
        if let repositoryError = error as? MovieRecommendationRepositoryError {
            self.init(repositoryError)
            return
        }

        if let imageRepositoryError = error as? MovieImageRepositoryError {
            self.init(imageRepositoryError)
            return
        }

        self = .unknown(error)
    }

    ///
    /// Creates a fetch movie recommendations error from a movie recommendation repository error.
    ///
    /// - Parameter error: The movie recommendation repository error to convert.
    ///
    init(_ error: MovieRecommendationRepositoryError) {
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

    ///
    /// Creates a fetch movie recommendations error from a movie image repository error.
    ///
    /// - Parameter error: The movie image repository error to convert.
    ///
    init(_ error: MovieImageRepositoryError) {
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
