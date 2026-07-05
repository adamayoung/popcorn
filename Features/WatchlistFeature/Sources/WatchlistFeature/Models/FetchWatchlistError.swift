//
//  FetchWatchlistError.swift
//  WatchlistFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesApplication

/// A user-facing error surfaced when fetching the watchlist fails.
public enum FetchWatchlistError: LocalizedError {

    case unknown(Error? = nil)

    public var errorDescription: String? {
        switch self {
        case .unknown:
            String(localized: "WATCHLIST_LOAD_ERROR_DESCRIPTION", bundle: .module)
        }
    }

    public var failureReason: String? {
        switch self {
        case .unknown:
            String(localized: "WATCHLIST_LOAD_ERROR_REASON", bundle: .module)
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .unknown:
            String(localized: "WATCHLIST_LOAD_ERROR_RECOVERY", bundle: .module)
        }
    }

}

extension FetchWatchlistError {

    /// Wraps an arbitrary error, mapping known ``FetchWatchlistMoviesError`` cases to
    /// specific cases and anything else to ``unknown``.
    public init(_ error: any Error) {
        if let fetchWatchlistMoviesError = error as? FetchWatchlistMoviesError {
            self.init(fetchWatchlistMoviesError)
            return
        }

        self = .unknown(error)
    }

    init(_ error: FetchWatchlistMoviesError) {
        switch error {
        case .unauthorised:
            self = .unknown(error)
        case .unknown:
            self = .unknown(error)
        }
    }

}
