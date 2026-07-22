//
//  MovieLogoImageProviding.swift
//  PopcornPeople
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation

///
/// Provides a movie's logo image, sourced from another context.
///
/// The people context needs movie logos to decorate a person's "Known For"
/// credits but does not own movie image data; the app's composition layer
/// supplies an implementation backed by the movies context.
///
public protocol MovieLogoImageProviding: Sendable {

    ///
    /// Returns the logo image URL set for a movie, if one is available.
    ///
    /// - Parameter movieID: The identifier of the movie.
    /// - Returns: The movie's logo ``ImageURLSet``, or `nil` if it has no logo.
    /// - Throws: ``MovieLogoImageProviderError`` if the lookup fails.
    ///
    func imageURLSet(forMovie movieID: Int) async throws(MovieLogoImageProviderError)
        -> ImageURLSet?

}

///
/// Errors that can occur when providing a movie's logo image.
///
public enum MovieLogoImageProviderError: Error {

    /// The movie's images could not be found.
    case notFound

    /// The request was not authorised.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
