//
//  FetchPersonDetailsError.swift
//  PopcornPeople
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import PeopleDomain

///
/// Errors that can occur when fetching person details.
///
public enum FetchPersonDetailsError: Error {

    /// The requested person was not found.
    case notFound

    /// The request was not authorized.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error?)

}

extension FetchPersonDetailsError {

    init(_ error: Error) {
        if let repositoryError = error as? PersonRepositoryError {
            self.init(repositoryError)
            return
        }

        if let appConfigurationProviderError = error as? AppConfigurationProviderError {
            self.init(appConfigurationProviderError)
            return
        }

        self = .unknown(error)
    }

    init(_ error: PersonRepositoryError) {
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
