//
//  AddMediaSearchHistoryEntryError.swift
//  PopcornSearch
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SearchDomain

public enum AddMediaSearchHistoryEntryError: Error {

    case unknown(Error?)

}

extension AddMediaSearchHistoryEntryError {

    init(_ error: MediaRepositoryError) {
        switch error {
        case .unauthorised:
            self = .unknown(nil)
        case .unknown(let error):
            self = .unknown(error)
        }
    }

}
