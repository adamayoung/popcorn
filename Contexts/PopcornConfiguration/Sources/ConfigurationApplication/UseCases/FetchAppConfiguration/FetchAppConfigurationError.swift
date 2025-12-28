//
//  FetchAppConfigurationError.swift
//  PopcornConfiguration
//
//  Copyright © 2025 Adam Young.
//

import ConfigurationDomain
import Foundation

///
/// Errors that can occur when fetching application configuration.
///
public enum FetchAppConfigurationError: Error {

    /// The request was not authorised.
    case unauthorised

    /// An unknown error occurred.
    case unknown(Error? = nil)

}

extension FetchAppConfigurationError {

    init(_ error: ConfigurationRepositoryError) {
        switch error {
        case .cacheUnavailable:
            self = .unknown(nil)
        case .unauthorised:
            self = .unauthorised
        case .unknown(let error):
            self = .unknown(error)
        }
    }

}
