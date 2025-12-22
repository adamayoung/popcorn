//
//  FoundationModelsChatSession.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ChatDomain
import Foundation
import FoundationModels
import Observability
import OSLog

final class FoundationModelsChatSession: ChatSessionManaging {

    private static let logger = Logger.chatInfrastructure

    private let session: LanguageModelSession
    private let observability: any Observing

    init(
        tools: [any Sendable],
        instructions: String,
        observability: some Observing
    ) {
        // Cast tools to FoundationModels Tool protocol
        let fmTools = tools.compactMap { $0 as? any Tool }

        self.session = LanguageModelSession(
            tools: fmTools,
            instructions: instructions
        )
        self.observability = observability
    }

    func send(message: String) async throws(ChatSessionManagerError) -> String {
        let response: LanguageModelSession.Response<String>

        do {
            response = try await session.respond(to: message)
        } catch let error as LanguageModelSession.ToolCallError {
            observability.capture(
                error: error,
                extras: [
                    "tool_name": error.tool.name,
                    "underlying_error": error.underlyingError.localizedDescription,
                    "message": message
                ]
            )
            Self.logger.error(
                "Tool call failed: \(error.tool.name, privacy: .public), error: \(error.localizedDescription, privacy: .public)"
            )
            throw .toolCallFailed(error)
        } catch {
            observability.capture(
                error: error,
                extras: ["message": message]
            )
            Self.logger.error(
                "Chat session failed: \(error.localizedDescription, privacy: .public)"
            )
            throw .sessionFailed(error)
        }

        return response.content.description
    }

}
