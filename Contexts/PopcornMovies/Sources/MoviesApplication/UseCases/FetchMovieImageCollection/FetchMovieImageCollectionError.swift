//
//  FetchMovieImageCollectionError.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
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
