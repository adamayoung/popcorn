//
//  TrendingRemoteDataSource.swift
//  PopcornTrending
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A data source for fetching trending content from a remote API.
///
/// Implementations of this protocol are responsible for communicating with
/// external services to retrieve trending movies, TV series, and people.
///
public protocol TrendingRemoteDataSource: Sendable {

    ///
    /// Fetches a page of trending movies from the remote API.
    ///
    /// - Parameter page: The page number to fetch.
    /// - Returns: An array of trending movie previews.
    /// - Throws: ``TrendingRepositoryError`` if the fetch fails.
    ///
    func movies(page: Int) async throws(TrendingRepositoryError) -> [MoviePreview]

    ///
    /// Fetches a page of trending TV series from the remote API.
    ///
    /// - Parameter page: The page number to fetch.
    /// - Returns: An array of trending TV series previews.
    /// - Throws: ``TrendingRepositoryError`` if the fetch fails.
    ///
    func tvSeries(page: Int) async throws(TrendingRepositoryError) -> [TVSeriesPreview]

    ///
    /// Fetches a page of trending people from the remote API.
    ///
    /// - Parameter page: The page number to fetch.
    /// - Returns: An array of trending person previews.
    /// - Throws: ``TrendingRepositoryError`` if the fetch fails.
    ///
    func people(page: Int) async throws(TrendingRepositoryError) -> [PersonPreview]

}
