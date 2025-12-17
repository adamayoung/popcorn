//
//  ObservabilityAdaptersFactory.swift
//  ObservabilityAdapters
//
//  Created by Adam Young on 16/12/2025.
//

import Foundation
import Observability
import OSLog

public final class ObservabilityAdaptersFactory: Sendable {

    private static let logger = Logger(
        subsystem: "ObservabilityAdapters",
        category: "ObservabilityAdaptersFactory"
    )

    public init() {}

    public func makeObservabilityFactory() -> ObservabilityFactory {
        let provider = SentryObservabilityProvider()
        return ObservabilityFactory(provider: provider)
    }

}
