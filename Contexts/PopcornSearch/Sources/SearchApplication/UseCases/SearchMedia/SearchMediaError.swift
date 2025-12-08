//
//  SearchMediaError.swift
//  PopcornSearch
//
//  Created by Adam Young on 25/11/2025.
//

import Foundation
import SearchDomain

public enum SearchMediaError: Error {

    case unauthorised
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
