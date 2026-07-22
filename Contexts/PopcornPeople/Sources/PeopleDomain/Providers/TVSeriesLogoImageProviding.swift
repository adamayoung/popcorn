//
//  TVSeriesLogoImageProviding.swift
//  PopcornPeople
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation

///
/// Provides a TV series' logo image, sourced from another context.
///
/// The people context needs TV series logos to decorate a person's "Known For"
/// credits but does not own TV series image data; the app's composition layer
/// supplies an implementation backed by the TV series context.
///
public protocol TVSeriesLogoImageProviding: Sendable {

    ///
    /// Returns the logo image URL set for a TV series, if one is available.
    ///
    /// - Parameter tvSeriesID: The identifier of the TV series.
    /// - Returns: The TV series' logo ``ImageURLSet``, or `nil` if it has no logo.
    /// - Throws: ``TVSeriesLogoImageProviderError`` if the lookup fails.
    ///
    func imageURLSet(forTVSeries tvSeriesID: Int) async throws(TVSeriesLogoImageProviderError)
        -> ImageURLSet?

}

///
/// Errors that can occur when providing a TV series' logo image.
///
public enum TVSeriesLogoImageProviderError: Error {

    /// The TV series' images could not be found.
    case notFound

    /// The request was not authorised.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
