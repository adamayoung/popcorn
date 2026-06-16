//
//  FetchChannelsError.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

public enum FetchChannelsError: Error {

    case local(Error?)
    case unknown(Error?)

}

extension FetchChannelsError {

    init(_ error: TVListingsRepositoryError) {
        switch error {
        case .local(let error):
            self = .local(error)

        case .remote(let error), .unknown(let error):
            self = .unknown(error)
        }
    }

}
