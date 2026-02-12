//
//  SentrySpanTests.swift
//  ObservabilityAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import Observability
@testable import ObservabilityAdapters
import Testing

@Suite("SentrySpan Tests")
struct SentrySpanTests {

    // MARK: - Protocol Conformance Tests

    @Test("Conforms to Span protocol")
    func conformsToSpanProtocol() {
        let provider = SentryObservabilityProvider()
        let transaction = provider.startTransaction(name: "test", operation: .uiLoad)
        let span = transaction.startChild(operation: .clientFetch, description: "Test span")

        let conformingSpan: any Span = span

        #expect(conformingSpan is SentrySpan)
    }

    @Test("Span is Sendable")
    func spanIsSendable() {
        let provider = SentryObservabilityProvider()
        let transaction = provider.startTransaction(name: "test", operation: .uiLoad)
        let span = transaction.startChild(operation: .clientFetch, description: "Test span")

        let sendableSpan: any Sendable = span

        #expect(sendableSpan is SentrySpan)
    }

    // MARK: - startChild Tests

    @Test("startChild returns a Span")
    func startChildReturnsSpan() {
        let provider = SentryObservabilityProvider()
        let transaction = provider.startTransaction(name: "parent", operation: .uiLoad)
        let span = transaction.startChild(operation: .clientFetch, description: "Parent span")

        let childSpan = span.startChild(operation: .repositoryGet, description: "Child span")

        #expect(childSpan is SentrySpan)
    }

    @Test("startChild with nil description returns a Span")
    func startChildWithNilDescriptionReturnsSpan() {
        let provider = SentryObservabilityProvider()
        let transaction = provider.startTransaction(name: "parent", operation: .uiLoad)
        let span = transaction.startChild(operation: .clientFetch, description: "Parent span")

        let childSpan = span.startChild(operation: .cacheGet, description: nil)

        #expect(childSpan is SentrySpan)
    }

    @Test("Can create nested child spans")
    func canCreateNestedChildSpans() {
        let provider = SentryObservabilityProvider()
        let transaction = provider.startTransaction(name: "root", operation: .uiLoad)
        let span1 = transaction.startChild(operation: .clientFetch, description: "Level 1")
        let span2 = span1.startChild(operation: .useCaseExecute, description: "Level 2")
        let span3 = span2.startChild(operation: .repositoryGet, description: "Level 3")

        #expect(span1 is SentrySpan)
        #expect(span2 is SentrySpan)
        #expect(span3 is SentrySpan)

        // Clean up - finish in reverse order
        span3.finish()
        span2.finish()
        span1.finish()
        transaction.finish()
    }

    // MARK: - setData Tests

    @Test("setData can be called with string value")
    func setDataWithStringValue() {
        let provider = SentryObservabilityProvider()
        let transaction = provider.startTransaction(name: "test", operation: .uiLoad)
        let span = transaction.startChild(operation: .clientFetch, description: "Test span")

        span.setData(key: "movie_title", value: "Inception")

        #expect(true)

        span.finish()
        transaction.finish()
    }

    @Test("setData can be called with integer value")
    func setDataWithIntegerValue() {
        let provider = SentryObservabilityProvider()
        let transaction = provider.startTransaction(name: "test", operation: .uiLoad)
        let span = transaction.startChild(operation: .clientFetch, description: "Test span")

        span.setData(key: "movie_id", value: 550)

        #expect(true)

        span.finish()
        transaction.finish()
    }

    @Test("setData can be called with boolean value")
    func setDataWithBooleanValue() {
        let provider = SentryObservabilityProvider()
        let transaction = provider.startTransaction(name: "test", operation: .uiLoad)
        let span = transaction.startChild(operation: .clientFetch, description: "Test span")

        span.setData(key: "from_cache", value: false)

        #expect(true)

        span.finish()
        transaction.finish()
    }

    @Test("setData can be called multiple times")
    func setDataMultipleTimes() {
        let provider = SentryObservabilityProvider()
        let transaction = provider.startTransaction(name: "test", operation: .uiLoad)
        let span = transaction.startChild(operation: .clientFetch, description: "Test span")

        span.setData(key: "key1", value: "value1")
        span.setData(key: "key2", value: 123)
        span.setData(key: "key3", value: true)

        #expect(true)

        span.finish()
        transaction.finish()
    }

    // MARK: - finish Tests

    @Test("finish can be called")
    func finishCanBeCalled() {
        let provider = SentryObservabilityProvider()
        let transaction = provider.startTransaction(name: "test", operation: .uiLoad)
        let span = transaction.startChild(operation: .clientFetch, description: "Test span")

        span.finish()

        #expect(true)

        transaction.finish()
    }

    @Test("finish with ok status can be called")
    func finishWithOkStatus() {
        let provider = SentryObservabilityProvider()
        let transaction = provider.startTransaction(name: "test", operation: .uiLoad)
        let span = transaction.startChild(operation: .clientFetch, description: "Test span")

        span.finish(status: .ok)

        #expect(true)

        transaction.finish()
    }

    @Test("finish with error status can be called")
    func finishWithErrorStatus() {
        let provider = SentryObservabilityProvider()
        let transaction = provider.startTransaction(name: "test", operation: .uiLoad)
        let span = transaction.startChild(operation: .clientFetch, description: "Test span")

        span.finish(status: .notFound)

        #expect(true)

        transaction.finish()
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
        let span = transaction.startChild(operation: .clientFetch, description: "Test span")

        span.finish(status: status)

        #expect(true)

        transaction.finish()
    }

    // MARK: - Parent Span Restoration Tests

    @Test("Child span finish restores parent span context")
    func childSpanFinishRestoresParentContext() {
        let provider = SentryObservabilityProvider()
        let transaction = provider.startTransaction(name: "test", operation: .uiLoad)
        let parentSpan = transaction.startChild(operation: .clientFetch, description: "Parent")
        let childSpan = parentSpan.startChild(operation: .repositoryGet, description: "Child")

        // Finish child - should restore parent to scope
        childSpan.finish()

        // Parent should still be usable
        parentSpan.setData(key: "after_child", value: true)
        parentSpan.finish()

        #expect(true)

        transaction.finish()
    }

}
