//
//  SentryTransaction.swift
//  ObservabilityAdapters
//
//  Created by Adam Young on 17/12/2025.
//

import Foundation
import Observability
import Sentry

struct SentryTransaction: Transaction {

    let name: String
    let operation: String

    private let span: Sentry.Span

    init(name: String, operation: String, span: Sentry.Span) {
        self.name = name
        self.operation = operation
        self.span = span
    }

    func startChild(operation: String, description: String?) -> Span {
        let childSpan = span.startChild(operation: operation, description: description)
        return SentrySpan(childSpan)
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
