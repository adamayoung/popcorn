//
//  TrendingTVSeriesViewModel.swift
//  TrendingTVSeriesFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observation
import OSLog

/// Drives ``TrendingTVSeriesView``.
///
/// Loading is driven by the view through ``load()`` from a `.task(id:)`, so SwiftUI
/// owns the lifetime: the work is cancelled on disappear and restarted on reappear
/// (or when ``reload()`` bumps ``reloadID``). There is deliberately no
/// view-model-owned `Task` — structured concurrency keeps the work tied to the
/// view's lifetime with no manual cancellation.
///
/// Holds a single ``tvSeries`` array with no loading or error state. A fetch failure
/// is logged and leaves the existing ``tvSeries`` untouched.
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

        do {
            tvSeries = try await dependencies.fetchTrendingTVSeries()
        } catch {
            // A tab-switch cancellation isn't a failure — don't log it as one.
            if !Task.isCancelled, !(error is CancellationError) {
                Self.logger.error(
                    "Failed fetching trending TV series: \(error.localizedDescription, privacy: .public)"
                )
            }
        }
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
