//
//  AnalyticsService.swift
//  Analytics
//
//  Copyright © 2026 Adam Young.
//

import Foundation

struct AnalyticsService: Analysing, AnalyticsInitialising {

    private let provider: any AnalyticsProviding

    init(provider: some AnalyticsProviding) {
        self.provider = provider
    }

    func start(_ config: AnalyticsConfiguration) async throws {
        try await provider.start(config)
    }

    func track(event: String, properties: [String: any Sendable]?) {
        guard provider.isInitialised else {
            return
        }

        provider.track(event: event, properties: properties)
    }

    func setUserId(_ userId: String?) {
        guard provider.isInitialised else {
            return
        }

        provider.setUserId(userId)
    }

    func setUserProperties(_ properties: [String: any Sendable]) {
        guard provider.isInitialised else {
            return
        }

        provider.setUserProperties(properties)
    }

    func reset() {
        guard provider.isInitialised else {
            return
        }

        provider.reset()
    }

}
