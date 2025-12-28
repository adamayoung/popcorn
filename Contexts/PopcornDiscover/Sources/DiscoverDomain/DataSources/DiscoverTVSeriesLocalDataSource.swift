//
//  DiscoverTVSeriesLocalDataSource.swift
//  PopcornDiscover
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Defines the contract for local persistence of discovered TV series.
///
/// Implementations of this protocol handle caching and retrieval of TV series
/// previews from local storage, enabling offline access and reducing
/// network requests.
///
public protocol DiscoverTVSeriesLocalDataSource: Sendable, Actor {

    ///
    /// Retrieves a page of cached TV series matching the specified filter.
    ///
    /// - Parameters:
    ///   - filter: Optional filter criteria to match. Pass `nil` for no filtering.
    ///   - page: The page number to retrieve (1-indexed).
    /// - Returns: An array of ``TVSeriesPreview`` instances if cached data exists, or `nil` if no cache is available.
    /// - Throws: ``DiscoverTVSeriesLocalDataSourceError`` if a persistence error occurs.
    ///
    func tvSeries(
        filter: TVSeriesFilter?,
        page: Int
    ) async throws(DiscoverTVSeriesLocalDataSourceError) -> [TVSeriesPreview]?

    ///
    /// Creates an async stream that emits cached TV series whenever the local store changes.
    ///
    /// - Parameter filter: Optional filter criteria to match. Pass `nil` for no filtering.
    /// - Returns: An ``AsyncThrowingStream`` that emits arrays of ``TVSeriesPreview`` or `nil` when no data is
    /// available.
    ///
    func tvSeriesStream(
        filter: TVSeriesFilter?
    ) async -> AsyncThrowingStream<[TVSeriesPreview]?, Error>

    ///
    /// Retrieves the highest page number currently cached for the given filter.
    ///
    /// - Parameter filter: Optional filter criteria to match. Pass `nil` for no filtering.
    /// - Returns: The highest cached page number, or `nil` if no pages are cached.
    /// - Throws: ``DiscoverTVSeriesLocalDataSourceError`` if a persistence error occurs.
    ///
    func currentTVSeriesStreamPage(
        filter: TVSeriesFilter?
    ) async throws(DiscoverTVSeriesLocalDataSourceError) -> Int?

    ///
    /// Stores a page of TV series previews in the local cache.
    ///
    /// - Parameters:
    ///   - tvSeriesPreviews: The array of ``TVSeriesPreview`` instances to cache.
    ///   - filter: Optional filter criteria associated with this data. Pass `nil` for no filtering.
    ///   - page: The page number this data represents (1-indexed).
    /// - Throws: ``DiscoverTVSeriesLocalDataSourceError`` if the data cannot be persisted.
    ///
    func setTVSeries(
        _ tvSeriesPreviews: [TVSeriesPreview],
        filter: TVSeriesFilter?,
        page: Int
    ) async throws(DiscoverTVSeriesLocalDataSourceError)

}

///
/// Errors that can occur when accessing the local TV series data source.
///
public enum DiscoverTVSeriesLocalDataSourceError: Error {

    /// A persistence layer error occurred.
    case persistence(Error)

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
