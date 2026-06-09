//
//  TrendingTVSeriesViewModel.swift
//  TrendingTVSeriesFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observation
import OSLog

/// Drives ``TrendingTVSeriesScreen``. The MVVM replacement for `TrendingTVSeriesFeature`.
///
/// Loading is driven by the view through ``load()`` from a `.task(id:)`, so SwiftUI
/// owns the lifetime: the work is cancelled on disappear and restarted on reappear
/// (or when ``reload()`` bumps ``reloadID``). There is deliberately no
/// view-model-owned `Task` — structured concurrency keeps the work tied to the
/// view's lifetime with no manual cancellation.
///
/// Mirrors the former reducer's state shape exactly — a single ``tvSeries`` array
/// with no loading or error state. As in the reducer's `loadTrendingTVSeriesFailed`
/// handler, a fetch failure is logged and leaves the existing ``tvSeries`` untouched.
@Observable
@MainActor
public final class TrendingTVSeriesViewModel {

    private static let logger = Logger.trendingTVSeries

    public private(set) var tvSeries: [TVSeriesPreview] = []

    /// Drives `.task(id:)` reruns. ``reload()`` bumps it to retry after a failure.
    public private(set) var reloadID = 0

    private let dependencies: TrendingTVSeriesDependencies
    private let navigator: any TrendingTVSeriesNavigating

    public init(
        dependencies: TrendingTVSeriesDependencies,
        navigator: any TrendingTVSeriesNavigating,
        tvSeries: [TVSeriesPreview] = []
    ) {
        self.dependencies = dependencies
        self.navigator = navigator
        self.tvSeries = tvSeries
    }

    // MARK: - Lifecycle

    /// Fetches the trending TV series.
    ///
    /// Drive this from the view's `.task(id:)`; SwiftUI cancels it on disappear
    /// and reruns it on reappear / ``reload()``.
    public func load() async {
        Self.logger.info("User fetching trending TV series")

        let tvSeries: [TVSeriesPreview]
        do {
            tvSeries = try await self.dependencies.fetchTrendingTVSeries()
        } catch {
            Self.logger.error(
                "Failed fetching trending TV series: \(error.localizedDescription, privacy: .public)"
            )
            return
        }

        self.tvSeries = tvSeries
    }

    /// Retries loading by changing ``reloadID``, which reruns the view's `.task(id:)`.
    public func reload() {
        reloadID += 1
    }

    // MARK: - Navigation

    public func selectTVSeries(id: Int) {
        navigator.openTVSeriesDetails(id: id)
    }

}

#if DEBUG
    public extension TrendingTVSeriesViewModel {

        /// A view model with no-op dependencies and navigation, for previews and
        /// snapshot tests.
        static func preview(
            tvSeries: [TVSeriesPreview] = TVSeriesPreview.mocks
        ) -> TrendingTVSeriesViewModel {
            TrendingTVSeriesViewModel(
                dependencies: .preview,
                navigator: NoOpTrendingTVSeriesNavigator(),
                tvSeries: tvSeries
            )
        }

    }
#endif
