//
//  FetchGamesCatalogError.swift
//  GamesCatalogFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import GamesCatalogApplication

enum FetchGamesCatalogError: LocalizedError {

    case unknown(Error? = nil)

    var errorDescription: String? {
        switch self {
        case .unknown:
            String(localized: "GAMES_LOAD_ERROR_DESCRIPTION", bundle: .module)
        }
    }

    var failureReason: String? {
        switch self {
        case .unknown:
            String(localized: "GAMES_LOAD_ERROR_REASON", bundle: .module)
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .unknown:
            String(localized: "GAMES_LOAD_ERROR_RECOVERY", bundle: .module)
        }
    }

}

extension FetchGamesCatalogError {

    init(_ error: any Error) {
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
