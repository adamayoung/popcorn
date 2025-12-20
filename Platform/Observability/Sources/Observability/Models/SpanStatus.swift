//
//  SpanStatus.swift
//  Observability
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public enum SpanStatus: String, Sendable {
    case ok
    case cancelled
    case unknownError
    case invalidArgument
    case deadlineExceeded
    case notFound
    case permissionDenied
    case resourceExhausted
    case unimplemented
    case unavailable
    case internalError
}
