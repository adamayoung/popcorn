//
//  FetchDiscoverTVSeriesError.swift
//  PopcornDiscover
//
//  Copyright © 2026 Adam Young.
//

import DiscoverDomain
import Foundation

public enum FetchDiscoverTVSeriesError: Error {

    case unauthorised
    case unknown(Error?)

}

extension FetchDiscoverTVSeriesError {

    init(_ error: Error) {
        if let repositoryError = error as? DiscoverTVSeriesRepositoryError {
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

    init(_ error: DiscoverTVSeriesRepositoryError) {
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
