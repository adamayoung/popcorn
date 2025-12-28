//
//  ObservabilityFactory.swift
//  Observability
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A factory for creating observability service instances.
///
/// Use this factory to create configured observability services with a specific
/// provider implementation.
///
public final class ObservabilityFactory: Sendable {

    private let provider: any ObservabilityProviding

    ///
    /// Creates a new observability factory with the specified provider.
    ///
    /// - Parameter provider: The observability provider implementation.
    ///
    public init(provider: some ObservabilityProviding) {
        self.provider = provider
    }

    ///
    /// Creates a new observability service instance.
    ///
    /// - Returns: A service conforming to both ``Observing`` and
    ///   ``ObservabilityInitialising``.
    ///
    public func makeService() -> some Observing & ObservabilityInitialising {
        ObservabilityService(provider: provider)
    }

}
