//
//  StreamPopularMoviesError.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain

public enum StreamPopularMoviesError: Error {

    case notFound
    case unauthorised
    case unknown(Error?)

}

extension StreamPopularMoviesError {

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
