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
            return "Tool call failed: \(error?.localizedDescription ?? "Unknown error")"
        case .exceededContextWindowSize(let message):
            return "Exceeded context window size: \(message ?? "Unknown")"
        case .assetsUnavailable(let message):
            return "Assets unavailable: \(message ?? "Unknown")"
        case .guardrailViolation(let message):
            return "Guardrail violation: \(message ?? "Unknown")"
        case .unsupportedGuide(let message):
            return "Unsupported guide: \(message ?? "Unknown")"
        case .unsupportedLanguageOrLocale(let message):
            return "Unsupported language or locale: \(message ?? "Unknown")"
        case .decodingFailure(let message):
            return "Decoding failure: \(message ?? "Unknown")"
        case .rateLimited(let message):
            return "Rate limited: \(message ?? "Unknown")"
        case .concurrentRequests(let message):
            return "Concurrent requests: \(message ?? "Unknown")"
        case .refusal(let message):
            return "Refusal: \(message ?? "Unknown")"
        case .unknown(let error):
            return "Unknown error: \(error?.localizedDescription ?? "Unknown")"
        }
    }

}
