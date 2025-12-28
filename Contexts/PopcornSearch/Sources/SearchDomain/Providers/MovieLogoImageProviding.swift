//
//  MovieLogoImageProviding.swift
//  PopcornSearch
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

///
/// A provider for fetching movie logo images.
///
/// Implementations of this protocol retrieve logo image URLs for movies,
/// supporting multiple resolutions through the returned image URL set.
///
public protocol MovieLogoImageProviding: Sendable {

    ///
    /// Fetches the logo image URL set for a movie.
    ///
    /// - Parameter movieID: The unique identifier for the movie.
    /// - Returns: An image URL set containing logo URLs at various resolutions, or `nil` if no logo exists.
    /// - Throws: ``MovieLogoImageProviderError`` if the fetch operation fails.
    ///
    func imageURLSet(forMovie movieID: Int) async throws(MovieLogoImageProviderError)
        -> ImageURLSet?

}

///
/// Errors that can occur when fetching movie logo images.
///
public enum MovieLogoImageProviderError: Error {

    /// The requested movie was not found.
    case notFound

    /// The request was not authorized, typically due to invalid or missing credentials.
    case unauthorised

    /// An unknown error occurred.
    case unknown(Error? = nil)

}
