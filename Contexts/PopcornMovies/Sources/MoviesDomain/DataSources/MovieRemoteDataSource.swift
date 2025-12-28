//
//  MovieRemoteDataSource.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Defines the contract for fetching movie data from a remote API.
///
/// This data source provides methods to retrieve movie data, images, and related
/// movie collections from a remote service such as TMDB. Implementations handle
/// network requests and response parsing.
///
public protocol MovieRemoteDataSource: Sendable {

    ///
    /// Fetches detailed information for a specific movie from the remote API.
    ///
    /// - Parameter id: The unique identifier of the movie.
    /// - Returns: A ``Movie`` instance containing the movie's details.
    /// - Throws: ``MovieRemoteDataSourceError`` if the request fails.
    ///
    func movie(withID id: Int) async throws(MovieRemoteDataSourceError) -> Movie

    ///
    /// Fetches the image collection for a specific movie from the remote API.
    ///
    /// - Parameter movieID: The unique identifier of the movie.
    /// - Returns: An ``ImageCollection`` containing posters, backdrops, and logos.
    /// - Throws: ``MovieRemoteDataSourceError`` if the request fails.
    ///
    func imageCollection(
        forMovie movieID: Int
    ) async throws(MovieRemoteDataSourceError) -> ImageCollection

    ///
    /// Fetches a page of popular movies from the remote API.
    ///
    /// - Parameter page: The page number to fetch (1-indexed).
    /// - Returns: An array of ``MoviePreview`` instances.
    /// - Throws: ``MovieRemoteDataSourceError`` if the request fails.
    ///
    func popular(page: Int) async throws(MovieRemoteDataSourceError) -> [MoviePreview]

    ///
    /// Fetches a page of movies similar to a specific movie from the remote API.
    ///
    /// - Parameters:
    ///   - movieID: The unique identifier of the reference movie.
    ///   - page: The page number to fetch (1-indexed).
    /// - Returns: An array of ``MoviePreview`` instances.
    /// - Throws: ``MovieRemoteDataSourceError`` if the request fails.
    ///
    func similar(
        toMovie movieID: Int,
        page: Int
    ) async throws(MovieRemoteDataSourceError) -> [MoviePreview]

    ///
    /// Fetches a page of recommended movies for a specific movie from the remote API.
    ///
    /// - Parameters:
    ///   - movieID: The unique identifier of the reference movie.
    ///   - page: The page number to fetch (1-indexed).
    /// - Returns: An array of ``MoviePreview`` instances.
    /// - Throws: ``MovieRemoteDataSourceError`` if the request fails.
    ///
    func recommendations(
        forMovie movieID: Int,
        page: Int
    ) async throws(MovieRemoteDataSourceError) -> [MoviePreview]

}

///
/// Errors that can occur when fetching movie data from a remote API.
///
public enum MovieRemoteDataSourceError: Error {

    /// The requested resource was not found.
    case notFound

    /// The request was not authorized.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
