//
//  MockTVSeriesLogoImageProvider.swift
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
/// correct when the use case fans `imageURLSet(forTVSeries:)` out across a task group.
final class MockTVSeriesLogoImageProvider: TVSeriesLogoImageProviding, @unchecked Sendable {

    private struct Tracking {
        var callCount = 0
        var calledWith: [Int] = []
    }

    private let tracking = Mutex(Tracking())

    /// Per-series stubs. A series absent from this map returns `nil`.
    var imageURLSetStubs: [Int: Result<ImageURLSet?, TVSeriesLogoImageProviderError>] = [:]

    var imageURLSetCallCount: Int {
        tracking.withLock { $0.callCount }
    }

    var imageURLSetCalledWith: [Int] {
        tracking.withLock { $0.calledWith }
    }

    func imageURLSet(
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesLogoImageProviderError) -> ImageURLSet? {
        tracking.withLock {
            $0.callCount += 1
            $0.calledWith.append(tvSeriesID)
        }

        guard let stub = imageURLSetStubs[tvSeriesID] else {
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
