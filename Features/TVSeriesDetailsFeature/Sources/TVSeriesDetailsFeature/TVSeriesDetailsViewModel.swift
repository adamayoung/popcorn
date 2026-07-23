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

/// Drives ``TVSeriesDetailsView``.
///
/// The screen renders progressively: ``viewState`` gates the primary TV-series content
/// and becomes `.ready` as soon as the series itself loads, while the cast-and-crew
/// carousel loads independently into its own view state. A cast-and-crew failure
/// degrades that section only — it never fails the whole screen.
///
/// Loading is driven by the view through ``load()`` from a `.task(id:)`, so SwiftUI
/// owns the lifetime: the work is cancelled on disappear and restarted on reappear
/// (or when ``reload()`` bumps ``reloadID``). There is deliberately no
/// view-model-owned `Task` — structured concurrency keeps the work tied to the
/// view's lifetime with no manual cancellation.
///
/// After the hero is ready, a live stream (``observeTVSeriesUpdates()``) patches
/// ``viewState`` with late-arriving enrichment such as the poster theme colour and
/// background-refreshed data. TV series details has no watchlist toggle.
@Observable
@MainActor
public final class TVSeriesDetailsViewModel {

    private static let logger = Logger.tvSeriesDetails

    /// The primary TV-series content. Becomes `.ready` once the series has loaded,
    /// without waiting for the cast-and-crew section.
    public private(set) var viewState: ViewState<TVSeries>

    /// The cast-and-crew carousel, loaded independently after the series is ready.
    public private(set) var castAndCrewState: ViewState<Credits>

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
        viewState: ViewState<TVSeries> = .initial,
        castAndCrewState: ViewState<Credits> = .initial,
        isCastAndCrewEnabled: Bool = false,
        isIntelligenceEnabled: Bool = false,
        isBackdropFocalPointEnabled: Bool = false
    ) {
        self.tvSeriesID = tvSeriesID
        self.transitionID = transitionID
        self.dependencies = dependencies
        self.navigator = navigator
        self.viewState = viewState
        self.castAndCrewState = castAndCrewState
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

    /// Fetches the series, then loads the cast-and-crew section and observes live
    /// series updates once it is ready.
    ///
    /// Drive this from the view's `.task(id:)`; SwiftUI cancels it on disappear
    /// and reruns it on reappear / ``reload()``. The cast-and-crew load and the
    /// live stream run concurrently once the series is ready, so cancellation
    /// propagates to both.
    public func load() async {
        await fetch()
        guard viewState.isReady else {
            return
        }

        async let castAndCrew: Void = loadCastAndCrew()
        async let updates: Void = observeTVSeriesUpdates()
        _ = await (castAndCrew, updates)
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

        do {
            let tvSeries = try await dependencies.fetchTVSeries(tvSeriesID)
            viewState = .ready(tvSeries)
        } catch {
            Self.logger.error(
                "Failed fetching TV series [tvSeriesID: \(self.tvSeriesID, privacy: .private)]: \(error.localizedDescription, privacy: .public)"
            )
            viewState.applyLoadFailure(error)
        }
    }

    func loadCastAndCrew() async {
        guard (try? dependencies.isCastAndCrewEnabled()) == true else {
            castAndCrewState = .initial
            return
        }
        guard !castAndCrewState.isReady, !castAndCrewState.isLoading else {
            return
        }

        castAndCrewState = .loading
        do {
            let credits = try await dependencies.fetchCredits(tvSeriesID)
            castAndCrewState = .ready(credits)
        } catch {
            Self.logger.warning(
                "Failed fetching credits [tvSeriesID: \(self.tvSeriesID, privacy: .private)]: \(error.localizedDescription, privacy: .public)"
            )
            castAndCrewState.applyLoadFailure(error)
        }
    }

    /// Observes the live TV-series stream and patches ``viewState`` as updates arrive.
    ///
    /// The stream delivers enrichment that is kept off the initial fetch — most notably
    /// the poster theme colour — and any background-refreshed data, shortly after the
    /// hero has already rendered.
    func observeTVSeriesUpdates() async {
        guard case .ready = viewState else {
            return
        }

        Self.logger.info(
            "Starting TV series details stream [tvSeriesID: \(self.tvSeriesID, privacy: .private)]"
        )
        do {
            let stream = try await dependencies.streamTVSeries(tvSeriesID)
            for try await tvSeries in stream {
                guard let tvSeries else { continue }
                applyTVSeriesUpdate(tvSeries)
            }
        } catch is CancellationError {
            // Expected when the view disappears and the `.task` is cancelled.
        } catch {
            Self.logger.error(
                "TV series details stream failed [tvSeriesID: \(self.tvSeriesID, privacy: .private)]: \(error.localizedDescription, privacy: .public)"
            )
        }
    }

    private func applyTVSeriesUpdate(_ tvSeries: TVSeries) {
        guard case .ready = viewState else {
            return
        }
        viewState = .ready(tvSeries)
    }

}

#if DEBUG
    public extension TVSeriesDetailsViewModel {

        /// A view model pinned to fixed view states with no-op dependencies and
        /// navigation, for previews and snapshot tests.
        static func preview(
            viewState: ViewState<TVSeries>,
            castAndCrewState: ViewState<Credits> = .initial,
            isCastAndCrewEnabled: Bool = false,
            isIntelligenceEnabled: Bool = false,
            isBackdropFocalPointEnabled: Bool = false
        ) -> TVSeriesDetailsViewModel {
            TVSeriesDetailsViewModel(
                tvSeriesID: viewState.content?.id ?? 0,
                dependencies: .preview,
                navigator: NoOpTVSeriesDetailsNavigator(),
                viewState: viewState,
                castAndCrewState: castAndCrewState,
                isCastAndCrewEnabled: isCastAndCrewEnabled,
                isIntelligenceEnabled: isIntelligenceEnabled,
                isBackdropFocalPointEnabled: isBackdropFocalPointEnabled
            )
        }

    }
#endif
