//
//  FetchTrendingTVSeriesError.swift
//  PopcornTrending
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import TrendingDomain

///
/// Errors that can occur when fetching trending TV series.
///
public enum FetchTrendingTVSeriesError: Error {

    /// The request was not authorized.
    case unauthorised

    /// An unknown error occurred.
    case unknown(Error?)

}

extension FetchTrendingTVSeriesError {

    init(_ error: Error) {
        if let repositoryError = error as? TrendingRepositoryError {
            self.init(repositoryError)
            return
        }

        if let appConfigurationProviderError = error as? AppConfigurationProviderError {
            self.init(appConfigurationProviderError)
            return
        }

        self = .unknown(error)
    }

    init(_ error: TrendingRepositoryError) {
        switch error {
        case .cacheUnavailable:
            self = .unknown(nil)
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
