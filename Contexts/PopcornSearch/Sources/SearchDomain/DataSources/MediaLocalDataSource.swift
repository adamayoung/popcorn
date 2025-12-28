//
//  MediaLocalDataSource.swift
//  PopcornSearch
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A data source for persisting and retrieving media search history from local storage.
///
/// Implementations of this protocol handle the local persistence of search history entries,
/// supporting movies, TV series, and people. This enables features like recent searches
/// and personalized suggestions.
///
public protocol MediaLocalDataSource: Sendable {

    ///
    /// Fetches all media search history entries.
    ///
    /// - Returns: An array of media search history entries sorted by most recent.
    /// - Throws: ``MediaLocalDataSourceError`` if the fetch operation fails.
    ///
    func mediaSearchHistory() async throws(MediaLocalDataSourceError) -> [MediaSearchHistoryEntry]

    ///
    /// Fetches movie search history entries.
    ///
    /// - Returns: An array of movie search history entries sorted by most recent.
    /// - Throws: ``MediaLocalDataSourceError`` if the fetch operation fails.
    ///
    func movieSearchHistory() async throws(MediaLocalDataSourceError) -> [MovieSearchHistoryEntry]

    ///
    /// Fetches TV series search history entries.
    ///
    /// - Returns: An array of TV series search history entries sorted by most recent.
    /// - Throws: ``MediaLocalDataSourceError`` if the fetch operation fails.
    ///
    func tvSeriesSearchHistory() async throws(MediaLocalDataSourceError)
        -> [TVSeriesSearchHistoryEntry]

    ///
    /// Fetches person search history entries.
    ///
    /// - Returns: An array of person search history entries sorted by most recent.
    /// - Throws: ``MediaLocalDataSourceError`` if the fetch operation fails.
    ///
    func personSearchHistory() async throws(MediaLocalDataSourceError) -> [PersonSearchHistoryEntry]

    ///
    /// Saves a movie search history entry to local storage.
    ///
    /// - Parameter entry: The movie search history entry to save.
    /// - Throws: ``MediaLocalDataSourceError`` if the save operation fails.
    ///
    func saveMovieSearchHistoryEntry(_ entry: MovieSearchHistoryEntry)
        async throws(MediaLocalDataSourceError)

    ///
    /// Saves a TV series search history entry to local storage.
    ///
    /// - Parameter entry: The TV series search history entry to save.
    /// - Throws: ``MediaLocalDataSourceError`` if the save operation fails.
    ///
    func saveTVSeriesSearchHistoryEntry(_ entry: TVSeriesSearchHistoryEntry)
        async throws(MediaLocalDataSourceError)

    ///
    /// Saves a person search history entry to local storage.
    ///
    /// - Parameter entry: The person search history entry to save.
    /// - Throws: ``MediaLocalDataSourceError`` if the save operation fails.
    ///
    func savePersonSearchHistoryEntry(_ entry: PersonSearchHistoryEntry)
        async throws(MediaLocalDataSourceError)

}

///
/// Errors that can occur during local data source operations.
///
public enum MediaLocalDataSourceError: Error {

    /// A persistence layer error occurred during the operation.
    case persistence(Error)

    /// An unknown error occurred.
    case unknown(Error? = nil)

}
