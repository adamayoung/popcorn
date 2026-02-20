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

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
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
                    Label(
                        LocalizedStringResource("UNABLE_TO_LOAD", bundle: .module),
                        systemImage: "exclamationmark.triangle"
                    )
                } description: {
                    Text(error.message)
                } actions: {
                    if error.isRetryable {
                        Button(LocalizedStringResource("RETRY", bundle: .module)) {
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
                        LocalizedStringResource("INTELLIGENCE", bundle: .module),
                        systemImage: "apple.intelligence"
                    ) {
                        store.send(.navigate(.tvSeriesIntelligence(id: snapshot.tvSeries.id)))
                    }
                }
            }
        }
        .contentTransition(.opacity)
        .animation(reduceMotion ? nil : .easeInOut(duration: 1), value: store.viewState.isReady)
        .overlay {
            if store.viewState.isLoading {
                loadingBody
            }
        }
        .onAppear {
            store.send(.didAppear)
        }
        .task {
            store.send(.fetch)
        }
    }

}

extension TVSeriesDetailsView {

    private var loadingBody: some View {
        ProgressView()
            .accessibilityLabel(Text("LOADING", bundle: .module))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func content(tvSeries: TVSeries) -> some View {
        TVSeriesDetailsContentView(
            tvSeries: tvSeries,
            isBackdropFocalPointEnabled: store.isBackdropFocalPointEnabled,
            didSelectSeason: { seasonNumber in
                let seasonName = tvSeries.seasons
                    .first { $0.seasonNumber == seasonNumber }?.name ?? ""
                store.send(
                    .navigate(
                        .seasonDetails(
                            tvSeriesID: tvSeries.id,
                            seasonNumber: seasonNumber,
                            seasonName: seasonName
                        )
                    )
                )
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
