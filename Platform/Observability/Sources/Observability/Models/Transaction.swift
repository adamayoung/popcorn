//
//  Transaction.swift
//  Observability
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public protocol Transaction: Span {

    var name: String { get }

    var operation: SpanOperation { get }

}
