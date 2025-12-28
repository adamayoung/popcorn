//
//  TVSeriesLogoImageProviding.swift
//  PopcornDiscover
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

///
/// Defines the contract for providing TV series logo images.
///
/// Implementations of this protocol fetch logo image URLs for TV series,
/// typically used for displaying branding or title treatments.
///
public protocol TVSeriesLogoImageProviding: Sendable {

    ///
    /// Fetches the logo image URL set for a specific TV series.
    ///
    /// - Parameter tvSeriesID: The unique identifier of the TV series.
    /// - Returns: An ``ImageURLSet`` containing logo image URLs at various sizes, or `nil` if no logo is available.
    /// - Throws: ``TVSeriesLogoImageProviderError`` if the request fails.
    ///
    func imageURLSet(forTVSeries tvSeriesID: Int) async throws(TVSeriesLogoImageProviderError)
        -> ImageURLSet?

}

///
/// Errors that can occur when fetching TV series logo images.
///
public enum TVSeriesLogoImageProviderError: Error {

    /// No logo image was found for the specified TV series.
    case notFound

    /// The request was not authorized due to invalid or missing credentials.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
