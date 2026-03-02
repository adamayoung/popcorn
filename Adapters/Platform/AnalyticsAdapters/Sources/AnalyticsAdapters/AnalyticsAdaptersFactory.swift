//
//  AnalyticsAdaptersFactory.swift
//  AnalyticsAdapters
//
//  Copyright © 2026 Adam Young.
//

import Analytics
import Foundation

public final class AnalyticsAdaptersFactory: Sendable {

    public init() {}

    public func makeAnalyticsFactory() -> AnalyticsFactory {
        let provider = AmplitudeAnalyticsProvider()
        return AnalyticsFactory(provider: provider)
    }

}
