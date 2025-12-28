//
//  DiscoverRemoteDataSource.swift
//  PopcornDiscover
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Defines the contract for fetching discover content from a remote API.
///
/// Implementations of this protocol are responsible for retrieving movie and
/// TV series previews from external data sources such as TMDB.
///
public protocol DiscoverRemoteDataSource: Sendable {

    ///
    /// Fetches a page of movies from the remote API.
    ///
    /// - Parameters:
    ///   - filter: Optional filter criteria to apply. Pass `nil` for no filtering.
    ///   - page: The page number to fetch (1-indexed).
    /// - Returns: An array of ``MoviePreview`` instances.
    /// - Throws: ``DiscoverRemoteDataSourceError`` if the request fails.
    ///
    func movies(
        filter: MovieFilter?,
        page: Int
    ) async throws(DiscoverRemoteDataSourceError) -> [MoviePreview]

    ///
    /// Fetches a page of TV series from the remote API.
    ///
    /// - Parameters:
    ///   - filter: Optional filter criteria to apply. Pass `nil` for no filtering.
    ///   - page: The page number to fetch (1-indexed).
    /// - Returns: An array of ``TVSeriesPreview`` instances.
    /// - Throws: ``DiscoverRemoteDataSourceError`` if the request fails.
    ///
    func tvSeries(
        filter: TVSeriesFilter?,
        page: Int
    ) async throws(DiscoverRemoteDataSourceError) -> [TVSeriesPreview]

}

///
/// Errors that can occur when fetching discover content from a remote data source.
///
public enum DiscoverRemoteDataSourceError: Error {

    /// The request was not authorized due to invalid or missing credentials.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
