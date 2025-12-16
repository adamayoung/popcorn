//
//  FetchTVSeriesImageCollectionError.swift
//  PopcornTVSeries
//
//  Created by Adam Young on 24/11/2025.
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
        case .notFound:
            self = .notFound
        case .unauthorised:
            self = .unauthorised
        case .unknown(let error):
            self = .unknown(error)
        }
    }

}
