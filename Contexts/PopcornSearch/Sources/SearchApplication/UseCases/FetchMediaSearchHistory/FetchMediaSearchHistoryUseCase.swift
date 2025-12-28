//
//  FetchMediaSearchHistoryUseCase.swift
//  PopcornSearch
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A use case for fetching the user's media search history.
///
/// This use case retrieves recently searched media items with their full preview details,
/// sorted by most recent first. It hydrates the stored history entries with current
/// media data from the provider.
///
public protocol FetchMediaSearchHistoryUseCase: Sendable {

    ///
    /// Fetches the user's media search history.
    ///
    /// - Returns: An array of media preview details representing the user's search history.
    /// - Throws: ``FetchMediaSearchHistoryError`` if the fetch operation fails.
    ///
    func execute() async throws(FetchMediaSearchHistoryError) -> [MediaPreviewDetails]

}
