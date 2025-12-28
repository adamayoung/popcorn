//
//  MediaRepository.swift
//  PopcornSearch
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A repository for searching media and managing search history.
///
/// This repository provides a unified interface for searching movies, TV series,
/// and people, as well as persisting and retrieving the user's search history.
/// It abstracts the underlying data sources and handles caching strategies.
///
public protocol MediaRepository: Sendable {

    ///
    /// Searches for media matching the given query.
    ///
    /// - Parameters:
    ///   - query: The search query string.
    ///   - page: The page number for paginated results (1-indexed).
    ///   - cachePolicy: The caching strategy to use for this request.
    /// - Returns: An array of media previews matching the search query.
    /// - Throws: ``MediaRepositoryError`` if the search operation fails.
    ///
    func search(
        query: String,
        page: Int,
        cachePolicy: CachePolicy
    ) async throws(MediaRepositoryError) -> [MediaPreview]

    ///
    /// Fetches the user's media search history.
    ///
    /// - Parameter cachePolicy: The caching strategy to use for this request.
    /// - Returns: An array of media search history entries sorted by most recent.
    /// - Throws: ``MediaRepositoryError`` if the fetch operation fails.
    ///
    func mediaSearchHistory(
        cachePolicy: CachePolicy
    ) async throws(MediaRepositoryError) -> [MediaSearchHistoryEntry]

    ///
    /// Saves a movie to the search history.
    ///
    /// - Parameter entry: The movie search history entry to save.
    /// - Throws: ``MediaRepositoryError`` if the save operation fails.
    ///
    func saveMovieSearchHistoryEntry(_ entry: MovieSearchHistoryEntry)
        async throws(MediaRepositoryError)

    ///
    /// Saves a TV series to the search history.
    ///
    /// - Parameter entry: The TV series search history entry to save.
    /// - Throws: ``MediaRepositoryError`` if the save operation fails.
    ///
    func saveTVSeriesSearchHistoryEntry(_ entry: TVSeriesSearchHistoryEntry)
        async throws(MediaRepositoryError)

    ///
    /// Saves a person to the search history.
    ///
    /// - Parameter entry: The person search history entry to save.
    /// - Throws: ``MediaRepositoryError`` if the save operation fails.
    ///
    func savePersonSearchHistoryEntry(_ entry: PersonSearchHistoryEntry)
        async throws(MediaRepositoryError)

}

public extension MediaRepository {

    ///
    /// Searches for media matching the given query using the default cache policy.
    ///
    /// - Parameters:
    ///   - query: The search query string.
    ///   - page: The page number for paginated results (1-indexed).
    /// - Returns: An array of media previews matching the search query.
    /// - Throws: ``MediaRepositoryError`` if the search operation fails.
    ///
    func search(query: String, page: Int) async throws(MediaRepositoryError) -> [MediaPreview] {
        try await search(query: query, page: page, cachePolicy: .cacheFirst)
    }

    ///
    /// Fetches the user's media search history using the default cache policy.
    ///
    /// - Returns: An array of media search history entries sorted by most recent.
    /// - Throws: ``MediaRepositoryError`` if the fetch operation fails.
    ///
    func mediaSearchHistory() async throws(MediaRepositoryError) -> [MediaSearchHistoryEntry] {
        try await mediaSearchHistory(cachePolicy: .cacheFirst)
    }

}

///
/// Errors that can occur during media repository operations.
///
public enum MediaRepositoryError: Error {

    /// The requested data is not available in the cache.
    case cacheUnavailable

    /// The request was not authorized, typically due to invalid or missing credentials.
    case unauthorised

    /// An unknown error occurred.
    case unknown(Error?)

}
