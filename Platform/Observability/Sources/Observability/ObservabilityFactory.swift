//
//  ObservabilityFactory.swift
//  Observability
//
//  Created by Adam Young on 16/12/2025.
//

import Foundation

public final class ObservabilityFactory: Sendable {

    private let provider: any ObservabilityProviding

    public init(provider: some ObservabilityProviding) {
        self.provider = provider
    }

    public func makeService() -> some Observability & ObservabilityInitialising {
        ObservabilityService(provider: provider)
    }

}
