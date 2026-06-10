//
//  FeatureFlagsViewModel.swift
//  DeveloperFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observation
import OSLog
import Presentation

/// Drives ``FeatureFlagsView``. The MVVM replacement for `FeatureFlagsFeature`.
///
/// Loading is driven by the view through ``load()`` from a `.task`, so SwiftUI
/// owns the lifetime. ``setFeatureFlagOverride(_:_:)`` and ``resetAllOverrides()``
/// mutate the shared override service and then refetch the flags — mirroring the
/// reducer's `.concatenate(update, fetchAll)` / `.concatenate(removeAll, fetchAll)`.
@Observable
@MainActor
public final class FeatureFlagsViewModel {

    /// A snapshot of the feature flags shown by ``FeatureFlagsView`` once loaded.
    public struct ViewSnapshot: Equatable, Sendable {

        public let featureFlags: [FeatureFlag]

        public init(featureFlags: [FeatureFlag]) {
            self.featureFlags = featureFlags
        }

    }

    private static let logger = Logger.developer

    public private(set) var viewState: ViewState<ViewSnapshot>

    /// Drives `.task(id:)` reruns. ``reload()`` bumps it to retry after an error.
    public private(set) var reloadID = 0

    private let dependencies: FeatureFlagsDependencies

    public init(
        dependencies: FeatureFlagsDependencies,
        viewState: ViewState<ViewSnapshot> = .initial
    ) {
        self.dependencies = dependencies
        self.viewState = viewState
    }

    // MARK: - Lifecycle

    /// Loads the feature flags. Sets `.loading`, then fetches and transitions to
    /// `.ready` or `.error`. Drive this from the view's `.task`.
    public func load() async {
        viewState = .loading
        await fetchAll()
    }

    /// Retries loading after an error by changing ``reloadID``, which reruns the
    /// view's `.task(id:)`.
    public func reload() {
        reloadID += 1
    }

    // MARK: - Overrides

    /// Updates a single flag's override, then refetches the flags. Mirrors the
    /// reducer's `.concatenate(handleUpdateFeatureFlagOverride, handleFetchAll)`.
    public func setFeatureFlagOverride(
        _ featureFlag: FeatureFlag,
        _ override: FeatureFlagOverrideState
    ) async {
        dependencies.updateFeatureFlagValue(featureFlag, override.value)
        await fetchAll()
    }

    /// Removes all overrides, then refetches the flags. Mirrors the reducer's
    /// `.concatenate(handleResetAllOverrides, handleFetchAll)`.
    public func resetAllOverrides() async {
        dependencies.removeAllOverrides()
        await fetchAll()
    }

    // MARK: - Loading

    private func fetchAll() async {
        Self.logger.info("User fetching feature flags")

        let featureFlags: [FeatureFlag]
        do {
            featureFlags = try await dependencies.fetchFeatureFlags()
        } catch {
            Self.logger.error(
                "Failed fetching feature flags content: \(error.localizedDescription, privacy: .public)"
            )
            viewState.applyLoadFailure(error)
            return
        }

        viewState = .ready(ViewSnapshot(featureFlags: featureFlags))
    }

}

#if DEBUG
    public extension FeatureFlagsViewModel {

        /// A view model pinned to a fixed view state with no-op dependencies, for
        /// previews and snapshot tests.
        static func preview(
            viewState: ViewState<ViewSnapshot> = .initial
        ) -> FeatureFlagsViewModel {
            FeatureFlagsViewModel(dependencies: .preview, viewState: viewState)
        }

    }
#endif
