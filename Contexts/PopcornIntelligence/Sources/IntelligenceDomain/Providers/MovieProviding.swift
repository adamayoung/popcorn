//
//  MovieProviding.swift
//  PopcornIntelligence
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A protocol for providing movie data to the intelligence domain.
///
/// Conforming types supply movie information that can be used by the
/// intelligence features to provide context-aware responses about movies.
///
public protocol MovieProviding: Sendable {

    ///
    /// Retrieves a movie by its unique identifier.
    ///
    /// - Parameter id: The unique identifier of the movie to retrieve.
    /// - Returns: The ``Movie`` instance matching the specified identifier.
    /// - Throws: ``MovieProviderError`` if the movie cannot be retrieved.
    ///
    func movie(withID id: Int) async throws(MovieProviderError) -> Movie
}

///
/// Errors that can occur when retrieving movie data.
///
public enum MovieProviderError: Error {

    /// The requested movie was not found.
    case notFound

    /// The request was not authorised to access the movie data.
    case unauthorised

    /// An unknown error occurred while retrieving the movie.
    case unknown(Error? = nil)

}
