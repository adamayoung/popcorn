//
//  TVSeriesDetailsViewModel.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observation
import OSLog
import Presentation

/// The data shown by ``TVSeriesDetailsView`` once loaded.
public struct TVSeriesDetailsViewSnapshot: Equatable, Sendable {

    public let tvSeries: TVSeries
    public let castMembers: [CastMember]
    public let crewMembers: [CrewMember]

    public init(
        tvSeries: TVSeries,
        castMembers: [CastMember] = [],
        crewMembers: [CrewMember] = []
    ) {
        self.tvSeries = tvSeries
        self.castMembers = castMembers
        self.crewMembers = crewMembers
    }

}

/// Drives ``TVSeriesDetailsView``. The MVVM replacement for `TVSeriesDetailsFeature`.
///
/// Loading is driven by the view through ``load()`` from a `.task(id:)`, so SwiftUI
/// owns the lifetime: the work is cancelled on disappear and restarted on reappear
/// (or when ``reload()`` bumps ``reloadID``). There is deliberately no
/// view-model-owned `Task` — structured concurrency keeps the work tied to the
/// view's lifetime with no manual cancellation.
///
/// TV series details has no live stream and no watchlist toggle: ``load()`` is a
/// single fetch.
@Observable
@MainActor
public final class TVSeriesDetailsViewModel {

    public typealias ViewSnapshot = TVSeriesDetailsViewSnapshot

    private static let logger = Logger.tvSeriesDetails

    public private(set) var viewState: ViewState<ViewSnapshot>
    public private(set) var isCastAndCrewEnabled: Bool
    public private(set) var isIntelligenceEnabled: Bool
    public private(set) var isBackdropFocalPointEnabled: Bool

    /// Drives `.task(id:)` reruns. ``reload()`` bumps it to retry after an error.
    public private(set) var reloadID = 0

    public let tvSeriesID: Int
    public let transitionID: String?

    private let dependencies: TVSeriesDetailsDependencies
    private let navigator: any TVSeriesDetailsNavigating

    public init(
        tvSeriesID: Int,
        transitionID: String? = nil,
        dependencies: TVSeriesDetailsDependencies,
        navigator: any TVSeriesDetailsNavigating,
        viewState: ViewState<ViewSnapshot> = .initial,
        isCastAndCrewEnabled: Bool = false,
        isIntelligenceEnabled: Bool = false,
        isBackdropFocalPointEnabled: Bool = false
    ) {
        self.tvSeriesID = tvSeriesID
        self.transitionID = transitionID
        self.dependencies = dependencies
        self.navigator = navigator
        self.viewState = viewState
        self.isCastAndCrewEnabled = isCastAndCrewEnabled
        self.isIntelligenceEnabled = isIntelligenceEnabled
        self.isBackdropFocalPointEnabled = isBackdropFocalPointEnabled
    }

    // MARK: - Lifecycle

    public func didAppear() {
        updateFeatureFlags()
    }

    public func updateFeatureFlags() {
        isCastAndCrewEnabled = (try? dependencies.isCastAndCrewEnabled()) ?? false
        isIntelligenceEnabled = (try? dependencies.isIntelligenceEnabled()) ?? false
        isBackdropFocalPointEnabled = (try? dependencies.isBackdropFocalPointEnabled()) ?? false
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

    public func openIntelligence(id: Int) {
        navigator.openTVSeriesIntelligence(id: id)
    }

    public func selectSeason(seasonNumber: Int) {
        navigator.openSeasonDetails(tvSeriesID: tvSeriesID, seasonNumber: seasonNumber)
    }

    public func selectPerson(id: Int) {
        navigator.openPersonDetails(id: id)
    }

    public func openCastAndCrew() {
        navigator.openTVSeriesCastAndCrew(tvSeriesID: tvSeriesID)
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
            "User fetching TV series [tvSeriesID: \(self.tvSeriesID, privacy: .private)]"
        )

        let tvSeries: TVSeries
        do {
            tvSeries = try await dependencies.fetchTVSeries(tvSeriesID)
        } catch {
            Self.logger.error(
                "Failed fetching TV series [tvSeriesID: \(self.tvSeriesID, privacy: .private)]: \(error.localizedDescription, privacy: .public)"
            )
            viewState = .error(ViewStateError(error))
            return
        }

        let isCastAndCrewEnabled = (try? dependencies.isCastAndCrewEnabled()) ?? false

        var castMembers: [CastMember] = []
        var crewMembers: [CrewMember] = []
        if isCastAndCrewEnabled {
            do {
                let credits = try await dependencies.fetchCredits(tvSeriesID)
                castMembers = credits.castMembers
                crewMembers = credits.crewMembers
            } catch {
                Self.logger.warning(
                    "Failed fetching credits [tvSeriesID: \(self.tvSeriesID, privacy: .private)]: \(error.localizedDescription, privacy: .public)"
                )
            }
        }

        viewState = .ready(ViewSnapshot(
            tvSeries: tvSeries,
            castMembers: castMembers,
            crewMembers: crewMembers
        ))
    }

}

#if DEBUG
    public extension TVSeriesDetailsViewModel {

        /// A view model pinned to a fixed view state with no-op dependencies and
        /// navigation, for previews and snapshot tests.
        static func preview(
            viewState: ViewState<ViewSnapshot>,
            isCastAndCrewEnabled: Bool = false,
            isIntelligenceEnabled: Bool = false,
            isBackdropFocalPointEnabled: Bool = false
        ) -> TVSeriesDetailsViewModel {
            TVSeriesDetailsViewModel(
                tvSeriesID: viewState.content?.tvSeries.id ?? 0,
                dependencies: .preview,
                navigator: NoOpTVSeriesDetailsNavigator(),
                viewState: viewState,
                isCastAndCrewEnabled: isCastAndCrewEnabled,
                isIntelligenceEnabled: isIntelligenceEnabled,
                isBackdropFocalPointEnabled: isBackdropFocalPointEnabled
            )
        }

    }
#endif
