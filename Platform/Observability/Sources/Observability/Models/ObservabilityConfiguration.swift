//
//  ObservabilityConfiguration.swift
//  Observability
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Configuration settings for initializing an observability service.
///
/// Provides the necessary credentials and context for connecting to an error
/// tracking provider such as Sentry.
///
public struct ObservabilityConfiguration: Sendable {

    /// The Data Source Name (DSN) for the observability provider.
    public let dsn: String

    /// The deployment environment for error reporting.
    public let environment: Environment

    /// The unique identifier for the current user.
    public let userID: String

    ///
    /// Creates a new observability configuration.
    ///
    /// - Parameters:
    ///   - dsn: The Data Source Name for the provider.
    ///   - environment: The deployment environment.
    ///   - userID: The unique identifier for the current user.
    ///
    public init(
        dsn: String,
        environment: Environment,
        userID: String
    ) {
        self.dsn = dsn
        self.environment = environment
        self.userID = userID
    }

}

public extension ObservabilityConfiguration {

    ///
    /// The deployment environment for error reporting.
    ///
    /// Different environments help categorize errors and filter reports
    /// based on their origin.
    ///
    enum Environment: String, Sendable {
        /// Development environment for local testing.
        case development

        /// Staging environment for pre-production testing.
        case staging

        /// Production environment for end users.
        case production
    }

}
