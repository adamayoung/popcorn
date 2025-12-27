//
//  MovieImageRepository.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Defines the contract for accessing movie image data.
///
/// This repository provides methods to fetch image collections for movies, either
/// as a single asynchronous call or as a continuous stream of updates. Image
/// collections include posters, backdrops, and logos. Implementations may retrieve
/// data from remote APIs, local caches, or a combination of both.
///
public protocol MovieImageRepository: Sendable {

    ///
    /// Fetches the image collection for a specific movie.
    ///
    /// - Parameters:
    ///   - movieID: The unique identifier of the movie.
    ///   - cachePolicy: The caching strategy to use for this request.
    /// - Returns: An ``ImageCollection`` containing posters, backdrops, and logos.
    /// - Throws: ``MovieImageRepositoryError`` if the images cannot be fetched.
    ///
    func imageCollection(
        forMovie movieID: Int,
        cachePolicy: CachePolicy
    ) async throws(MovieImageRepositoryError) -> ImageCollection

    ///
    /// Creates a stream that continuously emits updates for a movie's image collection.
    ///
    /// This stream is useful for observing changes to a movie's images over time,
    /// such as cache updates or when new images are added.
    ///
    /// - Parameter movieID: The unique identifier of the movie.
    /// - Returns: An async throwing stream that emits ``ImageCollection`` instances or `nil` if not available.
    ///
    func imageCollectionStream(
        forMovie movieID: Int
    ) async -> AsyncThrowingStream<ImageCollection?, Error>

}

///
/// Errors that can occur when accessing movie image data through a repository.
///
extension MovieImageRepository {

    public func imageCollection(
        forMovie movieID: Int
    ) async throws(MovieImageRepositoryError) -> ImageCollection {
        try await imageCollection(forMovie: movieID, cachePolicy: .cacheFirst)
    }

}

public enum MovieImageRepositoryError: Error {

    /// No cached data is available for the request.
    case cacheUnavailable

    /// The requested movie images were not found.
    case notFound

    /// The request was not authorized.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
