//
//  StubMovieImageRepository.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

public final class StubMovieImageRepository: MovieImageRepository, Sendable {

    public init() {}

    public func imageCollection(forMovie movieID: Int) async throws(MovieImageRepositoryError)
    -> ImageCollection {
        ImageCollection(
            id: movieID,
            posterPaths: [],
            backdropPaths: [],
            logoPaths: []
        )
    }

    public func imageCollectionStream(
        forMovie movieID: Int
    ) async -> AsyncThrowingStream<ImageCollection?, Error> {
        AsyncThrowingStream { continuation in
            continuation.yield(
                ImageCollection(
                    id: movieID,
                    posterPaths: [],
                    backdropPaths: [],
                    logoPaths: []
                )
            )
            continuation.finish()
        }
    }

}
