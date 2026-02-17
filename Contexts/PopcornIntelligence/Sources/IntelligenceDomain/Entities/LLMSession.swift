//
//  LLMSession.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

/// Defines the ``LLMSession`` contract.
public protocol LLMSession: Sendable {

    func respond(to prompt: String) async throws(LLMSessionError) -> String

}

/// Represents the ``LLMSessionError`` values.
public enum LLMSessionError: LocalizedError {

    case toolCallFailed(Error?)

    case exceededContextWindowSize(message: String?)
    case assetsUnavailable(message: String?)
    case guardrailViolation(message: String?)
    case unsupportedGuide(message: String?)
    case unsupportedLanguageOrLocale(message: String?)
    case decodingFailure(message: String?)
    case rateLimited(message: String?)
    case concurrentRequests(message: String?)
    case refusal(message: String?)

    case unknown(Error? = nil)

    public var localizedDescription: String {
        switch self {
        case .toolCallFailed(let error):
            "Tool call failed: \(error?.localizedDescription ?? "Unknown error")"
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
        case .unknown(let error):
            "Unknown error: \(error?.localizedDescription ?? "Unknown")"
        }
    }

}
