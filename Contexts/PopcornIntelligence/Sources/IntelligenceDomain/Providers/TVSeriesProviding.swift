//
//  TVSeriesProviding.swift
//  PopcornIntelligence
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A protocol for providing TV series data to the intelligence domain.
///
/// Conforming types supply TV series information that can be used by the
/// intelligence features to provide context-aware responses about TV series.
///
public protocol TVSeriesProviding: Sendable {

    ///
    /// Retrieves a TV series by its unique identifier.
    ///
    /// - Parameter id: The unique identifier of the TV series to retrieve.
    /// - Returns: The ``TVSeries`` instance matching the specified identifier.
    /// - Throws: ``TVSeriesProviderError`` if the TV series cannot be retrieved.
    ///
    func tvSeries(withID id: Int) async throws(TVSeriesProviderError) -> TVSeries
}

///
/// Errors that can occur when retrieving TV series data.
///
public enum TVSeriesProviderError: Error {

    /// The requested TV series was not found.
    case notFound

    /// The request was not authorised to access the TV series data.
    case unauthorised

    /// An unknown error occurred while retrieving the TV series.
    case unknown(Error? = nil)

}
