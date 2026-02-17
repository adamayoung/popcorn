//
//  MovieIntelligenceFeature.swift
//  MovieIntelligenceFeature
//
//  Copyright © 2026 Adam Young.
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
    public struct State: Equatable, Sendable {
        let movieID: Int
        var movie: IntelligenceDomain.Movie?
        var session: (any LLMSession)?
        var isThinking: Bool
        var error: LLMSessionError?
        var messages: [Message]

        public init(
            movieID: Int,
            movie: IntelligenceDomain.Movie? = nil,
            session: (any LLMSession)? = nil,
            isThinking: Bool = false,
            error: LLMSessionError? = nil,
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
        case sessionStarted(IntelligenceDomain.Movie, LLMSession)
        case sessionStartFailed(LLMSessionError)
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

                let message = Message(role: .assistant, textContent: "I couldn't respond to that. Please try again.")
                state.messages.append(message)

                return .none
            }
        }
    }

}

public extension MovieIntelligenceFeature.State {

    /// `session` is a protocol existential and cannot be meaningfully compared,
    /// so it is excluded from equality. `movie` is identified by `movieID` and
    /// does not change after session start, so it is also excluded.
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.movieID == rhs.movieID
            && lhs.isThinking == rhs.isThinking
            && lhs.error == rhs.error
            && lhs.messages == rhs.messages
    }

}

private extension MovieIntelligenceFeature {

    func handleStartSession(_ state: inout State) -> EffectOf<Self> {
        .run { [movieID = state.movieID, client] send in
            async let movieTask = client.fetchMovie(id: movieID)
            async let sessionTask = client.createSession(movieID: movieID)

            let movie: IntelligenceDomain.Movie
            let session: any LLMSession
            do {
                movie = try await movieTask
                session = try await sessionTask
            } catch let error as LLMSessionError {
                observability.capture(error: error)
                Self.logger.error("Failed to start session: \(error.localizedDescription)")
                await send(.sessionStartFailed(error))
                return
            } catch {
                let sessionError = LLMSessionError.unknown(error.localizedDescription)
                observability.capture(error: error)
                Self.logger.error("Failed to start session: \(error.localizedDescription)")
                await send(.sessionStartFailed(sessionError))
                return
            }

            await send(.sessionStarted(movie, session))
        }
    }

    func handleSendPrompt(_ state: inout State, prompt: String) -> EffectOf<Self> {
        .run { [session = state.session] send in
            guard let session else {
                Self.logger.warning("No current session")
                await send(.sendPromptFailed(.unknown("Session not available")))
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
            } catch {
                // Typed throws are erased when calling through an `any LLMSession` existential,
                // so this catch handles any unexpected errors from concrete implementations.
                let sessionError = LLMSessionError.unknown(error.localizedDescription)
                observability.capture(error: error)
                Self.logger.error("Unexpected error sending prompt: \(error.localizedDescription)")
                await send(.sendPromptFailed(sessionError))
                return
            }

            await send(.responseReceived(response))
        }
    }

}
