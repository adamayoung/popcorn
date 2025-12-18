//
//  SentrySpan.swift
//  ObservabilityAdapters
//
//  Created by Adam Young on 17/12/2025.
//

import Foundation
import Observability
import Sentry

struct SentrySpan: Observability.Span, @unchecked Sendable {

    private let span: Sentry.Span
    private let parentSpan: Sentry.Span?

    init(_ span: Sentry.Span, parentSpan: Sentry.Span? = nil) {
        self.span = span
        self.parentSpan = parentSpan
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
        // Restore parent span to scope when this span finishes
        restoreParentSpanToScope()
    }

    func finish(status: SpanStatus) {
        span.finish(status: status.sentryStatus)
        // Restore parent span to scope when this span finishes
        restoreParentSpanToScope()
    }

    private func restoreParentSpanToScope() {
        SentrySDK.configureScope { scope in
            scope.span = parentSpan
        }
    }

}

extension SpanStatus {

    var sentryStatus: SentrySpanStatus {
        switch self {
        case .ok: .ok
        case .cancelled: .cancelled
        case .unknownError: .unknownError
        case .invalidArgument: .invalidArgument
        case .deadlineExceeded: .deadlineExceeded
        case .notFound: .notFound
        case .permissionDenied: .permissionDenied
        case .resourceExhausted: .resourceExhausted
        case .unimplemented: .unimplemented
        case .unavailable: .unavailable
        case .internalError: .internalError
        }
    }

}
