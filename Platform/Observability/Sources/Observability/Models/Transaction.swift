//
//  Transaction.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol Transaction: Span {

    var name: String { get }

    var operation: SpanOperation { get }

}
