//
//  DiscoverMovieLocalDataSource.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol DiscoverMovieLocalDataSource: Sendable, Actor {

    func movies(
        filter: MovieFilter?,
        page: Int
    ) async throws(DiscoverMovieLocalDataSourceError) -> [MoviePreview]?

    func moviesStream(
        filter: MovieFilter?
    ) async -> AsyncThrowingStream<[MoviePreview]?, Error>

    func currentMoviesStreamPage(
        filter: MovieFilter?
    ) async throws(DiscoverMovieLocalDataSourceError) -> Int?

    func setMovies(
        _ moviePreviews: [MoviePreview],
        filter: MovieFilter?,
        page: Int
    ) async throws(DiscoverMovieLocalDataSourceError)

}

public enum DiscoverMovieLocalDataSourceError: Error {

    case persistence(Error)
    case unknown(Error? = nil)

}
