//
//  TVSeriesRepository.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
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
    /// - Parameters:
    ///   - id: The unique identifier of the TV series to fetch.
    ///   - cachePolicy: The caching strategy to use for this request.
    /// - Returns: A ``TVSeries`` instance containing the series' details.
    /// - Throws: ``TVSeriesRepositoryError`` if the series cannot be fetched.
    ///
    func tvSeries(
        withID id: Int,
        cachePolicy: CachePolicy
    ) async throws(TVSeriesRepositoryError) -> TVSeries

    ///
    /// Fetches the image collection for a specific TV series.
    ///
    /// - Parameters:
    ///   - tvSeriesID: The unique identifier of the TV series.
    ///   - cachePolicy: The caching strategy to use for this request.
    /// - Returns: An ``ImageCollection`` containing posters, backdrops, and logos.
    /// - Throws: ``TVSeriesRepositoryError`` if the images cannot be fetched.
    ///
    func images(
        forTVSeries tvSeriesID: Int,
        cachePolicy: CachePolicy
    ) async throws(TVSeriesRepositoryError) -> ImageCollection

}

///
/// Errors that can occur when accessing TV series data through a repository.
///
extension TVSeriesRepository {

    public func tvSeries(withID id: Int) async throws(TVSeriesRepositoryError) -> TVSeries {
        try await tvSeries(withID: id, cachePolicy: .cacheFirst)
    }

    public func images(forTVSeries tvSeriesID: Int) async throws(TVSeriesRepositoryError) -> ImageCollection {
        try await images(forTVSeries: tvSeriesID, cachePolicy: .cacheFirst)
    }

}

public enum TVSeriesRepositoryError: Error {

    /// No cached data is available for the request.
    case cacheUnavailable

    /// The requested TV series was not found.
    case notFound

    /// The request was not authorized.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
