//
//  FetchEpisodeDetailsError.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesApplication

/// A user-facing error surfaced when fetching a TV episode's details fails.
public enum FetchEpisodeDetailsError: LocalizedError {

    case notFound(Error? = nil)
    case unknown(Error? = nil)

    public var errorDescription: String? {
        switch self {
        case .notFound:
            String(localized: "EPISODE_NOT_FOUND_ERROR_DESCRIPTION", bundle: .module)
        case .unknown:
            String(localized: "UNKNOWN_ERROR_DESCRIPTION", bundle: .module)
        }
    }

    public var failureReason: String? {
        switch self {
        case .notFound:
            String(localized: "EPISODE_NOT_FOUND_ERROR_REASON", bundle: .module)
        case .unknown:
            String(localized: "UNKNOWN_ERROR_REASON", bundle: .module)
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .notFound:
            String(localized: "EPISODE_NOT_FOUND_ERROR_RECOVERY", bundle: .module)
        case .unknown:
            String(localized: "UNKNOWN_ERROR_RECOVERY", bundle: .module)
        }
    }

}

extension FetchEpisodeDetailsError {

    /// Wraps an arbitrary error, mapping known ``FetchTVEpisodeDetailsError`` cases to
    /// specific cases and anything else to ``unknown``.
    public init(_ error: any Error) {
        if let fetchTVEpisodeDetailsError = error as? FetchTVEpisodeDetailsError {
            self.init(fetchTVEpisodeDetailsError)
            return
        }

        self = .unknown(error)
    }

    init(_ error: FetchTVEpisodeDetailsError) {
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
