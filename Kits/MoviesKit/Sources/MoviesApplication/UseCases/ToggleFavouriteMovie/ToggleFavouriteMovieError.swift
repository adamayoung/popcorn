//
//  ToggleFavouriteMovieError.swift
//  MoviesKit
//
//  Created by Adam Young on 03/12/2025.
//

import Foundation
import MoviesDomain

public enum ToggleFavouriteMovieError: Error {

    case notFound
    case unknown(Error?)

}

extension ToggleFavouriteMovieError {

    init(_ error: Error) {
        if let repositoryError = error as? MovieRepositoryError {
            self.init(repositoryError)
            return
        }

        if let repositoryError = error as? FavouriteMovieRepositoryError {
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
            self = .notFound

        case .unknown(let error):
            self = .unknown(error)
        }
    }

    init(_ error: FavouriteMovieRepositoryError) {
        switch error {
        case .unknown(let error):
            self = .unknown(error)
        }
    }

}
