//
//  DiscoverTVSeriesRepository.swift
//  PopcornDiscover
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Defines the contract for discovering TV series based on filters and criteria.
///
/// This repository provides methods to search and browse TV series using various
/// filters such as genre, language, and more. Implementations may retrieve data
/// from remote APIs, local caches, or a combination of both.
///
public protocol DiscoverTVSeriesRepository: Sendable {

    ///
    /// Fetches a page of TV series that match the specified filter criteria.
    ///
    /// - Parameters:
    ///   - filter: Optional filter criteria to apply (e.g., genre, language). Pass `nil` for no filtering.
    ///   - page: The page number to fetch (1-indexed).
    ///   - cachePolicy: The caching strategy to use for this request.
    /// - Returns: An array of ``TVSeriesPreview`` instances matching the filter criteria.
    /// - Throws: ``DiscoverTVSeriesRepositoryError`` if the TV series cannot be fetched.
    ///
    func tvSeries(
        filter: TVSeriesFilter?,
        page: Int,
        cachePolicy: CachePolicy
    ) async throws(DiscoverTVSeriesRepositoryError) -> [TVSeriesPreview]

}

public extension DiscoverTVSeriesRepository {

    ///
    /// Fetches a page of TV series using the default cache-first policy.
    ///
    /// This convenience method calls the full `tvSeries(filter:page:cachePolicy:)` method
    /// with ``CachePolicy/cacheFirst`` as the default caching strategy.
    ///
    /// - Parameters:
    ///   - filter: Optional filter criteria to apply. Pass `nil` for no filtering.
    ///   - page: The page number to fetch (1-indexed).
    /// - Returns: An array of ``TVSeriesPreview`` instances matching the filter criteria.
    /// - Throws: ``DiscoverTVSeriesRepositoryError`` if the TV series cannot be fetched.
    ///
    func tvSeries(
        filter: TVSeriesFilter?,
        page: Int
    ) async throws(DiscoverTVSeriesRepositoryError) -> [TVSeriesPreview] {
        try await tvSeries(filter: filter, page: page, cachePolicy: .cacheFirst)
    }

}

///
/// Errors that can occur when discovering TV series through a repository.
///
public enum DiscoverTVSeriesRepositoryError: Error {

    /// No cached data is available for the request.
    case cacheUnavailable

    /// The request was not authorized.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error?)

}
