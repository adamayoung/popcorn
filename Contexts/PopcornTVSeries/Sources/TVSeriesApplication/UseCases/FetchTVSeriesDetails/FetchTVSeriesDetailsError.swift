//
//  FetchTVSeriesDetailsError.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import TVSeriesDomain

///
/// Errors that can occur when fetching TV series details.
///
public enum FetchTVSeriesDetailsError: Error {

    /// The requested TV series was not found.
    case notFound

    /// The request was not authorized.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error?)

}

extension FetchTVSeriesDetailsError {

    init(_ error: Error) {
        if let repositoryError = error as? TVSeriesRepositoryError {
            self.init(repositoryError)
            return
        }

        if let appConfigurationProviderError = error as? AppConfigurationProviderError {
            self.init(appConfigurationProviderError)
            return
        }

        self = .unknown(error)
    }

    init(_ error: TVSeriesRepositoryError) {
        switch error {
        case .cacheUnavailable:
            self = .unknown(nil)
        case .notFound:
            self = .notFound
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
