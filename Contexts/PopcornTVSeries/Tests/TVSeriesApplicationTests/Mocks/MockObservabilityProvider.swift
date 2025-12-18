//
//  MockObservabilityProvider.swift
//  PopcornTVSeries
//
//  Created by Adam Young on 18/12/2025.
//

import Foundation
import Observability

final class MockObservabilityProvider: ObservabilityProviding, @unchecked Sendable {

    var currentSpanStub: Span?

    func start(_ config: ObservabilityConfiguration) async throws {
        fatalError("Not needed for use case tests")
    }

    func startTransaction(name: String, operation: SpanOperation) -> Transaction {
        fatalError("Not needed for use case tests")
    }

    func currentSpan() -> Span? {
        currentSpanStub
    }

    func capture(error: any Error) {
        fatalError("Not needed for use case tests")
    }

    func capture(error: any Error, extras: [String: any Sendable]) {
        fatalError("Not needed for use case tests")
    }

    func capture(message: String) {
        fatalError("Not needed for use case tests")
    }

    func setUser(id: String?, email: String?, username: String?) {
        fatalError("Not needed for use case tests")
    }

    func addBreadcrumb(category: String, message: String) {
        fatalError("Not needed for use case tests")
    }

}
