//
//  Observing.swift
//  Observability
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A protocol for capturing errors, messages, and user context for observability.
///
/// Use this protocol to report errors and diagnostic information to monitoring
/// services such as Sentry.
///
public protocol Observing: Sendable {

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
    /// Breadcrumbs provide a trail of events leading up to an error.
    ///
    /// - Parameters:
    ///   - category: The category of the breadcrumb (e.g., "navigation", "user").
    ///   - message: A description of the event.
    ///
    func addBreadcrumb(category: String, message: String)

}
