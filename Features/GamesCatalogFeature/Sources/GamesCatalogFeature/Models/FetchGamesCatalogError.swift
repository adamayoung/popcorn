//
//  FetchGamesCatalogError.swift
//  GamesCatalogFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import GamesCatalogApplication

/// A user-facing error surfaced when fetching the games catalog fails.
public enum FetchGamesCatalogError: LocalizedError {

    case unknown(Error? = nil)

    public var errorDescription: String? {
        switch self {
        case .unknown:
            String(localized: "GAMES_LOAD_ERROR_DESCRIPTION", bundle: .module)
        }
    }

    public var failureReason: String? {
        switch self {
        case .unknown:
            String(localized: "GAMES_LOAD_ERROR_REASON", bundle: .module)
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .unknown:
            String(localized: "GAMES_LOAD_ERROR_RECOVERY", bundle: .module)
        }
    }

}

extension FetchGamesCatalogError {

    /// Wraps an arbitrary error, mapping known ``FetchGamesError`` cases to specific
    /// cases and anything else to ``unknown``.
    public init(_ error: any Error) {
        if let fetchGamesError = error as? FetchGamesError {
            self.init(fetchGamesError)
            return
        }

        self = .unknown(error)
    }

    init(_ error: FetchGamesError) {
        switch error {
        case .unknown:
            self = .unknown(error)
        }
    }

}
