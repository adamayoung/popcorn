//
//  SpanContext.swift
//  Observability
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Synchronization

public enum SpanContext {

    /// Global provider, set once at app bootstrap. A `Mutex` (not
    /// `nonisolated(unsafe)`) so the debug-only case where SwiftUI previews build
    /// `AppServices` more than once can't tear a read against a re-`configure`.
    private static let globalProvider = Mutex<(any ObservabilityProviding)?>(nil)

    /// TaskLocal override for test isolation.
    @TaskLocal public static var localProvider: (any ObservabilityProviding)?

    /// The observability provider: the task-local override if set (tests), else
    /// the global set once at bootstrap.
    public static var provider: (any ObservabilityProviding)? {
        localProvider ?? globalProvider.withLock { $0 }
    }

    /// Sets the global provider. Call once, at app bootstrap. Tests must use
    /// `$localProvider.withValue(...)` for isolation, never this. Last-write-wins
    /// (no precondition — SwiftUI previews build `AppServices` more than once).
    static func configure(_ provider: some ObservabilityProviding) {
        globalProvider.withLock { $0 = provider }
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
