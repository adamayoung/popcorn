//
//  SentryObservabilityProvider.swift
//  ObservabilityAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import Observability
import OSLog
import Sentry

///
/// An observability provider that uses Sentry for error tracking and performance monitoring.
///
/// This provider implements ``ObservabilityProviding`` by wrapping the Sentry SDK
/// to capture errors, messages, and performance data.
///
struct SentryObservabilityProvider: ObservabilityProviding {

    private static let logger = Logger.observability

    ///
    /// Initializes the Sentry SDK with the provided configuration.
    ///
    /// This method configures Sentry with performance tracing, app hang tracking,
    /// and MetricKit integration based on the environment settings.
    ///
    /// - Parameter config: The observability configuration containing DSN and environment settings.
    ///
    /// - Throws: An error if Sentry initialization fails.
    ///
    @MainActor
    func start(_ config: ObservabilityConfiguration) async throws {
        let isDebug = config.environment == .production ? false : true

        SentrySDK.start { options in
            options.dsn = config.dsn
            options.environment = config.environment.rawValue

            options.enableAutoPerformanceTracing = true
            options.tracesSampleRate = config.tracesSampleRate

            options.enableAppHangTracking = true

            options.enableMetricKit = true

            options.debug = isDebug
        }

        let user = User()
        user.userId = config.userID
        SentrySDK.setUser(user)

        if SentrySDK.isEnabled {
            Self.logger
                .info(
                    "Sentry enabled (DSN: \(config.dsn, privacy: .private), environment: \(config.environment.rawValue, privacy: .public), debug: \(isDebug, privacy: .public))"
                )
        } else {
            Self.logger.warning("Sentry disabled")
        }
    }

    ///
    /// Captures an error and sends it to Sentry.
    ///
    /// - Parameter error: The error to capture.
    ///
    func capture(error: any Error) {
        SentrySDK.capture(error: error)
    }

    ///
    /// Captures an error with additional context and sends it to Sentry.
    ///
    /// - Parameters:
    ///   - error: The error to capture.
    ///   - extras: Additional key-value pairs providing context about the error.
    ///
    func capture(error: any Error, extras: [String: any Sendable]) {
        SentrySDK.capture(error: error) { scope in
            scope.setExtras(extras)
        }
    }

    ///
    /// Captures a message and sends it to Sentry.
    ///
    /// - Parameter message: The message to capture.
    ///
    func capture(message: String) {
        SentrySDK.capture(message: message)
    }

    ///
    /// Sets the current user context in Sentry.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the user, or `nil` to clear.
    ///   - email: The email address of the user, or `nil` if not available.
    ///   - username: The username of the user, or `nil` if not available.
    ///
    /// - Note: If all parameters are `nil`, the user context is cleared.
    ///
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

    ///
    /// Adds a breadcrumb to the Sentry event trail.
    ///
    /// Breadcrumbs are trail of events that lead up to an error and are helpful
    /// for understanding the user's actions before an error occurred.
    ///
    /// - Parameters:
    ///   - category: The category of the breadcrumb (e.g., "navigation", "network").
    ///   - message: A description of the event.
    ///
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
