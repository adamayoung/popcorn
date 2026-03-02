//
//  AnalyticsFactory.swift
//  Analytics
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public final class AnalyticsFactory: Sendable {

    private let provider: any AnalyticsProviding

    public init(provider: some AnalyticsProviding) {
        self.provider = provider
    }

    public func makeService() -> some Analysing & AnalyticsInitialising {
        AnalyticsService(provider: provider)
    }

}
