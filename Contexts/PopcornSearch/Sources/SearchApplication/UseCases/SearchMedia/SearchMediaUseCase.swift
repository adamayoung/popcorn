//
//  SearchMediaUseCase.swift
//  PopcornSearch
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A use case for searching media content.
///
/// This use case searches for movies, TV series, and people based on a query string,
/// returning detailed preview information suitable for display in the UI.
///
public protocol SearchMediaUseCase: Sendable {

    ///
    /// Searches for media matching the given query.
    ///
    /// This is a convenience method that searches the first page of results.
    ///
    /// - Parameter query: The search query string.
    /// - Returns: An array of media preview details matching the search query.
    /// - Throws: ``SearchMediaError`` if the search operation fails.
    ///
    func execute(query: String) async throws(SearchMediaError) -> [MediaPreviewDetails]

    ///
    /// Searches for media matching the given query with pagination.
    ///
    /// - Parameters:
    ///   - query: The search query string.
    ///   - page: The page number for paginated results (1-indexed).
    /// - Returns: An array of media preview details matching the search query.
    /// - Throws: ``SearchMediaError`` if the search operation fails.
    ///
    func execute(query: String, page: Int) async throws(SearchMediaError) -> [MediaPreviewDetails]

}
