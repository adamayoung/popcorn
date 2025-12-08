//
//  PopularMovieLocalDataSource.swift
//  MoviesKit
//
//  Created by Adam Young on 03/12/2025.
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
