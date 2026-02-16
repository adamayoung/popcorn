//
//  FeatureFlagsView.swift
//  DeveloperFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI
import TCAFoundation

public struct FeatureFlagsView: View {

    @Bindable var store: StoreOf<FeatureFlagsFeature>

    public init(store: StoreOf<FeatureFlagsFeature>) {
        self._store = .init(store)
    }

    public var body: some View {
        ZStack {
            switch store.viewState {
            case .ready(let snapshot):
                content(snapshot)
            case .error(let error):
                errorBody(error)
            default:
                EmptyView()
            }
        }
        .navigationTitle(Text("FEATURE_FLAGS", bundle: .module))
        .accessibilityIdentifier("feature-flags.view")
        .contentTransition(.opacity)
        .overlay {
            if store.viewState.isLoading {
                loadingBody
            }
        }
        .task {
            store.send(.load)
        }
    }

}

extension FeatureFlagsView {

    private var loadingBody: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func content(_ snapshot: FeatureFlagsFeature.ViewSnapshot) -> some View {
        FeatureFlagsContentView(
            featureFlags: snapshot.featureFlags,
            updateFeatureValueOverride: { flag, override in
                store.send(.setFeatureFlagOverride(flag, override))
            }
        )
    }

    private func errorBody(_ error: ViewStateError) -> some View {
        ContentUnavailableView {
            Label(LocalizedStringResource("UNABLE_TO_LOAD", bundle: .module), systemImage: "exclamationmark.triangle")
        } description: {
            Text(error.message)
        } actions: {
            if error.isRetryable {
                Button {
                    store.send(.load)
                } label: {
                    Text("RETRY", bundle: .module)
                }
                .buttonStyle(.bordered)
            }
        }
    }

}

#Preview("Ready") {
    NavigationStack {
        FeatureFlagsView(
            store: Store(
                initialState: FeatureFlagsFeature.State(
                    viewState: .ready(
                        .init(
                            featureFlags: FeatureFlag.mocks
                        )
                    )
                ),
                reducer: { EmptyReducer() }
            )
        )
    }
}

#Preview("Loading") {
    NavigationStack {
        FeatureFlagsView(
            store: Store(
                initialState: FeatureFlagsFeature.State(
                    viewState: .loading
                ),
                reducer: { EmptyReducer() }
            )
        )
    }
}
