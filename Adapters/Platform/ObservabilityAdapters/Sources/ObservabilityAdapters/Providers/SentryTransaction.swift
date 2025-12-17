//
//  SentryTransaction.swift
//  ObservabilityAdapters
//
//  Created by Adam Young on 17/12/2025.
//

import Foundation
import Sentry

import protocol Observability.Span
import enum Observability.SpanStatus
import protocol Observability.Transaction

struct SentryTransaction: Observability.Transaction, @unchecked Sendable {

    let name: String
    let operation: String

    private let span: Sentry.Span

    init(name: String, operation: String, span: Sentry.Span) {
        self.name = name
        self.operation = operation
        self.span = span
    }

    func startChild(operation: String, description: String?) -> any Observability.Span {
        let childSpan = span.startChild(operation: operation, description: description)
        // Bind child span to scope so automatic instrumentation (like URLSession) uses it as parent
        SentrySDK.configureScope { scope in
            scope.span = childSpan
        }
        return SentrySpan(childSpan, parentSpan: span)
    }

    func setData(key: String, value: any Sendable) {
        span.setData(value: value, key: key)
    }

    func finish() {
        span.finish()
    }

    func finish(status: SpanStatus) {
        span.finish(status: status.sentryStatus)
    }

}
