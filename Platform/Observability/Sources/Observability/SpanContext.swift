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

}
