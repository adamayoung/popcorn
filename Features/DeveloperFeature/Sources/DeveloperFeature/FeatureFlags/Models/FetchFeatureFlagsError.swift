//
//  FetchFeatureFlagsError.swift
//  DeveloperFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation

enum FetchFeatureFlagsError: LocalizedError {

    case unknown(Error? = nil)

    var errorDescription: String? {
        switch self {
        case .unknown:
            String(localized: "FEATURE_FLAGS_LOAD_ERROR_DESCRIPTION", bundle: .module)
        }
    }

    var failureReason: String? {
        switch self {
        case .unknown:
            String(localized: "FEATURE_FLAGS_LOAD_ERROR_REASON", bundle: .module)
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .unknown:
            String(localized: "FEATURE_FLAGS_LOAD_ERROR_RECOVERY", bundle: .module)
        }
    }

}

extension FetchFeatureFlagsError {

    init(_ error: any Error) {
        self = .unknown(error)
    }

}
