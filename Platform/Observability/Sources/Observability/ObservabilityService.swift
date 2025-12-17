//
//  ObservabilityService.swift
//  Observability
//
//  Created by Adam Young on 16/12/2025.
//

import Foundation
import OSLog

struct ObservabilityService: Observability, ObservabilityInitialising {

    private static let logger = Logger(
        subsystem: "Observability",
        category: "ObservabilityService"
    )

    private let provider: any ObservabilityProviding

    init(provider: some ObservabilityProviding) {
        self.provider = provider
    }

    func start(_ config: ObservabilityConfiguration) async throws {
        try await provider.start(config)

        Self.logger.info(
            "Observability initialised: (environment: \(config.environment.rawValue), debug: \(config.isDebug))"
        )
    }

    func startTransaction(name: String, operation: String) -> Transaction {
        provider.startTransaction(name: name, operation: operation)
    }

    func capture(error: any Error) {
        provider.capture(error: error)
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
