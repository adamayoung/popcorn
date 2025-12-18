//
//  SpanStatus.swift
//  Observability
//
//  Created by Adam Young on 17/12/2025.
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
