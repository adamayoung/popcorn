//
//  GenreProviding.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A protocol for retrieving available movie genres.
///
/// Implementations provide access to the list of genres that can be used to filter
/// movies during Plot Remix game configuration. Genres allow players to customize
/// game content to their preferred film categories.
///
public protocol GenreProviding: Sendable {

    ///
    /// Retrieves the list of available movie genres.
    ///
    /// - Returns: An array of genres available for movie filtering.
    /// - Throws: ``GenreProviderError`` if genre retrieval fails.
    ///
    func movies() async throws(GenreProviderError) -> [Genre]

}

///
/// Errors that can occur when retrieving genre information.
///
public enum GenreProviderError: Error {

    /// The request was not authorized to access genre data.
    case unauthorised

    /// An unknown error occurred during genre retrieval.
    case unknown(Error? = nil)

}
