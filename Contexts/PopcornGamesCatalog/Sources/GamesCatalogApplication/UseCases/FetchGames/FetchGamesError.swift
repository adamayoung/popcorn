//
//  FetchGamesError.swift
//  PopcornGamesCatalog
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GamesCatalogDomain

///
/// Errors that can occur when fetching the list of games.
///
public enum FetchGamesError: Error {

    /// An unknown error occurred while fetching the games.
    case unknown(Error? = nil)

}

extension FetchGamesError {

    init(_ error: GameRepositoryError) {
        switch error {
        case .unknown(let error): self = .unknown(error)
        default: self = .unknown(nil)
        }
    }

}
