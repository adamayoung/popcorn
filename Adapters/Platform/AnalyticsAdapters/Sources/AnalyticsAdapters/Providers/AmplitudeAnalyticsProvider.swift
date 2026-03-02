//
//  AmplitudeAnalyticsProvider.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AmplitudeSwift
import Analytics
import Foundation
import OSLog

/// @unchecked Sendable: `amplitude` is written once during `start()` at app launch
/// and only read thereafter. The Amplitude SDK class is not Sendable.
final class AmplitudeAnalyticsProvider: AnalyticsProviding, @unchecked Sendable {

    private static let logger = Logger.analytics

    var isInitialised: Bool {
        amplitude != nil
    }

    private var amplitude: Amplitude?

    init() {}

    func start(_ config: AnalyticsConfiguration) async throws {
        let configuration = Configuration(
            apiKey: config.apiKey,
            autocapture: [.sessions, .appLifecycles]
        )

        let amplitudeInstance = Amplitude(configuration: configuration)
        amplitudeInstance.setUserId(userId: config.userID)
        amplitude = amplitudeInstance

        Self.logger.info(
            "Amplitude enabled (environment: \(config.environment.rawValue, privacy: .public))"
        )
    }

    func track(event: String, properties: [String: any Sendable]?) {
        guard let amplitude else {
            return
        }

        if let properties {
            amplitude.track(eventType: event, eventProperties: properties)
        } else {
            amplitude.track(eventType: event)
        }
    }

    func setUserId(_ userId: String?) {
        amplitude?.setUserId(userId: userId)
    }

    func setUserProperties(_ properties: [String: any Sendable]) {
        guard let amplitude else {
            return
        }

        let identify = Identify()
        for (key, value) in properties {
            identify.set(property: key, value: value)
        }
        amplitude.identify(identify: identify)
    }

    func reset() {
        amplitude?.reset()
    }

}
