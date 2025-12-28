//
//  ObservabilityAdaptersFactory.swift
//  ObservabilityAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import Observability

///
/// A factory for creating observability-related adapters.
///
/// Creates adapters that bridge observability providers to the application's
/// observability layer.
///
public final class ObservabilityAdaptersFactory: Sendable {

    /// Creates an observability adapters factory.
    public init() {}

    ///
    /// Creates an observability factory with configured adapters.
    ///
    /// - Returns: A configured ``ObservabilityFactory`` instance.
    ///
    public func makeObservabilityFactory() -> ObservabilityFactory {
        let provider = SentryObservabilityProvider()
        return ObservabilityFactory(provider: provider)
    }

}
