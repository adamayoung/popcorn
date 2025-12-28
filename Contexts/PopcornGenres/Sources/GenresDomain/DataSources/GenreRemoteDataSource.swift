//
//  GenreRemoteDataSource.swift
//  PopcornGenres
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Defines the contract for fetching genre data from a remote API.
///
/// This data source provides methods to retrieve genre lists for movies and
/// TV series from a remote service. Implementations typically communicate
/// with an external API such as TMDB.
///
public protocol GenreRemoteDataSource: Sendable {

    ///
    /// Fetches all available movie genres from the remote API.
    ///
    /// - Returns: An array of ``Genre`` instances representing movie genres.
    /// - Throws: ``GenreRemoteDataSourceError`` if the network request fails.
    ///
    func movieGenres() async throws(GenreRemoteDataSourceError) -> [Genre]

    ///
    /// Fetches all available TV series genres from the remote API.
    ///
    /// - Returns: An array of ``Genre`` instances representing TV series genres.
    /// - Throws: ``GenreRemoteDataSourceError`` if the network request fails.
    ///
    func tvSeriesGenres() async throws(GenreRemoteDataSourceError) -> [Genre]

}

///
/// Errors that can occur when fetching genre data from a remote API.
///
public enum GenreRemoteDataSourceError: Error {

    /// The request was not authorized, typically due to invalid or missing credentials.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
