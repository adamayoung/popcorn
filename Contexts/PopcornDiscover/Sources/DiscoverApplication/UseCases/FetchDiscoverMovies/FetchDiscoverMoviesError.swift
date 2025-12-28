//
//  FetchDiscoverMoviesError.swift
//  PopcornDiscover
//
//  Copyright © 2025 Adam Young.
//

import DiscoverDomain
import Foundation

///
/// Errors that can occur when fetching discoverable movies.
///
public enum FetchDiscoverMoviesError: Error {

    /// The request was not authorized due to invalid or missing credentials.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
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
        case .cacheUnavailable:
            self = .unknown(nil)
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
