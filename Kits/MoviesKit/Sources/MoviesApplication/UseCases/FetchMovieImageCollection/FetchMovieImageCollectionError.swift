//
//  FetchMovieImageCollectionError.swift
//  MoviesKit
//
//  Created by Adam Young on 24/11/2025.
//

import Foundation
import MoviesDomain

public enum FetchMovieImageCollectionError: Error {

    case notFound
    case unauthorised
    case unknown(Error?)

}

extension FetchMovieImageCollectionError {

    init(_ error: Error) {
        if let repositoryError = error as? MovieRepositoryError {
            self.init(repositoryError)
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

}
