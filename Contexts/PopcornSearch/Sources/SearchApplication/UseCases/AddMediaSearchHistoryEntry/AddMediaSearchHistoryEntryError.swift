//
//  AddMediaSearchHistoryEntryError.swift
//  PopcornSearch
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import SearchDomain

///
/// Errors that can occur when adding a media search history entry.
///
public enum AddMediaSearchHistoryEntryError: Error {

    /// An unknown error occurred.
    case unknown(Error?)

}

extension AddMediaSearchHistoryEntryError {

    init(_ error: MediaRepositoryError) {
        switch error {
        case .cacheUnavailable:
            self = .unknown(nil)
        case .unauthorised:
            self = .unknown(nil)
        case .unknown(let error):
            self = .unknown(error)
        }
    }

}
