//
//  SyncTVListingsError.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

public enum SyncTVListingsError: Error {

    case remote(Error?)
    case local(Error?)
    case unknown(Error?)

}

extension SyncTVListingsError {

    init(_ error: TVListingsRepositoryError) {
        switch error {
        case .remote(let error):
            self = .remote(error)

        case .local(let error):
            self = .local(error)

        case .unknown(let error):
            self = .unknown(error)
        }
    }

}
