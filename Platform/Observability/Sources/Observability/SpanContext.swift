//
//  SpanContext.swift
//  Observability
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public enum SpanContext {

    /// Global provider for production use.
    private nonisolated(unsafe) static var globalProvider: (any ObservabilityProviding)?

    /// TaskLocal override for test isolation.
    @TaskLocal public static var localProvider: (any ObservabilityProviding)?

    /// The observability provider: the task-local override if set (tests), else
    /// the global set once at bootstrap.
    public static var provider: (any ObservabilityProviding)? {
        localProvider ?? globalProvider
    }

    /// Sets the global provider. Call once, at app bootstrap. Tests must use
    /// `$localProvider.withValue(...)` for isolation, never this. Last-write-wins
    /// (no precondition — SwiftUI previews build `AppServices` more than once).
    static func configure(_ provider: some ObservabilityProviding) {
        globalProvider = provider
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
