//
//  TVListingsRepositoryError+Infrastructure.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

extension TVListingsRepositoryError {

    init(_ error: TVListingsLocalDataSourceError) {
        switch error {
        case .persistence(let error):
            self = .local(error)

        case .unknown(let error):
            self = .unknown(error)
        }
    }

    init(_ error: TVListingsRemoteDataSourceError) {
        switch error {
        case .network(let error):
            self = .remote(error)

        case .decoding(let error):
            self = .remote(error)

        case .unknown(let error):
            self = .unknown(error)
        }
    }

}
