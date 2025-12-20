//
//  SentryTransaction.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import Observability
import Sentry

struct SentryTransaction: Observability.Transaction, @unchecked Sendable {

    let name: String
    let operation: SpanOperation

    private let span: Sentry.Span

    init(name: String, operation: SpanOperation, span: Sentry.Span) {
        self.name = name
        self.operation = operation
        self.span = span
    }

    func startChild(operation: SpanOperation, description: String?) -> any Observability.Span {
        let childSpan = span.startChild(operation: operation.value, description: description)
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
