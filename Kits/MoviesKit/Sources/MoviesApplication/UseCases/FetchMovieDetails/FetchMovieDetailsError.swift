//
//  FetchMovieError.swift
//  MoviesKit
//
//  Created by Adam Young on 09/06/2025.
//

import Foundation
import MoviesDomain

public enum FetchMovieDetailsError: Error {

    case notFound
    case unauthorised
    case unknown(Error?)

}

extension FetchMovieDetailsError {

    init(_ error: Error) {
        if let repositoryError = error as? MovieRepositoryError {
            self.init(repositoryError)
            return
        }

        if let appConfigurationProviderError = error as? AppConfigurationProviderError {
            self.init(appConfigurationProviderError)
            return
        }

        self = .unknown(error)
    }

    init(_ error: MovieRepositoryError) {
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
