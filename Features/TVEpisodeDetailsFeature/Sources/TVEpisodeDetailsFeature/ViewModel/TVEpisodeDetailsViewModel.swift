//
//  TVEpisodeDetailsViewModel.swift
//  TVEpisodeDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observation
import OSLog
import Presentation

/// The data shown by ``TVEpisodeDetailsScreen`` once loaded.
public struct TVEpisodeDetailsViewSnapshot: Equatable, Sendable {

    public let episode: TVEpisode
    public let castMembers: [CastMember]
    public let crewMembers: [CrewMember]

    public init(
        episode: TVEpisode,
        castMembers: [CastMember] = [],
        crewMembers: [CrewMember] = []
    ) {
        self.episode = episode
        self.castMembers = castMembers
        self.crewMembers = crewMembers
    }

}

/// Drives ``TVEpisodeDetailsScreen``. The MVVM replacement for `TVEpisodeDetailsFeature`.
///
/// Loading is driven by the view through ``load()`` from a `.task(id:)`, so SwiftUI
/// owns the lifetime: the work is cancelled on disappear and restarted on reappear
/// (or when ``reload()`` bumps ``reloadID``). There is deliberately no
/// view-model-owned `Task` — structured concurrency keeps the work tied to the
/// view's lifetime with no manual cancellation.
///
/// TV episode details has no live stream and no watchlist toggle: ``load()`` is a
/// single fetch.
@Observable
@MainActor
public final class TVEpisodeDetailsViewModel {

    public typealias ViewSnapshot = TVEpisodeDetailsViewSnapshot

    private static let logger = Logger.tvEpisodeDetails

    public private(set) var viewState: ViewState<ViewSnapshot>
    public private(set) var isCastAndCrewEnabled: Bool

    /// Drives `.task(id:)` reruns. ``reload()`` bumps it to retry after an error.
    public private(set) var reloadID = 0

    public let tvSeriesID: Int
    public let seasonNumber: Int
    public let episodeNumber: Int

    private let dependencies: TVEpisodeDetailsDependencies
    private let navigator: any TVEpisodeDetailsNavigating

    public init(
        tvSeriesID: Int,
        seasonNumber: Int,
        episodeNumber: Int,
        dependencies: TVEpisodeDetailsDependencies,
        navigator: any TVEpisodeDetailsNavigating,
        viewState: ViewState<ViewSnapshot> = .initial,
        isCastAndCrewEnabled: Bool = false
    ) {
        self.tvSeriesID = tvSeriesID
        self.seasonNumber = seasonNumber
        self.episodeNumber = episodeNumber
        self.dependencies = dependencies
        self.navigator = navigator
        self.viewState = viewState
        self.isCastAndCrewEnabled = isCastAndCrewEnabled
    }

    // MARK: - Lifecycle

    public func didAppear() {
        updateFeatureFlags()
    }

    public func updateFeatureFlags() {
        isCastAndCrewEnabled = (try? dependencies.isCastAndCrewEnabled()) ?? false
    }

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

    public func openCastAndCrew() {
        navigator.openTVEpisodeCastAndCrew(
            tvSeriesID: tvSeriesID,
            seasonNumber: seasonNumber,
            episodeNumber: episodeNumber
        )
    }

    public func selectPerson(id: Int) {
        navigator.openPersonDetails(id: id)
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
            "Fetching episode details [tvSeriesID: \(self.tvSeriesID, privacy: .private), S\(self.seasonNumber)E\(self.episodeNumber)]"
        )

        let isCastAndCrewEnabled = (try? dependencies.isCastAndCrewEnabled()) ?? false

        let episode: TVEpisode
        do {
            episode = try await dependencies.fetchEpisode(tvSeriesID, seasonNumber, episodeNumber)
        } catch {
            Self.logger.error(
                "Failed fetching episode details [tvSeriesID: \(self.tvSeriesID, privacy: .private), S\(self.seasonNumber)E\(self.episodeNumber)]: \(error.localizedDescription, privacy: .public)"
            )
            viewState = .error(ViewStateError(error))
            return
        }

        var castMembers: [CastMember] = []
        var crewMembers: [CrewMember] = []
        if isCastAndCrewEnabled {
            do {
                let credits = try await dependencies.fetchCredits(tvSeriesID, seasonNumber, episodeNumber)
                castMembers = credits.castMembers
                crewMembers = credits.crewMembers
            } catch {
                Self.logger.warning(
                    "Failed fetching episode credits [tvSeriesID: \(self.tvSeriesID, privacy: .private), S\(self.seasonNumber)E\(self.episodeNumber)]: \(error.localizedDescription, privacy: .public)"
                )
            }
        }

        viewState = .ready(ViewSnapshot(
            episode: episode,
            castMembers: castMembers,
            crewMembers: crewMembers
        ))
    }

}

#if DEBUG
    public extension TVEpisodeDetailsViewModel {

        /// A view model pinned to a fixed view state with no-op dependencies and
        /// navigation, for previews and snapshot tests.
        static func preview(
            viewState: ViewState<ViewSnapshot>,
            isCastAndCrewEnabled: Bool = false
        ) -> TVEpisodeDetailsViewModel {
            TVEpisodeDetailsViewModel(
                tvSeriesID: viewState.content?.episode.tvSeriesID ?? 0,
                seasonNumber: viewState.content?.episode.seasonNumber ?? 0,
                episodeNumber: viewState.content?.episode.episodeNumber ?? 0,
                dependencies: .preview,
                navigator: NoOpTVEpisodeDetailsNavigator(),
                viewState: viewState,
                isCastAndCrewEnabled: isCastAndCrewEnabled
            )
        }

    }
#endif
