//
//  TVSeasonDetailsViewModel.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observation
import OSLog
import Presentation

/// The data shown by ``TVSeasonDetailsView`` once loaded.
public struct TVSeasonDetailsViewSnapshot: Equatable, Sendable {

    public let season: TVSeason
    public let episodes: [TVEpisode]

    public init(
        season: TVSeason,
        episodes: [TVEpisode]
    ) {
        self.season = season
        self.episodes = episodes
    }

}

/// Drives ``TVSeasonDetailsView``. The MVVM replacement for `TVSeasonDetailsFeature`.
///
/// Loading is driven by the view through ``load()`` from a `.task(id:)`, so SwiftUI
/// owns the lifetime: the work is cancelled on disappear and restarted on reappear
/// (or when ``reload()`` bumps ``reloadID``). There is deliberately no
/// view-model-owned `Task` — structured concurrency keeps the work tied to the
/// view's lifetime with no manual cancellation.
///
/// TV season details has no live stream, no feature flags and no watchlist toggle:
/// ``load()`` is a single fetch.
@Observable
@MainActor
public final class TVSeasonDetailsViewModel {

    public typealias ViewSnapshot = TVSeasonDetailsViewSnapshot

    private static let logger = Logger.tvSeasonDetails

    public private(set) var viewState: ViewState<ViewSnapshot>

    /// Drives `.task(id:)` reruns. ``reload()`` bumps it to retry after an error.
    public private(set) var reloadID = 0

    public let tvSeriesID: Int
    public let seasonNumber: Int

    private let dependencies: TVSeasonDetailsDependencies
    private let navigator: any TVSeasonDetailsNavigating

    public init(
        tvSeriesID: Int,
        seasonNumber: Int,
        dependencies: TVSeasonDetailsDependencies,
        navigator: any TVSeasonDetailsNavigating,
        viewState: ViewState<ViewSnapshot> = .initial
    ) {
        self.tvSeriesID = tvSeriesID
        self.seasonNumber = seasonNumber
        self.dependencies = dependencies
        self.navigator = navigator
        self.viewState = viewState
    }

    // MARK: - Lifecycle

    /// Fetches details. There is no live stream, so this is a single fetch.
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

    public func selectEpisode(tvSeriesID: Int, seasonNumber: Int, episodeNumber: Int) {
        navigator.openEpisodeDetails(
            tvSeriesID: tvSeriesID,
            seasonNumber: seasonNumber,
            episodeNumber: episodeNumber
        )
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
        Self.logger.info(
            "Fetching season details [tvSeriesID: \(self.tvSeriesID, privacy: .private), seasonNumber: \(self.seasonNumber)]"
        )

        let season: TVSeason
        let episodes: [TVEpisode]
        do {
            (season, episodes) = try await dependencies.fetchSeasonAndEpisodes(
                tvSeriesID,
                seasonNumber
            )
        } catch {
            Self.logger.error(
                "Failed fetching season details [tvSeriesID: \(self.tvSeriesID, privacy: .private), seasonNumber: \(self.seasonNumber)]: \(error.localizedDescription, privacy: .public)"
            )
            viewState.applyLoadFailure(error)
            return
        }

        viewState = .ready(ViewSnapshot(season: season, episodes: episodes))
    }

}

#if DEBUG
    public extension TVSeasonDetailsViewModel {

        /// A view model pinned to a fixed view state with no-op dependencies and
        /// navigation, for previews and snapshot tests.
        static func preview(
            viewState: ViewState<ViewSnapshot>
        ) -> TVSeasonDetailsViewModel {
            TVSeasonDetailsViewModel(
                tvSeriesID: viewState.content?.season.tvSeriesID ?? 0,
                seasonNumber: viewState.content?.season.seasonNumber ?? 0,
                dependencies: .preview,
                navigator: NoOpTVSeasonDetailsNavigator(),
                viewState: viewState
            )
        }

    }
#endif
