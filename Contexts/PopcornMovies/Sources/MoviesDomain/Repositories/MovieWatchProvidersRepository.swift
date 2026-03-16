//
//  MovieWatchProvidersRepository.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public protocol MovieWatchProvidersRepository: Sendable {

    func watchProviders(
        forMovie movieID: Int
    ) async throws(MovieWatchProvidersRepositoryError) -> WatchProviderCollection?

}

///
/// Errors that can occur when accessing movie watch provider data through a repository.
///
public enum MovieWatchProvidersRepositoryError: Error {

    /// The requested movie was not found.
    case notFound

    /// The request was not authorized.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
