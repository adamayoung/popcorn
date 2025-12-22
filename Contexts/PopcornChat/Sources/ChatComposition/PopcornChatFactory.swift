//
//  PopcornChatFactory.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ChatApplication
import ChatDomain
import ChatInfrastructure
import Foundation
import Observability

///
/// Main factory for the PopcornChat context
///
public struct PopcornChatFactory {

    private let infrastructureFactory: ChatInfrastructureFactory
    private let applicationFactory: ChatApplicationFactory

    ///
    /// Creates a new PopcornChat factory
    ///
    /// - Parameters:
    ///   - movieToolsProvider: Provider for movie chat tools
    ///   - tvSeriesToolsProvider: Provider for TV series chat tools
    ///   - observability: Observability service for logging and error tracking
    ///
    public init(
        movieToolsProvider: any MovieChatToolsProviding,
        tvSeriesToolsProvider: any TVSeriesChatToolsProviding,
        observability: some Observing
    ) {
        self.infrastructureFactory = ChatInfrastructureFactory(
            observability: observability
        )
        self.applicationFactory = ChatApplicationFactory(
            movieToolsProvider: movieToolsProvider,
            tvSeriesToolsProvider: tvSeriesToolsProvider,
            chatSessionFactory: infrastructureFactory.makeChatSessionFactory()
        )
    }

    ///
    /// Creates a use case for creating movie chat sessions
    ///
    /// - Returns: A use case for creating movie chat sessions
    ///
    public func makeCreateMovieChatSessionUseCase() -> any CreateMovieChatSessionUseCase {
        applicationFactory.makeCreateMovieChatSessionUseCase()
    }

    ///
    /// Creates a use case for creating TV series chat sessions
    ///
    /// - Returns: A use case for creating TV series chat sessions
    ///
    public func makeCreateTVSeriesChatSessionUseCase() -> any CreateTVSeriesChatSessionUseCase {
        applicationFactory.makeCreateTVSeriesChatSessionUseCase()
    }

}
