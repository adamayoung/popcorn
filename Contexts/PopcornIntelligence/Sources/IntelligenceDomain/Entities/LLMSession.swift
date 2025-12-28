//
//  LLMSession.swift
//  PopcornIntelligence
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A protocol that defines an interface for interacting with a language model session.
///
/// Conforming types provide the ability to send prompts to a language model and receive
/// generated text responses. Sessions are designed to be thread-safe and can be used
/// concurrently from multiple contexts.
///
public protocol LLMSession: Sendable {

    ///
    /// Sends a prompt to the language model and returns the generated response.
    ///
    /// - Parameter prompt: The text prompt to send to the language model.
    /// - Returns: The generated text response from the language model.
    /// - Throws: ``LLMSessionError`` if the response generation fails.
    ///
    func respond(to prompt: String) async throws(LLMSessionError) -> String

}

///
/// Errors that can occur during language model session operations.
///
/// These errors represent failures that may happen when interacting with the
/// underlying language model, including tool execution failures and generation errors.
///
public enum LLMSessionError: Error {

    /// A tool call within the session failed to execute.
    case toolCallFailed(Error?)

    /// The language model failed to generate a response.
    case generatorFailed(Error?)

    /// An unknown error occurred during the session.
    case unknown(Error? = nil)

}
