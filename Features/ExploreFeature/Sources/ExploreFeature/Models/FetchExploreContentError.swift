//
//  FetchExploreContentError.swift
//  ExploreFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// A user-facing error surfaced when fetching Explore content fails.
public enum FetchExploreContentError: LocalizedError {

    case unknown(Error? = nil)

    public var errorDescription: String? {
        switch self {
        case .unknown:
            String(localized: "EXPLORE_CONTENT_LOAD_ERROR_DESCRIPTION", bundle: .module)
        }
    }

    public var failureReason: String? {
        switch self {
        case .unknown:
            String(localized: "EXPLORE_CONTENT_LOAD_ERROR_REASON", bundle: .module)
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .unknown:
            String(localized: "EXPLORE_CONTENT_LOAD_ERROR_RECOVERY", bundle: .module)
        }
    }

}

public extension FetchExploreContentError {

    /// Wraps an arbitrary error as ``unknown``.
    init(_ error: any Error) {
        self = .unknown(error)
    }

}
