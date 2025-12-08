//
//  MovieImageLocalDataSource.swift
//  PopcornMovies
//
//  Created by Adam Young on 03/12/2025.
//

import Foundation

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
