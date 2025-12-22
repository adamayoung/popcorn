//
//  DefaultCreateMovieChatSessionUseCase.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ChatDomain
import Foundation

final class DefaultCreateMovieChatSessionUseCase: CreateMovieChatSessionUseCase {

    private let movieToolsProvider: any MovieChatToolsProviding
    private let chatSessionFactory: any ChatSessionFactory

    init(
        movieToolsProvider: any MovieChatToolsProviding,
        chatSessionFactory: any ChatSessionFactory
    ) {
        self.movieToolsProvider = movieToolsProvider
        self.chatSessionFactory = chatSessionFactory
    }

    func execute(movieID: Int) async throws(CreateMovieChatSessionError) -> any ChatSessionManaging {
        let tools = movieToolsProvider.tools(for: movieID)

        let instructions = """
        You are a helpful movie assistant. The user is viewing a specific movie and \
        wants to learn more about it. Use the available tools to answer their questions \
        about the movie's details, images, and recommendations.

        Keep responses concise and focused on the information requested.
        """

        return chatSessionFactory.makeSession(
            tools: tools,
            instructions: instructions
        )
    }

}
