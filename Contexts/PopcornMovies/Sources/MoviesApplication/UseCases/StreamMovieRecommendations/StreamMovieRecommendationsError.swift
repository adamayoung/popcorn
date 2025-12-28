//
//  StreamMovieRecommendationsError.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

///
/// Errors that can occur when streaming movie recommendations.
///
/// This error type represents all possible failure scenarios when attempting
/// to stream or paginate recommendations through ``StreamMovieRecommendationsUseCase``.
///
public enum StreamMovieRecommendationsError: Error {

    /// The requested movie recommendations were not found.
    case notFound

    /// Access to the recommendation data or API is unauthorised.
    case unauthorised

    /// An unexpected error occurred.
    case unknown(Error?)

}

extension StreamMovieRecommendationsError {

    ///
    /// Creates a stream movie recommendations error from any error type.
    ///
    /// This initializer maps known error types from repositories to the appropriate
    /// ``StreamMovieRecommendationsError`` case. Unrecognised errors are wrapped
    /// in the ``unknown(_:)`` case.
    ///
    /// - Parameter error: The error to convert.
    ///
    init(_ error: Error) {
        if let repositoryError = error as? MovieRecommendationRepositoryError {
            self.init(repositoryError)
            return
        }

        self = .unknown(error)
    }

    ///
    /// Creates a stream movie recommendations error from a movie recommendation repository error.
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

}
