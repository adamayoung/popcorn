//
//  ObservabilityInitialising.swift
//  Observability
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A protocol for initializing observability services.
///
/// Implement this protocol to provide startup configuration for error tracking
/// and monitoring providers.
///
public protocol ObservabilityInitialising: Sendable {

    ///
    /// Starts the observability service with the specified configuration.
    ///
    /// - Parameter config: The configuration containing DSN, environment,
    ///   and user identification.
    /// - Throws: An error if the service fails to initialize.
    ///
    func start(_ config: ObservabilityConfiguration) async throws

}
