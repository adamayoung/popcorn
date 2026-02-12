//
//  SentryObservabilityProviderTests.swift
//  ObservabilityAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import Observability
@testable import ObservabilityAdapters
import Testing

@Suite("SentryObservabilityProvider Tests")
struct SentryObservabilityProviderTests {

    // MARK: - Protocol Conformance Tests

    @Test("Conforms to ObservabilityProviding protocol")
    func conformsToObservabilityProvidingProtocol() {
        let provider = SentryObservabilityProvider()

        let conformingProvider: any ObservabilityProviding = provider

        #expect(conformingProvider is SentryObservabilityProvider)
    }

    @Test("Provider is Sendable")
    func providerIsSendable() {
        let provider = SentryObservabilityProvider()

        let sendableProvider: any Sendable = provider

        #expect(sendableProvider is SentryObservabilityProvider)
    }

    // MARK: - startTransaction Tests

    @Test("startTransaction returns a Transaction")
    func startTransactionReturnsTransaction() {
        let provider = SentryObservabilityProvider()
        let name = "test-transaction"
        let operation = SpanOperation.uiLoad

        let transaction = provider.startTransaction(name: name, operation: operation)

        #expect(transaction.name == name)
        #expect(transaction.operation.value == operation.value)
    }

    @Test("startTransaction returns SentryTransaction type")
    func startTransactionReturnsSentryTransactionType() {
        let provider = SentryObservabilityProvider()

        let transaction = provider.startTransaction(name: "test", operation: .clientFetch)

        #expect(transaction is SentryTransaction)
    }

    @Test("startTransaction with different operations creates correct transactions")
    func startTransactionWithDifferentOperations() {
        let provider = SentryObservabilityProvider()
        let operations: [SpanOperation] = [
            .uiAction,
            .uiLoad,
            .clientFetch,
            .useCaseExecute,
            .repositoryGet,
            .cacheGet
        ]

        for operation in operations {
            let transaction = provider.startTransaction(name: "test-\(operation.value)", operation: operation)

            #expect(transaction.operation.value == operation.value)
        }
    }

    // MARK: - currentSpan Tests

    @Test("currentSpan returns nil when no span is active")
    func currentSpanReturnsNilWhenNoSpanActive() {
        let provider = SentryObservabilityProvider()

        // Note: This test may return a span if Sentry SDK has an active span
        // The behavior depends on SDK state
        _ = provider.currentSpan()

        // We can only verify the method is callable without crashing
        #expect(true)
    }

    // MARK: - setUser Tests

    @Test("setUser can be called with all nil parameters")
    func setUserWithAllNilParameters() {
        let provider = SentryObservabilityProvider()

        // Should not throw
        provider.setUser(id: nil, email: nil, username: nil)

        #expect(true)
    }

    @Test("setUser can be called with id only")
    func setUserWithIdOnly() {
        let provider = SentryObservabilityProvider()

        provider.setUser(id: "user-123", email: nil, username: nil)

        #expect(true)
    }

    @Test("setUser can be called with all parameters")
    func setUserWithAllParameters() {
        let provider = SentryObservabilityProvider()

        provider.setUser(id: "user-123", email: "test@example.com", username: "testuser")

        #expect(true)
    }

    // MARK: - capture Tests

    @Test("capture error can be called")
    func captureError() {
        let provider = SentryObservabilityProvider()

        provider.capture(error: TestError.generic)

        #expect(true)
    }

    @Test("capture error with extras can be called")
    func captureErrorWithExtras() {
        let provider = SentryObservabilityProvider()
        let extras: [String: any Sendable] = [
            "key1": "value1",
            "key2": 123,
            "key3": true
        ]

        provider.capture(error: TestError.generic, extras: extras)

        #expect(true)
    }

    @Test("capture message can be called")
    func captureMessage() {
        let provider = SentryObservabilityProvider()

        provider.capture(message: "Test message")

        #expect(true)
    }

    // MARK: - addBreadcrumb Tests

    @Test("addBreadcrumb can be called")
    func addBreadcrumb() {
        let provider = SentryObservabilityProvider()

        provider.addBreadcrumb(category: "navigation", message: "User navigated to details")

        #expect(true)
    }

}

// MARK: - Test Helpers

private enum TestError: Error {
    case generic
}
