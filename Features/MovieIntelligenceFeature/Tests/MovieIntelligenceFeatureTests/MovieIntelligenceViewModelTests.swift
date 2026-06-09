//
//  MovieIntelligenceViewModelTests.swift
//  MovieIntelligenceFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import IntelligenceDomain
@testable import MovieIntelligenceFeature
import Synchronization
import Testing

@Suite("MovieIntelligenceViewModel Tests")
struct MovieIntelligenceViewModelTests {

    @Test("startSession loads movie and session and appends the intro message")
    @MainActor
    func startSessionSuccess() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchMovie: { _ in Self.testMovie },
                createSession: { _ in FakeLLMSession(response: "I'm your movie assistant.") }
            )
        )

        await viewModel.startSession()

        #expect(viewModel.movieTitle == Self.testMovie.title)
        #expect(viewModel.messages == [Message(role: .assistant, textContent: "I'm your movie assistant.")])
        #expect(viewModel.isThinking == false)
        #expect(viewModel.error == nil)
    }

    @Test("startSession failure captures the error and appends the fallback message")
    @MainActor
    func startSessionFailure() async {
        let captured = Mutex(false)
        let error = LLMSessionError.unknown("Failed to start session")
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchMovie: { _ in Self.testMovie },
                createSession: { _ in throw error },
                captureError: { _ in captured.withLock { $0 = true } }
            )
        )

        await viewModel.startSession()

        #expect(captured.withLock { $0 } == true)
        #expect(viewModel.error == error)
        #expect(viewModel.messages == [
            Message(role: .assistant, textContent: "There was a problem and I can't help you.")
        ])
        #expect(viewModel.isThinking == false)
    }

    @Test("startSession is idempotent once a session exists")
    @MainActor
    func startSessionIdempotent() async {
        let createCount = Mutex(0)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchMovie: { _ in Self.testMovie },
                createSession: { _ in
                    createCount.withLock { $0 += 1 }
                    return FakeLLMSession(response: "Hi")
                }
            )
        )

        await viewModel.startSession()
        await viewModel.startSession()

        #expect(createCount.withLock { $0 } == 1)
    }

    @Test("sendPrompt appends the user prompt and the assistant response")
    @MainActor
    func sendPromptSuccess() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchMovie: { _ in Self.testMovie },
                createSession: { _ in FakeLLMSession(response: "Intro") }
            )
        )
        await viewModel.startSession()

        await viewModel.sendPrompt("Tell me about this movie")

        #expect(viewModel.messages == [
            Message(role: .assistant, textContent: "Intro"),
            Message(role: .user, textContent: "Tell me about this movie"),
            Message(role: .assistant, textContent: "Intro")
        ])
        #expect(viewModel.isThinking == false)
        #expect(viewModel.error == nil)
    }

    @Test("sendPrompt failure captures the error and appends the fallback message")
    @MainActor
    func sendPromptFailure() async {
        let captured = Mutex(false)
        let error = LLMSessionError.guardrailViolation(message: "Content not allowed")
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchMovie: { _ in Self.testMovie },
                createSession: { _ in FakeLLMSession(error: error) },
                captureError: { _ in captured.withLock { $0 = true } }
            )
        )
        await viewModel.startSession()
        captured.withLock { $0 = false }

        await viewModel.sendPrompt("Tell me about this movie")

        #expect(captured.withLock { $0 } == true)
        #expect(viewModel.error == error)
        #expect(viewModel.messages.last == Message(
            role: .assistant,
            textContent: "I couldn't respond to that. Please try again."
        ))
        #expect(viewModel.isThinking == false)
    }

}

// MARK: - Fake Session

private struct FakeLLMSession: LLMSession {

    var response: String = ""
    var error: LLMSessionError?

    func respond(to prompt: String) async throws(LLMSessionError) -> String {
        if let error {
            throw error
        }

        return response
    }

}

// MARK: - Factories

extension MovieIntelligenceViewModelTests {

    @MainActor
    static func makeViewModel(
        dependencies: MovieIntelligenceDependencies = stubDependencies()
    ) -> MovieIntelligenceViewModel {
        MovieIntelligenceViewModel(movieID: 1, dependencies: dependencies)
    }

    static func stubDependencies(
        fetchMovie: @escaping @Sendable (Int) async throws -> IntelligenceDomain.Movie = { _ in testMovie },
        createSession: @escaping @Sendable (Int) async throws -> any LLMSession = { _ in FakeLLMSession() },
        captureError: @escaping @Sendable (any Error) -> Void = { _ in }
    ) -> MovieIntelligenceDependencies {
        MovieIntelligenceDependencies(
            fetchMovie: fetchMovie,
            createSession: createSession,
            captureError: captureError
        )
    }

}

// MARK: - Test Data

extension MovieIntelligenceViewModelTests {

    static let testMovie = IntelligenceDomain.Movie(
        id: 1,
        title: "Fight Club",
        overview: "An insomniac office worker and a soap maker form an underground fight club."
    )

}
