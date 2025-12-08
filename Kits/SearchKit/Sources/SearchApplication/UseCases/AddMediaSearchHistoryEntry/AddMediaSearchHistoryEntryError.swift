//
//  AddMediaSearchHistoryEntryError.swift
//  SearchKit
//
//  Created by Adam Young on 04/12/2025.
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
