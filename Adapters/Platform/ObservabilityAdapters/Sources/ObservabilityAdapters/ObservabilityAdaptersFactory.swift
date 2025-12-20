//
//  ObservabilityAdaptersFactory.swift
//  ObservabilityAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import Observability

public final class ObservabilityAdaptersFactory: Sendable {

    public init() {}

    public func makeObservabilityFactory() -> ObservabilityFactory {
        let provider = SentryObservabilityProvider()
        return ObservabilityFactory(provider: provider)
    }

}
