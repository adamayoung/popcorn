//
//  TVSeriesCreditsRepository.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Defines the contract for accessing TV series credits data.
///
/// This repository provides methods to fetch cast and crew information for a
/// TV series. Implementations may retrieve data from remote APIs, local
/// caches, or a combination of both.
///
public protocol TVSeriesCreditsRepository: Sendable {

    ///
    /// Fetches the credits for a specific TV series.
    ///
    /// - Parameter tvSeriesID: The unique identifier of the TV series.
    /// - Returns: A ``Credits`` instance containing the cast and crew.
    /// - Throws: ``TVSeriesCreditsRepositoryError`` if the credits cannot be fetched.
    ///
    func credits(forTVSeries tvSeriesID: Int) async throws(TVSeriesCreditsRepositoryError)
        -> Credits

}

///
/// Errors that can occur when accessing TV series credits data through a repository.
///
public enum TVSeriesCreditsRepositoryError: Error {

    /// The requested TV series credits were not found.
    case notFound

    /// The request was not authorized.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
