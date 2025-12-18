//
//  ObservabilityProviding.swift
//  Observability
//
//  Created by Adam Young on 16/12/2025.
//

import Foundation

public protocol ObservabilityProviding: Sendable {

    func start(_ config: ObservabilityConfiguration) async throws

    func startTransaction(name: String, operation: SpanOperation) -> Transaction

    func currentSpan() -> Span?

    func capture(error: any Error)

    func capture(error: any Error, extras: [String: any Sendable])

    func capture(message: String)

    func setUser(id: String?, email: String?, username: String?)

    func addBreadcrumb(category: String, message: String)

}
