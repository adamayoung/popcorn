//
//  SentryObservabilityProvider.swift
//  ObservabilityAdapters
//
//  Created by Adam Young on 16/12/2025.
//

import Foundation
import OSLog
import Sentry

import struct Observability.ObservabilityConfiguration
import protocol Observability.ObservabilityProviding
import protocol Observability.Transaction

struct SentryObservabilityProvider: ObservabilityProviding {

    private static let logger = Logger(
        subsystem: "ObservabilityAdapters",
        category: "SentryObservabilityProvider"
    )

    @MainActor
    func start(_ config: ObservabilityConfiguration) async throws {
        Self.logger.debug("Sentry DSN: \(config.dsn, privacy: .sensitive)")

        SentrySDK.start { options in
            options.dsn = config.dsn
            options.environment = config.environment.rawValue

            options.enableAppHangTracking = true

            options.attachScreenshot = true
            options.attachViewHierarchy = true

            options.tracesSampleRate = config.tracesSampleRate

            options.sessionReplay.sessionSampleRate = config.sessionReplaySessionSampleRate
            options.sessionReplay.onErrorSampleRate = config.sessionReplayOnErrorSampleRate

            options.enableMetricKit = true
            options.enableMetricKitRawPayload = true

            options.debug = true  //config.isDebug
        }

        let user = User()
        user.userId = config.userID
        SentrySDK.setUser(user)

        Self.logger.info(
            "Sentry initialised: (environment: \(config.environment.rawValue, privacy: .public), debug: \(config.isDebug, privacy: .public))"
        )
    }

    func startTransaction(name: String, operation: String) -> Transaction {
        let span = SentrySDK.startTransaction(name: name, operation: operation, bindToScope: true)
        return SentryTransaction(name: name, operation: operation, span: span)
    }

    func capture(error: any Error) {
        SentrySDK.capture(error: error)
    }

    func capture(message: String) {
        SentrySDK.capture(message: message)
    }

    func setUser(id: String?, email: String?, username: String?) {
        if id == nil, email == nil, username == nil {
            SentrySDK.setUser(nil)
            return
        }

        let user = User()
        user.userId = id
        user.email = email
        user.username = username
        SentrySDK.setUser(user)
    }

    func addBreadcrumb(category: String, message: String) {
        let breadcrumb = Breadcrumb()
        breadcrumb.category = category
        breadcrumb.message = message
        SentrySDK.addBreadcrumb(breadcrumb)
    }

}

extension ObservabilityConfiguration {

    fileprivate var tracesSampleRate: NSNumber {
        switch self.environment {
        case .development: 1.0
        case .staging: 1.0
        case .production: 0.2
        }
    }

    fileprivate var sessionReplaySessionSampleRate: Float {
        switch self.environment {
        case .development: 1.0
        case .staging: 1.0
        case .production: 0.2
        }
    }

    fileprivate var sessionReplayOnErrorSampleRate: Float {
        switch self.environment {
        case .development: 1.0
        case .staging: 1.0
        case .production: 0.2
        }
    }

}
