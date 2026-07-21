//
//  DiscoverMovieRepository.swift
//  PopcornDiscover
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Defines the contract for discovering movies based on filters and criteria.
///
/// This repository provides methods to search and browse movies using various
/// filters such as genre, release date, rating, and more. Implementations may
/// retrieve data from remote APIs, local caches, or a combination of both.
///
public protocol DiscoverMovieRepository: Sendable {

    ///
    /// Fetches a page of movies that match the specified filter criteria.
    ///
    /// - Parameters:
    ///   - filter: Optional filter criteria to apply (e.g., genre, year, rating). Pass `nil` for no filtering.
    ///   - page: The page number to fetch (1-indexed).
    /// - Returns: A ``MoviePreviewPage`` of movies matching the filter criteria, with pagination metadata.
    /// - Throws: ``DiscoverMovieRepositoryError`` if the movies cannot be fetched.
    ///
    func movies(
        filter: MovieFilter?,
        page: Int
    ) async throws(DiscoverMovieRepositoryError) -> MoviePreviewPage

}

///
/// Errors that can occur when discovering movies through a repository.
///
public enum DiscoverMovieRepositoryError: Error {

    /// The request was not authorized.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error?)

}
