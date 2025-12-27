//
//  FetchTVSeriesImageCollectionError.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import TVSeriesDomain

public enum FetchTVSeriesImageCollectionError: Error {

    case notFound
    case unauthorised
    case unknown(Error?)

}

extension FetchTVSeriesImageCollectionError {

    init(_ error: Error) {
        if let repositoryError = error as? TVSeriesRepositoryError {
            self.init(repositoryError)
            return
        }

        self = .unknown(error)
    }

    init(_ error: TVSeriesRepositoryError) {
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

}
