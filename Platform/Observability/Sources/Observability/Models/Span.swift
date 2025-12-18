//
//  Span.swift
//  Observability
//
//  Created by Adam Young on 17/12/2025.
//

import Foundation

public protocol Span: Sendable {

    func startChild(operation: SpanOperation, description: String?) -> Span

    func setData(key: String, value: any Sendable)

    func setData(_ data: [String: any Sendable])

    func finish()

    func finish(status: SpanStatus)

}

extension Span {

    public func startChild(operation: SpanOperation) -> Span {
        startChild(operation: operation, description: nil)
    }

    public func setData(_ data: [String: any Sendable]) {
        for (key, value) in data {
            setData(key: key, value: value)
        }
    }

    public func finish() {
        finish(status: .ok)
    }

}
