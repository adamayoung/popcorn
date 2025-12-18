//
//  Observing.swift
//  Observability
//
//  Created by Adam Young on 16/12/2025.
//

import Foundation

public protocol Observing: Sendable {

    func startTransaction(name: String, operation: String) -> Transaction

    func capture(error: any Error)

    func capture(error: any Error, extras: [String: any Sendable])

    func capture(message: String)

    func setUser(id: String?, email: String?, username: String?)

    func addBreadcrumb(category: String, message: String)

}

extension Observing {

    public func trace<T: Sendable>(
        name: String,
        operation: String,
        _ work: @Sendable (Transaction) async throws -> T
    ) async rethrows -> T {
        let transaction = startTransaction(name: name, operation: operation)
        do {
            let result = try await SpanContext.$current.withValue(transaction) {
                try await work(transaction)
            }
            transaction.finish()
            return result
        } catch {
            transaction.setData(key: "error", value: error.localizedDescription)
            transaction.finish(status: .internalError)
            throw error
        }
    }

}
