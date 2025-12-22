//
//  MockObservabilityProvider.swift
//  Observability
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import Observability

public final class MockObservabilityProvider: ObservabilityProviding, @unchecked Sendable {

    public struct CapturedError: Sendable {
        public let error: Error
        public let extras: [String: any Sendable]?

        public init(error: Error, extras: [String: any Sendable]? = nil) {
            self.error = error
            self.extras = extras
        }
    }

    public struct CapturedUser: Sendable {
        public let id: String?
        public let email: String?
        public let username: String?

        public init(id: String?, email: String?, username: String?) {
            self.id = id
            self.email = email
            self.username = username
        }
    }

    public struct CapturedBreadcrumb: Sendable {
        public let category: String
        public let message: String

        public init(category: String, message: String) {
            self.category = category
            self.message = message
        }
    }

    public private(set) var startCalled: Bool = false
    public private(set) var startConfig: ObservabilityConfiguration?
    public private(set) var transactions: [MockTransaction] = []
    public private(set) var capturedErrors: [CapturedError] = []
    public private(set) var capturedMessages: [String] = []
    public private(set) var capturedUsers: [CapturedUser] = []
    public private(set) var breadcrumbs: [CapturedBreadcrumb] = []

    private var _currentSpan: Span?
    public var currentSpanStub: Span?

    public init() {}

    public func start(_ config: ObservabilityConfiguration) async throws {
        startCalled = true
        startConfig = config
    }

    public func startTransaction(name: String, operation: SpanOperation) -> Transaction {
        let transaction = MockTransaction(name: name, operation: operation)
        transactions.append(transaction)
        _currentSpan = transaction
        return transaction
    }

    public func currentSpan() -> Span? {
        currentSpanStub ?? _currentSpan
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

    public func reset() {
        startCalled = false
        startConfig = nil
        transactions.removeAll()
        capturedErrors.removeAll()
        capturedMessages.removeAll()
        capturedUsers.removeAll()
        breadcrumbs.removeAll()
        _currentSpan = nil
        currentSpanStub = nil
    }

}
