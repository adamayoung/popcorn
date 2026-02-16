//
//  FeatureFlagsFeature.swift
//  DeveloperFeature
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import OSLog
import TCAFoundation

/// A feature that manages the display and override of feature flags in the developer menu.
@Reducer
public struct FeatureFlagsFeature: Sendable {

    private static let logger = Logger.developer

    @Dependency(\.featureFlagsClient) private var client

    /// The state managed by the developer feature.
    ///
    /// Tracks the current view state and provides computed properties for loading and ready states.
    @ObservableState
    public struct State {
        /// The current view state of the feature flags screen.
        public var viewState: ViewState<ViewSnapshot>

        public init(viewState: ViewState<ViewSnapshot> = .initial) {
            self.viewState = viewState
        }
    }

    /// A snapshot of all developer content loaded from various sources.
    public struct ViewSnapshot: Equatable, Sendable {
        /// Feature flags
        public let featureFlags: [FeatureFlag]

        public init(featureFlags: [FeatureFlag]) {
            self.featureFlags = featureFlags
        }
    }

    /// Actions that can be performed in the developer feature.
    public enum Action {
        /// Initiates loading of all developer content from enabled sources.
        case load
        /// Content has been successfully loaded.
        case loaded(ViewSnapshot)
        /// Loading content failed with an error.
        case loadFailed(ViewStateError)

        case setFeatureFlagOverride(FeatureFlag, FeatureFlagOverrideState)
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .load:
                state.viewState = .loading
                return handleFetchAll()

            case .loaded(let snapshot):
                state.viewState = .ready(snapshot)
                return .none

            case .loadFailed(let error):
                state.viewState = .error(error)
                return .none

            case .setFeatureFlagOverride(let featureFlag, let override):
                return .concatenate(
                    handleUpdateFeatureFlagOverride(featureFlag: featureFlag, override: override),
                    handleFetchAll()
                )
            }
        }
    }

}

extension FeatureFlagsFeature {

    private func handleFetchAll() -> EffectOf<Self> {
        .run { [client] send in
            Self.logger.info("User fetching feature flags")

            let featureFlags: [FeatureFlag]
            do {
                featureFlags = try await client.fetchFeatureFlags()
            } catch let error {
                Self.logger.error(
                    "Failed fetching feature flags content: \(error.localizedDescription, privacy: .public)"
                )
                await send(.loadFailed(ViewStateError(error)))
                return
            }

            let snapshot = ViewSnapshot(featureFlags: featureFlags)
            await send(.loaded(snapshot))
        }
    }

    private func handleUpdateFeatureFlagOverride(
        featureFlag: FeatureFlag,
        override: FeatureFlagOverrideState
    ) -> EffectOf<Self> {
        .run { [client] _ in
            client.updateFeatureFlagValue(featureFlag, override.value)
        }
    }

}
