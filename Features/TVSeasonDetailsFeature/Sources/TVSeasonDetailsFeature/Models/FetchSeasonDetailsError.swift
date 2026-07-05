//
//  FetchSeasonDetailsError.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesApplication

/// A user-facing error surfaced when fetching a TV season's details fails.
public enum FetchSeasonDetailsError: LocalizedError {

    case notFound(Error? = nil)
    case unknown(Error? = nil)

    public var errorDescription: String? {
        switch self {
        case .notFound:
            String(localized: "SEASON_NOT_FOUND_ERROR_DESCRIPTION", bundle: .module)
        case .unknown:
            String(localized: "UNKNOWN_ERROR_DESCRIPTION", bundle: .module)
        }
    }

    public var failureReason: String? {
        switch self {
        case .notFound:
            String(localized: "SEASON_NOT_FOUND_ERROR_REASON", bundle: .module)
        case .unknown:
            String(localized: "UNKNOWN_ERROR_REASON", bundle: .module)
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .notFound:
            String(localized: "SEASON_NOT_FOUND_ERROR_RECOVERY", bundle: .module)
        case .unknown:
            String(localized: "UNKNOWN_ERROR_RECOVERY", bundle: .module)
        }
    }

}

extension FetchSeasonDetailsError {

    /// Wraps an arbitrary error, mapping known ``FetchTVSeasonDetailsError`` cases to
    /// specific cases and anything else to ``unknown``.
    public init(_ error: any Error) {
        if let fetchTVSeasonDetailsError = error as? FetchTVSeasonDetailsError {
            self.init(fetchTVSeasonDetailsError)
            return
        }

        self = .unknown(error)
    }

    init(_ error: FetchTVSeasonDetailsError) {
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
