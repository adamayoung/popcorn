//
//  FetchMovieRecommendationsError.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

public enum FetchMovieRecommendationsError: Error {

    case notFound
    case unauthorised
    case unknown(Error?)

}

extension FetchMovieRecommendationsError {

    init(_ error: Error) {
        if let repositoryError = error as? MovieRecommendationRepositoryError {
            self.init(repositoryError)
            return
        }

        if let imageRepositoryError = error as? MovieImageRepositoryError {
            self.init(imageRepositoryError)
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

    init(_ error: MovieImageRepositoryError) {
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
