//
//  LLMSession.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol LLMSession: Sendable {

    func respond(to prompt: String) async throws(LLMSessionError) -> String

}

public enum LLMSessionError: Error {

    case toolCallFailed(Error?)
    case generatorFailed(Error?)
    case unknown(Error? = nil)

}
