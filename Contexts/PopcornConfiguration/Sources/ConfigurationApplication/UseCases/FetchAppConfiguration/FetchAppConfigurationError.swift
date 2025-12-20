//
//  FetchAppConfigurationError.swift
//  PopcornConfiguration
//
//  Copyright © 2025 Adam Young.
//

import ConfigurationDomain
import Foundation

public enum FetchAppConfigurationError: Error {

    case unauthorised
    case unknown(Error? = nil)

}

extension FetchAppConfigurationError {

    init(_ error: ConfigurationRepositoryError) {
        switch error {
        case .unauthorised:
            self = .unauthorised
        case .unknown(let error):
            self = .unknown(error)
        }
    }

}
