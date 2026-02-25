//
//  FetchTVSeriesCreditsError.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

///
/// Errors that can occur when fetching TV series credits.
///
/// This error type represents all possible failure scenarios when attempting
/// to retrieve comprehensive TV series credits information through ``FetchTVSeriesCreditsUseCase``.
/// Errors from underlying repositories are mapped to this type for consistent
/// error handling at the application layer.
///
public enum FetchTVSeriesCreditsError: Error {

    /// The requested TV series was not found.
    case notFound

    /// Access to the TV series data or API is unauthorised.
    case unauthorised

    /// An unexpected error occurred.
    ///
    /// - Parameter Error: The underlying error that caused the failure, if available
    case unknown(Error?)

}

extension FetchTVSeriesCreditsError {

    init(_ error: Error) {
        if let repositoryError = error as? TVSeriesCreditsRepositoryError {
            self.init(repositoryError)
            return
        }

        if let appConfigurationProviderError = error as? AppConfigurationProviderError {
            self.init(appConfigurationProviderError)
            return
        }

        self = .unknown(error)
    }

    init(_ error: TVSeriesCreditsRepositoryError) {
        switch error {
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
