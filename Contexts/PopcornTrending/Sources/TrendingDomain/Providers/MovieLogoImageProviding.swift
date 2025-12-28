//
//  MovieLogoImageProviding.swift
//  PopcornTrending
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

///
/// A provider for movie logo images.
///
/// Implementations of this protocol supply logo image URLs for movies,
/// which are used for branding and display purposes in the UI.
///
public protocol MovieLogoImageProviding: Sendable {

    ///
    /// Retrieves the logo image URL set for a specific movie.
    ///
    /// - Parameter movieID: The unique identifier of the movie.
    /// - Returns: An image URL set containing logo URLs at various resolutions, or `nil` if unavailable.
    /// - Throws: ``MovieLogoImageProviderError`` if the retrieval fails.
    ///
    func imageURLSet(forMovie movieID: Int) async throws(MovieLogoImageProviderError)
        -> ImageURLSet?

}

///
/// Errors that can occur when retrieving movie logo images.
///
public enum MovieLogoImageProviderError: Error {

    /// The requested movie logo was not found.
    case notFound

    /// The request was not authorized.
    case unauthorised

    /// An unknown error occurred.
    case unknown(Error? = nil)

}
