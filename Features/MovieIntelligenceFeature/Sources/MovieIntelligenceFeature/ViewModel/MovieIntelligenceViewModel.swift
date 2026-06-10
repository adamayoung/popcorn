//
//  MovieIntelligenceViewModel.swift
//  MovieIntelligenceFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import IntelligenceDomain
import Observation
import OSLog

/// Drives ``MovieIntelligenceView``.
///
/// Unlike the fetch-based feature view models, this chat leaf exposes discrete
/// observable properties (``messages``, ``isThinking``, ``error``) rather than a
/// single `ViewState`. The view drives ``startSession()`` from a `.task` and sends
/// prompts via `Task { await viewModel.sendPrompt(_:) }`, so SwiftUI owns the
/// lifetime of the work. There is deliberately no view-model-owned `Task`, no
/// `deinit`, and no `nonisolated(unsafe)` state.
@Observable
@MainActor
public final class MovieIntelligenceViewModel {

    private static let logger = Logger.movieIntelligence

    public private(set) var messages: [Message] = []
    public private(set) var isThinking = false
    public private(set) var error: LLMSessionError?

    public let movieID: Int

    private var movie: IntelligenceDomain.Movie?
    private var session: (any LLMSession)?
    private let dependencies: MovieIntelligenceDependencies

    public init(
        movieID: Int,
        dependencies: MovieIntelligenceDependencies
    ) {
        self.movieID = movieID
        self.dependencies = dependencies
    }

    /// The title shown by the screen once the movie has loaded.
    public var movieTitle: String? {
        movie?.title
    }

    // MARK: - Session

    /// Fetches the movie and creates the LLM session, then sends the auto-intro
    /// prompt. Driven by the view's `.task`; idempotent so reappearance does not
    /// start a second session.
    public func startSession() async {
        guard session == nil else {
            return
        }

        isThinking = true

        do {
            async let movieTask = dependencies.fetchMovie(movieID)
            async let sessionTask = dependencies.createSession(movieID)

            let movie = try await movieTask
            let session = try await sessionTask
            self.movie = movie
            self.session = session

            // The intro is sent WITHOUT appending a user message.
            await respond(to: "Introduce yourself and what you're for")
        } catch {
            handleStartFailure(error)
        }
    }

    /// Appends the user's prompt then responds.
    public func sendPrompt(_ prompt: String) async {
        messages.append(Message(role: .user, textContent: prompt))
        await respond(to: prompt)
    }

    // MARK: - Responding

    /// Sends `prompt` to the session and appends the assistant's reply.
    private func respond(to prompt: String) async {
        guard let session else {
            Self.logger.warning("No current session")
            handleSendFailure(.unknown("Session not available"))
            return
        }

        isThinking = true

        do {
            let response = try await session.respond(to: prompt)
            isThinking = false
            messages.append(Message(role: .assistant, textContent: response))
        } catch let error as LLMSessionError {
            dependencies.captureError(error)
            Self.logger.error("Failed to send prompt: \(error.localizedDescription)")
            isThinking = false
            self.error = error
            messages.append(Message(role: .assistant, textContent: "I couldn't respond to that. Please try again."))
        } catch {
            // Typed throws are erased when calling through an `any LLMSession` existential,
            // so this catch handles any unexpected errors from concrete implementations.
            let sessionError = LLMSessionError.unknown(error.localizedDescription)
            dependencies.captureError(error)
            Self.logger.error("Unexpected error sending prompt: \(error.localizedDescription)")
            isThinking = false
            self.error = sessionError
            messages.append(Message(role: .assistant, textContent: "I couldn't respond to that. Please try again."))
        }
    }

    private func handleStartFailure(_ error: any Error) {
        // Capture the RAW error so Sentry keeps its original type/domain for
        // grouping; wrapping it as `.unknown(localizedDescription)` first (e.g.
        // turning a cancelled session into `.unknown("cancelled")`) destroys that.
        dependencies.captureError(error)
        Self.logger.error("Failed to start session: \(error.localizedDescription)")
        isThinking = false
        self.error = error as? LLMSessionError
        messages.append(Message(role: .assistant, textContent: "There was a problem and I can't help you."))
    }

    private func handleSendFailure(_ error: LLMSessionError) {
        isThinking = false
        self.error = error
        messages.append(Message(role: .assistant, textContent: "I couldn't respond to that. Please try again."))
    }

}

#if DEBUG
    public extension MovieIntelligenceViewModel {

        /// A view model with no-op preview dependencies, pinned to a fixed set of
        /// messages, for previews and snapshot tests.
        static func preview(
            messages: [Message] = [],
            isThinking: Bool = false
        ) -> MovieIntelligenceViewModel {
            let viewModel = MovieIntelligenceViewModel(movieID: 550, dependencies: .preview)
            viewModel.messages = messages
            viewModel.isThinking = isThinking
            return viewModel
        }

    }
#endif
