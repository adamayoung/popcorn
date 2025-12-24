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

    @Dependency(\.movieIntelligenceClient) private var movieIntelligenceClient
    @Dependency(\.observability) private var observability
    @Dependency(\.dismiss) private var dismiss

    @ObservableState
    public struct State: Sendable {
        let movieID: Int
        var session: LLMSession?
        var isThinking: Bool
        var error: Error?
        var messages: [Message]

        public init(
            movieID: Int,
            session: LLMSession? = nil,
            isThinking: Bool = false,
            error: Error? = nil,
            messages: [Message] = []
        ) {
            self.movieID = movieID
            self.session = session
            self.isThinking = isThinking
            self.error = error
            self.messages = messages
        }
    }

    public enum Action {
        case startSession
        case sessionStarted(LLMSession)
        case sessionStartFailed(Error)
        case sendPrompt(String)
        case responseReceived(String)
        case sendPromptFailed(Error)
        case close
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .startSession:
                return handleStartSession(&state)

            case .sessionStarted(let session):
                state.session = session
                return handleSendPrompt(&state, prompt: "Introduce yourself and what you're for")

            case .sessionStartFailed(let error):
                state.error = error
                return .none

            case .sendPrompt(let prompt):
                state.isThinking = true
                let message = Message(role: .user, textContent: prompt)
                state.messages.append(message)

                return handleSendPrompt(&state, prompt: prompt)

            case .responseReceived(let response):
                let message = Message(role: .assistant, textContent: response)
                state.messages.append(message)
                state.isThinking = false
                return .none

            case .sendPromptFailed(let error):
                state.isThinking = false
                state.error = error
                return .none

            case .close:
                return .run { _ in
                    await dismiss()
                }
            }
        }
    }

}

private extension MovieIntelligenceFeature {

    func handleStartSession(_ state: inout State) -> EffectOf<Self> {
        .run { [state] send in
            let session: LLMSession
            do {
                session = try await movieIntelligenceClient.createSession(movieID: state.movieID)
            } catch let error {
                await send(.sessionStartFailed(error))
                return
            }

            await send(.sessionStarted(session))
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
            } catch let error {
                await send(.sendPromptFailed(error))
                return
            }

            await send(.responseReceived(response))
        }
    }

}
