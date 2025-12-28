//
//  FetchTVSeriesImageCollectionError.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import TVSeriesDomain

///
/// Errors that can occur when fetching a TV series' image collection.
///
public enum FetchTVSeriesImageCollectionError: Error {

    /// The requested TV series was not found.
    case notFound

    /// The request was not authorized.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
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
