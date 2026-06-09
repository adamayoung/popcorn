//
//  GamesCatalogViewModel.swift
//  GamesCatalogFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observation
import OSLog
import Presentation

/// The data shown by ``GamesCatalogScreen`` once loaded.
public struct GamesCatalogViewSnapshot: Equatable, Sendable {

    public let games: [GameMetadata]

    public init(games: [GameMetadata]) {
        self.games = games
    }

}

/// Drives ``GamesCatalogScreen``. The MVVM replacement for `GamesCatalogFeature`.
///
/// Loading is driven by the view through ``load()`` from a `.task(id:)`, so SwiftUI
/// owns the lifetime: the work is cancelled on disappear and restarted on reappear
/// (or when ``reload()`` bumps ``reloadID``). There is deliberately no
/// view-model-owned `Task` — structured concurrency keeps the work tied to the
/// view's lifetime with no manual cancellation.
@Observable
@MainActor
public final class GamesCatalogViewModel {

    public typealias ViewSnapshot = GamesCatalogViewSnapshot

    private static let logger = Logger.gamesCatalog

    public private(set) var viewState: ViewState<ViewSnapshot>

    /// Drives `.task(id:)` reruns. ``reload()`` bumps it to retry after an error.
    public private(set) var reloadID = 0

    private let dependencies: GamesCatalogDependencies
    private let navigator: any GamesCatalogNavigating

    public init(
        dependencies: GamesCatalogDependencies,
        navigator: any GamesCatalogNavigating,
        viewState: ViewState<ViewSnapshot> = .initial
    ) {
        self.dependencies = dependencies
        self.navigator = navigator
        self.viewState = viewState
    }

    // MARK: - Lifecycle

    /// Fetches the games catalog.
    ///
    /// Drive this from the view's `.task(id:)`; SwiftUI cancels it on disappear
    /// and reruns it on reappear / ``reload()``.
    public func load() async {
        await fetch()
    }

    /// Retries loading after an error by changing ``reloadID``, which reruns the
    /// view's `.task(id:)`.
    public func reload() {
        reloadID += 1
    }

    // MARK: - Navigation

    public func selectGame(id: Int) {
        navigator.openGame(id: id)
    }

    // MARK: - Loading

    func fetch() async {
        guard !viewState.isReady else {
            return
        }
        guard !viewState.isLoading else {
            return
        }

        viewState = .loading
        Self.logger.info("User fetching games")

        let snapshot: ViewSnapshot
        do {
            let games = try await dependencies.fetchGames()
            snapshot = ViewSnapshot(games: games)
        } catch {
            Self.logger.error("Failed fetching games: \(error.localizedDescription, privacy: .public)")
            viewState = .error(ViewStateError(error))
            return
        }

        viewState = .ready(snapshot)
    }

}

#if DEBUG
    public extension GamesCatalogViewModel {

        /// A view model pinned to a fixed view state with no-op dependencies and
        /// navigation, for previews and snapshot tests.
        static func preview(
            viewState: ViewState<ViewSnapshot>
        ) -> GamesCatalogViewModel {
            GamesCatalogViewModel(
                dependencies: .preview,
                navigator: NoOpGamesCatalogNavigator(),
                viewState: viewState
            )
        }

    }
#endif
