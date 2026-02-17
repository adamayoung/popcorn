//
//  MovieIntelligenceFeatureTests.swift
//  MovieIntelligenceFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import IntelligenceDomain
@testable import MovieIntelligenceFeature
import Testing

@Suite("MovieIntelligenceFeature Tests")
struct MovieIntelligenceFeatureTests {

    @Test("startSession sets isThinking to true")
    @MainActor
    func startSessionSetsIsThinking() async {
        let store = TestStore(initialState: MovieIntelligenceFeature.State(movieID: 1)) {
            MovieIntelligenceFeature()
        } withDependencies: {
            $0.movieIntelligenceClient.fetchMovie = { _ in Movie(id: 1, title: "Alien") }
            $0.movieIntelligenceClient.createSession = { _ in MockLLMSession() }
            $0.observability = .noop
        }
        store.exhaustivity = .off

        await store.send(.startSession) {
            $0.isThinking = true
        }
    }

    @Test("sessionStartFailed sets error and appends fallback message")
    @MainActor
    func sessionStartFailedSetsErrorAndMessage() async {
        let store = TestStore(initialState: MovieIntelligenceFeature.State(movieID: 1)) {
            MovieIntelligenceFeature()
        } withDependencies: {
            $0.observability = .noop
        }

        struct FetchError: Error {}
        let error = FetchError()

        await store.send(.sessionStartFailed(error)) {
            $0.isThinking = false
            $0.error = error
            $0.messages = [Message(role: .assistant, textContent: "There was a problem and I can't help you.")]
        }
    }

    @Test("responseReceived sets isThinking false and appends message")
    @MainActor
    func responseReceivedAppendsMessage() async {
        let store = TestStore(initialState: MovieIntelligenceFeature.State(movieID: 1)) {
            MovieIntelligenceFeature()
        } withDependencies: {
            $0.observability = .noop
        }

        await store.send(.responseReceived("Hello!")) {
            $0.isThinking = false
            $0.messages = [Message(role: .assistant, textContent: "Hello!")]
        }
    }

    @Test("sendPrompt appends user message and sets isThinking")
    @MainActor
    func sendPromptAppendsUserMessage() async {
        let session = MockLLMSession(response: "I am your movie assistant.")
        let store = TestStore(
            initialState: MovieIntelligenceFeature.State(movieID: 1, session: session)
        ) {
            MovieIntelligenceFeature()
        } withDependencies: {
            $0.observability = .noop
        }
        store.exhaustivity = .off

        await store.send(.sendPrompt("Tell me about this movie")) {
            $0.isThinking = true
            $0.messages = [Message(role: .user, textContent: "Tell me about this movie")]
        }
    }

    @Test("sendPromptFailed sets error and appends assistant message")
    @MainActor
    func sendPromptFailedSetsErrorAndMessage() async {
        let store = TestStore(initialState: MovieIntelligenceFeature.State(movieID: 1)) {
            MovieIntelligenceFeature()
        } withDependencies: {
            $0.observability = .noop
        }

        let error = LLMSessionError.guardrailViolation(message: "Content not allowed")

        await store.send(.sendPromptFailed(error)) {
            $0.isThinking = false
            $0.error = error
            $0.messages = [Message(role: .assistant, textContent: error.localizedDescription)]
        }
    }

}

// MARK: - MockLLMSession

private struct MockLLMSession: LLMSession {

    var response: String = ""

    func respond(to prompt: String) async throws(LLMSessionError) -> String {
        response
    }

}
