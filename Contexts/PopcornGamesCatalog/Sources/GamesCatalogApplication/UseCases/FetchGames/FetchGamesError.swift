//
//  FetchGamesError.swift
//  PopcornGamesCatalog
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import GamesCatalogDomain

public enum FetchGamesError: Error {

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
