//
//  FetchRecentlySearchedMediaError.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import SearchDomain

public enum FetchMediaSearchHistoryError: Error {

    case unknown(Error?)

}

extension FetchMediaSearchHistoryError {

    init(_ error: Error) {
        if let repositoryError = error as? MediaRepositoryError {
            self.init(repositoryError)
            return
        }

        if let appConfigurationProviderError = error as? AppConfigurationProviderError {
            self.init(appConfigurationProviderError)
            return
        }

        if let mediaProviderError = error as? MediaProviderError {
            self.init(mediaProviderError)
            return
        }

        self = .unknown(error)
    }

    init(_ error: MediaRepositoryError) {
        switch error {
        case .unauthorised:
            self = .unknown(nil)
        case .unknown(let error):
            self = .unknown(error)
        }
    }

    init(_ error: AppConfigurationProviderError) {
        switch error {
        case .unauthorised:
            self = .unknown(nil)
        case .unknown(let error):
            self = .unknown(error)
        }
    }

    init(_ error: MediaProviderError) {
        switch error {
        case .notFound:
            self = .unknown(nil)
        case .unauthorised:
            self = .unknown(nil)
        case .unknown(let error):
            self = .unknown(error)
        }
    }

}
