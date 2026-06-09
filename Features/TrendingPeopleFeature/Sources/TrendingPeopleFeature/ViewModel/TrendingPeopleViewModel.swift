//
//  TrendingPeopleViewModel.swift
//  TrendingPeopleFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observation
import OSLog

/// Drives ``TrendingPeopleScreen``. The MVVM replacement for `TrendingPeopleFeature`.
///
/// Loading is driven by the view through ``load()`` from a `.task`, so SwiftUI owns
/// the lifetime: the work is cancelled on disappear and restarted on reappear (or
/// when ``reload()`` bumps ``reloadID``). There is deliberately no view-model-owned
/// `Task` — structured concurrency keeps the work tied to the view's lifetime with
/// no manual cancellation.
@Observable
@MainActor
public final class TrendingPeopleViewModel {

    private static let logger = Logger.trendingPeople

    public private(set) var people: [PersonPreview] = []

    /// Drives `.task(id:)` reruns. ``reload()`` bumps it to retry.
    public private(set) var reloadID = 0

    private let dependencies: TrendingPeopleDependencies
    private let navigator: any TrendingPeopleNavigating

    public init(
        dependencies: TrendingPeopleDependencies,
        navigator: any TrendingPeopleNavigating,
        people: [PersonPreview] = []
    ) {
        self.dependencies = dependencies
        self.navigator = navigator
        self.people = people
    }

    // MARK: - Loading

    /// Fetches trending people and publishes them to ``people``.
    ///
    /// Drive this from the view's `.task`; SwiftUI cancels it on disappear and
    /// reruns it on reappear / ``reload()``. Mirrors the former reducer: on failure
    /// it logs and leaves ``people`` unchanged.
    public func load() async {
        Self.logger.info("User fetching trending people")

        let people: [PersonPreview]
        do {
            people = try await dependencies.fetchTrendingPeople()
        } catch {
            Self.logger.error(
                "Failed fetching trending people: \(error.localizedDescription, privacy: .public)"
            )
            return
        }

        self.people = people
    }

    /// Retries loading by changing ``reloadID``, which reruns the view's `.task(id:)`.
    public func reload() {
        reloadID += 1
    }

    // MARK: - Navigation

    public func selectPerson(id: Int) {
        navigator.openPersonDetails(id: id)
    }

}

#if DEBUG
    public extension TrendingPeopleViewModel {

        /// A view model with no-op dependencies and navigation, for previews and
        /// snapshot tests.
        static func preview(
            people: [PersonPreview] = PersonPreview.mocks
        ) -> TrendingPeopleViewModel {
            TrendingPeopleViewModel(
                dependencies: .preview,
                navigator: NoOpTrendingPeopleNavigator(),
                people: people
            )
        }

    }
#endif
