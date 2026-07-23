//
//  TVSeriesRepository.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Defines the contract for accessing and managing TV series data.
///
/// This repository provides methods to fetch TV series information and associated
/// image collections. Implementations may retrieve data from remote APIs, local
/// caches, or a combination of both.
///
public protocol TVSeriesRepository: Sendable {

    ///
    /// Fetches detailed information for a specific TV series.
    ///
    /// - Parameter id: The unique identifier of the TV series to fetch.
    /// - Returns: A ``TVSeries`` instance containing the series' details.
    /// - Throws: ``TVSeriesRepositoryError`` if the series cannot be fetched.
    ///
    func tvSeries(withID id: Int) async throws(TVSeriesRepositoryError) -> TVSeries

    ///
    /// Creates a stream that continuously emits updates for a specific TV series.
    ///
    /// This stream is useful for observing changes to TV series data over time,
    /// such as cache updates or background synchronization.
    ///
    /// - Parameter id: The unique identifier of the TV series to observe.
    /// - Returns: An async throwing stream that emits ``TVSeries`` instances or `nil` if not available.
    ///
    func tvSeriesStream(withID id: Int) async -> AsyncThrowingStream<TVSeries?, Error>

    ///
    /// Fetches the image collection for a specific TV series.
    ///
    /// - Parameter tvSeriesID: The unique identifier of the TV series.
    /// - Returns: An ``ImageCollection`` containing posters, backdrops, and logos.
    /// - Throws: ``TVSeriesRepositoryError`` if the images cannot be fetched.
    ///
    func images(forTVSeries tvSeriesID: Int) async throws(TVSeriesRepositoryError)
        -> ImageCollection

}

///
/// Errors that can occur when accessing TV series data through a repository.
///
public enum TVSeriesRepositoryError: Error {

    /// The requested TV series was not found.
    case notFound

    /// The request was not authorized.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
