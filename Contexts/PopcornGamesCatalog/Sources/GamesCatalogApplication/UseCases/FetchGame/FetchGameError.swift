//
//  FetchGameError.swift
//  PopcornGamesCatalog
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GamesCatalogDomain

///
/// Errors that can occur when fetching a single game.
///
public enum FetchGameError: Error {

    /// The requested game was not found in the catalog.
    case notFound

    /// An unknown error occurred while fetching the game.
    case unknown(Error? = nil)

}

extension FetchGameError {

    init(_ error: GameRepositoryError) {
        switch error {
        case .cacheUnavailable: self = .unknown(nil)
        case .notFound: self = .notFound
        case .unknown(let error): self = .unknown(error)
        }
    }

}
