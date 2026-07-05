//
//  MockTVSeriesLogoImageProvider.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import TrendingDomain

final class MockTVSeriesLogoImageProvider: TVSeriesLogoImageProviding, @unchecked Sendable {

    var imageURLSetCallCount = 0
    var imageURLSetCalledWith: [Int] = []
    var imageURLSetStub: Result<ImageURLSet?, TVSeriesLogoImageProviderError>?

    func imageURLSet(forTVSeries tvSeriesID: Int) async throws(TVSeriesLogoImageProviderError) -> ImageURLSet? {
        imageURLSetCallCount += 1
        imageURLSetCalledWith.append(tvSeriesID)

        guard let stub = imageURLSetStub else {
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
