//
//  TVEpisodeRepository.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Defines the contract for accessing TV episode data.
///
/// This repository provides methods to fetch a specific episode of a TV series,
/// including its overview, air date, and still image path. Implementations may
/// retrieve data from remote APIs, local caches, or a combination of both.
///
public protocol TVEpisodeRepository: Sendable {

    ///
    /// Fetches a specific episode of a TV series.
    ///
    /// - Parameters:
    ///   - episodeNumber: The episode number to fetch.
    ///   - seasonNumber: The season number containing the episode.
    ///   - tvSeriesID: The unique identifier of the TV series.
    /// - Returns: A ``TVEpisode`` instance with details populated.
    /// - Throws: ``TVEpisodeRepositoryError`` if the episode cannot be fetched.
    ///
    func episode(
        _ episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: Int
    ) async throws(TVEpisodeRepositoryError) -> TVEpisode

}

///
/// Errors that can occur when accessing TV episode data through a repository.
///
public enum TVEpisodeRepositoryError: Error {

    /// The requested episode was not found.
    case notFound

    /// The request was not authorized.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
