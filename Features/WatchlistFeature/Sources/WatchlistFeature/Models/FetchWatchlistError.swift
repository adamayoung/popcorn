//
//  FetchWatchlistError.swift
//  WatchlistFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesApplication

enum FetchWatchlistError: LocalizedError {

    case unknown(Error? = nil)

    var errorDescription: String? {
        switch self {
        case .unknown:
            String(localized: "WATCHLIST_LOAD_ERROR_DESCRIPTION", bundle: .module)
        }
    }

    var failureReason: String? {
        switch self {
        case .unknown:
            String(localized: "WATCHLIST_LOAD_ERROR_REASON", bundle: .module)
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .unknown:
            String(localized: "WATCHLIST_LOAD_ERROR_RECOVERY", bundle: .module)
        }
    }

}

extension FetchWatchlistError {

    init(_ error: any Error) {
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
