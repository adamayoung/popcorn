//
//  FetchCreditsError.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesApplication

/// A user-facing error surfaced when fetching a movie's credits fails.
public enum FetchCreditsError: LocalizedError {

    case notFound(Error? = nil)
    case unknown(Error? = nil)

    public var errorDescription: String? {
        switch self {
        case .notFound:
            String(localized: "CREDITS_NOT_FOUND_FOR_MOVIE_ERROR_DESCRIPTION", bundle: .module)
        case .unknown:
            String(localized: "UNKNOWN_ERROR_DESCRIPTION", bundle: .module)
        }
    }

    public var failureReason: String? {
        switch self {
        case .notFound:
            String(localized: "CREDITS_NOT_FOUND_FOR_MOVIE_ERROR_REASON", bundle: .module)
        case .unknown:
            String(localized: "UNKNOWN_ERROR_REASON", bundle: .module)
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .notFound:
            String(localized: "CREDITS_NOT_FOUND_FOR_MOVIE_ERROR_RECOVERY", bundle: .module)
        case .unknown:
            String(localized: "UNKNOWN_ERROR_RECOVERY", bundle: .module)
        }
    }

}

extension FetchCreditsError {

    /// Wraps an arbitrary error, mapping known ``FetchMovieCreditsError`` cases to
    /// specific cases and anything else to ``unknown``.
    public init(_ error: any Error) {
        if let fetchMovieCreditsError = error as? FetchMovieCreditsError {
            self.init(fetchMovieCreditsError)
            return
        }

        self = .unknown(error)
    }

    init(_ error: FetchMovieCreditsError) {
        switch error {
        case .notFound:
            self = .notFound(error)
        case .unauthorised:
            self = .unknown(error)
        case .unknown:
            self = .unknown(error)
        }
    }

}
