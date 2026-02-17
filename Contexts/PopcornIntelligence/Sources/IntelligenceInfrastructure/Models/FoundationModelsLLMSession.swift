//
//  FoundationModelsLLMSession.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import FoundationModels
import IntelligenceDomain
import OSLog

final class FoundationModelsLLMSession: IntelligenceDomain.LLMSession {

    private static let logger = Logger.intelligenceInfrastructure

    private let session: LanguageModelSession

    init(session: LanguageModelSession) {
        self.session = session
    }

    func respond(to prompt: String) async throws(LLMSessionError) -> String {
        let response: LanguageModelSession.Response<String>
        do {
            response = try await session.respond(to: prompt)
        } catch let error as LanguageModelSession.ToolCallError {
            Self.logger.error(
                "Tool call failed: \(error.tool.name, privacy: .public), error: \(error.localizedDescription, privacy: .public)"
            )
            throw LLMSessionError(error)
        } catch let error as LanguageModelSession.GenerationError {
            Self.logger.error("Response generation failed: \(error.localizedDescription)")
            throw LLMSessionError(error)
        } catch let error {
            Self.logger.error("Session response failed: \(error.localizedDescription)")
            throw LLMSessionError(error)
        }

        return response.content.description
    }

}

extension LLMSessionError {

    init(_ error: Error) {
        self = .unknown(error.localizedDescription)
    }

    init(_ error: LanguageModelSession.ToolCallError) {
        self = .toolCallFailed(error.localizedDescription)
    }

    init(_ error: LanguageModelSession.GenerationError) {
        switch error {
        case .exceededContextWindowSize(let context):
            self = .exceededContextWindowSize(message: context.debugDescription)
        case .assetsUnavailable(let context):
            self = .assetsUnavailable(message: context.debugDescription)
        case .guardrailViolation(let context):
            self = .guardrailViolation(message: context.debugDescription)
        case .unsupportedGuide(let context):
            self = .unsupportedGuide(message: context.debugDescription)
        case .unsupportedLanguageOrLocale(let context):
            self = .unsupportedLanguageOrLocale(message: context.debugDescription)
        case .decodingFailure(let context):
            self = .decodingFailure(message: context.debugDescription)
        case .rateLimited(let context):
            self = .rateLimited(message: context.debugDescription)
        case .concurrentRequests(let context):
            self = .concurrentRequests(message: context.debugDescription)
        case .refusal(_, let context):
            self = .refusal(message: context.debugDescription)
        @unknown default:
            self = .unknown(error.localizedDescription)
        }
    }

}
