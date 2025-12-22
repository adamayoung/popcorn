//
//  DefaultCreateTVSeriesChatSessionUseCase.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ChatDomain
import Foundation

final class DefaultCreateTVSeriesChatSessionUseCase: CreateTVSeriesChatSessionUseCase {

    private let tvSeriesToolsProvider: any TVSeriesChatToolsProviding
    private let chatSessionFactory: any ChatSessionFactory

    init(
        tvSeriesToolsProvider: any TVSeriesChatToolsProviding,
        chatSessionFactory: any ChatSessionFactory
    ) {
        self.tvSeriesToolsProvider = tvSeriesToolsProvider
        self.chatSessionFactory = chatSessionFactory
    }

    func execute(tvSeriesID: Int) async throws(CreateTVSeriesChatSessionError) -> any ChatSessionManaging {
        let tools = tvSeriesToolsProvider.tools(for: tvSeriesID)

        let instructions = """
        You are a helpful TV series assistant. The user is viewing a specific TV series and \
        wants to learn more about it. Use the available tools to answer their questions \
        about the series details and images.

        Keep responses concise and focused on the information requested.
        """

        return chatSessionFactory.makeSession(
            tools: tools,
            instructions: instructions
        )
    }

}
