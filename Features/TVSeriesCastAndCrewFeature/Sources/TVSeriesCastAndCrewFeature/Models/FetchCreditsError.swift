//
//  FetchCreditsError.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesApplication

enum FetchCreditsError: LocalizedError {

    case notFound(Error? = nil)
    case unknown(Error? = nil)

    var errorDescription: String? {
        switch self {
        case .notFound:
            String(localized: "CREDITS_NOT_FOUND_FOR_TV_SERIES_ERROR_DESCRIPTION", bundle: .module)
        case .unknown:
            String(localized: "UNKNOWN_ERROR_DESCRIPTION", bundle: .module)
        }
    }

    var failureReason: String? {
        switch self {
        case .notFound:
            String(localized: "CREDITS_NOT_FOUND_FOR_TV_SERIES_ERROR_REASON", bundle: .module)
        case .unknown:
            String(localized: "UNKNOWN_ERROR_REASON", bundle: .module)
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .notFound:
            String(localized: "CREDITS_NOT_FOUND_FOR_TV_SERIES_ERROR_RECOVERY", bundle: .module)
        case .unknown:
            String(localized: "UNKNOWN_ERROR_RECOVERY", bundle: .module)
        }
    }

}

extension FetchCreditsError {

    init(_ error: any Error) {
        if let fetchTVSeriesAggregateCreditsError = error as? FetchTVSeriesAggregateCreditsError {
            self.init(fetchTVSeriesAggregateCreditsError)
            return
        }

        self = .unknown(error)
    }

    init(_ error: FetchTVSeriesAggregateCreditsError) {
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
