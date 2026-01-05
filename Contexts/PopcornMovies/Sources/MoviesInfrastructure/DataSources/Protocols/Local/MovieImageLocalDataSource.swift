//
//  MovieImageLocalDataSource.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

public protocol MovieImageLocalDataSource: Sendable, Actor {

    func imageCollection(
        forMovie movieID: Int
    ) async throws(MovieImageLocalDataSourceError) -> ImageCollection?

    func imageCollectionStream(
        forMovie movieID: Int
    ) async -> AsyncThrowingStream<ImageCollection?, Error>

    func setImageCollection(
        _ imageCollection: ImageCollection
    ) async throws(MovieImageLocalDataSourceError)

}

public enum MovieImageLocalDataSourceError: Error {

    case persistence(Error)
    case unknown(Error? = nil)

}
