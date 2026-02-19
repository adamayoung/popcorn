//
//  TVSeriesDetailsView.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI
import TCAFoundation

public struct TVSeriesDetailsView: View {

    @Bindable private var store: StoreOf<TVSeriesDetailsFeature>
    private let namespace: Namespace.ID

    public init(
        store: StoreOf<TVSeriesDetailsFeature>,
        transitionNamespace: Namespace.ID
    ) {
        self._store = .init(store)
        self.namespace = transitionNamespace
    }

    public var body: some View {
        ZStack {
            switch store.viewState {
            case .ready(let snapshot):
                content(tvSeries: snapshot.tvSeries)
            case .error(let error):
                ContentUnavailableView {
                    Label("UNABLE_TO_LOAD", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(error.message)
                } actions: {
                    if error.isRetryable {
                        Button("RETRY") {
                            store.send(.fetch)
                        }
                        .buttonStyle(.bordered)
                    }
                }
            default:
                EmptyView()
            }
        }
        .accessibilityIdentifier("tv-series-details.view")
        .toolbar {
            if case .ready(let snapshot) = store.viewState, store.isIntelligenceEnabled {
                ToolbarItem(placement: .primaryAction) {
                    Button(
                        "Intelligence",
                        systemImage: "apple.intelligence"
                    ) {
                        store.send(.navigate(.tvSeriesIntelligence(id: snapshot.tvSeries.id)))
                    }
                }
            }
        }
        .contentTransition(.opacity)
        .animation(.easeInOut(duration: 1), value: store.viewState.isReady)
        .overlay {
            if store.viewState.isLoading {
                loadingBody
            }
        }
        .onAppear {
            store.send(.didAppear)
        }
        .task {
            await store.send(.fetch).finish()
        }
    }

}

extension TVSeriesDetailsView {

    private var loadingBody: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func content(tvSeries: TVSeries) -> some View {
        TVSeriesDetailsContentView(
            tvSeries: tvSeries,
            isBackdropFocalPointEnabled: store.isBackdropFocalPointEnabled,
            didSelectSeason: { seasonNumber in
                store.send(.navigate(.seasonDetails(tvSeriesID: tvSeries.id, seasonNumber: seasonNumber)))
            }
        )
    }

}

#Preview("Ready") {
    @Previewable @Namespace var namespace

    NavigationStack {
        TVSeriesDetailsView(
            store: Store(
                initialState: TVSeriesDetailsFeature.State(
                    tvSeriesID: 1,
                    viewState: .ready(.init(tvSeries: TVSeries.mock))
                ),
                reducer: { EmptyReducer() }
            ),
            transitionNamespace: namespace
        )
    }
}

#Preview("Loading") {
    @Previewable @Namespace var namespace

    NavigationStack {
        TVSeriesDetailsView(
            store: Store(
                initialState: TVSeriesDetailsFeature.State(
                    tvSeriesID: 1,
                    viewState: .loading
                ),
                reducer: { EmptyReducer() }
            ),
            transitionNamespace: namespace
        )
    }
}
