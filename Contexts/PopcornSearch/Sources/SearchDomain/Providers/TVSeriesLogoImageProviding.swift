//
//  TVSeriesLogoImageProviding.swift
//  PopcornSearch
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

///
/// A provider for fetching TV series logo images.
///
/// Implementations of this protocol retrieve logo image URLs for TV series,
/// supporting multiple resolutions through the returned image URL set.
///
public protocol TVSeriesLogoImageProviding: Sendable {

    ///
    /// Fetches the logo image URL set for a TV series.
    ///
    /// - Parameter tvSeriesID: The unique identifier for the TV series.
    /// - Returns: An image URL set containing logo URLs at various resolutions, or `nil` if no logo exists.
    /// - Throws: ``TVSeriesLogoImageProviderError`` if the fetch operation fails.
    ///
    func imageURLSet(forTVSeries tvSeriesID: Int) async throws(TVSeriesLogoImageProviderError)
        -> ImageURLSet?

}

///
/// Errors that can occur when fetching TV series logo images.
///
public enum TVSeriesLogoImageProviderError: Error {

    /// The requested TV series was not found.
    case notFound

    /// The request was not authorized, typically due to invalid or missing credentials.
    case unauthorised

    /// An unknown error occurred.
    case unknown(Error? = nil)

}
