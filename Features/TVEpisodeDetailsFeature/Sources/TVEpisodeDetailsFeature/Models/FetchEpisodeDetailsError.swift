//
//  FetchEpisodeDetailsError.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesApplication

enum FetchEpisodeDetailsError: LocalizedError {

    case notFound(Error? = nil)
    case unknown(Error? = nil)

    var errorDescription: String? {
        switch self {
        case .notFound:
            String(localized: "EPISODE_NOT_FOUND_ERROR_DESCRIPTION", bundle: .module)
        case .unknown:
            String(localized: "UNKNOWN_ERROR_DESCRIPTION", bundle: .module)
        }
    }

    var failureReason: String? {
        switch self {
        case .notFound:
            String(localized: "EPISODE_NOT_FOUND_ERROR_REASON", bundle: .module)
        case .unknown:
            String(localized: "UNKNOWN_ERROR_REASON", bundle: .module)
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .notFound:
            String(localized: "EPISODE_NOT_FOUND_ERROR_RECOVERY", bundle: .module)
        case .unknown:
            String(localized: "UNKNOWN_ERROR_RECOVERY", bundle: .module)
        }
    }

}

extension FetchEpisodeDetailsError {

    init(_ error: any Error) {
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
