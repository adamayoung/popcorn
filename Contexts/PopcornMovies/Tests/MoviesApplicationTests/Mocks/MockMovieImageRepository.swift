//
//  MockMovieImageRepository.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain
import Synchronization

/// @unchecked Sendable is safe here: stubs are configured before the exercise,
/// and the mutable call-tracking state is guarded by a `Mutex` so the mock stays
/// correct when a use case fans `imageCollection(forMovie:)` out across a task group.
final class MockMovieImageRepository: MovieImageRepository, @unchecked Sendable {

    private struct Tracking {
        var callCount = 0
        var calledWith: [Int] = []
    }

    private let tracking = Mutex(Tracking())

    var imageCollectionStubs: [Int: Result<ImageCollection, MovieImageRepositoryError>] = [:]

    var imageCollectionCallCount: Int {
        tracking.withLock { $0.callCount }
    }

    var imageCollectionCalledWith: [Int] {
        tracking.withLock { $0.calledWith }
    }

    func imageCollection(
        forMovie movieID: Int
    ) async throws(MovieImageRepositoryError) -> ImageCollection {
        tracking.withLock {
            $0.callCount += 1
            $0.calledWith.append(movieID)
        }

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
