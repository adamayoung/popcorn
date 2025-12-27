//
//  GenreRepository.swift
//  PopcornGenres
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Defines the contract for accessing genre data.
///
/// This repository provides methods to fetch genre lists for both movies and
/// TV series. Genres categorize media into thematic groups like Action, Comedy,
/// Drama, etc. Implementations may retrieve data from remote APIs or local caches.
///
public protocol GenreRepository: Sendable {

    ///
    /// Fetches all available genres for movies.
    ///
    /// - Parameter cachePolicy: The caching strategy to use for this request.
    /// - Returns: An array of ``Genre`` instances representing movie genres.
    /// - Throws: ``GenreRepositoryError`` if the genres cannot be fetched.
    ///
    func movieGenres(cachePolicy: CachePolicy) async throws(GenreRepositoryError) -> [Genre]

    ///
    /// Fetches all available genres for TV series.
    ///
    /// - Parameter cachePolicy: The caching strategy to use for this request.
    /// - Returns: An array of ``Genre`` instances representing TV series genres.
    /// - Throws: ``GenreRepositoryError`` if the genres cannot be fetched.
    ///
    func tvSeriesGenres(cachePolicy: CachePolicy) async throws(GenreRepositoryError) -> [Genre]

}

///
/// Errors that can occur when accessing genre data through a repository.
///
public extension GenreRepository {

    func movieGenres() async throws(GenreRepositoryError) -> [Genre] {
        try await movieGenres(cachePolicy: .cacheFirst)
    }

    func tvSeriesGenres() async throws(GenreRepositoryError) -> [Genre] {
        try await tvSeriesGenres(cachePolicy: .cacheFirst)
    }

}

public enum GenreRepositoryError: Error {

    /// No cached data is available for the request.
    case cacheUnavailable

    /// The request was not authorized.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error?)

}
