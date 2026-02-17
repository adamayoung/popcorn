//
//  ObservabilityFactory.swift
//  Observability
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public final class ObservabilityFactory: Sendable {

    private let provider: any ObservabilityProviding

    public init(provider: some ObservabilityProviding) {
        self.provider = provider
    }

    public func makeService() -> some Observing & ObservabilityInitialising {
        ObservabilityService(provider: provider)
    }

}
