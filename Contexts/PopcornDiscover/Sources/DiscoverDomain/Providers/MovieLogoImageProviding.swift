//
//  MovieLogoImageProviding.swift
//  PopcornDiscover
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

///
/// Defines the contract for providing movie logo images.
///
/// Implementations of this protocol fetch logo image URLs for movies,
/// typically used for displaying branding or title treatments.
///
public protocol MovieLogoImageProviding: Sendable {

    ///
    /// Fetches the logo image URL set for a specific movie.
    ///
    /// - Parameter movieID: The unique identifier of the movie.
    /// - Returns: An ``ImageURLSet`` containing logo image URLs at various sizes, or `nil` if no logo is available.
    /// - Throws: ``MovieLogoImageProviderError`` if the request fails.
    ///
    func imageURLSet(forMovie movieID: Int) async throws(MovieLogoImageProviderError)
        -> ImageURLSet?

}

///
/// Errors that can occur when fetching movie logo images.
///
public enum MovieLogoImageProviderError: Error {

    /// No logo image was found for the specified movie.
    case notFound

    /// The request was not authorized due to invalid or missing credentials.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
