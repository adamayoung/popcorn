//
//  MovieRecommendationRepository.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Defines the contract for accessing movie recommendations data.
///
/// This repository provides methods to fetch recommended movies for a given movie,
/// based on user ratings and preferences. Implementations may retrieve data from
/// remote APIs, local caches, or a combination of both.
///
public protocol MovieRecommendationRepository: Sendable {

    ///
    /// Fetches a page of recommended movies for a specific movie.
    ///
    /// - Parameters:
    ///   - movieID: The unique identifier of the reference movie.
    ///   - page: The page number to fetch (1-indexed).
    /// - Returns: An array of ``MoviePreview`` instances representing recommended movies.
    /// - Throws: ``MovieRecommendationRepositoryError`` if the movies cannot be fetched.
    ///
    func recommendations(
        forMovie movieID: Int,
        page: Int
    ) async throws(MovieRecommendationRepositoryError) -> [MoviePreview]

}

///
/// Errors that can occur when accessing movie recommendations data through a repository.
///
public enum MovieRecommendationRepositoryError: Error {

    /// The requested movie recommendations were not found.
    case notFound

    /// The request was not authorized.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
