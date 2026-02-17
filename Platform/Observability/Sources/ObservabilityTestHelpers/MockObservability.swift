//
//  MockObservability.swift
//  Observability
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observability

public final class MockObservability: Observing, @unchecked Sendable {

    public typealias CapturedError = MockObservabilityProvider.CapturedError
    public typealias CapturedUser = MockObservabilityProvider.CapturedUser
    public typealias CapturedBreadcrumb = MockObservabilityProvider.CapturedBreadcrumb

    public private(set) var transactions: [MockTransaction] = []
    public private(set) var capturedErrors: [CapturedError] = []
    public private(set) var capturedMessages: [String] = []
    public private(set) var capturedUsers: [CapturedUser] = []
    public private(set) var breadcrumbs: [CapturedBreadcrumb] = []

    public init() {}

    public func startTransaction(name: String, operation: SpanOperation) -> Transaction {
        let transaction = MockTransaction(name: name, operation: operation)
        transactions.append(transaction)
        return transaction
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
        transactions.removeAll()
        capturedErrors.removeAll()
        capturedMessages.removeAll()
        capturedUsers.removeAll()
        breadcrumbs.removeAll()
    }

}
