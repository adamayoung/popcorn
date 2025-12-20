//
//  SentryObservabilityProvider.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import Observability
import OSLog
import Sentry

struct SentryObservabilityProvider: ObservabilityProviding {

    private static let logger = Logger.observability

    @MainActor
    func start(_ config: ObservabilityConfiguration) async throws {
        Self.logger.debug("Sentry DSN: \(config.dsn, privacy: .private)")

        SentrySDK.start { options in
            options.dsn = config.dsn
            options.environment = config.environment.rawValue

            options.enableAppHangTracking = true
            options.tracesSampleRate = config.tracesSampleRate
            options.enableMetricKit = true

            options.debug = config.isDebug
        }

        let user = User()
        user.userId = config.userID
        SentrySDK.setUser(user)

        Self.logger
            .info(
                "Sentry initialised: (environment: \(config.environment.rawValue, privacy: .public), debug: \(config.isDebug, privacy: .public))"
            )
    }

    func startTransaction(name: String, operation: SpanOperation) -> Transaction {
        let span = SentrySDK.startTransaction(
            name: name,
            operation: operation.value,
            bindToScope: true
        )
        return SentryTransaction(name: name, operation: operation, span: span)
    }

    func currentSpan() -> Observability.Span? {
        guard let sentrySpan = SentrySDK.span else {
            return nil
        }

        return SentrySpan(sentrySpan)
    }

    func capture(error: any Error) {
        SentrySDK.capture(error: error)
    }

    func capture(error: any Error, extras: [String: any Sendable]) {
        SentrySDK.capture(error: error) { scope in
            scope.setExtras(extras)
        }
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

private extension ObservabilityConfiguration {

    var tracesSampleRate: NSNumber {
        switch environment {
        case .development: 1.0
        case .staging: 1.0
        case .production: 0.2
        }
    }

    var sessionReplaySessionSampleRate: Float {
        switch environment {
        case .development: 1.0
        case .staging: 1.0
        case .production: 0.2
        }
    }

    var sessionReplayOnErrorSampleRate: Float {
        switch environment {
        case .development: 1.0
        case .staging: 1.0
        case .production: 0.2
        }
    }

}
