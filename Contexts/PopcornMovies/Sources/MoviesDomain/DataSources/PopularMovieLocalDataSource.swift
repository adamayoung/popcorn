//
//  PopularMovieLocalDataSource.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol PopularMovieLocalDataSource: Sendable, Actor {

    func popular(page: Int) async throws(PopularMovieLocalDataSourceError) -> [MoviePreview]?

    func popularStream() async -> AsyncThrowingStream<[MoviePreview]?, Error>

    func currentPopularStreamPage() async throws(PopularMovieLocalDataSourceError) -> Int?

    func setPopular(
        _ moviePreviews: [MoviePreview],
        page: Int
    ) async throws(PopularMovieLocalDataSourceError)

}

public enum PopularMovieLocalDataSourceError: Error {

    case persistence(Error)
    case unknown(Error? = nil)

}
