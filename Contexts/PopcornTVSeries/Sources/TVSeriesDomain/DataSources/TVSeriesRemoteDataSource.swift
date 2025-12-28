//
//  TVSeriesRemoteDataSource.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Defines the contract for fetching TV series data from a remote source.
///
/// Implementations of this protocol are responsible for communicating with
/// external APIs or services to retrieve TV series information and images.
///
public protocol TVSeriesRemoteDataSource: Sendable {

    ///
    /// Fetches a TV series by its unique identifier.
    ///
    /// - Parameter id: The unique identifier of the TV series.
    /// - Returns: A ``TVSeries`` instance containing the series' details.
    /// - Throws: ``TVSeriesRemoteDataSourceError`` if the request fails.
    ///
    func tvSeries(withID id: Int) async throws(TVSeriesRemoteDataSourceError) -> TVSeries

    ///
    /// Fetches the image collection for a TV series.
    ///
    /// - Parameter tvSeriesID: The unique identifier of the TV series.
    /// - Returns: An ``ImageCollection`` containing posters, backdrops, and logos.
    /// - Throws: ``TVSeriesRemoteDataSourceError`` if the request fails.
    ///
    func images(
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesRemoteDataSourceError) -> ImageCollection

}

///
/// Errors that can occur when fetching TV series data from a remote source.
///
public enum TVSeriesRemoteDataSourceError: Error {

    /// The requested TV series was not found.
    case notFound

    /// The request was not authorized.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
