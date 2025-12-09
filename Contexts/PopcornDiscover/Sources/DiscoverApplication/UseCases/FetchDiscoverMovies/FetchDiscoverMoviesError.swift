//
//  FetchDiscoverMoviesError.swift
//  PopcornDiscover
//
//  Created by Adam Young on 08/12/2025.
//

import DiscoverDomain
import Foundation

public enum FetchDiscoverMoviesError: Error {

    case unauthorised
    case unknown(Error?)

}

extension FetchDiscoverMoviesError {

    init(_ error: Error) {
        if let repositoryError = error as? DiscoverMovieRepositoryError {
            self.init(repositoryError)
            return
        }

        if let providerError = error as? GenreProviderError {
            self.init(providerError)
            return
        }

        if let appConfigurationProviderError = error as? AppConfigurationProviderError {
            self.init(appConfigurationProviderError)
            return
        }

        self = .unknown(error)
    }

    init(_ error: DiscoverMovieRepositoryError) {
        switch error {
        case .unauthorised:
            self = .unauthorised
        case .unknown(let error):
            self = .unknown(error)
        }
    }

    init(_ error: GenreProviderError) {
        switch error {
        case .unauthorised:
            self = .unauthorised
        case .unknown(let error):
            self = .unknown(error)
        }
    }

    init(_ error: AppConfigurationProviderError) {
        switch error {
        case .unauthorised:
            self = .unauthorised
        case .unknown(let error):
            self = .unknown(error)
        }
    }

}
