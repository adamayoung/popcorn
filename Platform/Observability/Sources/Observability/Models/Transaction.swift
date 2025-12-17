//
//  Transaction.swift
//  Observability
//
//  Created by Adam Young on 17/12/2025.
//

import Foundation

public protocol Transaction: Span {

    var name: String { get }

    var operation: String { get }

}
