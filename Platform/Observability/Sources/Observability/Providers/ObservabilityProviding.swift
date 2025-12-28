//
//  ObservabilityProviding.swift
//  Observability
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A protocol for implementing observability providers.
///
/// Implement this protocol to integrate with external error tracking and
/// monitoring services such as Sentry, Crashlytics, or custom solutions.
///
public protocol ObservabilityProviding: Sendable {

    ///
    /// Starts the observability provider with the specified configuration.
    ///
    /// - Parameter config: The configuration containing credentials and context.
    /// - Throws: An error if the provider fails to initialize.
    ///
    func start(_ config: ObservabilityConfiguration) async throws

    ///
    /// Captures an error for reporting.
    ///
    /// - Parameter error: The error to capture.
    ///
    func capture(error: any Error)

    ///
    /// Captures an error with additional context for reporting.
    ///
    /// - Parameters:
    ///   - error: The error to capture.
    ///   - extras: Additional key-value pairs providing context about the error.
    ///
    func capture(error: any Error, extras: [String: any Sendable])

    ///
    /// Captures a message for reporting.
    ///
    /// - Parameter message: The message to capture.
    ///
    func capture(message: String)

    ///
    /// Sets the current user context for error reporting.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the user.
    ///   - email: The user's email address.
    ///   - username: The user's display name.
    ///
    func setUser(id: String?, email: String?, username: String?)

    ///
    /// Adds a breadcrumb for debugging context.
    ///
    /// - Parameters:
    ///   - category: The category of the breadcrumb.
    ///   - message: A description of the event.
    ///
    func addBreadcrumb(category: String, message: String)

}
