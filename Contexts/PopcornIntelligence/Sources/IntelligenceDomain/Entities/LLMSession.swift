//
//  LLMSession.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public protocol LLMSession: Sendable {

    func respond(to prompt: String) async throws(LLMSessionError) -> String

}

public enum LLMSessionError: LocalizedError, Equatable, Sendable {

    case toolCallFailed(String?)

    case exceededContextWindowSize(message: String?)
    case assetsUnavailable(message: String?)
    case guardrailViolation(message: String?)
    case unsupportedGuide(message: String?)
    case unsupportedLanguageOrLocale(message: String?)
    case decodingFailure(message: String?)
    case rateLimited(message: String?)
    case concurrentRequests(message: String?)
    case refusal(message: String?)

    case unknown(String? = nil)

    public var errorDescription: String? {
        switch self {
        case .toolCallFailed(let message):
            "Tool call failed: \(message ?? "Unknown error")"
        case .exceededContextWindowSize(let message):
            "Exceeded context window size: \(message ?? "Unknown")"
        case .assetsUnavailable(let message):
            "Assets unavailable: \(message ?? "Unknown")"
        case .guardrailViolation(let message):
            "Guardrail violation: \(message ?? "Unknown")"
        case .unsupportedGuide(let message):
            "Unsupported guide: \(message ?? "Unknown")"
        case .unsupportedLanguageOrLocale(let message):
            "Unsupported language or locale: \(message ?? "Unknown")"
        case .decodingFailure(let message):
            "Decoding failure: \(message ?? "Unknown")"
        case .rateLimited(let message):
            "Rate limited: \(message ?? "Unknown")"
        case .concurrentRequests(let message):
            "Concurrent requests: \(message ?? "Unknown")"
        case .refusal(let message):
            "Refusal: \(message ?? "Unknown")"
        case .unknown(let message):
            "Unknown error: \(message ?? "Unknown")"
        }
    }

}
