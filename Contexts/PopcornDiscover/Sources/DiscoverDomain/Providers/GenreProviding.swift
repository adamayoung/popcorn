//
//  GenreProviding.swift
//  PopcornDiscover
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Defines the contract for providing genre information.
///
/// Implementations of this protocol are responsible for fetching the list
/// of available genres for movies and TV series.
///
public protocol GenreProviding: Sendable {

    ///
    /// Fetches the list of available movie genres.
    ///
    /// - Returns: An array of ``Genre`` instances for movies.
    /// - Throws: ``GenreProviderError`` if the genres cannot be fetched.
    ///
    func movieGenres() async throws(GenreProviderError) -> [Genre]

    ///
    /// Fetches the list of available TV series genres.
    ///
    /// - Returns: An array of ``Genre`` instances for TV series.
    /// - Throws: ``GenreProviderError`` if the genres cannot be fetched.
    ///
    func tvSeriesGenres() async throws(GenreProviderError) -> [Genre]

}

///
/// Errors that can occur when fetching genre information.
///
public enum GenreProviderError: Error {

    /// The request was not authorized due to invalid or missing credentials.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
