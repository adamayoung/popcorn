//
//  FetchMovieGenresError.swift
//  PopcornGenres
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GenresDomain

///
/// Errors that can occur when fetching movie genres.
///
public enum FetchMovieGenresError: Error {

    /// The request was not authorized, typically due to invalid or missing credentials.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}

extension FetchMovieGenresError {

    init(_ error: GenreRepositoryError) {
        switch error {
        case .cacheUnavailable: self = .unknown(nil)
        case .unauthorised: self = .unauthorised
        case .unknown(let error): self = .unknown(error)
        }
    }

}
