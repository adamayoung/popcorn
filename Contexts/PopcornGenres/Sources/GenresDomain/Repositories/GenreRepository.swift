//
//  GenreRepository.swift
//  PopcornGenres
//
//  Copyright © 2026 Adam Young.
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
    /// - Returns: An array of ``Genre`` instances representing movie genres.
    /// - Throws: ``GenreRepositoryError`` if the genres cannot be fetched.
    ///
    func movieGenres() async throws(GenreRepositoryError) -> [Genre]

    ///
    /// Fetches all available genres for TV series.
    ///
    /// - Returns: An array of ``Genre`` instances representing TV series genres.
    /// - Throws: ``GenreRepositoryError`` if the genres cannot be fetched.
    ///
    func tvSeriesGenres() async throws(GenreRepositoryError) -> [Genre]

}

///
/// Errors that can occur when accessing genre data through a repository.
///
public enum GenreRepositoryError: Error {

    /// The request was not authorized.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error?)

}
