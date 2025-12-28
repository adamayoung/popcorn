//
//  AddMediaSearchHistoryEntryUseCase.swift
//  PopcornSearch
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A use case for adding media items to the search history.
///
/// This use case records when a user selects a media item from search results,
/// enabling the recent searches feature. Each media type (movie, TV series, person)
/// has a dedicated method to ensure type safety.
///
public protocol AddMediaSearchHistoryEntryUseCase: Sendable {

    ///
    /// Adds a movie to the search history.
    ///
    /// - Parameter movieID: The unique identifier for the movie to add.
    /// - Throws: ``AddMediaSearchHistoryEntryError`` if the save operation fails.
    ///
    func execute(movieID: Int) async throws(AddMediaSearchHistoryEntryError)

    ///
    /// Adds a TV series to the search history.
    ///
    /// - Parameter tvSeriesID: The unique identifier for the TV series to add.
    /// - Throws: ``AddMediaSearchHistoryEntryError`` if the save operation fails.
    ///
    func execute(tvSeriesID: Int) async throws(AddMediaSearchHistoryEntryError)

    ///
    /// Adds a person to the search history.
    ///
    /// - Parameter personID: The unique identifier for the person to add.
    /// - Throws: ``AddMediaSearchHistoryEntryError`` if the save operation fails.
    ///
    func execute(personID: Int) async throws(AddMediaSearchHistoryEntryError)

}
