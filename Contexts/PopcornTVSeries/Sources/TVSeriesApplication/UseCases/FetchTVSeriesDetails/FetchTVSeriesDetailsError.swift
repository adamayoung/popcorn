//
//  FetchTVSeriesDetailsError.swift
//  PopcornTVSeries
//
//  Created by Adam Young on 09/06/2025.
//

import Foundation
import TVSeriesDomain

public enum FetchTVSeriesDetailsError: Error {

    case notFound
    case unauthorised
    case unknown(Error?)

}

extension FetchTVSeriesDetailsError {

    init(_ error: Error) {
        if let repositoryError = error as? TVSeriesRepositoryError {
            self.init(repositoryError)
            return
        }

        if let appConfigurationProviderError = error as? AppConfigurationProviderError {
            self.init(appConfigurationProviderError)
            return
        }

        self = .unknown(error)
    }

    init(_ error: TVSeriesRepositoryError) {
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
