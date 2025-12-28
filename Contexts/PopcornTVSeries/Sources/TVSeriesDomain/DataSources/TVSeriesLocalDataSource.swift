//
//  TVSeriesLocalDataSource.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Defines the contract for storing and retrieving TV series data locally.
///
/// Implementations of this protocol provide local caching or persistence
/// for TV series information and images. As an actor-based protocol,
/// implementations ensure thread-safe access to the underlying storage.
///
public protocol TVSeriesLocalDataSource: Sendable, Actor {

    ///
    /// Retrieves a TV series from local storage.
    ///
    /// - Parameter id: The unique identifier of the TV series.
    /// - Returns: A ``TVSeries`` instance if found, or `nil` if not cached.
    /// - Throws: ``TVSeriesLocalDataSourceError`` if a storage error occurs.
    ///
    func tvSeries(withID id: Int) async throws(TVSeriesLocalDataSourceError) -> TVSeries?

    ///
    /// Stores a TV series in local storage.
    ///
    /// - Parameter tvSeries: The TV series to store.
    /// - Throws: ``TVSeriesLocalDataSourceError`` if the storage operation fails.
    ///
    func setTVSeries(_ tvSeries: TVSeries) async throws(TVSeriesLocalDataSourceError)

    ///
    /// Retrieves an image collection for a TV series from local storage.
    ///
    /// - Parameter tvSeriesID: The unique identifier of the TV series.
    /// - Returns: An ``ImageCollection`` if found, or `nil` if not cached.
    /// - Throws: ``TVSeriesLocalDataSourceError`` if a storage error occurs.
    ///
    func images(
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesLocalDataSourceError) -> ImageCollection?

    ///
    /// Stores an image collection for a TV series in local storage.
    ///
    /// - Parameters:
    ///   - imageCollection: The image collection to store.
    ///   - tvSeriesID: The unique identifier of the TV series.
    /// - Throws: ``TVSeriesLocalDataSourceError`` if the storage operation fails.
    ///
    func setImages(
        _ imageCollection: ImageCollection,
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesLocalDataSourceError)

}

///
/// Errors that can occur when accessing TV series data from local storage.
///
public enum TVSeriesLocalDataSourceError: Error {

    /// A persistence layer error occurred.
    case persistence(Error)

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
