//
//  StreamMovieRecommendationsError.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain

public enum StreamMovieRecommendationsError: Error {

    case notFound
    case unauthorised
    case unknown(Error?)

}

extension StreamMovieRecommendationsError {

    init(_ error: Error) {
        if let repositoryError = error as? MovieRecommendationRepositoryError {
            self.init(repositoryError)
            return
        }

        self = .unknown(error)
    }

    init(_ error: MovieRecommendationRepositoryError) {
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
