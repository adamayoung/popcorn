//
//  TVSeriesIntelligenceViewModelTests.swift
//  TVSeriesIntelligenceFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import protocol IntelligenceDomain.LLMSession
import enum IntelligenceDomain.LLMSessionError
import Synchronization
import Testing
@testable import TVSeriesIntelligenceFeature

// Only LLMSession/LLMSessionError are imported from IntelligenceDomain (not its
// TVSeries) so the feature's own `TVSeries` display model stays unambiguous.

@Suite("TVSeriesIntelligenceViewModel Tests")
struct TVSeriesIntelligenceViewModelTests {

    // MARK: - startSession

    @Test("startSession fetches the series, starts a session and sends the intro prompt")
    @MainActor
    func startSessionSuccessSendsIntro() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTVSeries: { id in TVSeries(id: id, name: "Stranger Things", tagline: "Tagline") },
                createSession: { _ in FakeLLMSession(response: "Hello, I'm your assistant.") }
            )
        )

        await viewModel.startSession()

        #expect(viewModel.tvSeriesName == "Stranger Things")
        #expect(viewModel.tvSeriesTagline == "Tagline")
        #expect(viewModel.isThinking == false)
        #expect(viewModel.error == nil)
        // The intro prompt produces a single assistant message with no user message.
        #expect(viewModel.messages.count == 1)
        #expect(Self.isAssistant(viewModel.messages.first))
        #expect(Self.message(viewModel.messages.first, hasText: "Hello, I'm your assistant."))
    }

    @Test("startSession is idempotent once a session exists")
    @MainActor
    func startSessionIsIdempotent() async {
        let createCount = Mutex(0)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
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

    @Test("startSession failure captures the error and appends a fallback message")
    @MainActor
    func startSessionFailureCapturesErrorAndAppendsFallback() async {
        let captured = Mutex(false)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTVSeries: { _ in throw TestError.generic },
                captureError: { _ in captured.withLock { $0 = true } }
            )
        )

        await viewModel.startSession()

        #expect(captured.withLock { $0 } == true)
        #expect(viewModel.isThinking == false)
        #expect(viewModel.messages.count == 1)
        #expect(Self.isAssistant(viewModel.messages.first))
        #expect(Self.message(viewModel.messages.first, hasText: "There was a problem and I can't help you."))
    }

    @Test("startSession failure surfaces an LLMSessionError when the session cannot be created")
    @MainActor
    func startSessionFailureSurfacesLLMSessionError() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                createSession: { _ in throw LLMSessionError.rateLimited(message: "slow down") }
            )
        )

        await viewModel.startSession()

        #expect(viewModel.error == .rateLimited(message: "slow down"))
    }

    // MARK: - sendPrompt

    @Test("sendPrompt appends the user prompt and the assistant response")
    @MainActor
    func sendPromptSuccessAppendsMessages() async {
        let session = FakeLLMSession(response: "Sure, here's an answer.")
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(createSession: { _ in session })
        )
        await viewModel.startSession()

        await viewModel.sendPrompt("What is this show about?")

        // intro assistant + user prompt + assistant response.
        #expect(viewModel.messages.count == 3)
        #expect(Self.isUser(viewModel.messages[1]))
        #expect(Self.message(viewModel.messages[1], hasText: "What is this show about?"))
        #expect(Self.isAssistant(viewModel.messages[2]))
        #expect(Self.message(viewModel.messages[2], hasText: "Sure, here's an answer."))
        #expect(viewModel.isThinking == false)
    }

    @Test("sendPrompt failure captures the error, sets it and appends a fallback message")
    @MainActor
    func sendPromptFailureCapturesErrorAndAppendsFallback() async {
        let captured = Mutex(false)
        let session = FakeLLMSession(response: "intro")
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                createSession: { _ in session },
                captureError: { _ in captured.withLock { $0 = true } }
            )
        )
        await viewModel.startSession()
        session.error = .refusal(message: "no")

        await viewModel.sendPrompt("Tell me more")

        #expect(captured.withLock { $0 } == true)
        #expect(viewModel.error == .refusal(message: "no"))
        #expect(viewModel.isThinking == false)
        // intro assistant + user prompt + assistant fallback.
        #expect(viewModel.messages.count == 3)
        #expect(Self.isUser(viewModel.messages[1]))
        #expect(Self.isAssistant(viewModel.messages.last))
        #expect(Self.message(viewModel.messages.last, hasText: "I couldn't respond to that. Please try again."))
    }

}

// MARK: - Factories

extension TVSeriesIntelligenceViewModelTests {

    @MainActor
    static func makeViewModel(
        dependencies: TVSeriesIntelligenceDependencies = stubDependencies()
    ) -> TVSeriesIntelligenceViewModel {
        TVSeriesIntelligenceViewModel(
            tvSeriesID: 1396,
            dependencies: dependencies
        )
    }

    static func stubDependencies(
        fetchTVSeries: @escaping @Sendable (Int) async throws -> TVSeries = { id in
            TVSeries(id: id, name: "Stranger Things", tagline: "Tagline")
        },
        createSession: @escaping @Sendable (Int) async throws -> any LLMSession = { _ in
            FakeLLMSession(response: "intro")
        },
        captureError: @escaping @Sendable (any Error) -> Void = { _ in }
    ) -> TVSeriesIntelligenceDependencies {
        TVSeriesIntelligenceDependencies(
            fetchTVSeries: fetchTVSeries,
            createSession: createSession,
            captureError: captureError
        )
    }

}

// MARK: - Message Assertions

extension TVSeriesIntelligenceViewModelTests {

    /// Reference roles taken from ``Message/mocks`` (`[user, assistant]`) so the
    /// `DesignSystem` `ChatRole`/`ChatMessageContent` types are never named here.
    private static let userRole = Message.mocks[0].role
    private static let assistantRole = Message.mocks[1].role

    static func isAssistant(_ message: Message?) -> Bool {
        message?.role == assistantRole
    }

    static func isUser(_ message: Message?) -> Bool {
        message?.role == userRole
    }

    static func message(_ message: Message?, hasText text: String) -> Bool {
        guard let message else {
            return false
        }

        return message.content == Message(role: message.role, textContent: text).content
    }

}

// MARK: - Fake LLMSession

private final class FakeLLMSession: LLMSession, @unchecked Sendable {

    var response: String
    var error: LLMSessionError?

    init(response: String, error: LLMSessionError? = nil) {
        self.response = response
        self.error = error
    }

    func respond(to _: String) async throws(LLMSessionError) -> String {
        if let error {
            throw error
        }
        return response
    }

}

// MARK: - Test Helpers

private enum TestError: Error, Equatable {
    case generic
}
