//
//  FetchExploreContentError.swift
//  ExploreFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation

enum FetchExploreContentError: LocalizedError {

    case unknown(Error? = nil)

    var errorDescription: String? {
        switch self {
        case .unknown:
            String(localized: "EXPLORE_CONTENT_LOAD_ERROR_DESCRIPTION", bundle: .module)
        }
    }

    var failureReason: String? {
        switch self {
        case .unknown:
            String(localized: "EXPLORE_CONTENT_LOAD_ERROR_REASON", bundle: .module)
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .unknown:
            String(localized: "EXPLORE_CONTENT_LOAD_ERROR_RECOVERY", bundle: .module)
        }
    }

}

extension FetchExploreContentError {

    init(_ error: any Error) {
        self = .unknown(error)
    }

}
