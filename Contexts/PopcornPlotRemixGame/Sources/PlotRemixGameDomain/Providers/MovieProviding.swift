//
//  MovieProviding.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A protocol for retrieving movies for Plot Remix game question generation.
///
/// Implementations provide access to movie data, supporting both filtered random
/// selection for question subjects and similar movie retrieval for generating
/// plausible incorrect answer options.
///
public protocol MovieProviding: Sendable {

    ///
    /// Retrieves a random selection of movies matching the specified filter criteria.
    ///
    /// - Parameters:
    ///   - filter: The criteria to filter movies by language, genre, and release year.
    ///   - limit: The maximum number of movies to return.
    /// - Returns: An array of randomly selected movies matching the filter.
    /// - Throws: ``MovieProviderError`` if movie retrieval fails.
    ///
    func randomMovies(filter: MovieFilter, limit: Int) async throws(MovieProviderError) -> [Movie]

    ///
    /// Retrieves movies similar to a given movie for use as incorrect answer options.
    ///
    /// Similar movies share thematic or genre characteristics with the source movie,
    /// making them plausible distractors in multiple choice questions.
    ///
    /// - Parameters:
    ///   - movieID: The identifier of the movie to find similar titles for.
    ///   - limit: The maximum number of similar movies to return.
    /// - Returns: An array of randomly selected similar movies.
    /// - Throws: ``MovieProviderError`` if retrieval fails.
    ///
    func randomSimilarMovies(
        to movieID: Int,
        limit: Int
    ) async throws(MovieProviderError) -> [Movie]

}

///
/// Errors that can occur when retrieving movie data.
///
public enum MovieProviderError: Error {

    /// The request was not authorized to access movie data.
    case unauthorised

    /// An unknown error occurred during movie retrieval.
    case unknown(Error? = nil)

}
