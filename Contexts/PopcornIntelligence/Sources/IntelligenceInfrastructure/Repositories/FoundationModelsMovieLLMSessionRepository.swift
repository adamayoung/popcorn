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

    private let movieProvider: any MovieProviding
    private let movieToolDataSource: any MovieToolDataSource
//    private let observability: any Observing

    init(
        movieProvider: some MovieProviding,
        movieToolDataSource: some MovieToolDataSource
//        observability: some Observing
    ) {
        self.movieProvider = movieProvider
        self.movieToolDataSource = movieToolDataSource
//        self.observability = observability
    }

    func session(forMovie movieID: Int) async throws(MovieLLMSessionRepositoryError) -> any LLMSession {
        let movie: Movie
        do {
            movie = try await movieProvider.movie(withID: movieID)
        } catch let error {
            throw MovieLLMSessionRepositoryError(error)
        }

        let tools: [any Tool] = [
            movieToolDataSource.movieDetails()
        ]

        let instructions = """
        You are a helpful movie assistant. The user is viewing the movie '\(movie.title)' \
        and wants to learn more about it. Use the available tools to answer their questions \
        about the movie's details.

        The movie ID the user is viewing is \(movie.id).
        The movie title the user is viewing is '\(movie.title)'.

        The focus of the conversation is the movie '\(movie.title)'.
        The conversation **MUST** focus on the movie '\(movie.title)'.

        Keep responses concise and focused on the information requested.

        You should have a pleasant nature and act like the TV series' director.
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

extension MovieLLMSessionRepositoryError {

    init(_ error: MovieProviderError) {
        switch error {
        case .notFound: self = .movieNotFound
        case .unauthorised: self = .unknown()
        case .unknown(let error): self = .unknown(error)
        }
    }

}
