//
//  MockTransaction.swift
//  Observability
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import Observability

public final class MockTransaction: MockSpan, Transaction, @unchecked Sendable {

    public let name: String
    public let operation: SpanOperation

    public init(name: String, operation: SpanOperation) {
        self.name = name
        self.operation = operation
        super.init()
    }

}
