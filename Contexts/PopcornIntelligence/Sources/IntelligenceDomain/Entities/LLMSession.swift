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
public enum LLMSessionError: Error {

    case toolCallFailed(Error?)
    case generatorFailed(Error?)
    case unknown(Error? = nil)

}
