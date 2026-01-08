//
//  MovieCreditsRepository.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol MovieCreditsRepository: Sendable {

    func credits(forMovie movieID: Int) async throws(MovieCreditsRepositoryError) -> Credits

}

///
/// Errors that can occur when accessing movie credits data through a repository.
///
public enum MovieCreditsRepositoryError: Error {

    /// The requested movie images were not found.
    case notFound

    /// The request was not authorized.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
