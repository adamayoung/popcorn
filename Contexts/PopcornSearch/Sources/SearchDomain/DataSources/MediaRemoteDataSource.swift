//
//  MediaRemoteDataSource.swift
//  PopcornSearch
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A data source for searching media content from a remote API.
///
/// Implementations of this protocol communicate with external services to search for
/// movies, TV series, and people based on user queries.
///
public protocol MediaRemoteDataSource: Sendable {

    ///
    /// Searches for media matching the given query.
    ///
    /// - Parameters:
    ///   - query: The search query string.
    ///   - page: The page number for paginated results (1-indexed).
    /// - Returns: An array of media previews matching the search query.
    /// - Throws: ``MediaRemoteDataSourceError`` if the search operation fails.
    ///
    func search(query: String, page: Int) async throws(MediaRemoteDataSourceError) -> [MediaPreview]

}

///
/// Errors that can occur during remote data source operations.
///
public enum MediaRemoteDataSourceError: Error {

    /// The request was not authorized, typically due to invalid or missing credentials.
    case unauthorised

    /// An unknown error occurred.
    case unknown(Error?)

}
