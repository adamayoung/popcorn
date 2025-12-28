//
//  MockObservabilityProvider.swift
//  Observability
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import Observability

///
/// A mock implementation of ``ObservabilityProviding`` for use in unit tests.
///
/// This mock records all captured errors, messages, users, and breadcrumbs,
/// allowing tests to verify observability provider interactions.
///
public final class MockObservabilityProvider: ObservabilityProviding, @unchecked Sendable {

    ///
    /// Represents an error captured by the mock provider.
    ///
    public struct CapturedError: Sendable {
        /// The captured error.
        public let error: Error

        /// Additional context provided with the error.
        public let extras: [String: any Sendable]?

        ///
        /// Creates a new captured error record.
        ///
        /// - Parameters:
        ///   - error: The captured error.
        ///   - extras: Additional context provided with the error.
        ///
        public init(error: Error, extras: [String: any Sendable]? = nil) {
            self.error = error
            self.extras = extras
        }
    }

    ///
    /// Represents user information captured by the mock provider.
    ///
    public struct CapturedUser: Sendable {
        /// The user's unique identifier.
        public let id: String?

        /// The user's email address.
        public let email: String?

        /// The user's display name.
        public let username: String?

        ///
        /// Creates a new captured user record.
        ///
        /// - Parameters:
        ///   - id: The user's unique identifier.
        ///   - email: The user's email address.
        ///   - username: The user's display name.
        ///
        public init(id: String?, email: String?, username: String?) {
            self.id = id
            self.email = email
            self.username = username
        }
    }

    ///
    /// Represents a breadcrumb captured by the mock provider.
    ///
    public struct CapturedBreadcrumb: Sendable {
        /// The breadcrumb category.
        public let category: String

        /// The breadcrumb message.
        public let message: String

        ///
        /// Creates a new captured breadcrumb record.
        ///
        /// - Parameters:
        ///   - category: The breadcrumb category.
        ///   - message: The breadcrumb message.
        ///
        public init(category: String, message: String) {
            self.category = category
            self.message = message
        }
    }

    /// A Boolean value indicating whether ``start(_:)`` has been called.
    public private(set) var startCalled: Bool = false

    /// The configuration passed to ``start(_:)``.
    public private(set) var startConfig: ObservabilityConfiguration?

    /// All errors captured by the mock.
    public private(set) var capturedErrors: [CapturedError] = []

    /// All messages captured by the mock.
    public private(set) var capturedMessages: [String] = []

    /// All user contexts set on the mock.
    public private(set) var capturedUsers: [CapturedUser] = []

    /// All breadcrumbs added to the mock.
    public private(set) var breadcrumbs: [CapturedBreadcrumb] = []

    /// Creates a new mock observability provider.
    public init() {}

    public func start(_ config: ObservabilityConfiguration) async throws {
        startCalled = true
        startConfig = config
    }

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
    /// Clears all recorded data and resets the start state.
    ///
    public func reset() {
        startCalled = false
        startConfig = nil
        capturedErrors.removeAll()
        capturedMessages.removeAll()
        capturedUsers.removeAll()
        breadcrumbs.removeAll()
    }

}
