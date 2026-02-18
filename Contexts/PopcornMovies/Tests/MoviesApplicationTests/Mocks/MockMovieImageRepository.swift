//
//  MockMovieImageRepository.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain

final class MockMovieImageRepository: MovieImageRepository, @unchecked Sendable {

    var imageCollectionCallCount = 0
    var imageCollectionCalledWith: [Int] = []
    var imageCollectionStubs: [Int: Result<ImageCollection, MovieImageRepositoryError>] = [:]

    func imageCollection(
        forMovie movieID: Int
    ) async throws(MovieImageRepositoryError) -> ImageCollection {
        imageCollectionCallCount += 1
        imageCollectionCalledWith.append(movieID)

        guard let stub = imageCollectionStubs[movieID] else {
            throw .notFound
        }

        switch stub {
        case .success(let imageCollection):
            return imageCollection
        case .failure(let error):
            throw error
        }
    }

    func imageCollectionStream(
        forMovie movieID: Int
    ) async -> AsyncThrowingStream<ImageCollection?, Error> {
        AsyncThrowingStream { _ in }
    }

}
