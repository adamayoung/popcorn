//
//  MockObservability.swift
//  Observability
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import Observability

///
/// A mock implementation of ``Observing`` for use in unit tests.
///
/// This mock records all captured errors, messages, users, and breadcrumbs,
/// allowing tests to verify observability interactions.
///
public final class MockObservability: Observing, @unchecked Sendable {

    /// Type alias for captured error records from ``MockObservabilityProvider``.
    public typealias CapturedError = MockObservabilityProvider.CapturedError

    /// Type alias for captured user records from ``MockObservabilityProvider``.
    public typealias CapturedUser = MockObservabilityProvider.CapturedUser

    /// Type alias for captured breadcrumb records from ``MockObservabilityProvider``.
    public typealias CapturedBreadcrumb = MockObservabilityProvider.CapturedBreadcrumb

    /// All errors captured by the mock.
    public private(set) var capturedErrors: [CapturedError] = []

    /// All messages captured by the mock.
    public private(set) var capturedMessages: [String] = []

    /// All user contexts set on the mock.
    public private(set) var capturedUsers: [CapturedUser] = []

    /// All breadcrumbs added to the mock.
    public private(set) var breadcrumbs: [CapturedBreadcrumb] = []

    /// Creates a new mock observability instance.
    public init() {}

    public func capture(error: any Error) {
        capturedErrors.append(CapturedError(error: error))
    }

    public func capture(error: any Error, extras: [String: any Sendable]) {
        capturedErrors.append(CapturedError(error: error, extras: extras))
    }

    public func capture(message: String) {
        capturedMessages.append(message)
    }

    public func setUser(id: String?, email: String?, username: String?) {
        capturedUsers.append(CapturedUser(id: id, email: email, username: username))
    }

    public func addBreadcrumb(category: String, message: String) {
        breadcrumbs.append(CapturedBreadcrumb(category: category, message: message))
    }

    ///
    /// Resets the mock to its initial state.
    ///
    /// Clears all recorded data.
    ///
    public func reset() {
        capturedErrors.removeAll()
        capturedMessages.removeAll()
        capturedUsers.removeAll()
        breadcrumbs.removeAll()
    }

}
