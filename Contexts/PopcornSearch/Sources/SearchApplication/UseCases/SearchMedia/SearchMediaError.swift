//
//  SearchMediaError.swift
//  PopcornSearch
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import SearchDomain

///
/// Errors that can occur during media search operations.
///
public enum SearchMediaError: Error {

    /// The request was not authorized, typically due to invalid or missing credentials.
    case unauthorised

    /// An unknown error occurred.
    case unknown(Error?)

}

extension SearchMediaError {

    init(_ error: Error) {
        if let repositoryError = error as? MediaRepositoryError {
            self.init(repositoryError)
            return
        }

        if let appConfigurationProviderError = error as? AppConfigurationProviderError {
            self.init(appConfigurationProviderError)
            return
        }

        self = .unknown(error)
    }

    init(_ error: MediaRepositoryError) {
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
