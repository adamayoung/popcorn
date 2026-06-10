//
//  PlotRemixGameViewModel.swift
//  PlotRemixGameFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observation
import OSLog

/// Drives ``PlotRemixGameView``.
///
/// Manages discrete state for the game's start / generating / playing phases (no
/// `ViewState` wrapper, because these phases are not a simple loading lifecycle).
///
/// Metadata loading is driven by the view through ``fetchMetadata()`` from a
/// `.task`. Game generation is driven through ``generateGame()`` from a
/// `.task(id:)` keyed on ``generateToken`` — ``startGenerating()`` bumps the token,
/// which reruns the view's `.task(id:)`. The structured `.task(id:)` is cancelled by
/// SwiftUI on cover teardown; ``close()`` additionally cancels the in-flight
/// generate work *before* asking the navigator to dismiss, so generation never
/// outlives the modal.
@Observable
@MainActor
public final class PlotRemixGameViewModel {

    private static let logger = Logger.plotRemixGame

    public let gameID: Int

    public private(set) var metadata: GameMetadata?
    public private(set) var isGeneratingGame: Bool
    public private(set) var generatingProgress: Float?
    public private(set) var game: Game?
    public private(set) var error: Error?

    /// Drives the view's generate `.task(id:)`. ``startGenerating()`` bumps it.
    public private(set) var generateToken = 0

    /// The in-flight generation task, captured so ``close()`` can cancel it
    /// synchronously before dismissing.
    private var generateTask: Task<Void, Never>?

    /// The token associated with the current ``generateTask``, so we know when
    /// the task is stale and can be cleaned up.
    private var generateTaskToken: Int = 0

    private let dependencies: PlotRemixGameDependencies
    private let navigator: any PlotRemixGameNavigating

    public init(
        gameID: Int,
        dependencies: PlotRemixGameDependencies,
        navigator: any PlotRemixGameNavigating,
        metadata: GameMetadata? = nil,
        isGeneratingGame: Bool = false,
        generatingProgress: Float? = nil,
        game: Game? = nil,
        error: Error? = nil
    ) {
        self.gameID = gameID
        self.dependencies = dependencies
        self.navigator = navigator
        self.metadata = metadata
        self.isGeneratingGame = isGeneratingGame
        self.generatingProgress = generatingProgress
        self.game = game
        self.error = error
    }

    // MARK: - Metadata

    /// Fetches the game metadata. Drive this from the view's `.task`.
    ///
    /// A no-op once metadata is already loaded.
    public func fetchMetadata() async {
        guard metadata == nil else {
            return
        }

        Self.logger.info(
            "User fetching game metadata [gameID: \(self.gameID, privacy: .private)]"
        )

        do {
            metadata = try await dependencies.gameMetadata(gameID)
        } catch {
            Self.logger.error(
                "Failed fetching game metadata [gameID: \(self.gameID, privacy: .private)]: \(error.localizedDescription, privacy: .public)"
            )
            self.error = error
        }
    }

    // MARK: - Generation

    /// Bumps ``generateToken`` so the view's generate `.task(id:)` reruns, and marks
    /// generation as in progress. The Start button calls this.
    public func startGenerating() {
        isGeneratingGame = true
        generateToken += 1
    }

    /// Generates the game, reporting progress on the main actor. Drive this from the
    /// view's `.task(id: generateToken)`.
    ///
    /// A no-op without metadata. Hops progress callbacks to the main actor and
    /// starts the game on success.
    public func generateGame() async {
        guard metadata != nil else {
            return
        }
        guard isGeneratingGame else {
            return
        }

        Self.logger.info("User generating game [gameID: \(self.gameID, privacy: .private)]")

        let tokenForThisGeneration = generateToken
        await performGameGeneration(with: tokenForThisGeneration)
    }

    /// Performs the actual game generation task with structured cancellation handling.
    private func performGameGeneration(with token: Int) async {
        let task = createGameGenerationTask()
        generateTask = task
        generateTaskToken = token
        // Cancel *this* generation's task on cancellation. Cancelling the shared
        // `generateTask` instead would let a rapid second Start (which replaces it)
        // cancel the new generation when the first task's `.task(id:)` tears down.
        await withTaskCancellationHandler {
            await task.value
        } onCancel: {
            task.cancel()
        }
        if generateTaskToken == token {
            generateTask = nil
            generateTaskToken = 0
        }
    }

    /// Creates a task that generates the game, handling progress callbacks and errors.
    private func createGameGenerationTask() -> Task<Void, Never> {
        Task { [weak self] in
            guard let self else {
                return
            }

            let game: Game
            do {
                game = try await dependencies.generateGame { [weak self] progress in
                    Task { @MainActor in
                        guard let self else {
                            return
                        }
                        self.generatingProgress = progress
                    }
                }
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else {
                    return
                }
                Self.logger.error(
                    "Failed generating game [gameID: \(self.gameID, privacy: .private)]: \(error.localizedDescription, privacy: .public)"
                )
                generatingProgress = nil
                isGeneratingGame = false
                self.error = error
                return
            }

            guard !Task.isCancelled else {
                return
            }

            self.game = game
            startGame()
        }
    }

    // MARK: - Game play

    /// Called once a game is ready. A no-op if the game has not been set yet.
    public func startGame() {
        guard game != nil else {
            return
        }
    }

    /// Records an answer for a question (currently a no-op).
    public func answerQuestion(_ questionIndex: Int, _ answerIndex: Int) {}

    /// Ends the current game (currently a no-op).
    public func endGame() {}

    // MARK: - Dismissal

    /// Cancels any in-flight generation first, then asks the navigator to dismiss.
    ///
    /// This ensures generation never outlives the modal.
    public func close() async {
        generateTask?.cancel()
        generateTask = nil
        navigator.dismiss()
    }

}

#if DEBUG
    public extension PlotRemixGameViewModel {

        /// A view model pinned to fixed state with no-op dependencies and navigation,
        /// for previews and snapshot tests.
        static func preview(
            gameID: Int = 1,
            metadata: GameMetadata? = nil,
            generatingProgress: Float? = nil,
            game: Game? = nil
        ) -> PlotRemixGameViewModel {
            PlotRemixGameViewModel(
                gameID: gameID,
                dependencies: .preview,
                navigator: NoOpPlotRemixGameNavigator(),
                metadata: metadata,
                generatingProgress: generatingProgress,
                game: game
            )
        }

    }
#endif
