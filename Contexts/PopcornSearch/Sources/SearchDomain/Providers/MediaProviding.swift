//
//  MediaProviding.swift
//  PopcornSearch
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A provider for fetching individual media items by their identifiers.
///
/// Implementations of this protocol retrieve detailed preview information for
/// movies, TV series, and people. This is typically used to hydrate search history
/// entries with current media data.
///
public protocol MediaProviding: Sendable {

    ///
    /// Fetches a movie preview by its identifier.
    ///
    /// - Parameter id: The unique identifier for the movie.
    /// - Returns: The movie preview for the specified identifier.
    /// - Throws: ``MediaProviderError`` if the movie cannot be fetched.
    ///
    func movie(withID id: Int) async throws(MediaProviderError) -> MoviePreview

    ///
    /// Fetches a TV series preview by its identifier.
    ///
    /// - Parameter id: The unique identifier for the TV series.
    /// - Returns: The TV series preview for the specified identifier.
    /// - Throws: ``MediaProviderError`` if the TV series cannot be fetched.
    ///
    func tvSeries(withID id: Int) async throws(MediaProviderError) -> TVSeriesPreview

    ///
    /// Fetches a person preview by their identifier.
    ///
    /// - Parameter id: The unique identifier for the person.
    /// - Returns: The person preview for the specified identifier.
    /// - Throws: ``MediaProviderError`` if the person cannot be fetched.
    ///
    func person(withID id: Int) async throws(MediaProviderError) -> PersonPreview

}

///
/// Errors that can occur when fetching media from a provider.
///
public enum MediaProviderError: Error {

    /// The requested media item was not found.
    case notFound

    /// The request was not authorized, typically due to invalid or missing credentials.
    case unauthorised

    /// An unknown error occurred.
    case unknown(Error? = nil)

}
