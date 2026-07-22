//
//  FetchPersonCreditsError.swift
//  PopcornPeople
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import PeopleDomain

///
/// Errors that can occur when fetching a person's credits.
///
public enum FetchPersonCreditsError: Error {

    /// The person or their credits could not be found.
    case notFound

    /// The request was not authorised.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error?)

}

extension FetchPersonCreditsError {

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
