//
//  FetchTrendingTVSeriesError.swift
//  TrendingKit
//
//  Created by Adam Young on 09/06/2025.
//

import Foundation
import TrendingDomain

public enum FetchTrendingTVSeriesError: Error {

    case unauthorised
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
