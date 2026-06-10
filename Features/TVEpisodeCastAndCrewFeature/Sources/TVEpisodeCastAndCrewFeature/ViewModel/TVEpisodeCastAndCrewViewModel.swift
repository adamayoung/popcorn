//
//  TVEpisodeCastAndCrewViewModel.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observation
import OSLog
import Presentation

/// The data shown by ``TVEpisodeCastAndCrewView`` once loaded.
public struct TVEpisodeCastAndCrewViewSnapshot: Equatable, Sendable {

    public let castMembers: [CastMember]
    public let crewByDepartment: [CrewDepartment]

    public init(
        castMembers: [CastMember],
        crewByDepartment: [CrewDepartment]
    ) {
        self.castMembers = castMembers
        self.crewByDepartment = crewByDepartment
    }

}

/// Drives ``TVEpisodeCastAndCrewView``.
///
/// Loading is driven by the view through ``load()`` from a `.task(id:)`, so SwiftUI
/// owns the lifetime: the work is cancelled on disappear and restarted on reappear
/// (or when ``reload()`` bumps ``reloadID``). There is deliberately no
/// view-model-owned `Task` — structured concurrency keeps the work tied to the
/// view's lifetime with no manual cancellation.
@Observable
@MainActor
public final class TVEpisodeCastAndCrewViewModel {

    public typealias ViewSnapshot = TVEpisodeCastAndCrewViewSnapshot

    private static let logger = Logger.tvEpisodeCastAndCrew

    public private(set) var viewState: ViewState<ViewSnapshot>

    /// Drives `.task(id:)` reruns. ``reload()`` bumps it to retry after an error.
    public private(set) var reloadID = 0

    public let tvSeriesID: Int
    public let seasonNumber: Int
    public let episodeNumber: Int

    private let dependencies: TVEpisodeCastAndCrewDependencies
    private let navigator: any TVEpisodeCastAndCrewNavigating

    public init(
        tvSeriesID: Int,
        seasonNumber: Int,
        episodeNumber: Int,
        dependencies: TVEpisodeCastAndCrewDependencies,
        navigator: any TVEpisodeCastAndCrewNavigating,
        viewState: ViewState<ViewSnapshot> = .initial
    ) {
        self.tvSeriesID = tvSeriesID
        self.seasonNumber = seasonNumber
        self.episodeNumber = episodeNumber
        self.dependencies = dependencies
        self.navigator = navigator
        self.viewState = viewState
    }

    // MARK: - Lifecycle

    /// Fetches the cast and crew.
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

    public func selectPerson(id: Int, transitionID _: String?) {
        // Cast & crew rows register their transition source in this screen's own
        // namespace, not the tab namespace the person-details destination zooms
        // against — forwarding the id would trigger an unmatched-zoom fallback. So
        // push without a transition id (plain push).
        navigator.openPersonDetails(id: id, transitionID: nil)
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
            "Fetching episode cast and crew [tvSeriesID: \(self.tvSeriesID, privacy: .private), S\(self.seasonNumber)E\(self.episodeNumber)]"
        )

        let snapshot: ViewSnapshot
        do {
            let credits = try await dependencies.fetchCredits(
                tvSeriesID,
                seasonNumber,
                episodeNumber
            )
            snapshot = ViewSnapshot(
                castMembers: credits.castMembers,
                crewByDepartment: credits.crewByDepartment
            )
        } catch {
            Self.logger.error(
                "Failed fetching episode cast and crew [tvSeriesID: \(self.tvSeriesID, privacy: .private), S\(self.seasonNumber)E\(self.episodeNumber)]: \(error.localizedDescription, privacy: .public)"
            )
            viewState.applyLoadFailure(error)
            return
        }

        viewState = .ready(snapshot)
    }

}

#if DEBUG
    public extension TVEpisodeCastAndCrewViewModel {

        /// A view model pinned to a fixed view state with no-op dependencies and
        /// navigation, for previews and snapshot tests.
        static func preview(
            viewState: ViewState<ViewSnapshot>
        ) -> TVEpisodeCastAndCrewViewModel {
            TVEpisodeCastAndCrewViewModel(
                tvSeriesID: 0,
                seasonNumber: 0,
                episodeNumber: 0,
                dependencies: .preview,
                navigator: NoOpTVEpisodeCastAndCrewNavigator(),
                viewState: viewState
            )
        }

    }
#endif
