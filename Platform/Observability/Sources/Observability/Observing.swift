//
//  Observing.swift
//  Observability
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol Observing: Sendable {

    func startTransaction(name: String, operation: SpanOperation) -> Transaction

    func capture(error: any Error)

    func capture(error: any Error, extras: [String: any Sendable])

    func capture(message: String)

    func setUser(id: String?, email: String?, username: String?)

    func addBreadcrumb(category: String, message: String)

}
