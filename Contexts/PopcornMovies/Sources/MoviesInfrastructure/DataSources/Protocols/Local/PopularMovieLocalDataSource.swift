//
//  PopularMovieLocalDataSource.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain

public protocol PopularMovieLocalDataSource: Sendable, Actor {

    func popular(page: Int) async throws(PopularMovieLocalDataSourceError) -> MoviePreviewPage?

    func popularStream() async -> AsyncThrowingStream<[MoviePreview]?, Error>

    func currentPopularStreamPage() async throws(PopularMovieLocalDataSourceError) -> Int?

    func setPopular(
        _ page: MoviePreviewPage
    ) async throws(PopularMovieLocalDataSourceError)

}

public enum PopularMovieLocalDataSourceError: Error {

    case persistence(Error)
    case unknown(Error? = nil)

}
