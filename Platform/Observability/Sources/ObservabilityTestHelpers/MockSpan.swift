//
//  MockSpan.swift
//  Observability
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import Observability

public class MockSpan: Span, @unchecked Sendable {

    public private(set) var childSpans: [MockSpan] = []
    public private(set) var data: [String: any Sendable] = [:]
    public private(set) var finishStatus: SpanStatus?
    public private(set) var isFinished: Bool = false

    public var startChildCallCount = 0
    public var startChildCalledWith: [(operation: SpanOperation, description: String?)] = []

    public var setDataCallCount = 0
    public var setDataCalledWith: [(key: String, value: String)] = []

    public var finishCallCount = 0
    public var finishCalledWithStatus: [SpanStatus] = []

    public var childSpanStub: MockSpan?

    public init() {}

    public func startChild(operation: SpanOperation, description: String?) -> Span {
        startChildCallCount += 1
        startChildCalledWith.append((operation, description))

        if let stub = childSpanStub {
            return stub
        }

        let child = MockSpan()
        childSpans.append(child)
        return child
    }

    public func setData(key: String, value: any Sendable) {
        setDataCallCount += 1
        setDataCalledWith.append((key, String(describing: value)))
        data[key] = value
    }

    public func finish(status: SpanStatus) {
        finishCallCount += 1
        finishCalledWithStatus.append(status)
        finishStatus = status
        isFinished = true
    }

}
