//
//  FetchTVEpisodeCreditsError.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

public enum FetchTVEpisodeCreditsError: Error {

    case notFound
    case unauthorised
    case unknown(Error?)

}

extension FetchTVEpisodeCreditsError {

    init(_ error: Error) {
        if let repositoryError = error as? TVEpisodeCreditsRepositoryError {
            self.init(repositoryError)
            return
        }

        if let appConfigurationProviderError = error as? AppConfigurationProviderError {
            self.init(appConfigurationProviderError)
            return
        }

        self = .unknown(error)
    }

    init(_ error: TVEpisodeCreditsRepositoryError) {
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
