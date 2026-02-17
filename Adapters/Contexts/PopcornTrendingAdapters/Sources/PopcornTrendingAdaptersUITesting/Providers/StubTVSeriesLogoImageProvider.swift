//
//  StubTVSeriesLogoImageProvider.swift
//  PopcornTrendingAdapters
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import TrendingDomain

final class StubTVSeriesLogoImageProvider: TVSeriesLogoImageProviding, Sendable {

    func imageURLSet(forTVSeries tvSeriesID: Int) async throws(TVSeriesLogoImageProviderError) -> ImageURLSet? {
        nil
    }

}
