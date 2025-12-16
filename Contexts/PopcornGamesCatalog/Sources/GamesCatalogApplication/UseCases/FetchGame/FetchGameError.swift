//
//  FetchGameError.swift
//  PopcornGamesCatalog
//
//  Created by Adam Young on 09/12/2025.
//

import Foundation
import GamesCatalogDomain

public enum FetchGameError: Error {

    case notFound
    case unknown(Error? = nil)

}

extension FetchGameError {

    init(_ error: GameRepositoryError) {
        switch error {
        case .notFound: self = .notFound
        case .unknown(let error): self = .unknown(error)
        }
    }

}
