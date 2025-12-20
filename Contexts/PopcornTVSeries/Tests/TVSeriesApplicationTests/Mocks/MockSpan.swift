//
//  MockSpan.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import Observability

final class MockSpan: Span, @unchecked Sendable {

    var startChildCallCount = 0
    var startChildCalledWith: [(operation: SpanOperation, description: String?)] = []

    var setDataCallCount = 0
    var setDataCalledWith: [(key: String, value: String)] = []

    var finishCallCount = 0
    var finishCalledWithStatus: [SpanStatus?] = []

    var childSpanStub: MockSpan?

    func startChild(operation: SpanOperation, description: String?) -> Span {
        startChildCallCount += 1
        startChildCalledWith.append((operation, description))
        return childSpanStub ?? self
    }

    func setData(key: String, value: any Sendable) {
        setDataCallCount += 1
        setDataCalledWith.append((key, String(describing: value)))
    }

    func finish() {
        finishCallCount += 1
        finishCalledWithStatus.append(.ok)
    }

    func finish(status: SpanStatus) {
        finishCallCount += 1
        finishCalledWithStatus.append(status)
    }

}
