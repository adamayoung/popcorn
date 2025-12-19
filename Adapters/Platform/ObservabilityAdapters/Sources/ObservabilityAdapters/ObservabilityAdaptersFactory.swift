//
//  ObservabilityAdaptersFactory.swift
//  ObservabilityAdapters
//
//  Created by Adam Young on 16/12/2025.
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
