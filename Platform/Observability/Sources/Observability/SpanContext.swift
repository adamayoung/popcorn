//
//  SpanContext.swift
//  Observability
//
//  Created by Adam Young on 17/12/2025.
//

import Foundation

public enum SpanContext {

    @TaskLocal public static var current: (any Span)?

    public static func startChild(operation: String, description: String? = nil) -> (any Span)? {
        current?.startChild(operation: operation, description: description)
    }

    public static func trace<T: Sendable>(
        operation: String,
        description: String? = nil,
        _ work: @Sendable ((any Span)?) async throws -> T
    ) async rethrows -> T {
        guard let child = current?.startChild(operation: operation, description: description) else {
            return try await work(nil)
        }
        do {
            let result = try await $current.withValue(child) {
                try await work(child)
            }
            child.finish()
            return result
        } catch {
            child.finish(status: .internalError)
            throw error
        }
    }

}
