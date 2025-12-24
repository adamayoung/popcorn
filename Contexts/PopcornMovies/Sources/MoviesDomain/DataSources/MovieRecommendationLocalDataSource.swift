//
//  MovieRecommendationLocalDataSource.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol MovieRecommendationLocalDataSource: Sendable, Actor {

    func recommendations(
        forMovie movieID: Int,
        page: Int
    ) async throws(MovieRecommendationLocalDataSourceError) -> [MoviePreview]?

    func setRecommendations(
        _ moviePreviews: [MoviePreview],
        forMovie movieID: Int,
        page: Int
    ) async throws(MovieRecommendationLocalDataSourceError)

}

public enum MovieRecommendationLocalDataSourceError: Error {

    case persistence(Error)
    case unknown(Error? = nil)

}
