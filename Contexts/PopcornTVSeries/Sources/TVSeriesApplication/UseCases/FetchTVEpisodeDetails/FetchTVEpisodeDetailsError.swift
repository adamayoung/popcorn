//
//  FetchTVEpisodeDetailsError.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

public enum FetchTVEpisodeDetailsError: Error {

    case notFound
    case unauthorised
    case unknown(Error?)

}

extension FetchTVEpisodeDetailsError {

    init(_ error: Error) {
        if let repositoryError = error as? TVEpisodeRepositoryError {
            self.init(repositoryError)
            return
        }

        if let appConfigurationProviderError = error as? AppConfigurationProviderError {
            self.init(appConfigurationProviderError)
            return
        }

        self = .unknown(error)
    }

    init(_ error: TVEpisodeRepositoryError) {
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
