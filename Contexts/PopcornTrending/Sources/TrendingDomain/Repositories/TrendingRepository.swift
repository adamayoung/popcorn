//
//  TrendingRepository.swift
//  PopcornTrending
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A repository for accessing trending content.
///
/// This protocol defines the interface for fetching trending movies, TV series, and people.
/// Implementations may use caching strategies to optimize performance.
///
public protocol TrendingRepository: Sendable {

    ///
    /// Fetches a page of trending movies.
    ///
    /// - Parameters:
    ///   - page: The page number to fetch.
    ///   - cachePolicy: The caching strategy to use for this request.
    /// - Returns: An array of trending movie previews.
    /// - Throws: ``TrendingRepositoryError`` if the fetch fails.
    ///
    func movies(
        page: Int,
        cachePolicy: CachePolicy
    ) async throws(TrendingRepositoryError) -> [MoviePreview]

    ///
    /// Fetches a page of trending TV series.
    ///
    /// - Parameters:
    ///   - page: The page number to fetch.
    ///   - cachePolicy: The caching strategy to use for this request.
    /// - Returns: An array of trending TV series previews.
    /// - Throws: ``TrendingRepositoryError`` if the fetch fails.
    ///
    func tvSeries(
        page: Int,
        cachePolicy: CachePolicy
    ) async throws(TrendingRepositoryError) -> [TVSeriesPreview]

    ///
    /// Fetches a page of trending people.
    ///
    /// - Parameters:
    ///   - page: The page number to fetch.
    ///   - cachePolicy: The caching strategy to use for this request.
    /// - Returns: An array of trending person previews.
    /// - Throws: ``TrendingRepositoryError`` if the fetch fails.
    ///
    func people(
        page: Int,
        cachePolicy: CachePolicy
    ) async throws(TrendingRepositoryError) -> [PersonPreview]

}

public extension TrendingRepository {

    ///
    /// Fetches a page of trending movies using the default cache-first policy.
    ///
    /// - Parameter page: The page number to fetch.
    /// - Returns: An array of trending movie previews.
    /// - Throws: ``TrendingRepositoryError`` if the fetch fails.
    ///
    func movies(page: Int) async throws(TrendingRepositoryError) -> [MoviePreview] {
        try await movies(page: page, cachePolicy: .cacheFirst)
    }

    ///
    /// Fetches a page of trending TV series using the default cache-first policy.
    ///
    /// - Parameter page: The page number to fetch.
    /// - Returns: An array of trending TV series previews.
    /// - Throws: ``TrendingRepositoryError`` if the fetch fails.
    ///
    func tvSeries(page: Int) async throws(TrendingRepositoryError) -> [TVSeriesPreview] {
        try await tvSeries(page: page, cachePolicy: .cacheFirst)
    }

    ///
    /// Fetches a page of trending people using the default cache-first policy.
    ///
    /// - Parameter page: The page number to fetch.
    /// - Returns: An array of trending person previews.
    /// - Throws: ``TrendingRepositoryError`` if the fetch fails.
    ///
    func people(page: Int) async throws(TrendingRepositoryError) -> [PersonPreview] {
        try await people(page: page, cachePolicy: .cacheFirst)
    }

}

///
/// Errors that can occur when accessing the trending repository.
///
public enum TrendingRepositoryError: Error {

    /// The requested data is not available in the cache.
    case cacheUnavailable

    /// The request was not authorized.
    case unauthorised

    /// An unknown error occurred.
    case unknown(Error?)

}
