//
//  Span.swift
//  Observability
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol Span: Sendable {

    func startChild(operation: SpanOperation, description: String?) -> Span

    func setData(key: String, value: any Sendable)

    func setData(_ data: [String: any Sendable])

    func setData(error: any Error)

    func finish()

    func finish(status: SpanStatus)

}

public extension Span {

    func startChild(operation: SpanOperation) -> Span {
        startChild(operation: operation, description: nil)
    }

    func setData(_ data: [String: any Sendable]) {
        for (key, value) in data {
            setData(key: key, value: value)
        }
    }

    func setData(error: any Error) {
        setData(key: "error", value: error.localizedDescription)
    }

    func finish() {
        finish(status: .ok)
    }

}
