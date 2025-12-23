//
//  ChatApplicationFactory.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ChatDomain
import Foundation

package final class ChatApplicationFactory {

    private let movieToolsProvider: any MovieChatToolsProviding
    private let tvSeriesToolsProvider: any TVSeriesChatToolsProviding
    private let chatSessionFactory: any ChatSessionFactory

    package init(
        movieToolsProvider: any MovieChatToolsProviding,
        tvSeriesToolsProvider: any TVSeriesChatToolsProviding,
        chatSessionFactory: any ChatSessionFactory
    ) {
        self.movieToolsProvider = movieToolsProvider
        self.tvSeriesToolsProvider = tvSeriesToolsProvider
        self.chatSessionFactory = chatSessionFactory
    }

    package func makeCreateMovieChatSessionUseCase() -> any CreateMovieChatSessionUseCase {
        DefaultCreateMovieChatSessionUseCase(
            movieToolsProvider: movieToolsProvider,
            chatSessionFactory: chatSessionFactory
        )
    }

    package func makeCreateTVSeriesChatSessionUseCase() -> any CreateTVSeriesChatSessionUseCase {
        DefaultCreateTVSeriesChatSessionUseCase(
            tvSeriesToolsProvider: tvSeriesToolsProvider,
            chatSessionFactory: chatSessionFactory
        )
    }

}
