//
//  SentrySpan.swift
//  ObservabilityAdapters
//
//  Created by Adam Young on 17/12/2025.
//

import Foundation
import Observability
import Sentry

struct SentrySpan: Span {

    private let span: Sentry.Span

    init(_ span: Sentry.Span) {
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
