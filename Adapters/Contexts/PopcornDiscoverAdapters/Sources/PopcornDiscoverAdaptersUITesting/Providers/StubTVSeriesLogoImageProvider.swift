//
//  StubTVSeriesLogoImageProvider.swift
//  PopcornDiscoverAdapters
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import DiscoverDomain
import Foundation

public final class StubTVSeriesLogoImageProvider: TVSeriesLogoImageProviding, Sendable {

    public init() {}

    public func imageURLSet(forTVSeries tvSeriesID: Int) async throws(TVSeriesLogoImageProviderError) -> ImageURLSet? {
        nil
    }

}
