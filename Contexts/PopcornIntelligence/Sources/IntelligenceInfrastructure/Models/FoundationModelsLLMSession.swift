//
//  FoundationModelsLLMSession.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import FoundationModels
import IntelligenceDomain
import Observability
import OSLog

final class FoundationModelsLLMSession: IntelligenceDomain.LLMSession {

    private static let logger = Logger.intelligenceInfrastructure

    private let session: LanguageModelSession
//    private let observability: any Observing

    init(
        session: LanguageModelSession
//        observability: some Observing
    ) {
        self.session = session
//        self.observability = observability
    }

    func respond(to prompt: String) async throws(LLMSessionError) -> String {
        let response: LanguageModelSession.Response<String>
        do {
            response = try await session.respond(to: prompt)
        } catch let error as LanguageModelSession.ToolCallError {
//            observability.capture(
//                error: error,
//                extras: [
//                    "tool_name": error.tool.name,
//                    "underlying_error": error.underlyingError.localizedDescription,
//                    "message": prompt
//                ]
//            )
            Self.logger.error(
                "Tool call failed: \(error.tool.name, privacy: .public), error: \(error.localizedDescription, privacy: .public)"
            )

            throw LLMSessionError(error)
        } catch let error as LanguageModelSession.GenerationError {
//            observability.capture(
//                error: error,
//                extras: [
//                    "underlying_error": error.localizedDescription,
//                    "message": prompt
//                ]
//            )
            Self.logger.error("Response generation failed: \(error.localizedDescription)")

            throw LLMSessionError(error)
        } catch let error {
//            observability.capture(error: error)
            Self.logger.error("Session response failed: \(error.localizedDescription)")
            throw LLMSessionError(error)
        }

        return response.content.description
    }

}

extension LLMSessionError {

    init(_ error: Error?) {
        self = .unknown(error)
    }

    init(_ error: LanguageModelSession.ToolCallError?) {
        self = .toolCallFailed(error)
    }

    init(_ error: LanguageModelSession.GenerationError?) {
        self = .generatorFailed(error)
    }

}
