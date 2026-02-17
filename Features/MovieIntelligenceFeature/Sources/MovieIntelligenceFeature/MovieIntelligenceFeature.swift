//
//  MovieIntelligenceFeature.swift
//  MovieIntelligenceFeature
//
//  Copyright © 2025 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import DesignSystem
import Foundation
import IntelligenceDomain
import Observability
import OSLog

@Reducer
public struct MovieIntelligenceFeature: Sendable {

    private static let logger = Logger.movieIntelligence

    @Dependency(\.movieIntelligenceClient) private var client
    @Dependency(\.observability) private var observability

    @ObservableState
    public struct State: Sendable {
        let movieID: Int
        var movie: Movie?
        var session: (any LLMSession)?
        var isThinking: Bool
        var error: Error?
        var messages: [Message]

        public init(
            movieID: Int,
            movie: Movie? = nil,
            session: (any LLMSession)? = nil,
            isThinking: Bool = false,
            error: Error? = nil,
            messages: [Message] = []
        ) {
            self.movieID = movieID
            self.movie = movie
            self.session = session
            self.isThinking = isThinking
            self.error = error
            self.messages = messages
        }
    }

    public enum Action {
        case startSession
        case sessionStarted(Movie, LLMSession)
        case sessionStartFailed(Error)
        case sendPrompt(String)
        case responseReceived(String)
        case sendPromptFailed(LLMSessionError)
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .startSession:
                state.isThinking = true
                return handleStartSession(&state)

            case .sessionStarted(let movie, let session):
                state.movie = movie
                state.session = session
                return handleSendPrompt(&state, prompt: "Introduce yourself and what you're for")

            case .sessionStartFailed(let error):
                state.isThinking = false

                let message = Message(role: .assistant, textContent: "There was a problem and I can't help you.")
                state.messages.append(message)

                state.error = error
                return .none

            case .sendPrompt(let prompt):
                let message = Message(role: .user, textContent: prompt)
                state.messages.append(message)

                state.isThinking = true

                return handleSendPrompt(&state, prompt: prompt)

            case .responseReceived(let response):
                state.isThinking = false

                let message = Message(role: .assistant, textContent: response)
                state.messages.append(message)

                return .none

            case .sendPromptFailed(let error):
                state.isThinking = false
                state.error = error

                let message = Message(role: .assistant, textContent: error.localizedDescription)
                state.messages.append(message)

                return .none
            }
        }
    }

}

private extension MovieIntelligenceFeature {

    func handleStartSession(_ state: inout State) -> EffectOf<Self> {
        .run { [state, client] send in
            async let movieTask = client.fetchMovie(id: state.movieID)
            async let sessionTask = client.createSession(movieID: state.movieID)

            let movie: Movie
            let session: LLMSession
            do {
                movie = try await movieTask
                session = try await sessionTask
            } catch let error {
                observability.capture(error: error)
                Self.logger.error("Failed to start session: \(error.localizedDescription)")
                await send(.sessionStartFailed(error))
                return
            }

            await send(.sessionStarted(movie, session))
        }
    }

    func handleSendPrompt(_ state: inout State, prompt: String) -> EffectOf<Self> {
        .run { [state] send in
            guard let session = state.session else {
                Self.logger.warning("No current session")
                return
            }

            let response: String
            do {
                response = try await session.respond(to: prompt)
            } catch let error as LLMSessionError {
                observability.capture(error: error)
                Self.logger.error("Failed to send prompt: \(error.localizedDescription)")
                await send(.sendPromptFailed(error))
                return
            }

            await send(.responseReceived(response))
        }
    }

}
