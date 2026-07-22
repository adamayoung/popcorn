//
//  MockMovieLogoImageProvider.swift
//  PopcornPeople
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import PeopleDomain
import Synchronization

/// @unchecked Sendable is safe here: stubs are configured before the exercise,
/// and the mutable call-tracking state is guarded by a `Mutex` so the mock stays
/// correct when the use case fans `imageURLSet(forMovie:)` out across a task group.
final class MockMovieLogoImageProvider: MovieLogoImageProviding, @unchecked Sendable {

    private struct Tracking {
        var callCount = 0
        var calledWith: [Int] = []
    }

    private let tracking = Mutex(Tracking())

    /// Per-movie stubs. A movie absent from this map returns `nil`.
    var imageURLSetStubs: [Int: Result<ImageURLSet?, MovieLogoImageProviderError>] = [:]

    var imageURLSetCallCount: Int {
        tracking.withLock { $0.callCount }
    }

    var imageURLSetCalledWith: [Int] {
        tracking.withLock { $0.calledWith }
    }

    func imageURLSet(forMovie movieID: Int) async throws(MovieLogoImageProviderError) -> ImageURLSet? {
        tracking.withLock {
            $0.callCount += 1
            $0.calledWith.append(movieID)
        }

        guard let stub = imageURLSetStubs[movieID] else {
            return nil
        }

        switch stub {
        case .success(let urlSet):
            return urlSet
        case .failure(let error):
            throw error
        }
    }

}
