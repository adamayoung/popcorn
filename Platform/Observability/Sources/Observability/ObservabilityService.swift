//
//  ObservabilityService.swift
//  Observability
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import OSLog

struct ObservabilityService: Observing, ObservabilityInitialising {

    private static let logger = Logger.observability

    private let provider: any ObservabilityProviding

    init(provider: some ObservabilityProviding) {
        self.provider = provider
        SpanContext.provider = provider
    }

    func start(_ config: ObservabilityConfiguration) async throws {
        try await provider.start(config)
    }

    func startTransaction(name: String, operation: SpanOperation) -> Transaction {
        provider.startTransaction(name: name, operation: operation)
    }

    func capture(error: any Error) {
        provider.capture(error: error)
    }

    func capture(error: any Error, extras: [String: any Sendable]) {
        provider.capture(error: error, extras: extras)
    }

    func capture(message: String) {
        provider.capture(message: message)
    }

    func setUser(id: String?, email: String?, username: String?) {
        provider.setUser(id: id, email: email, username: username)
    }

    func addBreadcrumb(category: String, message: String) {
        provider.addBreadcrumb(category: category, message: message)
    }

}
