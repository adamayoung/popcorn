//
//  FoundationModelsMovieLLMSessionRepository.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import FoundationModels
import IntelligenceDomain
import Observability
import OSLog

// swiftlint:disable:next type_name
final class FoundationModelsMovieLLMSessionRepository: MovieLLMSessionRepository {

    private typealias FMLanguageModelSession = FoundationModels.LanguageModelSession

    private static let logger = Logger.intelligenceInfrastructure

    private let movieToolDataSource: any MovieToolDataSource
//    private let observability: any Observing

    init(
        movieToolDataSource: some MovieToolDataSource
//        observability: some Observing
    ) {
        self.movieToolDataSource = movieToolDataSource
//        self.observability = observability
    }

    func session(forMovie movieID: Int) async throws(MovieLLMSessionRepositoryError) -> any LLMSession {
        let tools: [any Tool] = [
            movieToolDataSource.movieDetails()
        ]

        let instructions = """
        You are a helpful movie assistant. The user is viewing a specific movie and \
        wants to learn more about it. Use the available tools to answer their questions \
        about the movie's details, images, and recommendations.

        The movie ID the user is viewing is \(movieID).

        Keep responses concise and focused on the information requested.

        You should have a fun and play nature.
        """

        let session = FMLanguageModelSession(
            tools: tools,
            instructions: instructions
        )

        let llmSession = FoundationModelsLLMSession(
            session: session
//            observability: observability
        )

        return llmSession
    }

}
