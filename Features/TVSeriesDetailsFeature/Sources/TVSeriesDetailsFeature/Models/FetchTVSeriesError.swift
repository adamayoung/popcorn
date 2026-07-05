//
//  FetchTVSeriesError.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesApplication

/// A user-facing error surfaced when fetching TV series details fails.
public enum FetchTVSeriesError: LocalizedError {

    case notFound(Error? = nil)
    case unknown(Error? = nil)

    public var errorDescription: String? {
        switch self {
        case .notFound:
            String(localized: "TV_SERIES_NOT_FOUND_ERROR_DESCRIPTION", bundle: .module)
        case .unknown:
            String(localized: "UNKNOWN_ERROR_DESCRIPTION", bundle: .module)
        }
    }

    public var failureReason: String? {
        switch self {
        case .notFound:
            String(localized: "TV_SERIES_NOT_FOUND_ERROR_REASON", bundle: .module)
        case .unknown:
            String(localized: "UNKNOWN_ERROR_REASON", bundle: .module)
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .notFound:
            String(localized: "TV_SERIES_NOT_FOUND_ERROR_RECOVERY", bundle: .module)
        case .unknown:
            String(localized: "UNKNOWN_ERROR_RECOVERY", bundle: .module)
        }
    }

}

extension FetchTVSeriesError {

    /// Wraps an arbitrary error, mapping known ``FetchTVSeriesDetailsError`` cases to
    /// specific cases and anything else to ``unknown``.
    public init(_ error: any Error) {
        if let fetchTVSeriesDetailsError = error as? FetchTVSeriesDetailsError {
            self.init(fetchTVSeriesDetailsError)
            return
        }

        self = .unknown(error)
    }

    init(_ error: FetchTVSeriesDetailsError) {
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
