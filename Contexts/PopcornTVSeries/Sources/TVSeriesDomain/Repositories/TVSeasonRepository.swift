//
//  TVSeasonRepository.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Defines the contract for accessing TV season data.
///
/// This repository provides methods to fetch a specific season of a TV series,
/// including its overview and episodes. Implementations may retrieve data from
/// remote APIs, local caches, or a combination of both.
///
public protocol TVSeasonRepository: Sendable {

    ///
    /// Fetches a specific season of a TV series.
    ///
    /// - Parameters:
    ///   - seasonNumber: The season number to fetch.
    ///   - tvSeriesID: The unique identifier of the TV series.
    /// - Returns: A ``TVSeason`` instance with overview and episodes populated.
    /// - Throws: ``TVSeasonRepositoryError`` if the season cannot be fetched.
    ///
    func season(
        _ seasonNumber: Int,
        inTVSeries tvSeriesID: Int
    ) async throws(TVSeasonRepositoryError) -> TVSeason

}

///
/// Errors that can occur when accessing TV season data through a repository.
///
public enum TVSeasonRepositoryError: Error {

    /// The requested season was not found.
    case notFound

    /// The request was not authorized.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
