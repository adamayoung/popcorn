//
//  TVSeriesLogoImageProviding.swift
//  PopcornTrending
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

///
/// A provider for TV series logo images.
///
/// Implementations of this protocol supply logo image URLs for TV series,
/// which are used for branding and display purposes in the UI.
///
public protocol TVSeriesLogoImageProviding: Sendable {

    ///
    /// Retrieves the logo image URL set for a specific TV series.
    ///
    /// - Parameter tvSeriesID: The unique identifier of the TV series.
    /// - Returns: An image URL set containing logo URLs at various resolutions, or `nil` if unavailable.
    /// - Throws: ``TVSeriesLogoImageProviderError`` if the retrieval fails.
    ///
    func imageURLSet(forTVSeries tvSeriesID: Int) async throws(TVSeriesLogoImageProviderError)
        -> ImageURLSet?

}

///
/// Errors that can occur when retrieving TV series logo images.
///
public enum TVSeriesLogoImageProviderError: Error {

    /// The requested TV series logo was not found.
    case notFound

    /// The request was not authorized.
    case unauthorised

    /// An unknown error occurred.
    case unknown(Error? = nil)

}
