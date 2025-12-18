//
//  SpanContext.swift
//  Observability
//
//  Created by Adam Young on 17/12/2025.
//

import Foundation

public enum SpanContext {

    /// Global provider for production use.
    nonisolated(unsafe) private static var globalProvider: (any ObservabilityProviding)?

    /// TaskLocal override for test isolation.
    @TaskLocal public static var localProvider: (any ObservabilityProviding)?

    /// The observability provider that manages span context.
    ///
    /// In production, uses the global provider set via assignment.
    /// In tests, can be overridden using $_localProvider.withValue() for isolation.
    public static var provider: (any ObservabilityProviding)? {
        get { localProvider ?? globalProvider }
        set { globalProvider = newValue }
    }

    public static var current: (any Span)? {
        provider?.currentSpan()
    }

    public static func startChild(
        operation: SpanOperation,
        description: String? = nil
    ) -> (any Span)? {
        current?.startChild(operation: operation, description: description)
    }

}
