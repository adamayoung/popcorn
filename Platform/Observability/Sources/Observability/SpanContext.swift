//
//  SpanContext.swift
//  Observability
//
//  Created by Adam Young on 17/12/2025.
//

import Foundation

public enum SpanContext {

    /// The observability provider that manages span context.
    /// Set once during app initialization in ObservabilityService.init, then only read.
    nonisolated(unsafe) public static var provider: (any ObservabilityProviding)?

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
