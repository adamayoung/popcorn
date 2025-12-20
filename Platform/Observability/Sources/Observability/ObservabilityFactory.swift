//
//  ObservabilityFactory.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
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
