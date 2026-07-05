//
//  FetchMovieError.swift
//  MovieDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesApplication

/// A user-facing error surfaced when fetching a movie fails.
public enum FetchMovieError: LocalizedError {

    case notFound(Error? = nil)
    case unknown(Error? = nil)

    public var errorDescription: String? {
        switch self {
        case .notFound:
            String(localized: "MOVIE_NOT_FOUND_ERROR_DESCRIPTION", bundle: .module)
        case .unknown:
            String(localized: "UNKNOWN_ERROR_DESCRIPTION", bundle: .module)
        }
    }

    public var failureReason: String? {
        switch self {
        case .notFound:
            String(localized: "MOVIE_NOT_FOUND_ERROR_REASON", bundle: .module)
        case .unknown:
            String(localized: "UNKNOWN_ERROR_REASON", bundle: .module)
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .notFound:
            String(localized: "MOVIE_NOT_FOUND_ERROR_RECOVERY", bundle: .module)
        case .unknown:
            String(localized: "UNKNOWN_ERROR_RECOVERY", bundle: .module)
        }
    }

}

extension FetchMovieError {

    /// Wraps an arbitrary error, mapping known ``FetchMovieDetailsError`` cases to
    /// specific cases and anything else to ``unknown``.
    public init(_ error: any Error) {
        if let fetchMovieDetailsError = error as? FetchMovieDetailsError {
            self.init(fetchMovieDetailsError)
            return
        }

        self = .unknown(error)
    }

    init(_ error: FetchMovieDetailsError) {
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
