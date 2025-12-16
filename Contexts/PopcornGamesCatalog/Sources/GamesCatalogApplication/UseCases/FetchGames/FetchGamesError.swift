//
//  FetchGamesError.swift
//  PopcornGamesCatalog
//
//  Created by Adam Young on 09/12/2025.
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
