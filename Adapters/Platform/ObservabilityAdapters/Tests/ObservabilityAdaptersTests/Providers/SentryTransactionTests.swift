//
//  SentryTransactionTests.swift
//  ObservabilityAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import Observability
@testable import ObservabilityAdapters
import Testing

@Suite("SentryTransaction Tests")
struct SentryTransactionTests {

    // MARK: - Protocol Conformance Tests

    @Test("Conforms to Transaction protocol")
    func conformsToTransactionProtocol() {
        let provider = SentryObservabilityProvider()
        let transaction = provider.startTransaction(name: "test", operation: .uiLoad)

        let conformingTransaction: any Transaction = transaction

        #expect(conformingTransaction is SentryTransaction)
    }

    @Test("Conforms to Span protocol")
    func conformsToSpanProtocol() {
        let provider = SentryObservabilityProvider()
        let transaction = provider.startTransaction(name: "test", operation: .uiLoad)

        let conformingSpan: any Span = transaction

        #expect(conformingSpan is SentryTransaction)
    }

    @Test("Transaction is Sendable")
    func transactionIsSendable() {
        let provider = SentryObservabilityProvider()
        let transaction = provider.startTransaction(name: "test", operation: .uiLoad)

        let sendableTransaction: any Sendable = transaction

        #expect(sendableTransaction is SentryTransaction)
    }

    // MARK: - Properties Tests

    @Test("Transaction has correct name")
    func transactionHasCorrectName() {
        let provider = SentryObservabilityProvider()
        let expectedName = "fetch-movie-details"

        let transaction = provider.startTransaction(name: expectedName, operation: .clientFetch)

        #expect(transaction.name == expectedName)
    }

    @Test("Transaction has correct operation")
    func transactionHasCorrectOperation() {
        let provider = SentryObservabilityProvider()
        let expectedOperation = SpanOperation.useCaseExecute

        let transaction = provider.startTransaction(name: "test", operation: expectedOperation)

        #expect(transaction.operation.value == expectedOperation.value)
    }

    // MARK: - startChild Tests

    @Test("startChild returns a Span")
    func startChildReturnsSpan() {
        let provider = SentryObservabilityProvider()
        let transaction = provider.startTransaction(name: "parent", operation: .uiLoad)

        let childSpan = transaction.startChild(operation: .clientFetch, description: "Fetching data")

        #expect(childSpan is SentrySpan)
    }

    @Test("startChild with nil description returns a Span")
    func startChildWithNilDescriptionReturnsSpan() {
        let provider = SentryObservabilityProvider()
        let transaction = provider.startTransaction(name: "parent", operation: .uiLoad)

        let childSpan = transaction.startChild(operation: .repositoryGet, description: nil)

        #expect(childSpan is SentrySpan)
    }

    // MARK: - setData Tests

    @Test("setData can be called with string value")
    func setDataWithStringValue() {
        let provider = SentryObservabilityProvider()
        let transaction = provider.startTransaction(name: "test", operation: .uiLoad)

        transaction.setData(key: "movie_id", value: "123")

        // If we get here without crashing, the test passes
        #expect(true)
    }

    @Test("setData can be called with integer value")
    func setDataWithIntegerValue() {
        let provider = SentryObservabilityProvider()
        let transaction = provider.startTransaction(name: "test", operation: .uiLoad)

        transaction.setData(key: "count", value: 42)

        #expect(true)
    }

    @Test("setData can be called with boolean value")
    func setDataWithBooleanValue() {
        let provider = SentryObservabilityProvider()
        let transaction = provider.startTransaction(name: "test", operation: .uiLoad)

        transaction.setData(key: "is_cached", value: true)

        #expect(true)
    }

    // MARK: - finish Tests

    @Test("finish can be called")
    func finishCanBeCalled() {
        let provider = SentryObservabilityProvider()
        let transaction = provider.startTransaction(name: "test", operation: .uiLoad)

        transaction.finish()

        #expect(true)
    }

    @Test("finish with ok status can be called")
    func finishWithOkStatus() {
        let provider = SentryObservabilityProvider()
        let transaction = provider.startTransaction(name: "test", operation: .uiLoad)

        transaction.finish(status: .ok)

        #expect(true)
    }

    @Test("finish with error status can be called")
    func finishWithErrorStatus() {
        let provider = SentryObservabilityProvider()
        let transaction = provider.startTransaction(name: "test", operation: .uiLoad)

        transaction.finish(status: .internalError)

        #expect(true)
    }

    @Test(
        "finish with various statuses can be called",
        arguments: [
            SpanStatus.ok,
            SpanStatus.cancelled,
            SpanStatus.unknownError,
            SpanStatus.invalidArgument,
            SpanStatus.deadlineExceeded,
            SpanStatus.notFound,
            SpanStatus.permissionDenied,
            SpanStatus.resourceExhausted,
            SpanStatus.unimplemented,
            SpanStatus.unavailable,
            SpanStatus.internalError
        ]
    )
    func finishWithVariousStatuses(status: SpanStatus) {
        let provider = SentryObservabilityProvider()
        let transaction = provider.startTransaction(name: "test", operation: .uiLoad)

        transaction.finish(status: status)

        #expect(true)
    }

}
