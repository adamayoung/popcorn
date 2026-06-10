//
//  TVSeriesIntelligenceViewModel.swift
//  TVSeriesIntelligenceFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import IntelligenceDomain
import Observation
import OSLog

/// Drives ``TVSeriesIntelligenceView``.
///
/// A chat view model: it owns the conversation ``messages``, the ``isThinking``
/// indicator, and the most recent ``error``. The session is created lazily by
/// ``startSession()`` (driven from the view's `.task`), which also sends a single
/// auto-introduction prompt with no corresponding user message.
///
/// Concurrency: there is deliberately no view-model-owned `Task`, `deinit`, or
/// `nonisolated(unsafe)` state. The view drives ``startSession()`` from `.task`
/// and sends prompts from `Task { await viewModel.sendPrompt(_:) }`, so SwiftUI
/// owns the lifetime of all work.
@Observable
@MainActor
public final class TVSeriesIntelligenceViewModel {

    private static let logger = Logger.tvSeriesIntelligence

    private static let introPrompt = "Introduce yourself and what you're for"
    private static let sessionStartFailureMessage = "There was a problem and I can't help you."
    private static let promptFailureMessage = "I couldn't respond to that. Please try again."

    public private(set) var messages: [Message]
    public private(set) var isThinking: Bool
    public private(set) var error: LLMSessionError?

    public let tvSeriesID: Int

    private var tvSeries: TVSeries?
    private var session: (any LLMSession)?
    private let dependencies: TVSeriesIntelligenceDependencies

    public init(
        tvSeriesID: Int,
        dependencies: TVSeriesIntelligenceDependencies,
        messages: [Message] = [],
        isThinking: Bool = false,
        error: LLMSessionError? = nil
    ) {
        self.tvSeriesID = tvSeriesID
        self.dependencies = dependencies
        self.messages = messages
        self.isThinking = isThinking
        self.error = error
    }

    /// The name of the TV series, available once the session has started.
    public var tvSeriesName: String? {
        tvSeries?.name
    }

    /// The tagline of the TV series, available once the session has started.
    public var tvSeriesTagline: String? {
        tvSeries?.tagline
    }

    // MARK: - Lifecycle

    /// Fetches the TV series and creates the session, then sends a single
    /// auto-introduction prompt (with no user message).
    ///
    /// Idempotent: returns immediately if a session already exists. Drive this
    /// from the view's `.task` so SwiftUI owns its lifetime.
    public func startSession() async {
        guard session == nil else {
            return
        }

        isThinking = true
        Self.logger.info("Starting TV series intelligence session")

        let tvSeries: TVSeries
        let session: any LLMSession
        do {
            async let tvSeriesTask = dependencies.fetchTVSeries(tvSeriesID)
            async let sessionTask = dependencies.createSession(tvSeriesID)
            tvSeries = try await tvSeriesTask
            session = try await sessionTask
        } catch {
            dependencies.captureError(error)
            Self.logger.error(
                "Failed starting TV series intelligence session: \(error.localizedDescription, privacy: .public)"
            )
            // `error` is the published surface; session-start errors are typically
            // not `LLMSessionError`, so only surface those that are.
            self.error = error as? LLMSessionError
            messages.append(Message(role: .assistant, textContent: Self.sessionStartFailureMessage))
            isThinking = false
            return
        }

        self.tvSeries = tvSeries
        self.session = session

        await respond(to: Self.introPrompt)
    }

    // MARK: - Sending

    /// Appends the user's prompt to the conversation and requests a response.
    public func sendPrompt(_ prompt: String) async {
        messages.append(Message(role: .user, textContent: prompt))
        await respond(to: prompt)
    }

    private func respond(to prompt: String) async {
        guard let session else {
            Self.logger.warning("No current session")
            return
        }

        isThinking = true

        let response: String
        do {
            response = try await session.respond(to: prompt)
        } catch {
            // `respond(to:)` uses typed throws, so `error` is an `LLMSessionError`.
            dependencies.captureError(error)
            Self.logger.error(
                "Failed responding to prompt: \(error.localizedDescription, privacy: .public)"
            )
            self.error = error
            messages.append(Message(role: .assistant, textContent: Self.promptFailureMessage))
            isThinking = false
            return
        }

        messages.append(Message(role: .assistant, textContent: response))
        isThinking = false
    }

}

#if DEBUG
    public extension TVSeriesIntelligenceViewModel {

        /// A view model pinned to a fixed conversation with stub dependencies, for
        /// previews and snapshot tests.
        static func preview(
            messages: [Message] = Message.mocks,
            isThinking: Bool = false
        ) -> TVSeriesIntelligenceViewModel {
            TVSeriesIntelligenceViewModel(
                tvSeriesID: 1396,
                dependencies: .preview,
                messages: messages,
                isThinking: isThinking
            )
        }

    }
#endif
